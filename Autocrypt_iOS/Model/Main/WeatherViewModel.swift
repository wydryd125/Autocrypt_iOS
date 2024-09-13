//
//  WeatherViewModel.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/9/24.
//

import RxSwift
import RxCocoa
import Foundation

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var weatherForecastData: WeatherForecastData?
    @Published var isLoading: Bool = false
    let selectCity = BehaviorRelay<City?>(value: nil)
    
    private let disposeBag = DisposeBag()
    private let repository = WeatherRepository()
    
    init() {
        bind()
    }
    
    func bind() {
        self.selectCity
            .flatMapLatest { [weak self] city -> Observable<(WeatherData, WeatherForecastData)> in
                guard let self = self else { return Observable.empty() }
                self.isLoading = true 
                let coord: Coordinates
                if let city = city {
                    coord = city.coord
                } else {
                    // 기본 좌표 (서울)
                    coord = Coordinates(lon: 126.9780, lat: 37.566)                }
                
                let weatherObservable = self.fetchWeather(coord: coord)
                    .observe(on: MainScheduler.instance)
                let forecastObservable = self.fetchForecast(coord: coord)
                    .observe(on: MainScheduler.instance)
                
                return Observable.zip(weatherObservable, forecastObservable)
            }
            .do(onNext: { [weak self] _ in
                self?.isLoading = false
            })
            .subscribe(onNext: { [weak self] weather, forecast in
                self?.weatherData = weather
                self?.weatherForecastData = forecast
            }, onError: { error in
                print("!!! Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchWeather(coord: Coordinates) -> Observable<WeatherData> {
        return Observable.create { [weak self] observer in
            self?.repository.getWeather(coord: coord)
                .subscribe(onSuccess: { weather in
                    observer.onNext(weather)
                    observer.onCompleted()
                    
                }, onFailure: { error in
                    observer.onError(error)
                })
                .disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
    
    private func fetchForecast(coord: Coordinates) -> Observable<WeatherForecastData> {
        return Observable.create { [weak self] observer in
            self?.repository.getForecast(coord: coord)
                .subscribe(onSuccess: { forecast in
                    observer.onNext(forecast)
                    observer.onCompleted()
                    
                }, onFailure: { error in
                    observer.onError(error)
                })
                .disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
}
