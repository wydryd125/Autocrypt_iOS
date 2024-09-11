//
//  WeatherRepository.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/10/24.
//

import RxSwift

final class WeatherRepository {
    private let client: NetworkManager
    
    init(client: NetworkManager) {
        self.client = client
    }
    
    func fetchWeather(for city: String) -> Single<WeatherData> {
        client.request(API.weather(city: city))
    }
}
