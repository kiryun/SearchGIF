//
//  SearchUsecase.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/15.
//

import Foundation
import RxSwift

protocol SearchUsecase{
    func fetchableSearch(searchText: String) -> Observable<Search>
}

class SearchUsecaseImpl: SearchUsecase{
    var repository: Respository
    
    init(repository: Respository = SearchRepositoryImpl()){
        self.repository = repository
    }
    
    func fetchableSearch(searchText: String) -> Observable<Search>{
        self.repository.fetchableSearch(searchText: searchText)
    }
}
