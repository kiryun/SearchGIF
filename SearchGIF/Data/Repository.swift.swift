//
//  Repository.swift.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/15.
//

import Foundation
import Moya
import RxSwift

enum NetworkError: Error {
    case requestFail
    case decodingFail
}

extension NetworkError {
    var message: String {
        switch self {
        case .requestFail:
            return "## request fail!"
        case .decodingFail:
            return "## decoding fail!"
        }
    }
}

class Fetchable{
    let provier = MoyaProvider<Api>()
    
    func execute<T: Decodable>(api: Api, callbackQueue: DispatchQueue? = nil) -> Single<T>{
        Single<T>.create { single in
            let cancellableApi = self.provier.request(api, callbackQueue: callbackQueue, progress: nil) { result in
                switch result{
                case .success(let response):
                    guard let json = try? JSONDecoder().decode(T.self, from: response.data) else{
                        single(.failure(RxError.unknown))
                        return
                    }
                    single(.success(json))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create{
                cancellableApi.cancel()
            }
        }
    }
}

protocol Respository{
    func fetchableSearch(searchText q: String) -> Observable<Search>
}

class SearchRepositoryImpl: Fetchable, Respository{
    func fetchableSearch(searchText q: String) -> Observable<Search> {
        self.execute(api: .search(q: q))
            .asObservable()
    }
}
