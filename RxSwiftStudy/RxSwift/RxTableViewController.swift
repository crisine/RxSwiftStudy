//
//  RxTableViewController.swift
//  RxSwiftStudy
//
//  Created by Minho on 3/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class RxTableViewController: BaseViewController {
    
    private let rxTableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        view.addSubview(rxTableView)
    }
    
    override func configureConstraints() {
        rxTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        rxTableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { value in
                print("값이 눌림 : \(value)")
            })
            .disposed(by: disposeBag)
        
        rxTableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                print("눌린 값의 자세한 정보 : \(indexPath.section), \(indexPath.row)")
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        
        let items = Observable.just( (0..<30).map { "\($0)" } )
        
        items
            .bind(to: rxTableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
    }
}
