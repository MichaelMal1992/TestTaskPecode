//
//  CountryViewModel.swift
//  NewsClient
//
//  Created by Admin on 20.09.21.
//

import Foundation

protocol CountryViewModel {

    func loadSources(_ completion: @escaping ([String]) -> Void)
}
