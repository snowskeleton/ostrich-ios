//
//  NetworkInterceptorProvider.swift
//  OSTRich
//
//  Created by snow on 7/11/24.
//

import Foundation
import Apollo
import ApolloAPI

class NetworkInterceptorProvider: DefaultInterceptorProvider {
    
    override func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation : GraphQLOperation {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(UserManagementInterceptor(), at: 0)
//        interceptors.insert(RequestLoggingInterceptor(), at: 1)
        interceptors.append(ResponseLoggingInterceptor())
        return interceptors
    }
    
}
