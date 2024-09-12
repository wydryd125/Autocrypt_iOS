//
//  WeatherRepository.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/10/24.
//

import RxSwift

final class WeatherRepository {
    private let client = NetworkManager()

    func getWeather(coord: Coordinates) -> Single<WeatherData> {
        client.request(API.getWeather(coord: coord))
    }
    
    func getForecast(coord: Coordinates) -> Single<WeatherForecastData> {
        client.request(API.getForecast(coord: coord))
    }
}
