//
//  SearchUsecase.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/15.
//

import Foundation
import RxSwift

protocol SearchUsecase{
    func fetchSearch(searchText: String?) -> Observable<[String]>
    func isTouchBottom(currentY: CGFloat, bottomY: CGFloat) -> Observable<Bool>
}

class SearchUsecaseImpl: SearchUsecase{
    var repository: Respository
    
    let contentLimit: Int = 8
    var cachedExSearchText: String = "" // PublishSubject<String>()
    var currentSearchPageOffset: Int = 0 // PublishSubject<Int>()
    
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
    
    func fetchSearch(searchText: String? = nil) -> Observable<[String]>{
        
        if let searchText = searchText{
            self.cachedExSearchText = searchText
            self.currentSearchPageOffset = 0
        }else{
            // fetchSearch를 호출할 때 스크롤에 의한 page추가인 경우 searchText가 nil이다.
            self.currentSearchPageOffset += 1
        }
        
        return self.repository.fetchableSearch(
            parameter: SearchParameter(
                q: self.cachedExSearchText,
                offest: "\(self.currentSearchPageOffset)",
                limit: "\(self.contentLimit)"
            )
        )
            .map{$0.data.compactMap{$0.images.original.url}}
    }
}
