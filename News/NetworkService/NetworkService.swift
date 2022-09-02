//
//  NetworkService.swift
//  News
//
//  Created by Владислав Кузьмичёв on 31.08.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchArticles(completion: @escaping (Result<[Article]?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
   
    private let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey="
    private let apiKey = "708a03ef0dba4de9aceddfc9e4aa68c8"
    
    func fetchArticles(completion: @escaping (Result<[Article]?, Error>) -> Void) {
        
        let url = url+apiKey
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            do {
                let obj = try JSONDecoder().decode(Response.self, from: data!)
                let articles = obj.articles
                completion(.success(articles))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
