//
//  Autocrypt_iOS_Bundle.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/14/24.
//

import Foundation

extension Bundle {
    var apiKey: String? {
        return self.infoDictionary?["APIKey"] as? String
    }
}
