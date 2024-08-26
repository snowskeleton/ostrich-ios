////
////  RequestLoggingInterceptor.swift
////  OSTRich
////
////  Created by snow on 8/25/24.
////
//
//
//import Foundation
//import Apollo
//import ApolloAPI
//
////class RequestLoggingInterceptor: ApolloInterceptor {
////
////    func interceptAsync<Operation: GraphQLOperation>(
////        chain: RequestChain,
////        request: HTTPRequest<Operation>,
////        response: HTTPResponse<Operation>?,
////        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
////    ) {
////        print("Outgoing request: \(request)")
////        
////        chain.proceedAsync(
////            request: request,
////            response: response,
////            interceptor: self,
////            completion: completion
////        )
////    }
////}
//
//class RequestLoggingInterceptor: ApolloInterceptor {
//    public var id: String = UUID().uuidString
//
//    
//    func interceptAsync<Operation>(
//        chain: RequestChain,
//        request: HTTPRequest<Operation>,
//        response: HTTPResponse<Operation>?,
//        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
//    ) where Operation: GraphQLOperation {
//        
//        // Extract request details for logging
//        let url = request.graphQLEndpoint.absoluteString
//        let httpMethod = "POST" // GraphQL requests are typically POST
//        let headers = request.additionalHeaders
//        let bodyData = try? JSONSerialization.data(withJSONObject: request.operation.__variables ?? [:], options: [])
//
//        let body: [String: Any]?
//        
//        if let data = bodyData,
//           let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//            body = jsonObject
//        } else {
//            body = nil
//        }
//        
//        // Create the log object
//        let networkLog = NetworkLog(
//            url: url,
//            method: httpMethod,
//            headers: headers,
//            body: body,
//            response: nil,
//            statusCode: nil
//        )
//        
//        // Save the log
//        NetworkLogger.shared.addLog(networkLog)
//        
//        // Continue the request chain
//        chain.proceedAsync(request: request, response: response, interceptor: self, completion: completion)
//    }
//}
