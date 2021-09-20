//
//  FavouritesListViewModel.swift
//  NewsClient
//
//  Created by Admin on 20.09.21.
//

import Foundation

protocol FavouritesListViewModel {
    
    func loadImage(_ favouritesNewsData: [FavouritesNewsData], _ completion: @escaping ([ImageData]) -> Void)

    

}
