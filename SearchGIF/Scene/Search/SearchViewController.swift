//
//  SearchViewController.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/14.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit

class SearchViewController: UIViewController, View {

    var disposeBag = DisposeBag()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ?:
        self.searchController.searchResultsUpdater = nil
        // ?:
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = true
        
        self.setupUI()
    }
    
    func setupUI(){
        self.view.backgroundColor = .white
    }
    
    func bind(reactor: SearchViewReactor) {
        // MARK: send
        self.searchController.searchBar.rx.text.orEmpty
            .debounce(.microseconds(10), scheduler: MainScheduler.asyncInstance)
            .map{Reactor.Action.fetchSearch(searchText: $0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // MARK: receive
        reactor.state
            .compactMap{$0.searchResult}
            .subscribe{
                print($0.data.first?.url)
            }
            .disposed(by: self.disposeBag)
    }
}
