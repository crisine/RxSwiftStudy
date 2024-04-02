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
    
    private let repository = RealmRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configureDataSource()
    }
    
    private func bind() {
        
    }
    
    override func configureHierarchy() {
        [diffableCollectionView].forEach {
            view.addSubview($0)
        }
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
                print("input cell draw")
                return cell
            case .todo(let todo):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCollectionViewCell.reuseIdentifier, for: indexPath) as! TodoCollectionViewCell
                print("todo cell draw")
                
                cell.titleLabel.text = todo.titleText
                
                let favoriteButtonImage = todo.isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
                cell.favoriteButton.setImage(favoriteButtonImage, for: .normal)
                
                let completeButtonImage = todo.isCompleted ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
                cell.checkButton.setImage(completeButtonImage, for: .normal)
                
                cell.checkButton.rx.tap
                    .bind(with: self) { owner, _ in
                        var updateTodo = todo
                        updateTodo.isCompleted.toggle()
                        owner.repository.update(todo: updateTodo)
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
    
    private func initialSnapshot() -> NSDiffableDataSourceSnapshot<SectionType, Item> {
        let todoList = repository.fetch()
        
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
        let todoList = repository.fetch()
        
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
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
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
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
