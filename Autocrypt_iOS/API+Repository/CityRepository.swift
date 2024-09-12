//
//  CityRepository.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/11/24.
//

import Foundation
import RxSwift

final class CityRepository {
    var cities = [City]()
    
    func loadCities() -> Observable<[City]> {
        // 도시 데이터를 로드하기 위한 Observable을 반환
        return Observable.create { observer in
            // 도시 데이터 파일의 URL을 가져오기
            guard let url = Bundle.main.url(forResource: "citylist", withExtension: "json") else {
                observer.onError(NSError(domain: "CityRepositoryError", code: 1, userInfo: [NSLocalizedDescriptionKey: "유효하지 않은 URL입니다."]))
                return Disposables.create()
            }
            
            do {
                // URL에서 데이터 읽기
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                // 데이터 디코딩
                let cities = try decoder.decode([City].self, from: data)
                self.cities = cities // 저장소에 도시 데이터 저장
                observer.onNext(cities) // 로드한 도시 데이터 방출
                observer.onCompleted() // Observable 완료
            } catch {
                observer.onError(error) // 에러 발생 시 에러 방출
            }
            
            return Disposables.create() // 리소스 정리
        }
    }
}
