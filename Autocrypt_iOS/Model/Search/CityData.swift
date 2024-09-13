//
//  CityData.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/11/24.
//

import Foundation

struct City: Identifiable, Codable {
    let id: Int
    let name: String
    let country: String
    let coord: Coordinates
}

struct Coordinates: Codable {
    let lon: CGFloat
    let lat: CGFloat
}
