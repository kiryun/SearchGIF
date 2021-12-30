//
//  SearchUsecase.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/15.
//

import Foundation
import RxSwift


protocol SearchUsecase{
    func fetchSearch(searchText: String?) -> Observable<SearchResult>
    func isTouchBottom(currentY: CGFloat, bottomY: CGFloat) -> Observable<Bool>
}

class SearchUsecaseImpl: SearchUsecase{
    var repository: Respository
    
    let contentLimit: Int = 8
    var cachedExSearchText: String = "" // PublishSubject<String>()
    var currentSearchPageOffset: Int = 0 // PublishSubject<Int>()
    
    
//    enum LoadAction{
//        case load([String])
//        case loadMore([String])
//    }
//
//    let loadObservable: Observable<[String]> = PublishSubject<[String]>().asObserver()
//    let loadMoreObservable: Observable<[String]> = PublishSubject<[String]>().asObserver()
    
    init(repository: Respository = SearchRepositoryImpl()){
        self.repository = repository
    }
    
    func isTouchBottom(currentY: CGFloat, bottomY: CGFloat) -> Observable<Bool>{
        if currentY > bottomY{
            return .just(true)
        }else{
            return .just(false)
        }
    }
    
    func fetchSearch(searchText: String? = nil) -> Observable<SearchResult>{
        
        var newSearch: Bool = false
        
        if let searchText = searchText{
            self.cachedExSearchText = searchText
            self.currentSearchPageOffset = 0
            newSearch = true
        }else{
            // fetchSearch를 호출할 때 스크롤에 의한 page추가인 경우 searchText가 nil이다.
            self.currentSearchPageOffset += self.contentLimit
            newSearch = false
        }
        
        return self.repository.fetchableSearch(
            parameter: SearchParameter(
                q: self.cachedExSearchText,
                offest: "\(self.currentSearchPageOffset)",
                limit: "\(self.contentLimit)"
            )
        )
            .map{ result -> SearchResult in
                return SearchResult(search: result.data.compactMap{$0.images.original.url}, newSearch: newSearch)
            }
        
//        let loadUrl: Observable<LoadAction> = self.loadObservable
//            .map{LoadAction.load($0)}
//        let loadMoreUrl: Observable<LoadAction> = self.loadMoreObservable
//            .map{LoadAction.loadMore($0)}
//
//        let UrlResult: Observable<[String]> = Observable.merge(loadUrl, loadMoreUrl)
//            .scan(into: [String]()) { urls, action in
//                switch action{
//                case .load(let newUrls):
//                    urls = newUrls
//                case .loadMore(let newUrls):
//                    urls += newUrls
//                }
//            }
        
    }
}
