//
//  TodoInputTableViewCell.swift
//  RxSwiftStudy
//
//  Created by Minho on 4/2/24.
//

import UIKit

final class TodoInputTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TodoInputCell"

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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    private func configureHierarchy() {
        [textField, addButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.verticalEdges.equalTo(contentView).inset(8)
        }
        
        addButton.snp.makeConstraints { make in
            make.leading.equalTo(textField.snp.trailing).offset(4)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(32)
        }
    }
    
    private func configureView() {
        contentView.backgroundColor = .systemGray6
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
