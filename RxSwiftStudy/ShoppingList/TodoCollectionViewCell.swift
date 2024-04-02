//
//  TodoCollectionViewCell.swift
//  RxSwiftStudy
//
//  Created by Minho on 4/1/24.
//

import UIKit
import RxSwift

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
        [backView, checkButton, titleLabel, favoriteButton].forEach {
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
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.leading.equalTo(checkButton.snp.trailing).offset(8)
            make.trailing.equalTo(favoriteButton.snp.leading).inset(8)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.trailing.equalTo(backView).inset(16)
            make.size.equalTo(40)
        }
    }
    
    private func configureView() {
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
