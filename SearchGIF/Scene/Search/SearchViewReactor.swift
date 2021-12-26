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
        case checkBottom(currentY: CGFloat, bottomY: CGFloat)
    }
    
    // MARK: Output
    struct State{
        var searchResult: [String] = [String]()
        var isBottom: Bool = false
        var isLoading: Bool = false
    }
    
    // 데이터 가공의 동작을 정의
    enum Mutation{
        case fetchSearchedData([String])
        case hitTheBottom(Bool)
        case showLoading
        case hideLoading
    }
    
    let initialState: State = State()

    var usecase: SearchUsecase
    let contentLimit: Int = 8
    
    init(usecase: SearchUsecase = SearchUsecaseImpl()){
        self.usecase = usecase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchSearch(let searchText):
            return Observable.just(Mutation.showLoading)
                .concat(self.usecase.fetchableSearch(
                    parameter: SearchParameter(q: searchText, limit: "\(contentLimit)")
                )
                            .map{Mutation.fetchSearchedData($0)})
                .concat(Observable.just(Mutation.showLoading))
        case .checkBottom(currentY: let currentY, bottomY: let bottomY):
            if currentY > bottomY - (bottomY*0.2){
                print(true)
                return Observable.just(Mutation.hitTheBottom(true))
            }else{
                print(false)
                return Observable.just(Mutation.hitTheBottom(false))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .fetchSearchedData(let search):
            newState.searchResult += search 
//            newState.searchResult = search
        case .hitTheBottom(let isBottom):
            newState.isBottom = isBottom
        case .showLoading:
            newState.isLoading = true
        case .hideLoading:
            newState.isLoading = false
        }
        
        return newState
    }
    
}
