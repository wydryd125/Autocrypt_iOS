//
//  WeatherData.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/9/24.
//

import Foundation

struct WeatherData: Decodable {
    let main: Main
    let weather: [Weather]

    struct Main: Decodable {
        let temp: Double
        let humidity: Int
    }

    struct Weather: Decodable {
        let description: String
        let icon: String
    }
}
