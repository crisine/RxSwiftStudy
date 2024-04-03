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
    
    enum Item: Hashable {
        case input(dummy: Int)
        case todo(todo: Todo)
    }
    
    private lazy var diffableCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    typealias SectionType = Section
    private var dataSource: DataSource!
    private var searchBar: UISearchBar!
    private var todoList: [Todo] = []
    
    private let repository = RealmRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoList = repository.fetch()
        
        bind()
        configureDataSource()
    }
    
    private func bind() {
        
    }
    
    override func configureHierarchy() {        
        view.addSubview(diffableCollectionView)
    }
    
    override func configureConstraints() {
        diffableCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        diffableCollectionView.delegate = self
        diffableCollectionView.register(TodoInputCollectionViewCell.self, forCellWithReuseIdentifier: TodoInputCollectionViewCell.reuseIdentifier)
        diffableCollectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: TodoCollectionViewCell.reuseIdentifier)
        
        navigationItem.title = "To do List"
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "할 일 검색"
        
        navigationItem.titleView = searchBar
    }
}

extension TodoListViewController {
    final class DataSource: UICollectionViewDiffableDataSource<SectionType, Item> {
        
    }
}

extension TodoListViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: diffableCollectionView) { (collectionView, indexPath, itemIdentifier ) -> UICollectionViewCell? in
            
            switch itemIdentifier {
            case .input(let dummy):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoInputCollectionViewCell.reuseIdentifier, for: indexPath) as! TodoInputCollectionViewCell
                
                cell.addButton.rx.tap
                    .bind(with: self) { owner, _ in
                        guard let titleText = cell.textField.text else { return }
                        cell.textField.text = ""
                        
                        let newTodo = RealmTodo(titleText: titleText, isCompleted: false, isFavorited: false)
                        owner.repository.create(realmTodo: newTodo)
                        owner.todoList = owner.repository.fetch()
                        owner.updateSnapshot()
                    }
                    .disposed(by: cell.disposeBag)
                
                return cell
            case .todo(let todo):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCollectionViewCell.reuseIdentifier, for: indexPath) as! TodoCollectionViewCell
                
                cell.titleTextField.text = todo.titleText
                
                let favoriteButtonImage = todo.isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
                cell.favoriteButton.setImage(favoriteButtonImage, for: .normal)
                
                let completeButtonImage = todo.isCompleted ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
                cell.checkButton.setImage(completeButtonImage, for: .normal)
                
                cell.checkButton.rx.tap
                    .bind(with: self) { owner, _ in
                        var updateTodo = todo
                        updateTodo.isCompleted.toggle()
                        owner.repository.update(todo: updateTodo)
                        owner.todoList = owner.repository.fetch()
                        owner.updateSnapshot()
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.titleTextField.rx.controlEvent([.editingDidEnd])
                    .asObservable()
                    .subscribe(with: self) { owner, _ in
                        guard let titleText = cell.titleTextField.text else { return }
                        guard titleText != todo.titleText else { return } // MARK: distinctUntilChanged 로 어떻게 안되나?
                        var updateTodo = todo
                        updateTodo.titleText = titleText
                        owner.repository.update(todo: updateTodo)
                        owner.todoList = owner.repository.fetch()
                        owner.updateSnapshot()
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.favoriteButton.rx.tap
                    .bind(with: self) { owner, _ in
                        var updateTodo = todo
                        updateTodo.isFavorited.toggle()
                        owner.repository.update(todo: updateTodo)
                        owner.todoList = owner.repository.fetch()
                        owner.updateSnapshot()
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.detailButton.rx.tap
                    .bind(with: self) { owner, _ in
                        let vc = DetailViewController()
                        vc.selectedTodo = todo
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                
                cell.deleteButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.repository.delete(id: todo.id)
                        owner.todoList = owner.repository.fetch()
                        owner.updateSnapshot()
                    }
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
        }
        
        let snapshot = initialSnapshot()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func initialSnapshot() -> NSDiffableDataSourceSnapshot<SectionType, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Item>()
        snapshot.appendSections([.input])
        snapshot.appendItems([.input(dummy: 1)])
        snapshot.appendSections([.todo])
        todoList.forEach { todo in
            snapshot.appendItems([.todo(todo: todo)])
        }
        
        return snapshot
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Item>()
        snapshot.appendSections([.input])
        snapshot.appendItems([.input(dummy: 1)])
        snapshot.appendSections([.todo])
        todoList.forEach { todo in
            snapshot.appendItems([.todo(todo: todo)])
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}


extension TodoListViewController: UICollectionViewDelegate {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        // MARK: CompositionalLayout
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .input:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitems: [item])
                
                let layoutSection = NSCollectionLayoutSection(group: group)
                layoutSection.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
                
                return layoutSection
            case .todo:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(48)), subitems: [item])
                
                let layoutSection = NSCollectionLayoutSection(group: group)
                layoutSection.interGroupSpacing = 2
                layoutSection.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
                
                return layoutSection
            }
        }
        
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension TodoListViewController: UISearchBarDelegate {
    
    // MARK: 지금이야 Local Realm에 데이터도 적고 로컬이라 상관없지만 이게 원격인 경우를 생각하면 매우 비효율이고, 사실 여기에 코드를 작성해서도 안 된다. (Rx는 bind함수에서 해결)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else {
            todoList = repository.fetch()
            updateSnapshot()
            return
        }
        todoList = repository.fetch(titleText: searchText)
        updateSnapshot()
    }
}
