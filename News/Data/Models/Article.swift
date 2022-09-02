//
//  Article.swift
//  News
//
//  Created by Владислав Кузьмичёв on 31.08.2022.
//

import Foundation

struct Response: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    let source: Source?
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source: Decodable {
    let id: String?
    let name: String
}
