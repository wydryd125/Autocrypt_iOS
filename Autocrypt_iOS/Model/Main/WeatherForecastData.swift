//
//  WeatherForecastData.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/13/24.
//

import Foundation

// MARK: - 날씨 응답
struct WeatherForecastData: Codable {
    let cod: String // 응답 코드
    let message: Int // 메시지
    let cnt: Int // 목록 수
    let list: [WeatherList] // 날씨 목록
    let city: City // 도시 정보
}

// MARK: - 날씨 목록
struct WeatherList: Codable {
    let dt: Int // 날짜/시간 (유닉스 타임스탬프)
    let main: Main // 주요 날씨 정보
    let weather: [Weather] // 날씨 상태
    let clouds: Clouds // 구름 정보
    let wind: Wind // 바람 정보
    let visibility: Int // 가시 거리
    let pop: Double // 강수 확률
    let rain: Rain?
    let sys: Sys // 시스템 정보
    let dtTxt: String // 날짜/시간 (형식화된 문자열)
    
    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        case visibility
        case pop
        case rain
        case sys
        case dtTxt = "dt_txt"
    }
}

struct Rain: Codable {
    let h3: Double?
    
    enum CodingKeys: String, CodingKey {
        case h3 = "3h"
    }
}
