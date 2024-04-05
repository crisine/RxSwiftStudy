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
        let addButtonTap: ControlEvent<Void>
        let todoTitle: ControlProperty<String?>
    }
    
    struct Output {
        let items: BehaviorSubject<[Todo]>
        // let titleTextField: Driver<String>
    }
    
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
        
        input.addButtonTap
        // MARK: withLatest를 사용하면 titleText가 없는데도 addButton을 누를 경우
        // 마지막에 입력했던 todo Title로 계속 todo가 추가될 염려가 있다.
            .withLatestFrom(input.todoTitle.orEmpty)
            .subscribe(with: self) { owner, titleText in
                let addTodo = RealmTodo(titleText: titleText, isCompleted: false, isFavorited: false)
                owner.repository.create(realmTodo: addTodo)
                owner.fetchTodoList()
            }
            .disposed(by: disposeBag)
        
        return Output(items: items)
    }
    
    private func fetchTodoList() {
        todoList = repository.fetch()
        items.onNext(todoList)
    }
    
    private func fetchTodoList(query: String) {
        todoList = repository.fetch(titleText: query)
        items.onNext(todoList)
    }
    
    func updateTodo(todo: Todo, updatePolicy: UpdatePolicy) {
        
        var updateTodo = todo
        
        switch updatePolicy {
        case .complete:
            updateTodo.isCompleted.toggle()
        case .favorite:
            updateTodo.isFavorited.toggle()
        }
        
        repository.update(todo: todo)
        fetchTodoList()
    }
    
    func deleteTodo(todo: Todo) {
        repository.delete(id: todo.id)
        fetchTodoList()
    }
    
    enum UpdatePolicy {
        case complete
        case favorite
    }
}
