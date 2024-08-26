//
//  GraphyQLQueryTypes.swift
//  OSTRich
//
//  Created by snow on 9/4/23.
//

import Foundation

protocol OSTRichGraphQLQuery: HTTPQuery {
    /// Values to use in query
    var variables: [String: String] { get set }
    /// Name of function
    var operationName: String { get }
    /// The full string to send in the GraphQL request
    var query: String { get set }
}

extension OSTRichGraphQLQuery {
    var query: String {
        let filename = String("\(type(of: self))".split(separator: ".").last!)
        let bundle = Bundle.main.path(forResource: filename, ofType: "query")!
        let finalAnswer = try! String(contentsOfFile: bundle)
        return finalAnswer
    }
}
struct joinEventWithShortCode: OSTRichGraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    struct Response: Codable { let data: joinEventWithShortCodeData }
}
struct joinEventWithShortCodeData: Codable {
        let joinEventWithShortCode: String
}
