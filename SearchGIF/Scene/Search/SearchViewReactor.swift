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
        case fetchSearchedData([String])
        case showLoading
        case hideLoading
    }
    
    let initialState: State = State()

    var usecase: SearchUsecase
    let contentLimit: Int = 8
    var cachedExSearchText: String = ""
    
    init(usecase: SearchUsecase = SearchUsecaseImpl()){
        self.usecase = usecase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchSearch(let searchText):
            return self.fetchSearch(searchText: searchText)
        case .attachAtBottom(currentY: let currentY, bottomY: let bottomY):
            if currentY > bottomY{
                return self.fetchSearch(searchText: self.cachedExSearchText)
            }
            return Observable.empty()
                
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .fetchSearchedData(let search):
            newState.searchResult += search
            print(newState.searchResult)
//            newState.searchResult = search
        case .showLoading:
            newState.isLoading = true
        case .hideLoading:
            newState.isLoading = false
        }
        
        return newState
    }
    
}

extension SearchViewReactor{
    private func fetchSearch(searchText: String) -> Observable<Mutation>{
        self.cachedExSearchText = searchText
        
        return Observable.just(Mutation.showLoading)
            .concat(
                self.usecase.fetchableSearch(
                    parameter: SearchParameter(q: searchText, offest: "\(0)", limit: "\(self.contentLimit)")
                ).map{Mutation.fetchSearchedData($0)}
            )
            .concat(Observable.just(Mutation.showLoading))
    }
}
