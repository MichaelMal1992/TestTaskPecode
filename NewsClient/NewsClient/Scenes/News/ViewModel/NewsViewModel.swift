//
//  NewsViewModel.swift
//  NewsClient
//
//  Created by Admin on 19.09.21.
//

import Foundation
import UIKit

protocol NewsViewModel {

    var didLoadRequest: ((NewsData) -> Void)? { get set}
}
