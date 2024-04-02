//
//  TodoTableViewCell.swift
//  RxSwiftStudy
//
//  Created by Minho on 4/1/24.
//

import UIKit
import RxSwift

final class TodoTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TodoCell"

    var disposeBag = DisposeBag()
    
    let checkButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        view.tintColor = .black
        return view
    }()
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        return view
    }()
    let favoriteButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "star"), for: .normal)
        view.tintColor = .black
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    private func configureHierarchy() {
        [checkButton, titleLabel, favoriteButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        checkButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(16)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(checkButton.snp.trailing).offset(8)
            make.trailing.equalTo(favoriteButton.snp.leading).inset(8)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(16)
            make.size.equalTo(40)
        }
    }
    
    private func configureView() {
        contentView.backgroundColor = .systemGray6
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
