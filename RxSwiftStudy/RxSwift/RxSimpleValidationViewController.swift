//
//  RxSimpleValidationViewController.swift
//  RxSwiftStudy
//
//  Created by Minho on 3/28/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

final class RxSimpleValidationViewController: BaseViewController {
    
    private let usernameOutlet: UITextField = {
        let view = UITextField()
        view.layer.borderWidth = 1
        return view
    }()
    private let usernameValidOutlet: UILabel = {
        let view = UILabel()
        
        return view
    }()

    private let passwordOutlet: UITextField = {
        let view = UITextField()
        view.layer.borderWidth = 1
        return view
    }()
    private let passwordValidOutlet: UILabel = {
        let view = UILabel()
        
        return view
    }()

    private let doSomethingOutlet: UIButton = {
        let view = UIButton(configuration: .filled())
        view.setTitle("do something", for: .normal)
        return view
    }()
    
    private let disposeBag = DisposeBag()
    
    private var nickname = Observable.just("고래밥")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        
    }
    
    override func configureHierarchy() {
        [usernameOutlet, usernameValidOutlet, passwordOutlet, passwordValidOutlet, doSomethingOutlet].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        usernameOutlet.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(48)
        }
        
        usernameValidOutlet.snp.makeConstraints { make in
            make.top.equalTo(usernameOutlet.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(usernameOutlet)
        }
        
        passwordOutlet.snp.makeConstraints { make in
            make.top.equalTo(usernameValidOutlet.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(usernameOutlet)
        }
        
        passwordValidOutlet.snp.makeConstraints { make in
            make.top.equalTo(passwordOutlet.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(usernameOutlet)
        }
        
        doSomethingOutlet.snp.makeConstraints { make in
            make.top.equalTo(passwordValidOutlet.snp.bottom).offset(36)
            make.horizontalEdges.equalTo(usernameOutlet)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .white
    }
    
    private func bind() {
        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"

        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default

        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)

        usernameValid
            .bind(to: passwordOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        usernameValid
            .bind(to: usernameValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)

        passwordValid
            .bind(to: passwordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)

        everythingValid
            .bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        doSomethingOutlet.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
