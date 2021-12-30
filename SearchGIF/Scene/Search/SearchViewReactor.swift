//
//  SearchViewReactor.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/15.
//

import Foundation
import ReactorKit

class SearchViewReactor: Reactor{
    
    // MARK: Input
    enum Action{
        case fetchSearch(searchText: String)
        case attachAtBottom(currentY: CGFloat, bottomY: CGFloat)
    }
    
    // MARK: Output
    struct State{
        var searchResult: [String] = [String]()
        var isLoading: Bool = false
    }
    
    // 데이터 가공의 동작을 정의
    enum Mutation{
        case fetchSearchedData(SearchResult)
        case showLoading
        case hideLoading
    }
    
    let initialState: State = State()

    var usecase: SearchUsecase
    
    init(usecase: SearchUsecase = SearchUsecaseImpl()){
        self.usecase = usecase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchSearch(let searchText):
            return self.fetchSearch(searchText: searchText)
            
        case .attachAtBottom(currentY: let currentY, bottomY: let bottomY):
            return self.usecase.isTouchBottom(currentY: currentY, bottomY: bottomY)
                .flatMap{ isTouchBottom -> Observable<Mutation> in
                    if isTouchBottom{return self.fetchSearch()}
                    else{return Observable.empty()}
                }
                
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .fetchSearchedData(let result):
            if result.newSearch{
                newState.searchResult = result.search
            }else{
                newState.searchResult += result.search
            }
            
        case .showLoading:
            newState.isLoading = true
        case .hideLoading:
            newState.isLoading = false
        }
        
        return newState
    }
    
}

extension SearchViewReactor{
    private func fetchSearch(searchText: String? = nil) -> Observable<Mutation>{
        return Observable.just(Mutation.showLoading)
            .concat(
                self.usecase.fetchSearch(searchText: searchText)
                    .map{Mutation.fetchSearchedData($0)}
            )
            .concat(Observable.just(Mutation.showLoading))
    }
}
