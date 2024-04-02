//
//  TodoCollectionViewCell.swift
//  RxSwiftStudy
//
//  Created by Minho on 4/2/24.
//

import UIKit
import RxSwift

final class TodoInputCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TodoInputCell"

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let textField: UITextField = {
        let view = UITextField()
        view.placeholder = "무엇을 구매하실 건가요?"
        return view
    }()
    let addButton: UIButton = {
        let view = UIButton(configuration: .filled())
        view.setTitle("추가", for: .normal)
        view.clipsToBounds = true
        view.tintColor = .systemGray5
        view.layer.cornerRadius = 8
        return view
    }()
    
    var disposeBag = DisposeBag()
    
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
        [backView, textField, addButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.leading.equalTo(backView).offset(16)
            make.verticalEdges.equalTo(contentView).inset(8)
        }
        
        addButton.snp.makeConstraints { make in
            make.leading.equalTo(textField.snp.trailing).offset(4)
            make.trailing.equalTo(backView).inset(16)
            make.centerY.equalTo(backView)
            make.height.equalTo(32)
        }
    }
    
    private func configureView() {
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
