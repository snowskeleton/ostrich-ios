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

struct HTTPError: Decodable, Error {
    let code: Int
    let error: String
    let grpcCode: String
}

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    case badGateway
    case badRequest
    case forbidden
    case notFound
    case methodNotAllowed
    case requestTimeout
    case tooManyRequests
    case internalServerError
    case notImplemented
    case serviceUnavailable
    case gatewayTimeout


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
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type)
        async -> Result<T, RequestError>
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
            let log = NetworkLog(
                url: url.absoluteString,
                method: endpoint.method.rawValue,
                headers: endpoint.header,
                body: endpoint.body ?? [:],
                response: String(data: data, encoding: .utf8),
                statusCode: response.statusCode
            )
            NetworkLogger.shared.addLog(log)
            switch response.statusCode {
            case 200...299:
                do {
                    UserDefaults.standard.set(true, forKey: "netowrkAuthorized")
                    return .success(
                        try JSONDecoder().decode(responseModel, from: data))
                } catch {
                    let serverError = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Error decoding response: \(serverError)")
                    return .failure(.decode)
                }
            case 400: return .failure(.badRequest)
            case 401: return .failure(.unauthorized)
            case 403: return .failure(.forbidden)
            case 404: return .failure(.notFound)
            case 405: return .failure(.methodNotAllowed)
            case 408: return .failure(.requestTimeout)
            case 429: return .failure(.tooManyRequests)
            case 500: return .failure(.internalServerError)
            case 501: return .failure(.notImplemented)
            case 502: return .failure(.badGateway)
            case 503: return .failure(.serviceUnavailable)
            case 504: return .failure(.gatewayTimeout)
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
                        UserDefaults.standard.set(false, forKey: "netowrkAuthorized")
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
