//
//  Network Manager.swift
//  Betrayer App
//
//  Created by snow on 9/4/23.
//

import Foundation
import CoreData

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
        completion: @escaping (Result<T.Response, Error>) -> Void
    ) {
        // Because URLSession returns on the queue it creates for the request, we need to make sure we return on one and the same queue.
        // You can do this by either create a queue in your class (NetworkManager) which you return on, or return on the main queue.
        let completionOnMain: (Result<T.Response, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        var request = URLRequest(url: URL(string: "https://api.platform.wizards.com/auth/oauth/token")!)
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
        let defaults = UserDefaults.standard
        if let savedAuth = defaults.object(forKey: "savedAuth") as? Data {
            let decoder = JSONDecoder()
            if let credentials = try? decoder.decode(AuthCredentials.Response.self, from: savedAuth) {
                request.setValue("Bearer \(credentials.access_token)", forHTTPHeaderField: "Authorization")
            }
        } else { return }
        
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
    
public func joinEvent(with eventCode: String) {
    HTTPClient.shared.gqlRequest(joinEventWithShortCode(code: eventCode)
    ) { (result: Result<joinEventWithShortCode.Response, Error>) in
        switch result {
        case .success(let response):
            print("Joined event \(response.data.joinEventWithShortCode)")
        case .failure(let error):
            print("The error we got was: \(String(describing: error))")
        }
    }
}

//public func getEvents() {
//    HTTPClient.shared.gqlRequest(
//        requestType: myActiveEvents()
//    ) { (result: Result<myActiveEvents.Response, Error>) in
//        switch result {
//        case .success(let response):
//            print("We got these events:\n \(response.data.myActiveEvents) \n")
//        case .failure(let error):
//            print("The error we got was: \(String(describing: error))")
//        }
//    }
//}

//public func login(with username: String, and password: String) {
//    HTTPClient.shared.httpRequest(
//        requestType: AuthCredentials(grant_type: "password", username: username, password: password)
//    ) { (result: Result<AuthCredentials.Response, Error>) in
//        switch result {
//        case .success(let credentials):
//            print("We got these credentials:\n \(credentials) \n")
//            let encoder = JSONEncoder()
//            if let encoded = try? encoder.encode(credentials) {
//                let defaults = UserDefaults.standard
//                defaults.set(encoded, forKey: "savedAuth")
//            }
//        case .failure(let error):
//            print("The error we got was: \(String(describing: error))")
//        }
//    }
//}

