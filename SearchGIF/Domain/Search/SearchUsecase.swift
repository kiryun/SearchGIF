//
//  SearchUsecase.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/15.
//

import Foundation
import RxSwift

protocol SearchUsecase{
    func fetchableSearch(parameter: SearchParameter) -> Observable<[String]>
}

class SearchUsecaseImpl: SearchUsecase{
    var repository: Respository
    
    init(repository: Respository = SearchRepositoryImpl()){
        self.repository = repository
    }
    
    func fetchableSearch(parameter: SearchParameter) -> Observable<[String]>{
        self.repository.fetchableSearch(parameter: parameter)
            .map{$0.data.map{$0.url}}
            
    }
}
