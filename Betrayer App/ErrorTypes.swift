//
//  ErrorTypes.swift
//  Betrayer App
//
//  Created by snow on 9/17/23.
//

import Foundation

struct GraphQLError: Decodable, Error {
    struct Location: Decodable {
        let line: Int
        let column: Int
    }
    
    let message: String
    let locations: [Location]?
    let path: [String]?
    let extensions: Extensions
    
    struct Extensions: Decodable {
        let code: String
    }
}

struct HTTPError: Decodable, Error {
    let code: Int
    let error: String
    let grpcCode: String
}
