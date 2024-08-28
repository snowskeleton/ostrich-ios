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
                user.loggedIn
            else {
                chain.handleErrorAsync(
                    UserError.UserNotLoggedIn,
                    request: request,
                    response: response,
                    completion: completion
                )
                return
            }
            
            let _ = await AsyncUserManager.shared.refreshTokenIfNeeded()
            
            let refreshedUser = UserManager.shared.currentUser
            guard let token = refreshedUser?.token, refreshedUser?.loggedIn == true, !refreshedUser!.tokenExpired else {
                chain.handleErrorAsync(
                    UserError.unableToRefreshToken,
                    request: request,
                    response: response,
                    completion: completion
                )
                return
            }
            
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
