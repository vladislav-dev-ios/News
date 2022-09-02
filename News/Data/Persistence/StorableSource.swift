//
//  StorableSource.swift
//  News
//
//  Created by Владислав Кузьмичёв on 01.09.2022.
//

import Foundation
import RealmSwift

extension Source: Entity {
    private var storableSource: StorableSource {
        let storableSource = StorableSource()
        storableSource.id = id
        storableSource.name = name
        storableSource.uuid = name
        return storableSource
    }
    
    func toStorable() -> StorableSource {
        return storableSource
    }
}

class StorableSource: Object, Storable {
    
    @objc dynamic var id: String? = nil
    @objc dynamic var name: String = ""
    @objc dynamic var uuid: String = ""
    
    var model: Source {
        get {
            return Source(id: id, name: name)
        }
    }
}
