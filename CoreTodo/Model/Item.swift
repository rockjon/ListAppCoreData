//
//  Item.swift
//  CoreTodo
//
//  Created by Jonathan Hernandez on 12/26/17.
//  Copyright © 2017 Jonathan Hernandez. All rights reserved.
//

import Foundation
import RealmSwift

class  Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
