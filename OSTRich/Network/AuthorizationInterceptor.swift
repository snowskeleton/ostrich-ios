//
//  AuthorizationInterceptor.swift
//  OSTRich
//
//  Created by snow on 7/11/24.
//

import Foundation
import Apollo
import ApolloAPI

class AuthorizationInterceptor: ApolloInterceptor {
    public var id: String = UUID().uuidString
    
    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            request.addHeader(name: "Authorization", value: "Bearer \(accessToken)")
        }

        chain.proceedAsync(
            request: request,
            response: response,
            interceptor: self,
            completion: completion)
    }
    
}
