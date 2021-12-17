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
import RxGesture

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
    
    func bind(reactor: SearchViewReactor) {
        
        // MARK: UIView Life Cycle
        self.rx.viewDidLoad
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.setupController()
                self.setupUI()
            })
            .disposed(by: self.disposeBag)
        
        self.rx.viewWillAppear
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                DispatchQueue.main.async {
                    self.searchController.searchBar.becomeFirstResponder()
                }
            })
            .disposed(by: self.disposeBag)

        self.contentCollectionView.rx.setDelegate(self)
        .disposed(by: self.disposeBag)
        
        // MARK: send
        self.searchController.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        // 같은 아이템 안받기
            .distinctUntilChanged()
            .map{Reactor.Action.fetchSearch(searchText: $0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // MARK: receive
        reactor.state
            .compactMap{$0.searchResult}
            .bind(to: self.contentCollectionView.rx.items(cellIdentifier: String(describing: ContentCell.self), cellType: ContentCell.self)){ index, url, cell in
                
                cell.configure(imageURL: url)
            }
            .disposed(by: self.disposeBag)
        
        self.view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext:{ _ in
                DispatchQueue.main.async {
                    self.searchController.searchBar.resignFirstResponder()
                }
            })
            .disposed(by: self.disposeBag)
    
        
    }
    
    // MARK: Setup
    func setupController(){
        
        // searchController
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = true
    }
    
    func setupUI(){
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.contentCollectionView)
        self.contentCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width - 40) * 0.5,
                      height: (collectionView.bounds.size.width - 40) * 0.5)
                      
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
}
