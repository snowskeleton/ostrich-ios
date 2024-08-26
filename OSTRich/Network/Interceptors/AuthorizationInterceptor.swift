//
//  AuthorizationInterceptor.swift
//  OSTRich
//
//  Created by snow on 7/11/24.
//

import Foundation
import Apollo
import ApolloAPI

class UserManagementInterceptor: ApolloInterceptor {
    enum UserError: Error {
        case noLoginToken
        case UserNotLoggedIn
        case unableToRefreshToken
    }
    
    public var id: String = UUID().uuidString
    
    /// Helper function to add the token then move on to the next step
    private func addTokenAndProceed<Operation: GraphQLOperation>(
        _ token: Token,
        to request: HTTPRequest<Operation>,
        chain: RequestChain,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) {
        request.addHeader(name: "Authorization", value: "Bearer \(token.access_token)")
        chain.proceedAsync(
            request: request,
            response: response,
            interceptor: self,
            completion: completion
        )
    }
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) {
                    Task {
        guard
            let user = UserManager.shared.currentUser,
            let token = user.token
        else {
            chain.handleErrorAsync(
                UserError.noLoginToken,
                request: request,
                response: response,
                completion: completion
            )
            return
        }
        
        // If we've gotten here, there is a token!
        if !user.loggedIn {
            // try once to refresh the user's token
            await UserManager.shared.refreshToken()

            if !user.loggedIn {
                // user is beyond our help, so throw an error
                chain.handleErrorAsync(
                    UserError.unableToRefreshToken,
                    request: request,
                    response: response,
                    completion: completion
                )
                return
            }
        }
        // user logged in; proceed
        self.addTokenAndProceed(
            token,
            to: request,
            chain: chain,
            response: response,
            completion: completion
        )
                                    }
    }
}
