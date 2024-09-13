//
//  CitySearchViewModel.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/11/24.
//

import Foundation
import RxSwift
import RxRelay

class CitySearchViewModel {
    // MARK: - Property
    struct Input {
        var searchQuery = BehaviorRelay<String>(value: "")
        var selectCity = BehaviorRelay<City?>(value: nil)
    }
    
    struct Output {
        let filterCitiesRelay = BehaviorRelay<[City]>(value: [])
    }
    
    private let repository = CityRepository()
//    private let weatherViewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()
    
    let input = Input()
    let output = Output()
    
    init() {
        self.input.searchQuery
            .distinctUntilChanged()
            .filter { !$0.isEmpty } 
            .do(onNext: {
                print("검색어'\($0)'")
            })
            .map {

                let query = $0.lowercased().replacingOccurrences(of: " ", with: "")
                
                // 도시 이름에 쿼리가 포함된 경우 필터링
                let filterCity = self.repository.cities.filter { city in
                    let cityName = city.name.lowercased().replacingOccurrences(of: " ", with: "")
//                    let contryName = city.country.lowercased().replacingOccurrences(of: " ", with: "")
                    return cityName.contains(query) // 부분 문자열로 검색
                }
                
                // 알파벳 순서로 정렬된 필터링된 도시 반환
                return filterCity.sorted { $0.name < $1.name }
            }
            .bind(to: self.output.filterCitiesRelay)  // 필터링된 결과를 Output에 바인딩
            .disposed(by: self.disposeBag)  // DisposeBag에 추가하여 메모리 해제 처리
        
        self.repository.loadCities()
            .bind(to: self.output.filterCitiesRelay)
            .disposed(by: self.disposeBag)
        
    }
}
