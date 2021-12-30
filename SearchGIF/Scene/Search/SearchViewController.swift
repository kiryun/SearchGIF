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
        // 위에 viewDidLoad에서 썼던 observe, subscribe 쓰는 것 보다 더 나은 방법
            .asDriver()
            .drive(onNext: {
                self.searchController.searchBar.becomeFirstResponder()
            })
            .disposed(by: self.disposeBag)

        self.contentCollectionView.rx.setDelegate(self)
        .disposed(by: self.disposeBag)
        
        // MARK: send
        self.searchController.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        // 같은 아이템 안받기
            .debug("@@ ")
            .distinctUntilChanged()
            .map{Reactor.Action.fetchSearch(searchText: $0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // 무한 스크롤 구현
        // 스크롤이 아래로 height 만큼 닿게된다면 action
        self.contentCollectionView.rx.contentOffset
        // 스크롤이 여러번 되어서 api 호출을 여러번하는 불상사를 방지
            .throttle(
                .milliseconds(500),
                latest: false,
                scheduler: MainScheduler.instance
            )
            .map{$0.y + self.contentCollectionView.contentInset.bottom}
            .map{
                Reactor.Action.attachAtBottom(
                    currentY: $0,
                    bottomY: self.contentCollectionView.contentSize.height - self.contentCollectionView.frame.height
                )
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // MARK: receive
        // fetchSearch
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
        
        // contentCollectionView
        self.contentCollectionView.rx.willBeginDragging
            .asDriver()
            .drive(onNext: {
                self.searchController.searchBar.resignFirstResponder()
            })
            .disposed(by: self.disposeBag)
        
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
