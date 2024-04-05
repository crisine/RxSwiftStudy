//
//  TodoListRxViewController.swift
//  RxSwiftStudy
//
//  Created by Minho on 4/3/24.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: RxDataSource때문에 5시간 날려먹고 그냥 다른 뷰컨 만듭니다..
final class TodoListRxViewController: BaseViewController {
    
    let addAreaBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    let titleTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "새로운 할 일..."
        return view
    }()
    let addButton: UIButton = {
        let view = UIButton(configuration: .filled())
        view.tintColor = .systemGray6
        view.setTitle("추가", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private var searchBar: UISearchBar!
    private let todoTableView: UITableView = {
        let view = UITableView()
        view.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.reuseIdentifier)
        view.separatorStyle = .none
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let viewModel = TodoListViewModel()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        
        let input = TodoListViewModel.Input(searchBarText: searchBar.rx.text)
        
        let output = viewModel.transform(input: input)
        
//        addButton.rx.tap
//            .withLatestFrom(titleTextField.rx.text.orEmpty)
//            .bind(with: self) { owner, titleText in
//                owner.viewModel.inputAddButtonTap.onNext(titleText)
//                owner.titleTextField.text = ""
//            }
//            .disposed(by: disposeBag)
        
        output.items
            .bind(to: todoTableView.rx.items(cellIdentifier: TodoTableViewCell.reuseIdentifier, cellType: TodoTableViewCell.self)) { row, element, cell in
                
                let checkButtonImage = element.isCompleted ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
                
                cell.checkButton.setImage(checkButtonImage, for: .normal)
                
                let favoriteButtonImage = element.isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
                
                cell.favoriteButton.setImage(favoriteButtonImage, for: .normal)
                
                cell.titleTextField.text = element.titleText
//                cell.titleTextField.rx
//                    .controlEvent(.editingDidEnd)
//                    .withLatestFrom(cell.titleTextField.rx.text.orEmpty)
//                    .bind(with: self) { owner, titleText in
//                        let tuple = (element, titleText)
//                        owner.viewModel.inputTitleEditingDidEnd.onNext(tuple)
//                    }
//                    .disposed(by: cell.disposeBag)
                
                // MARK: RxSwift
//                cell.checkButton.rx.tap
//                    .bind(with: self) { owner, _ in
//                        owner.viewModel.inputCheckButtonTap.onNext(element)
//                    }
//                    .disposed(by: cell.disposeBag)
//                
//                cell.favoriteButton.rx.tap
//                    .bind(with: self) { owner, _ in
//                        owner.viewModel.inputFavoriteButtonTap.onNext(element)
//                    }
//                    .disposed(by: cell.disposeBag)
//                
//                cell.detailButton.rx.tap
//                    .bind(with: self) { owner, _ in
//                        // MARK: 이 경우엔 화면 이동을 어떻게?
//                    }
//                    .disposed(by: cell.disposeBag)
//                
//                cell.deleteButton.rx.tap
//                    .bind(with: self) { owner, _ in
//                        owner.viewModel.inputDeleteButtonTap.onNext(element)
//                    }
//                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [addAreaBackView, titleTextField, addButton, todoTableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        addAreaBackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.centerY.equalTo(addAreaBackView)
            make.leading.equalTo(addAreaBackView.snp.leading).offset(16)
            make.trailing.equalTo(addButton.snp.leading).offset(-8)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(addAreaBackView)
            make.trailing.equalTo(addAreaBackView.snp.trailing).inset(16)
            make.verticalEdges.equalTo(addAreaBackView).inset(16)
            make.width.equalTo(60)
        }
        
        todoTableView.snp.makeConstraints { make in
            make.top.equalTo(addAreaBackView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        todoTableView.delegate = self
        
        searchBar = UISearchBar()
        searchBar.placeholder = "할 일 검색"
        
        navigationItem.titleView = searchBar
        navigationItem.title = "To do List"
    }
}

extension TodoListRxViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}
