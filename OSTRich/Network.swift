//
//  Network.swift
//  OSTRich
//
//  Created by snow on 7/11/24.
//

import Foundation
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
}
