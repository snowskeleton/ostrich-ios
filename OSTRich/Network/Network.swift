//
//  Network.swift
//  OSTRich
//
//  Created by snow on 7/11/24.
//

import Foundation
import SwiftData
import Apollo

class Network {
    static let shared = Network()
    
//    private(set) lazy var apollo = ApolloClient(url: URL(string: "https://api.tabletop.wizards.com/silverbeak-griffin-service/graphql")!)
    private(set) lazy var apollo: ApolloClient = {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(client: client, store: store)
        let url = URL(string: "https://api.tabletop.wizards.com/silverbeak-griffin-service/graphql")!
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
        
        return ApolloClient(networkTransport: transport, store: store)
    }()
    
    
    /// Get a fresh copy of all events from the server. Makes new events or updates old events with new data as appropriate
    static func getEvents(context: ModelContext) {
        Network.shared.apollo.fetch(
            query: Gamestateschema.MyActiveEventsQuery()
        ) { response in
            switch response {
            case .success(let graphQLResult):
                graphQLResult.data?.myActiveEvents.forEach { eventData in
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
    static func getEvent(event: Event) -> Void {
        Network.shared.apollo.fetch(
            query: Gamestateschema.LoadEventJoinV2Query(eventId: event.id)
        ) { response in
            switch response {
            case .success(let graphQLResult):
                if let eventData = graphQLResult.data?.event {
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
    
    static func getEvenAsHost(event: Event) -> Void {
        Network.shared.apollo.fetch(
            query: Gamestateschema.LoadEventHostV2Query(eventId: event.id)
        ) { response in
            switch response {
            case .success(let graphQLResult):
                if let eventData = graphQLResult.data?.event {
                    event.update(with: eventData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getGameState(event: Event) -> Void {
        // round: 0 always returns the current round
        Network.shared.apollo.fetch(query: Gamestateschema.GetGameStateV2AtRoundQuery(eventId: event.id, round: 0)) { response in
            switch response {
            case .success(let graphQLResult):
                if let gamestateData = graphQLResult.data?.gameStateV2AtRound {
                    event.update(with: gamestateData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
