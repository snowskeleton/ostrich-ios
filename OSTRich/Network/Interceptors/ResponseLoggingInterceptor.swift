//
//  ResponseLoggingInterceptor.swift
//  OSTRich
//
//  Created by snow on 8/25/24.
//


import Foundation
import Apollo
import ApolloAPI

//class ResponseLoggingInterceptor: ApolloInterceptor {
//    public var id: String = UUID().uuidString
//    
//    func interceptAsync<Operation: GraphQLOperation>(
//        chain: RequestChain,
//        request: HTTPRequest<Operation>,
//        response: HTTPResponse<Operation>?,
//        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
//    ) {
//        defer {
//            chain.proceedAsync(
//                request: request,
//                response: response,
//                interceptor: self,
//                completion: completion
//            )
//        }
//        
//        if let response = response {
//            print("Received response: \(response.httpResponse)")
//            if let dataString = String(data: response.rawData, encoding: .utf8) {
//                print("Response data: \(dataString)")
//            } else {
//                print("Failed to parse response data.")
//            }
//        } else {
//            print("No response received.")
//        }
//    }
//}

class ResponseLoggingInterceptor: ApolloInterceptor {
    public var id: String = UUID().uuidString

    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation: GraphQLOperation {
        
        // Extract request details
        let url = request.graphQLEndpoint.absoluteString
        let httpMethod = "POST" // GraphQL requests are typically POST
        let headers = request.additionalHeaders
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: request.operation.__variables ?? [:], options: []) else {
            chain.proceedAsync(request: request, response: response, interceptor: self, completion: completion)
            return
        }
        
        let body: [String: Any]?
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: bodyData, options: []) else {
            chain.proceedAsync(request: request, response: response, interceptor: self, completion: completion)
            return
        }
        
        body = jsonObject as? [String : Any]
        
        // Create a log object
        var networkLog = NetworkLog(
            url: url,
            method: httpMethod,
            headers: headers,
            body: body,
            response: nil,
            statusCode: nil
        )
        
        // Extract response data for logging
        if let response = response {
            networkLog.response = String(data: response.rawData, encoding: .utf8)
            networkLog.statusCode = response.httpResponse.statusCode
        }
        
        // Save the log
        NetworkLogger.shared.addLog(networkLog)
        
        // Continue the response chain
        chain.proceedAsync(request: request, response: response, interceptor: self, completion: completion)
    }
}
