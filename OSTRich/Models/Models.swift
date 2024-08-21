//
//  Models.swift
//  OSTRich
//
//  Created by snow on 7/5/24.
//

import Foundation

class NetworkLogger: ObservableObject {
    static let shared = NetworkLogger()
    @Published var logs: [NetworkLog] = []
    
    func addLog(_ log: NetworkLog) {
        DispatchQueue.main.async {
            self.logs.append(log)
        }
    }
}

struct NetworkLog: Identifiable {
    let id = UUID()
    let url: String
    let method: String
    let headers: [String: String]?
    let body: [String: Any]?
    let response: String?
    let statusCode: Int?
    
    var operationName: String? {
        if let body = body, let operationName = body["operationName"] as? String {
            return operationName
        }
        return nil
    }
    
    func getBodyDictionary() -> [String: Any]? {
        return body
    }
    func getResponseDictionary() -> [String: Any]? {
        let jsonData = self.response!.data(using: .utf8)
        let json = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: Any]
        return json
    }
}
