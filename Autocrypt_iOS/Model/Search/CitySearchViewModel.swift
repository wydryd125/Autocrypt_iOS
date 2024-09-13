//
//  CitySearchViewModel.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/11/24.
//

import Foundation
import RxSwift
import RxRelay

class CitySearchViewModel: ObservableObject {
    // MARK: - Property
    @Published var selectCity = PublishRelay<City>()
    var searchQuery = BehaviorRelay<String>(value: "")
    let filterCitiesRelay = BehaviorRelay<[City]>(value: [])
    
    private var weatherViewModel: WeatherViewModel
    private let repository = CityRepository()
    private let disposeBag = DisposeBag()
 
    init(viewModel: WeatherViewModel) {
        self.weatherViewModel = viewModel
        self.searchQuery
            .distinctUntilChanged()
            .do(onNext: {
                print("검색어'\($0)'")
            })
            .map {
                let query = $0.lowercased().replacingOccurrences(of: " ", with: "")
                
                if query.isEmpty {
                    return self.repository.cities
                }
    
                let filterCity = self.repository.cities.filter { city in
                    let cityName = city.name.lowercased().replacingOccurrences(of: " ", with: "")
                    let countryName = city.country.lowercased().replacingOccurrences(of: " ", with: "")
                    return cityName.contains(query) || countryName.contains(query)
                }
                           
                return filterCity.sorted { $0.name < $1.name }
            }
            .bind(to: self.filterCitiesRelay)
            .disposed(by: self.disposeBag)
        
        self.repository.loadCities()
            .bind(to: self.filterCitiesRelay)
            .disposed(by: self.disposeBag)
        
        self.selectCity
            .bind(to: self.weatherViewModel.selectCity)
            .disposed(by: self.disposeBag)
        
    }
}
