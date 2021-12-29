//
//  ApiParameterBody.swift.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/14.
//

import Foundation

protocol Parameter: Codable{
    var api_key: String {get}
}

struct SearchParameter: Parameter{
    var api_key: String = "pUuPo8i25PkTJg12HlZ76KnPPjTWmrk8"
    var q: String
    var offest: String
    var limit: String? // Int
}
