//
//  WeatherAPI.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/10/24.
//

import RxSwift

extension API {
    static func weather(city: String) -> Endpoint<WeatherData> {
        let params: [String: Any] = ["q": city,
                                     "appid": "YOUR_API_KEY"]
        
        return Endpoint(method: .get,
                        path: .path("/data/2.5/weather"),
                        parameters: params
        )
    }
}

