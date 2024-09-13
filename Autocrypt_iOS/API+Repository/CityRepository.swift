//
//  CityRepository.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/11/24.
//

import Foundation
import RxSwift

enum CityRepositoryError: Error {
    case invalidURL
    case decodingError
}

final class CityRepository {
    var cities = [City]()
    
    func loadCities() -> Observable<[City]> {
        return Observable.create { observer in
            guard let url = Bundle.main.url(forResource: "citylist", withExtension: "json") else {
                observer.onError(CityRepositoryError.invalidURL)
                return Disposables.create()
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                
                let cities = try decoder.decode([City].self, from: data)
                self.cities = cities.filter { $0.name.count > 1 }.sorted { $0.name < $1.name }
                observer.onNext(self.cities)
                observer.onCompleted()
                
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
}
