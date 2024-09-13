//
//  WeatherForecastData.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/13/24.
//

import Foundation

struct DailyTemperature {
    let date: String
    let dayOfWeek: String
    let temp: Double
    let tempMax: Double
    let tempMin: Double

    
    func getMinMaxTemperature() -> String {
        let max = tempMax.getTemperatureString()
        let min = tempMin.getTemperatureString()
        return "최고: " + max + " | " + "최저: " + min
    }
}

struct KeyPointsData: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let subDescription: String?
}

struct WeatherForecastData: Codable {
    let cod: String // 응답 코드
    let message: Int // 메시지
    let cnt: Int // 목록 수
    var list: [WeatherList] // 날씨 목록
    let city: City // 도시 정보
    
    func getCityName() -> String {
        return city.name
    }
    
    func getWindSpeed() -> String {
        let windSpeeds = list.map { $0.wind.speed }
        let aveWindSpeed = windSpeeds.isEmpty ? 0 : windSpeeds.reduce(0, +) / Double(windSpeeds.count)
        return String(format: "%.1f m/s", aveWindSpeed)
    }
    
    func getWindMaxSpeed() -> String {
        let maxSpeed = list.map { $0.wind.speed }.max() ?? 0
        return String(format: "%.1f m/s", maxSpeed)
    }
    
    func getCloud() -> String {
        let cloudss = list.map { Double($0.clouds.all) }
        let aveClouds = cloudss.isEmpty ? 0 : cloudss.reduce(0, +) / Double(cloudss.count)
        return String(Int(aveClouds)) + " %"
    }
    
    func getHumidity() -> String {
        let humiditys = list.map { Double($0.main.humidity) }
        let aveHumidity = humiditys.isEmpty ? 0 : humiditys.reduce(0, +) / Double(humiditys.count)
        return String(Int(aveHumidity)) + " %"
    }
    
    func getPressure() -> String {
        let pressures = list.map { Double($0.main.pressure) }
        let avePressure = pressures.isEmpty ? 0 : pressures.reduce(0, +) / Double(pressures.count)
        return String(format: "%.1f \nhpa", avePressure)
    }
    
    func getDateWeatherList(date: Date? = Date()) -> [WeatherList] {
        var result = [WeatherList]()
   
        for weather in list {
            let fullDate = weather.date.fullDate()
            let dateStr = fullDate.formattedDate()
            if date?.formattedDate() == dateStr {
                result.append(weather)
            }
        }
        return Array(result.sorted { $0.date < $1.date })
    }
    
    func getWeekWeatherList() -> [DailyTemperature] {
        var weekData = [String: [WeatherList]]()
        var result = [DailyTemperature]()
        
        for weather in list {
            let date = weather.date.fullDate()
            let key = date.formattedDate()

            weekData[key] = getDateWeatherList(date: date)
        }
        
        for (_, weatherList) in weekData  {
            let date = weatherList.first?.date.fullDate()
            let maxTemp = weatherList.map { $0.main.tempMax }.sorted { $0 > $1 }.first ?? 0
            let minTemp = weatherList.map { $0.main.tempMin }.sorted { $0 < $1 }.first ?? 0
            
            result.append(DailyTemperature(date: date?.formattedDate() ?? "",
                                           dayOfWeek: date?.formattedDayOfWeek() ?? "",
                                           temp: (maxTemp + minTemp) / 2,
                                           tempMax: maxTemp,
                                           tempMin: minTemp))

        }
        return Array(result.sorted { $0.date < $1.date })
    }
    
    func getKeyPointsData() -> [KeyPointsData] {
        let titleList = ["습도", "구름", "바람속도", "기압"]
        var result = [KeyPointsData]()
        
        titleList.forEach {
            switch $0 {
            case "습도":
                result.append(KeyPointsData(title: $0, description: getHumidity(), subDescription: nil))
            case "구름":
                result.append(KeyPointsData(title: $0, description: getCloud(), subDescription: nil))
            case "바람속도":
                result.append(KeyPointsData(title: $0, description: getWindSpeed(), subDescription: "강풍: " + getWindMaxSpeed()))
            case "기압":
                result.append(KeyPointsData(title: $0, description: getPressure(), subDescription: nil))
            default:
             break
            }
        }
        return result
    }
    
    func getMinMaxTemperature() -> String {
        let maxTemp = (getDateWeatherList().map { $0.main.tempMax }.max() ?? 0).getTemperatureString()
        let minTemp = (getDateWeatherList().map { $0.main.tempMin }.min() ?? 0).getTemperatureString()
        return "최고: " + maxTemp + " | " + "최저: " + minTemp
    }
}

// MARK: - 날씨 목록
struct WeatherList: Codable, Identifiable {
    let dt: Int
    let main: Main // 주요 날씨 정보
    let weather: [Weather] // 날씨 상태
    let clouds: Clouds // 구름 정보
    let wind: Wind // 바람 정보
    let visibility: Int // 가시 거리
    let pop: Double // 강수 확률
    let rain: Rain?
    let sys: Sys // 시스템 정보
    let date: String
    
    var id: Int {
            return dt
        }
    
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
        case date = "dt_txt"
    }
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

struct Rain: Codable {
    let h3: Double?
    
    enum CodingKeys: String, CodingKey {
        case h3 = "3h"
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
    
    func getWeatherImage(id: Int) -> String {
        switch id {
        case 200...299:
            return "thunderstorms"
        case 300...399, 520...599:
            return "rainy"
        case 500...519:
            return "showers"
        case 600...699:
            return "snowy"
        case 700...799:
            return "foggy"
        case 800:
            return "sunny"
        case 801:
            return "partly_cloudy"
        case 802:
            return "cloudy"
        case 803, 804:
            return "mostly_cloudy"
        default:
            return "sunny"
        }
    }
}
