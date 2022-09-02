//
//  StorableArticle.swift
//  News
//
//  Created by Владислав Кузьмичёв on 01.09.2022.
//

import Foundation
import RealmSwift

extension Article: Entity {
    private var storableArticle: StorableArticle {
        let realmArticle = StorableArticle()
        realmArticle.source = source?.toStorable()
        realmArticle.author = author
        realmArticle.title = title
        realmArticle.articleDescription = articleDescription
        realmArticle.url = url
        realmArticle.urlToImage = urlToImage
        realmArticle.publishedAt = publishedAt
        realmArticle.content = content
        realmArticle.uuid = title
        return realmArticle
    }

    func toStorable() -> StorableArticle {
        return storableArticle
    }
}

class StorableArticle: Object, Storable {
    
    @objc dynamic var source: StorableSource?
    @objc dynamic var author: String?
    @objc dynamic var title: String = ""
    @objc dynamic var articleDescription: String?
    @objc dynamic var url: String = ""
    @objc dynamic var urlToImage: String?
    @objc dynamic var publishedAt: String = ""
    @objc dynamic var content: String?
    @objc dynamic var uuid: String = ""
    
    var model: Article {
        get {
            return Article(source: source?.model, author: author, title: title, articleDescription: articleDescription, url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)
        }
    }
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}


