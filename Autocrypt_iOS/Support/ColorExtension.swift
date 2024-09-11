//
//  UIColorExtension.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/9/24.
//

import SwiftUI

extension Color {
    init(red: Int, green: Int, blue: Int, alpha: Double = 1) {
        self.init(red: Double(red) / 255.0,
                  green: Double(green) / 255.0,
                  blue: Double(blue) / 255.0,
                  opacity: alpha)
    }
    
    init(hex: Int, alpha: CGFloat = 1) {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static let mainBlue = Color(red: 114, green: 145, blue: 192)
    static let contentsBlue = Color(red: 87, green: 124, blue: 183)
    static let searchBlue = Color(red: 88, green: 118, blue: 163)
    static let subTitleGrayBlue = Color(red: 172, green: 185, blue: 204)
    static let searchGray = Color(red: 102, green: 112, blue: 129)
    static let searchBgGray = Color(red: 137, green: 159, blue: 190)
    static let lineGray = Color(red: 137, green: 159, blue: 190)
    
}

