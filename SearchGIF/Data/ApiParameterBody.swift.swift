//
//  ApiParameterBody.swift.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/14.
//

import Foundation

struct SearchParameter: Codable{
    var q: String
    var limit: String?
}
