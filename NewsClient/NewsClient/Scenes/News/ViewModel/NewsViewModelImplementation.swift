//
//  NewsViewModelInplementaion.swift
//  NewsClient
//
//  Created by Admin on 19.09.21.
//

import Foundation

class NewsViewModelImplementation: NewsViewModel {

    weak var viewController: NewsViewController?
    init(_ viewController: NewsViewController) {
        self.viewController = viewController
    }

    private var imagesData: [ImageData] = [] {
        didSet {
            
        }
    }
    private var newsData: NewsData? {
        didSet {
            guard let newsData = newsData else {
                return
            }
            didLoadRequest?(newsData)
        }
    }

    var didLoadRequest: ((NewsData) -> Void)?
    
}
