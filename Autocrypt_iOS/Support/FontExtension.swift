//
//  UIFontExtension.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/9/24.
//

import SwiftUI

extension Font {
    enum PretendardWeight: String {
        case medium, semiBold, bold, extraBold
    }
    
    static func pretendard(size: CGFloat, weight: PretendardWeight = .medium) -> UIFont {
        if let font = UIFont(name: "Pretendard-\(weight)", size: size) {
            return font
        }
        
        switch weight {
        case .medium:
            return .systemFont(ofSize: size, weight: .medium)
        case .semiBold:
            return .systemFont(ofSize: size, weight: .semibold)
        case .bold:
            return .systemFont(ofSize: size, weight: .bold)
        case .extraBold:
            return .systemFont(ofSize: size, weight: .heavy)
        }
    }
}
