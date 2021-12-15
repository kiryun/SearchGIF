//
//  SearchViewModel.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/15.
//

import Foundation
import ReactorKit

class SearchViewModel: Reactor{

    enum Action{
        case fetchSearch(searchText: String)
    }
    
    struct State{
        var searchResult: Search?
        var isLoading: Bool = false
    }
    
    enum Mutation{
        case fetchSearchedData(Search)
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
            return Observable.just(Mutation.showLoading)
                .concat(self.usecase.fetchableSearch(searchText: searchText)
                            .map{Mutation.fetchSearchedData($0)}
                )
                .concat(Observable.just(Mutation.showLoading))
                
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .fetchSearchedData(let search):
            newState.searchResult = search
        case .showLoading:
            newState.isLoading = true
        case .hideLoading:
            newState.isLoading = false
        }
        
        return newState
    }
    
}
