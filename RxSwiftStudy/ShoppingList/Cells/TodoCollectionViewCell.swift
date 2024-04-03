//
//  TodoCollectionViewCell.swift
//  RxSwiftStudy
//
//  Created by Minho on 4/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class TodoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TodoCell"

    var disposeBag = DisposeBag()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let checkButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        view.tintColor = .black
        return view
    }()
    let titleTextField: UITextField = {
        let view = UITextField()
        view.font = .systemFont(ofSize: 18)
        return view
    }()
    let favoriteButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "star"), for: .normal)
        view.tintColor = .black
        return view
    }()
    let detailButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.right.circle"), for: .normal)
        view.tintColor = .black
        return view
    }()
    let deleteButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.tintColor = .systemRed
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    private func configureHierarchy() {
        [backView, checkButton, titleTextField, favoriteButton, detailButton, deleteButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
        
        checkButton.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.leading.equalTo(backView).offset(16)
            make.size.equalTo(40)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.leading.equalTo(checkButton.snp.trailing).offset(8)
            make.trailing.equalTo(favoriteButton.snp.leading).inset(8)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.trailing.equalTo(detailButton.snp.leading).inset(8)
            make.size.equalTo(40)
        }
        
        detailButton.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.trailing.equalTo(deleteButton.snp.leading).inset(8)
            make.size.equalTo(40)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.trailing.equalTo(backView).inset(8)
            make.size.equalTo(40)
        }
    }
    
    private func configureView() {
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
