//
//  TodoListViewModel.swift
//  RxSwiftStudy
//
//  Created by Minho on 4/3/24.
//

import RxSwift
import RxCocoa

final class TodoListViewModel {

    private let repository = RealmRepository()
    
    private var todoList: [Todo] = []
    let items: BehaviorSubject<[Todo]> = BehaviorSubject(value: [])

    struct Input {
        let searchBarText: ControlProperty<String?>
//        let addButton: ControlProperty<String>
//        let checkButton: ControlProperty<Todo>
//        let todoTitle: ControlProperty<(Todo, String)>
//        let favoriteButton: ControlProperty<Todo>
//        let deleteButton: ControlProperty<Todo>
    }
    
    struct Output {
        let items: BehaviorSubject<[Todo]>
    }
    
//    let inputSearchBarQuery = PublishSubject<String>()
//    let inputAddButtonTap = PublishSubject<String>()
//    let inputCheckButtonTap = PublishSubject<Todo>()
//    let inputTitleEditingDidEnd = PublishSubject<(Todo, String)>()
//    let inputFavoriteButtonTap = PublishSubject<Todo>()
//    let inputDeleteButtonTap = PublishSubject<Todo>()
    
    private var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.searchBarText
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, query in
                guard query != "" else {
                    owner.fetchTodoList()
                    return
                }
                owner.fetchTodoList(query: query)
            }
            .disposed(by: disposeBag)
        
        return Output(items: items)
    }
    
//    init() {
//        fetchTodoList()
//        
//        inputSearchBarQuery
//            .subscribe(with: self) { owner, query in
//                guard query != "" else {
//                    owner.fetchTodoList()
//                    return
//                }
//                owner.fetchTodoList(query: query)
//            }
//            .disposed(by: disposeBag)
//        
//        inputAddButtonTap
//            .subscribe(with: self) { owner, titleText in
//                let addTodo = RealmTodo(titleText: titleText, isCompleted: false, isFavorited: false)
//                owner.repository.create(realmTodo: addTodo)
//                owner.fetchTodoList()
//            }
//            .disposed(by: disposeBag)
//        
//        inputCheckButtonTap
//            .subscribe(with: self) { owner, todo in
//                var updateTodo = todo
//                updateTodo.isCompleted.toggle()
//                owner.updateTodo(todo: todo)
//            }
//            .disposed(by: disposeBag)
//        
//        inputTitleEditingDidEnd
//            .subscribe(with: self) { owner, tuple in
//                var updateTodo = tuple.0
//                updateTodo.titleText = tuple.1
//                owner.updateTodo(todo: updateTodo)
//            }
//            .disposed(by: disposeBag)
//        
//        inputFavoriteButtonTap
//            .subscribe(with: self) { owner, todo in
//                var updateTodo = todo
//                updateTodo.isFavorited.toggle()
//                owner.updateTodo(todo: todo)
//            }
//            .disposed(by: disposeBag)
//        
//        inputDeleteButtonTap
//            .subscribe(with: self) { owner, todo in
//                owner.repository.delete(id: todo.id)
//                owner.fetchTodoList()
//            }
//            .disposed(by: disposeBag)
//    }
    
    private func fetchTodoList() {
        todoList = repository.fetch()
        items.onNext(todoList)
    }
    
    private func fetchTodoList(query: String) {
        todoList = repository.fetch(titleText: query)
        items.onNext(todoList)
    }
    
    private func updateTodo(todo: Todo) {
        repository.update(todo: todo)
        fetchTodoList()
    }
}
