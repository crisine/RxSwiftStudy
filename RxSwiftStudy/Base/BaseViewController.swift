//
//  BaseViewController.swift
//  RxSwiftStudy
//
//  Created by Minho on 3/27/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    func configureHierarchy() {
        
    }
    
    func configureConstraints() {
        
    }
    
    func configureView() {
        view.backgroundColor = .white
    }
}
