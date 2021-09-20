//
//  NewsViewModel.swift
//  NewsClient
//
//  Created by Admin on 19.09.21.
//

import Foundation

protocol NewsViewModel {

    func loadRequest(filters: String, _ comletion: @escaping (NewsData, [ImageData]) -> Void)

    var isPagination: Bool { get set }
}
