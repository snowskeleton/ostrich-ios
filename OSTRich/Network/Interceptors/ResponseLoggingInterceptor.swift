//
//  ResponseLoggingInterceptor.swift
//  OSTRich
//
//  Created by snow on 8/25/24.
//


import Foundation
import Apollo
import ApolloAPI


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
        
        
        do {
            // Convert variables into a loggable format
            let loggableVariables = convertToLoggableFormat(request.operation.__variables ?? [:])
            
            // Serialize the sanitized variables
            let bodyData = try JSONSerialization.data(withJSONObject: loggableVariables ?? [:], options: [])
            print(bodyData)
            
            let body: [String: Any]?
            
            let jsonObject = try? JSONSerialization.jsonObject(with: bodyData, options: [])
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
            
        } catch {
            print("JSONSerialization error: \(error)")
            chain.proceedAsync(request: request, response: response, interceptor: self, completion: completion)
            return
        }
    }
}

fileprivate func convertToLoggableFormat(_ object: Any) -> Any? {
    if let dict = object as? [String: Any] {
        var loggableDict = [String: Any]()
        for (key, value) in dict {
            loggableDict[key] = convertToLoggableFormat(value)
        }
        return loggableDict
    } else if let array = object as? [Any] {
        return array.compactMap { convertToLoggableFormat($0) }
    } else if let customSerializable = object as? CustomSerializable {
        return customSerializable.toDictionary()
    } else if JSONSerialization.isValidJSONObject(object) {
        return object
    } else {
        return String(describing: object)
    }
}

protocol CustomSerializable {
    func toDictionary() -> [String: Any]
}

extension Gamestateschema.TeamResultInputV2: CustomSerializable {
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["matchId"] = matchId
        dict["submitter"] = submitter.unwrapped
        dict["isBye"] = isBye
        dict["wins"] = wins
        dict["losses"] = losses
        dict["draws"] = draws
        dict["teamId"] = teamId
        return dict
    }
}

