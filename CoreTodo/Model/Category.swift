//
//  Category.swift
//  CoreTodo
//
//  Created by Jonathan Hernandez on 12/26/17.
//  Copyright © 2017 Jonathan Hernandez. All rights reserved.
//

import Foundation
import RealmSwift

class  Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
