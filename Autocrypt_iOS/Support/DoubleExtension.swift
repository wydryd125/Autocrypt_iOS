//
//  DoubleExtension.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/13/24.
//

import Foundation

extension Double {
    func getTemperatureString() -> String {
        return String(format: "%.0f°", self - 273.15)
    }
}
