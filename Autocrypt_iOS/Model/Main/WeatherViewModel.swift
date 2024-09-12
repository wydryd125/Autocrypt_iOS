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
    
    private let disposeBag = DisposeBag()
    private let repository = WeatherRepository()
    
    // Input
    struct Input {
        let selectCity = BehaviorRelay<City?>(value: nil)
    }
    
    let input = Input() // Input 인스턴스 생성
    
    // 초기화
    init() {
        bind() // 데이터 바인딩 설정
    }
    
    // 데이터 바인딩 설정
    private func bind() {
        input.selectCity
            .flatMapLatest { [weak self] city -> Observable<(WeatherData, WeatherForecastData)> in
                guard let self = self else { return Observable.empty() }
                self.isLoading = true // 로딩 시작
                
                let coord: Coordinates
                if let city = city {
                    coord = city.coord
                } else {
                    coord = Coordinates(lon: 126.9780, lat: 37.566) // 기본 좌표 (서울)
                }
                
                // 두 개의 Observable을 병합하여 함께 처리
                let weatherObservable = self.fetchWeather(coord: coord)
                    .observe(on: MainScheduler.instance) // 메인 스레드에서 실행
                let forecastObservable = self.fetchForecast(coord: coord)
                    .observe(on: MainScheduler.instance) // 메인 스레드에서 실행
                
                return Observable.zip(weatherObservable, forecastObservable)
            }
            .do(onNext: { [weak self] _ in
                self?.isLoading = false // 로딩 완료
            })
            .subscribe(onNext: { [weak self] weather, forecast in
                self?.weatherData = weather // 날씨 데이터 업데이트
                self?.weatherForecastData = forecast // 날씨 예보 데이터 업데이트
            }, onError: { error in
                print("API Error: \(error)") // 에러 처리
            })
            .disposed(by: disposeBag) // 메모리 관리를 위해 disposeBag에 추가
    }
    
    // 좌표를 사용하여 날씨 데이터를 요청하는 메서드
    private func fetchWeather(coord: Coordinates) -> Observable<WeatherData> {
        return Observable.create { [weak self] observer in
            self?.repository.getWeather(coord: coord)
                .subscribe(onSuccess: { weather in
                    observer.onNext(weather) // 데이터를 방출
                    observer.onCompleted() // 완료
                }, onFailure: { error in
                    observer.onError(error) // 에러 처리
                })
                .disposed(by: self?.disposeBag ?? DisposeBag()) // 메모리 관리를 위해 disposeBag에 추가
            return Disposables.create() // Disposables 반환
        }
    }
    
    // 좌표를 사용하여 날씨 예보 데이터를 요청하는 메서드
    private func fetchForecast(coord: Coordinates) -> Observable<WeatherForecastData> {
        return Observable.create { [weak self] observer in
            self?.repository.getForecast(coord: coord)
                .subscribe(onSuccess: { forecast in
                    observer.onNext(forecast) // 데이터를 방출
                    observer.onCompleted() // 완료
                }, onFailure: { error in
                    observer.onError(error) // 에러 처리
                })
                .disposed(by: self?.disposeBag ?? DisposeBag()) // 메모리 관리를 위해 disposeBag에 추가
            return Disposables.create() // Disposables 반환
        }
    }
}
