//
//  WeatherSearchDataManager.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

protocol WeatherSearchDataManagerProtocol {
    func runService<T: Codable>(request: String) -> Observable<T>
}

final class WeatherSearchDataManager { }

extension WeatherSearchDataManager: WeatherSearchDataManagerProtocol {
    func runService<T: Codable>(request: String) -> Observable<T> {
        return Observable<T>.create { observer in
            let disposables = Disposables.create()

            AF.request(request)
                .responseDecodable(of: T.self) { response in
                if let search = response.value {
                    observer.onNext(search)
                } else if let error = response.error {
                    observer.onError(error)
                }
               
                observer.onCompleted()
            }
            
            return disposables
        }
    }
}
