//
//  Encodable+.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/14.
//

import Foundation

extension Encodable {
    var gifDictionaryConvert: [String: Any]? {
        let encoder = JSONEncoder()

        return (try? JSONSerialization.jsonObject(with: encoder.encode(self))) as? [String: Any]
    }
    
    var gifApiBodyConvert: [String: String]? {
        let encoder = JSONEncoder()

        return (try? JSONSerialization.jsonObject(with: encoder.encode(self))) as? [String: String]
    }
}
