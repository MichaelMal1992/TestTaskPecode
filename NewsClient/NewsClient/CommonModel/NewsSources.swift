//
//  NewsSources.swift
//  NewsClient
//
//  Created by Admin on 15.09.21.
//

import Foundation

struct NewsSources: Codable {

    let status: String
    let sources: [Sources]
}

struct Sources: Codable {

    let source: String
    let category: String
    let country: String

    enum CodingKeys: String, CodingKey {
        
        case source = "id"
        case category
        case country
    }
}
