//
//  DetailViewController.swift
//  RxSwiftStudy
//
//  Created by Minho on 4/3/24.
//

import UIKit

final class DetailViewController: BaseViewController {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 32)
        return view
    }()
    
    var selectedTodo: Todo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        view.addSubview(titleLabel)
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(120)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .white
        titleLabel.text = selectedTodo.titleText
    }
}
