//
//  WeatherAPI.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/10/24.
//

import RxSwift

extension API {
    static func getWeather(coord: Coordinates) -> Endpoint<WeatherData> {
        let params: [String: Any] = ["lon": coord.lon,
                                     "lat": coord.lat,
                                     "appid": "10a177996c09432322a07e4b59cda283"]
        
        return Endpoint(method: .get,
                        path: .path("/data/2.5/weather"),
                        parameters: params
        )
    }
    
    static func getForecast(coord: Coordinates) -> Endpoint<WeatherForecastData> {
        let params: [String: Any] = ["lon": coord.lon,
                                     "lat": coord.lat,
                                     "appid": "10a177996c09432322a07e4b59cda283"]
        
        return Endpoint(method: .get,
                        path: .path("/data/2.5/forecast"),
                        parameters: params
        )
    }
}
