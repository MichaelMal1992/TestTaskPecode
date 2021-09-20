//
//  RequestManager.swift
//  NewsClient
//
//  Created by Admin on 15.09.21.
//

import Foundation
import UIKit

class HTTPClient {
    
    static let shared = HTTPClient()
    private let apiKey = "08aba6ce6b6c477ba3102fb32edd8822"
    private let endPointsForNew = "https://newsapi.org/v2/top-headlines?"
    private let endPointsForSources = "https://newsapi.org/v2/top-headlines/sources?"
    private let authorization = "Authorization"

    private func makeGetRequest(url: URL,
                                headers: [String: String]) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    func fetchAvailableNewsSources(queue: DispatchQueue = .main,
                                   _ completion: @escaping (Result<NewsSources, Error>) -> Void) {
        guard let url = URL(string: endPointsForSources),
              let request = makeGetRequest(url: url, headers: [authorization : apiKey]) else {
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                queue.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                print("no data in response")
                return
            }
            do {
                let sources = try JSONDecoder().decode(NewsSources.self, from: data)
                queue.async {
                    completion(.success(sources))
                }
            } catch {
                queue.async {
                    completion(.failure(error))
                }
                return
            }
        }
        task.resume()
    }
    
    func fetchAvailableNews(page: Int,
                            queue: DispatchQueue = .main,
                            _ completion: @escaping (Result<NewsData, Error>, _ finishLoad: Bool) -> Void) {
        
        guard let data = FiltersValue.shared.filter.data(using: .utf8),
              let str = String(data: data, encoding: .utf8) else {
            return
        }
        guard let url = URL(string: endPointsForNew
                                + str
                                + "&pageSize="
                                + String(page)),
              let request = makeGetRequest(url: url, headers: [authorization : apiKey]) else {
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                queue.async {
                    completion(.failure(error), true)
                }
                return
            }
            guard let data = data else {
                print("no data in response")
                return
            }
            do {
                let news = try JSONDecoder().decode(NewsData.self, from: data)
                queue.async {
                    completion(.success(news), true)
                }
            } catch {
                queue.async {
                    completion(.failure(error), true)
                }
                return
            }
        }
        task.resume()
    }
    
    func downloadImage(_ urlsArray: [String], queue: DispatchQueue = .main,
                       _ completion: @escaping (Result<[ImageData], Error>) -> Void) {
        var array: [ImageData] = []
        DispatchQueue.global().async {
            let group = DispatchGroup()
            for link in urlsArray {
                guard let url = URL(string: link) else {
                    return
                }
                group.enter()
                let request = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    if let error = error {
                        queue.async {
                            completion(.failure(error))
                        }
                    }
                    if let data = data {
                        let image = UIImage(data: data) ?? UIImage(named: "notFoundImage_icon") ?? UIImage()
                        queue.async {
                            let imageData = ImageData(name: link, image: image)
                            array.append(imageData)
                        }
                    }
                    group.leave()
                }
                task.resume()
            }
            group.notify(queue: queue, execute: {
                queue.async {
                    completion(.success(array))
                }
            })
        }
    }
}
