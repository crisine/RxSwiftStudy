//
//  RealmRepository.swift
//  RxSwiftStudy
//
//  Created by Minho on 4/2/24.
//

import RealmSwift

final class RealmRepository {
    
    private let realm = try! Realm()
    
    // MARK: Create
    func create(realmTodo: RealmTodo) {
        do {
            try realm.write {
                realm.add(realmTodo)
            }
        } catch {
            dump(error)
        }
    }
    
    
    // MARK: Read
    func fetch() -> [Todo] {
        print(realm.configuration.fileURL ?? "")
        return Array(realm.objects(RealmTodo.self).map { $0.toStruct() })
    }
    
    private func fetch(id: ObjectId) -> RealmTodo? {
        return realm.object(ofType: RealmTodo.self, forPrimaryKey: id)
    }
    
    func fetch(titleText: String) -> [Todo] {
        let realmTodoList = realm.objects(RealmTodo.self).where{ realmTodo in
            realmTodo.titleText.contains(titleText)
        }
        
        return Array(realmTodoList.map { $0.toStruct() })
    }
    
    
    // MARK: Update
    func update(todo: Todo) {
        guard let oldTodo = realm.object(ofType: RealmTodo.self, forPrimaryKey: todo.id) else {
            return
        }
        
        do {
            try realm.write {
                oldTodo.titleText = todo.titleText
                oldTodo.isCompleted = todo.isCompleted
                oldTodo.isFavorited = todo.isFavorited
            }
        } catch {
            dump(error)
        }
    }
    
    
    // MARK: Delete
    func delete(id: ObjectId) {
        guard let todo = fetch(id: id) else {
            return
        }
        
        do {
            try realm.write {
                realm.delete(todo)
            }
        } catch {
            dump(error)
        }
    }
}
