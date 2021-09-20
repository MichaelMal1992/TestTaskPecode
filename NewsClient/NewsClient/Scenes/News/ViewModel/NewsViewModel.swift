//
//  NewsViewModel.swift
//  NewsClient
//
//  Created by Admin on 19.09.21.
//

import Foundation

protocol NewsViewModel {

    func loadRequest(_ comletion: @escaping (NewsData) -> Void)
    
    func loadImage(newsData: NewsData, _ completion: @escaping ([ImageData]) -> Void)

    var isPagination: Bool { get set }
}
