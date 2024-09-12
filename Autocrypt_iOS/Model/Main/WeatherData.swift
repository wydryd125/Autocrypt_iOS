//
//  WeatherData.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/9/24.
//

import Foundation

// MARK: - 날씨 데이터
struct WeatherData: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int // 데이터 수집 시간
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
    // 도시 이름을 반환하는 함수
    func getCityName() -> String {
        return name
    }
}

// MARK: - 좌표
struct Coord: Codable {
    let lon: Double // 경도
    let lat: Double // 위도
}

// MARK: - 날씨 상태
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - 주요 날씨 정보
struct Main: Codable {
    let temp: Double // 현재 온도
    let feelsLike: Double // 체감 온도
    let tempMin: Double // 최저 온도
    let tempMax: Double // 최고 온도
    let pressure: Int // 기압
    let humidity: Int // 습도
    let seaLevel: Int? // 해수면 기압
    let grndLevel: Int? // 지면 기압
    let tempKf: Double? // 온도 보정값
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case tempKf = "temp_kf"
    }
}

// MARK: - 바람 정보
struct Wind: Codable {
    let speed: Double // 바람 속도 (미터/초)
    let deg: Int // 바람 방향 (각도)
    let gust: Double? // 돌풍 속도 (옵셔널)
}

// MARK: - 구름 정보
struct Clouds: Codable {
    let all: Int // 구름 양 (백분율)
}

// MARK: - 시스템 정보
struct Sys: Codable {
    let country: String? // 국가 코드
    let sunrise: Int? // 일출 시간
    let pod: String? // 날씨 시간대
    let sunset: Int? // 일몰 시간
}
