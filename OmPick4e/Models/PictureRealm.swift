//
//  PictureRealm.swift
//  OmPick4e
//
//  Created by Mikhail Danilov on 25.07.2021.
//

import Foundation
import RealmSwift

class PictureRealm: Object {
    @objc dynamic var id = ""
    @objc dynamic var width = 0
    @objc dynamic var height = 0
    @objc dynamic var saveImg = ""
    @objc dynamic var createdAt = ""
    
    public required override init() {
        super.init()
    }

    convenience init(id: String, width: Int, height: Int, saveImg: String) {
        self.init()
        self.id = id
        self.width = width
        self.height = height
        self.saveImg = saveImg
    }
}
