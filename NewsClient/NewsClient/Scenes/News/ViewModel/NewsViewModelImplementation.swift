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
    
    private var totalPesult: Int?

    private var page = 10

    var isPagination: Bool = false {
        didSet {
            switch isPagination {
            case true:
                if self.page < totalPesult ?? self.page {
                    self.page += 10
                } else {
                    self.viewController?.showAlert("This is all news")
                    return
                }
            case false:
                return
            }
        }
    }

    func loadRequest(filters: String, _ comletion: @escaping (NewsData, [ImageData]) -> Void) {
        if viewController?.refreshControl?.isRefreshing == false,
           viewController?.activityIndicator.isAnimating == false {
            viewController?.activityIndicator.startAnimating()
        }
        HTTPClient.shared.fetchAvailableNews(page: page, filters: filters) { [weak self] results, finishLoad  in
            guard let self = self else {
                return
            }
            switch results {
            case .success(let news):
                self.viewController?.activityIndicator.stopAnimating()
                self.viewController?.refreshControl?.endRefreshing()
                if news.status == "ok",
                   news.articles.isEmpty == false {
                    self.totalPesult = news.totalResults
                    self.isPagination = !finishLoad
                    let imagesData = self.loadImage(news)
                    comletion(news, imagesData)
                } else {
                    self.viewController?.showAlert("Nothing found about this")
                }
            case .failure(let errror):
                self.viewController?.showAlert("Error")
                self.viewController?.activityIndicator.stopAnimating()
                self.viewController?.refreshControl?.endRefreshing()
                print(errror.localizedDescription)
            }
        }
    }
    
    private func loadImage(_ newsData: NewsData) -> [ImageData] {
        var strings: [String] = []
        var images: [ImageData] = []
        for articles in newsData.articles {
            if let string = articles.urlToImage,
               string.isEmpty == false,
               string.prefix(8) == "https://" || string.prefix(7) == "http://" {
                strings.append(string)
            }
        }
        HTTPClient.shared.downloadImage(strings) { results in
            switch results {
            case .success(let imageData):
                images = imageData
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return images
    }
}
