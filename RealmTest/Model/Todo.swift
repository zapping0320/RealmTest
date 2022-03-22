//
//  Todo.swift
//  RealmTest
//
//  Created by DONGHYUN KIM on 2022/03/22.
//

import RealmSwift

class Todo : Object {
    @objc dynamic var id                = 0
    @objc dynamic var isDone            = false //false - processing true - done
    @objc dynamic var title             = ""
    
    @objc dynamic var updatedDate:Date  = Date()
    @objc dynamic var deletedDate:Date?
  
   override static func primaryKey() -> String? {
       return "id"
   }
    
}
