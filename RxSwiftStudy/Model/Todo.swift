//
//  Todo.swift
//  RxSwiftStudy
//
//  Created by Minho on 4/1/24.
//

import RealmSwift

struct Todo: Hashable {
    var id: ObjectId
    var titleText: String
    var isCompleted: Bool
    var isFavorited: Bool
}
