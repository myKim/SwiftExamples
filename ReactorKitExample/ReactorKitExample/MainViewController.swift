//
//  ViewController.swift
//  ReactorKitExample
//
//  Created by 김명유 on 2019/12/08.
//  Copyright © 2019 myungyu Kim. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController, StoryboardView {

    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var increaseButton: UIButton!
    @IBOutlet var decreaseButton: UIButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let mainViewReactor = MainViewReactor()
        self.reactor = mainViewReactor
    }

    func bind(reactor: MainViewReactor) {
        // Action
        increaseButton.rx.tap
            .map { Reactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        decreaseButton.rx.tap
            .map { Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.value }
            .distinctUntilChanged()
            .map { "\($0)" }
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
}

