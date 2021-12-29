//
//  Api.swift.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/14.
//

import Foundation
import Moya

enum Api: TargetType{
    case search(SearchParameter)
}

extension Api{
    var baseURL: URL{
        URL(string: "https://api.giphy.com")!
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
        case .search(let parameter):
            let parameter = parameter
                .gifDictionaryConvert ?? [:]
            print("@@ api parameter: ", parameter)
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]?{
        return ["Content-Type": "application/json"]
    }
}
