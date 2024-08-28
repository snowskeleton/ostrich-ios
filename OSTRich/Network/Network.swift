//
//  Network.swift
//  OSTRich
//
//  Created by snow on 7/11/24.
//

import Apollo
import Foundation
import SwiftData
import SwiftUI

class Network {
    static let shared = Network()
    
    @AppStorage("netowrkAuthorized") static var authorized = true
    
    @discardableResult public func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .fetchIgnoringCacheCompletely,
        contextIdentifier: UUID? = nil,
        context: (any RequestContext)? = nil,
        queue: DispatchQueue = .main,
        resultHandler: @escaping (Result<Query.Data, Error>) -> Void
    ) -> (any Cancellable) {
        return Network.shared.apollo.fetch(
            query: query,
            cachePolicy: cachePolicy,
            contextIdentifier: contextIdentifier,
            context: context,
            queue: queue
        ) { result in
            switch result {
            case .success(let graphQLResult):
                Network.authorized = true
                if let errors = graphQLResult.errors, !errors.isEmpty {
                    if errors.contains(where: { $0.message!.contains("401: Unauthorized") }) {
                        Network.authorized  = false
                        resultHandler(.failure(NetworkError.authorizationError))
                    } else {
                        resultHandler(.failure(NetworkError.graphQLError(errors)))
                    }
                } else if let data = graphQLResult.data {
                    resultHandler(.success(data))
                } else {
                    resultHandler(.failure(NetworkError.unknownError))
                }
            case .failure(let error):
                resultHandler(.failure(error))
            }
        }
    }
    
    
    //    private(set) lazy var apollo = ApolloClient(url: URL(string: "https://api.tabletop.wizards.com/silverbeak-griffin-service/graphql")!)
    private(set) lazy var apollo: ApolloClient = {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(client: client, store: store)
        let url = URL(
            string:
                "https://api.tabletop.wizards.com/silverbeak-griffin-service/graphql"
        )!
        let transport = RequestChainNetworkTransport(
            interceptorProvider: provider, endpointURL: url)
        
        return ApolloClient(networkTransport: transport, store: store)
    }()
    
    /// Get a fresh copy of all events from the server. Makes new events or updates old events with new data as appropriate
    static func getEvents(context: ModelContext) {
        Network.shared.fetch(
            query: Gamestateschema.MyActiveEventsQuery()
        ) { response in
            switch response {
            case .success(let graphQLResult):
                graphQLResult.myActiveEvents.forEach { eventData in
                    let oldEvents = try! context.fetch(FetchDescriptor<Event>())
                    if let oldEvent = oldEvents.first(where: {
                        $0.id == eventData.id
                    }) {
                        oldEvent.update(with: eventData)
                    } else {
                        context.insert(Event(from: eventData))
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Fetch additional data about event from server. Not all data is included with getEvents() response, so this has to be called too.
    static func getEvent(event: Event) {
        Network.shared.fetch(
            query: Gamestateschema.LoadEventJoinV2Query(eventId: event.id)
        ) { response in
            switch response {
            case .success(let graphQLResult):
                if let eventData = graphQLResult.event {
                    eventData.teams.forEach { team in
                        print(team)
                    }
                    event.update(with: eventData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getEventAsHost(event: Event) {
        Network.shared.fetch(
            query: Gamestateschema.LoadEventHostV2Query(eventId: event.id)
        ) { response in
            switch response {
            case .success(let graphQLResult):
                if let eventData = graphQLResult.event {
                    event.update(with: eventData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getGameState(event: Event) {
        // round: 0 always returns the current round
        Network.shared.fetch(
            query: Gamestateschema.GetGameStateV2AtRoundQuery(
                eventId: event.id, round: 0)
        ) { response in
            switch response {
            case .success(let graphQLResult):
                if let gamestateData = graphQLResult.gameStateV2AtRound {
                    event.update(with: gamestateData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func submitMatchResults(eventId: String, results: [Gamestateschema.TeamResultInputV2], completion: @escaping (Result<Void, Error>) -> Void) {
        let mutation = Gamestateschema.RecordMatchResultV2Mutation(eventId: eventId, results: results)
        
        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let errors = graphQLResult.errors {
                    let error = errors.map { $0.localizedDescription }.joined(separator: "\n")
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error])))
                } else {
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getTimer(timerId: String, completion: @escaping (Result<Gamestateschema.GetTimerQuery.Data.Timer, Error>) -> Void) {
        Network.shared.fetch(
            query: Gamestateschema.GetTimerQuery(id: timerId)
        ) { response in
            switch response {
            case .success(let data):
                completion(.success(data.timer))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func joinEventWithShortCode(shortCode: String, completion: @escaping (Result<Gamestateschema.ID, Error>) -> Void) {
        let allCapsShortCode = shortCode.uppercased()
        let mutation = Gamestateschema.JoinEventWithShortCodeMutation(shortCode: allCapsShortCode)
        
        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let errors = graphQLResult.errors {
                    let error = errors.map { $0.localizedDescription }.joined(separator: "\n")
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error])))
                } else if let eventId = graphQLResult.data?.joinEventWithShortCode {
                    completion(.success(eventId))
                } else {
                    completion(.failure(NetworkError.unknownError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum NetworkError: Error {
    case authorizationError
    case graphQLError([GraphQLError])
    case unknownError
}
