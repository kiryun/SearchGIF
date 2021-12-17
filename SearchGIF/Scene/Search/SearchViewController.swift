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
import Then

import SnapKit

class SearchViewController: UIViewController, View {

    var disposeBag = DisposeBag()
    
    let searchController = UISearchController(
        searchResultsController: nil
    ).then {
        // ?:
        $0.searchResultsUpdater = nil
        // ?:
        $0.obscuresBackgroundDuringPresentation = false
    }
    
    var contentCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then{
        $0.register(ContentCell.self, forCellWithReuseIdentifier: String(describing: ContentCell.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupController()
        self.setupUI()
    }
    
    func setupController(){
        print("@@ setup Controller")
        
        // searchController
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = true
    }
    
    func setupUI(){
        print("@@ setup ui")
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.contentCollectionView)
        self.contentCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: SearchViewReactor) {
        print("@@ bind")
        
        self.contentCollectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        // MARK: send
        self.searchController.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map{Reactor.Action.fetchSearch(searchText: $0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // MARK: receive
        reactor.state
            .compactMap{$0.searchResult}
            .debug("## ")
            .bind(to: self.contentCollectionView.rx.items(cellIdentifier: String(describing: ContentCell.self), cellType: ContentCell.self)){ index, url, cell in
                print(cell)
                print(url)
                cell.configure(imageURL: url)
            }
            .disposed(by: self.disposeBag)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width - 40) * 0.5,
                      height: (collectionView.bounds.size.width - 40) * 0.5)
                      
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        print("@@ insets")
        return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
}
