//
//  RealmTodo.swift
//  RxSwiftStudy
//
//  Created by Minho on 4/2/24.
//

import RealmSwift

final class RealmTodo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var titleText: String
    @Persisted var isCompleted: Bool
    @Persisted var isFavorited: Bool
    
    convenience init(titleText: String, isCompleted: Bool, isFavorited: Bool) {
        self.init()
        self.titleText = titleText
        self.isCompleted = isCompleted
        self.isFavorited = isFavorited
    }
}

extension RealmTodo {
    func toStruct() -> Todo {
        return Todo(id: self.id, titleText: self.titleText, isCompleted: self.isCompleted, isFavorited: self.isFavorited)
    }
}
