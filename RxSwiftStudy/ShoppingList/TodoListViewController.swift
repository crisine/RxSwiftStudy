//
//  TodoListViewController.swift
//  RxSwiftStudy
//
//  Created by Minho on 4/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
 

final class TodoListViewController: BaseViewController {
    
    enum Section: Int, Hashable {
        case input
        case todo
    }
    
    private let diffableTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    typealias SectionType = Section
    private var dataSource: DataSource!
    
    private let repository = RealmRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configureDataSource()
    }
    
    private func bind() {
        
    }
    
    override func configureHierarchy() {
        [diffableTableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        diffableTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        diffableTableView.delegate = self
        diffableTableView.register(TodoInputTableViewCell.self, forCellReuseIdentifier: TodoInputTableViewCell.reuseIdentifier)
        diffableTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.reuseIdentifier)
    }
}

extension TodoListViewController {
    final class DataSource: UITableViewDiffableDataSource<SectionType, Todo> {
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let identifierToDelete = itemIdentifier(for: indexPath) {
                    var snapshot = self.snapshot()
                    snapshot.deleteItems([identifierToDelete])
                    apply(snapshot)
                }
            }
        }
    }
}

extension TodoListViewController {
    private func configureDataSource() {
        dataSource = DataSource(tableView: diffableTableView) { (tableView, indexPath, todo) -> UITableViewCell? in
            
            switch Section(rawValue: indexPath.section) {
            case .input:
                let cell = tableView.dequeueReusableCell(withIdentifier: TodoInputTableViewCell.reuseIdentifier, for: indexPath) as! TodoInputTableViewCell
                print("input cell draw")
                return cell
            case .todo:
                let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.reuseIdentifier, for: indexPath) as! TodoTableViewCell
                print("todo cell draw")
                
                cell.titleLabel.text = todo.titleText
                
                let favoriteButtonImage = todo.isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
                cell.favoriteButton.setImage(favoriteButtonImage, for: .normal)
                
                let completeButtonImage = todo.isCompleted ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
                cell.checkButton.setImage(completeButtonImage, for: .normal)
                
                cell.checkButton.rx.tap
                    .bind(with: self) { owner, _ in
                        var todo = owner.dataSource.itemIdentifier(for: indexPath)!
                        todo.isCompleted.toggle()
                        owner.repository.update(todo: todo)
                        owner.updateSnapshot()
                    }
                    .disposed(by: cell.disposeBag)
                
                return cell
            default:
                print("an error has occured")
            }
            
            return nil
        }
        
        let snapshot = initialSnapshot()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func initialSnapshot() -> NSDiffableDataSourceSnapshot<SectionType, Todo> {
        let todoList = repository.fetch()
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Todo>()
        snapshot.appendSections([.input])
        snapshot.appendItems([RealmTodo(titleText: "", isCompleted: false, isFavorited: false).toStruct()]) // MARK: Section을 띄우기 위한 땜빵. 제대로 띄우려면 ItemType도 만들 것
        snapshot.appendSections([.todo])
        snapshot.appendItems(todoList)
        
        return snapshot
    }
    
    private func updateSnapshot() {
        let todoList = repository.fetch()
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Todo>()
        snapshot.appendSections([.input])
        snapshot.appendItems([RealmTodo(titleText: "", isCompleted: false, isFavorited: false).toStruct()])
        snapshot.appendSections([.todo])
        snapshot.appendItems(todoList)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: TableView Delegate 관련
extension TodoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 여기서 화면이동 처리
    }
}
