//
//  RxPickerViewController.swift
//  RxSwiftStudy
//
//  Created by Minho on 3/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RxPickerViewController: BaseViewController {
    
    private let pickerView01: UIPickerView = {
        let view = UIPickerView()
        view.backgroundColor = .white
        return view
    }()
    private let pickerView02: UIPickerView = {
        let view = UIPickerView()
        view.backgroundColor = .white
        return view
    }()
    private let pickerView03: UIPickerView = {
        let view = UIPickerView()
        view.backgroundColor = .white
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        [pickerView01, pickerView02, pickerView03].forEach {
            stackView.addArrangedSubview($0)
        }
        
        view.addSubview(stackView)
    }
    
    override func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: modelSelected() 를 사용해서 변화를 감지
    override func configureView() {
        pickerView01.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print("models selected 1: \(models)")
            })
            .disposed(by: disposeBag)
        
        pickerView02.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print("models selected 2: \(models)")
            })
            .disposed(by: disposeBag)
        
        pickerView03.rx.modelSelected(UIColor.self)
            .subscribe(onNext: { models in
                print("models selected 3: \(models)")
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: just를 통해 Int 값을 Emit. 마지막 픽커뷰의 경우엔 UIColor값을 넣고 있음.
    private func bind() {
        Observable.just([1, 2, 3])
            .bind(to: pickerView01.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        Observable.just([1, 2, 3])
            .bind(to: pickerView02.rx.itemAttributedTitles) { _, item in
                return NSAttributedString(string: "\(item)",
                                          attributes: [
                                            NSAttributedString.Key.foregroundColor: UIColor.cyan,
                                            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue
                                        ])
            }
            .disposed(by: disposeBag)

        Observable.just([UIColor.red, UIColor.green, UIColor.blue])
            .bind(to: pickerView03.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: disposeBag)
    }
}
