//
//  ApiParameterBody.swift.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/14.
//

import Foundation

struct SearchParameter: Codable{
    var api_key: String
    var q: String
    var limit: String? // Int
}
