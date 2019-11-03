//
//  CitySearcherViewController.swift
//  RxSwiftExample01
//
//  Created by 김명유 on 2019/11/03.
//  Copyright © 2019 myungyu Kim. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

/**
 https://pilgwon.github.io/blog/2017/09/26/RxSwift-By-Examples-1-The-Basics.html
 */

class CitySearcherViewController: UIViewController {
    var shownCities = [String]()
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga", "Seoul", "Busan"]
    let disposeBag = DisposeBag() // view가 deallocated 될 때 release할 것들의 가방
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar
            .rx.text // RxCocoa의 Observable 속성
            .orEmpty // 옵션널이 아니도록 만든다.
            .debounce(.microseconds(500), scheduler: MainScheduler.instance) // 0.5초 기다린다.
            .distinctUntilChanged() // 새로운 값이 이전 값과 같은지 확인
            .filter { !$0.isEmpty } // 새로운 값이라면, 비어있는 쿼리인지 확인
            .subscribe(onNext: { [unowned self] query in
                self.shownCities = self.allCities.filter { $0.hasPrefix(query) }
                self.tableView.reloadData() // tableView의 데이터를 리로드한다.
            })
            .disposed(by: disposeBag)
    }
}

extension CitySearcherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        
        return cell
    }
}
