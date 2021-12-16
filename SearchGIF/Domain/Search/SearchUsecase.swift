//
//  SearchUsecase.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/15.
//

import Foundation
import RxSwift

protocol SearchUsecase{
    func fetchableSearch(searchText: String) -> Observable<[String]>
}

class SearchUsecaseImpl: SearchUsecase{
    var repository: Respository
    
    init(repository: Respository = SearchRepositoryImpl()){
        self.repository = repository
    }
    
    func fetchableSearch(searchText: String) -> Observable<[String]>{
        self.repository.fetchableSearch(searchText: searchText)
            .map{$0.data.map{$0.url}}
            
    }
}
