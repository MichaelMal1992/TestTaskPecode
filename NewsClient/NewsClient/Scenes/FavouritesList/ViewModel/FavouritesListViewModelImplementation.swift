//
//  FavouritesListViewModelImplementation.swift
//  NewsClient
//
//  Created by Admin on 20.09.21.
//

import Foundation

class FavouritesListViewModelImplementaion: FavouritesListViewModel {
    
    weak var viewController: FavouritesListViewController?
    init(_ viewController: FavouritesListViewController) {
        self.viewController = viewController
    }
    
    func loadImage(_ favouritesNewsData: [FavouritesNewsData], _ completion: @escaping ([ImageData]) -> Void) {
        if viewController?.activityIndicator.isAnimating == false {
            viewController?.activityIndicator.startAnimating()
        }
        var strings: [String] = []
        for string in favouritesNewsData {
            if string.urlToImage.isEmpty == false {
                strings.append(string.urlToImage)
            }
        }
        HTTPClient.shared.downloadImage(strings) { [weak self] results in
            switch results {
            case .success(let data):
                completion(data)
                self?.viewController?.activityIndicator.stopAnimating()
            case .failure(let error):
                self?.viewController?.activityIndicator.stopAnimating()
                print(error.localizedDescription)
            }
        }
    }
}
