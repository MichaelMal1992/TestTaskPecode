//
//  NewsData.swift
//  NewsClient
//
//  Created by Admin on 15.09.21.
//

import Foundation

struct NewsData: Codable {

    let status: String?
    let totalResults: Int?
    let articles: [Articles]
    
}

struct Articles: Codable {
    
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}

struct Source: Codable {

    let name: String?

}
