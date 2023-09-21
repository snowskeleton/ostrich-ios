//
//  Network Manager.swift
//  Betrayer App
//
//  Created by snow on 9/4/23.
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
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.tabletop.wizards.com"
    }
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

protocol NHTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension NHTTPClient {
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
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}


enum AuthenticationEndpoint {
    case login(email: String, password: String)
    case refreshLogin(refreshToken: String)
    case register(displayName: String, firstName: String, lastName: String, email: String, password: String, birthday: Date)
    case getMyEvents
}
extension AuthenticationEndpoint: Endpoint {
    var path: String {
        switch self {
        case .login, .refreshLogin:
            return "/auth/oauth/token"
        case .register:
            return "/accounts/register"
        default:
            return "/silverbeak-griffin-service/graphql"
        }
    }
    
    var host: String {
        switch self {
        case .login, .refreshLogin, .register:
            return "api.platform.wizards.com"
        default:
            return "api.tabletop.wizards.com"
        }
    }
    
    var method: RequestMethod {
        switch self {
        default:
            return .post
        }
    }
    
    var header: [String: String]? {
        switch self {
        case .login, .register, .refreshLogin:
            return [
                "Authorization": "Basic \(basicCredentialsBase64)",
                "Content-Type": "application/json"
            ]
        default:
            var headers: [String: String] = [:]
            if let savedAuth = UserDefaults.standard.object(forKey: "savedAuth") as? Data {
                if let credentials = try? JSONDecoder().decode(AuthCredentials.Response.self, from: savedAuth) {
                    headers = [
                        "Authorization": "Bearer \(credentials.access_token)",
                        "Content-Type": "application/json"
                    ]
                }
            }
            return headers
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .login(let email, let password):
            return [
                "grant_type": "password",
                "username": email,
                "password": password
            ]
        case .refreshLogin(let refreshToken):
            return [
                "grant_type": "refresh_token",
                "refresh_token": refreshToken
            ]
        case .register(let displayName, let firstName, let lastName, let email, let password, let birthday):
            return [
                "dateOfBirth": birthday.ISO8601Format().replacingOccurrences(of: "T.*Z", with: "", options: .regularExpression),
                "displayName": displayName,
                "email": email,
                "firstName": firstName,
                "lastName": lastName,
                "password": password,
                "country": "US",
                "acceptedTC": true,
                "emailOptIn": false,
                "dataShareOptIn": true
            ]
        case .getMyEvents:
            return [:]
        }
    }
}
protocol AuthenticationServiceable {
    func login(_ email: String, _ password: String) async -> Result<AuthCredentials.Response, RequestError>
    func refreshLogin(_ refreshToken: String) async -> Result<AuthCredentials.Response, RequestError>
    func register(displayName: String, firstName: String, lastName: String, email: String, password: String, birthday: Date) async -> Result<AuthCredentials.Response, RequestError>
    
}

struct AuthenticationService: NHTTPClient, AuthenticationServiceable {
    func register(displayName: String, firstName: String, lastName: String, email: String, password: String, birthday: Date) async -> Result<AuthCredentials.Response, RequestError> {
        return await sendRequest(
            endpoint: AuthenticationEndpoint.register(
                displayName: displayName,
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                birthday: birthday),
            responseModel: AuthCredentials.Response.self
        )
    }
    
    func login(_ email: String, _ password: String) async -> Result<AuthCredentials.Response, RequestError> {
        return await sendRequest(endpoint: AuthenticationEndpoint.login(email: email, password: password), responseModel: AuthCredentials.Response.self)
    }
    
    func refreshLogin(_ refreshToken: String) async -> Result<AuthCredentials.Response, RequestError> {
        return await sendRequest(endpoint: AuthenticationEndpoint.refreshLogin(refreshToken: refreshToken), responseModel: AuthCredentials.Response.self)
    }
}

let basicCredentials = "REDACTED"
let basicCredentialsBase64 = "REDACTED"

enum HttpMethod: String {
    case get
    case post
    
    var asString: String { rawValue.uppercased() }
}
enum ManagerErrors: Error {
    case invalidResponse
    case invalidStatusCode(Int)
}

class HTTPClient{
    static let shared = HTTPClient()
    
    func httpRequest<T: Query>(
        requestType: T,
        url: String? = nil,
        completion: @escaping (Result<T.Response, Error>) -> Void
    ) {
        // Because URLSession returns on the queue it creates for the request, we need to make sure we return on one and the same queue.
        // You can do this by either create a queue in your class (NetworkManager) which you return on, or return on the main queue.
        let completionOnMain: (Result<T.Response, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        var useThisURL = "https://api.platform.wizards.com/auth/oauth/token"
        if url != nil {
            useThisURL = url!
        }
        var request = URLRequest(url: URL(string: useThisURL)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(basicCredentialsBase64)", forHTTPHeaderField: "Authorization")
        request.httpMethod = HttpMethod.post.asString
        request.httpBody = try! JSONEncoder().encode(requestType)
        
        let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionOnMain(.failure(error))
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse else { return completionOnMain(.failure(ManagerErrors.invalidResponse)) }
            if !(200..<300).contains(urlResponse.statusCode) {
                return completionOnMain(.failure(ManagerErrors.invalidStatusCode(urlResponse.statusCode)))
            }
            
            guard let data = data else { return }
            do {
                let decodedData = try T.decodeResponse(data)
                completionOnMain(.success(decodedData))
            } catch {
                print(NSString(data: data, encoding: NSUTF8StringEncoding)!)
                debugPrint("Could not translate the data to the requested type. Reason: \(String(describing: error))")
                completionOnMain(.failure(error))
            }
        }
        
        urlSession.resume()
    }
    func gqlRequest<T: Query>(
        _ requestType: T,
        httpMethod: HttpMethod = .post,
        completion: @escaping (Result<T.Response, Error>) -> Void
    ) {
        // Because URLSession returns on the queue it creates for the request, we need to make sure we return on one and the same queue.
        // You can do this by either create a queue in your class (NetworkManager) which you return on, or return on the main queue.
        let completionOnMain: (Result<T.Response, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        var request = URLRequest(url: URL(string: "https://api.tabletop.wizards.com/silverbeak-griffin-service/graphql")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type" )
        request.httpMethod = httpMethod.asString
        request.httpBody = try! JSONEncoder().encode(requestType)
        
        // credentials
        if let savedAuth = UserDefaults.standard.object(forKey: "savedAuth") as? Data {
            if let credentials = try? JSONDecoder().decode(AuthCredentials.Response.self, from: savedAuth) {
                request.setValue("Bearer \(credentials.access_token)", forHTTPHeaderField: "Authorization")
            }
        } else { return }
        
        let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return completionOnMain(.failure(error)) }
            guard let urlResponse = response as? HTTPURLResponse else {
                return completionOnMain(.failure(ManagerErrors.invalidResponse)) }
            if !(200..<300).contains(urlResponse.statusCode) {
                return completionOnMain(.failure(ManagerErrors.invalidStatusCode(urlResponse.statusCode))) }
            guard let data = data else { return }
            
            do {
                let decodedData = try T.decodeResponse(data)
//                print(decodedData)
                completionOnMain(.success(decodedData))
            } catch {
                let decodedError = try? JSONDecoder().decode([GraphQLError].self, from: data)
                print(NSString(data: data, encoding: NSUTF8StringEncoding)!)
//                debugPrint("Could not translate the data to the requested type. Reason: \(String(describing: error))")
                debugPrint(decodedError as Any)
                completionOnMain(.failure(error))
            }
        }
        
        urlSession.resume()
    }
}
