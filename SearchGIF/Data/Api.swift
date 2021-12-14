//
//  Api.swift.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/14.
//

import Foundation
import Moya

enum Api: TargetType{
    case search(Int)
}

extension Api{
    var baseURL: URL{
        URL(string: "api.giphy.com")!
    }
    
    var path: String{
        return "/v1/gifs/search"
    }
    
    var method: Moya.Method{
        switch self{
        case .search:
            return .get
        }
    }
    
    var task: Task{
        switch self{
        case .search(let q):
            let parameter = SearchParameter(q: "\(q)").gifDictionaryConvert ?? [:]
            
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]?{
        return ["Content-Type": "application/json"]
    }
}
