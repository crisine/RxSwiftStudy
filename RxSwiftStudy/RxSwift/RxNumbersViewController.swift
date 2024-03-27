//
//  RxNumbersViewController.swift
//  RxSwiftStudy
//
//  Created by Minho on 3/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RxNumbersViewController: BaseViewController {
    
    private let numberTextField01: UITextField = {
        let view = UITextField()
        view.textAlignment = .right
        view.font = .systemFont(ofSize: 18)
        view.text = "1"
        return view
    }()
    private let numberTextField02: UITextField = {
        let view = UITextField()
        view.textAlignment = .right
        view.font = .systemFont(ofSize: 18)
        view.text = "2"
        return view
    }()
    private let numberTextField03: UITextField = {
        let view = UITextField()
        view.textAlignment = .right
        view.font = .systemFont(ofSize: 18)
        view.text = "3"
        return view
    }()
    
    private let plusLabel: UILabel = {
        let view = UILabel()
        view.text = "+"
        view.font = .systemFont(ofSize: 18)
        view.textAlignment = .right
        return view
    }()
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private let resultLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = .systemFont(ofSize: 24)
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        [numberTextField01, numberTextField02, numberTextField03].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [plusLabel, lineView, resultLabel, stackView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(160)
            make.width.equalTo(120)
        }
        
        plusLabel.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.bottom).inset(12)
            make.trailing.equalTo(stackView.snp.leading).offset(-8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(stackView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
        }
    }
    
    // MARK: orEmpty로 Optional인 textField를 언래핑해서 가져옴
    override func configureView() {
        Observable.combineLatest(numberTextField01.rx.text.orEmpty, numberTextField02.rx.text.orEmpty, numberTextField03.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
                return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map { $0.description } // MARK: .description 덕분에 Int로 더한 값들이 문자열 표현으로 반환됨
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
        
        view.backgroundColor = .white
    }
}
