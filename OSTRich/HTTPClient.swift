//
//  HTTPClient.swift
//  OSTRich
//
//  Created by snow on 9/22/23.
//

import Foundation


protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
}

extension Endpoint {
    var scheme: String { return "https" }
    var host: String { return "api.tabletop.wizards.com" }
}

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    case emailInUse
    case ageRestriction
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if endpoint.method != .get {
            if let body = endpoint.body {
                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            }
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                do {
//                    let success = try JSONSerialization.jsonObject(with: data, options: [])
//                    print("Success: \(success)")
                    return .success(try JSONDecoder().decode(responseModel, from: data))
                } catch {
                    let serverError = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Error decoding error: \(serverError)")
                    return .failure(.decode)
                }
            case 401:
                return .failure(.unauthorized)
            default:
                do {
                    let error =  try JSONDecoder().decode(HTTPError.self, from: data)
                    switch error.error {
                    case "EMAIL ADDRESS IN USE":
                        return .failure(.emailInUse)
                    case "AGE REQUIREMENT":
                        return .failure(.ageRestriction)
                    case "INVALID CLIENT CREDENTIALS":
                        return .failure(.unauthorized)
                    case "UNAUTHENTICATED":
                        return .failure(.unauthorized)
                    default:
                        print("Unknown error case: \(error)")
                        return .failure(.unknown)
                    }
                } catch {
                    print(error)
                    let serverError = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Error decoding error: \(serverError)")
                    return .failure(.unknown)
                }
            }
        } catch {
            print(String(describing: error))
            return .failure(.unknown)
        }
    }
}
