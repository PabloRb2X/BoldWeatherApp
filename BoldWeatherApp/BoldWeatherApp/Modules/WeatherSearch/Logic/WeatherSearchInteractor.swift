//
//  WeatherSearchInteractor.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import Foundation
import RxSwift

protocol WeatherSearchInteractorProtocol {
    func weatherSearchService(text: String) -> Observable<[WeatherPlace]>
    func weatherDescriptionService(woeid: Int) -> Observable<WeatherDescription>
}

final class WeatherSearchInteractor {
    private let dataManager: WeatherSearchDataManagerProtocol
    
    init(dataManager: WeatherSearchDataManagerProtocol = WeatherSearchDataManager()) {
        self.dataManager = dataManager
    }
}

extension WeatherSearchInteractor: WeatherSearchInteractorProtocol {
    func weatherSearchService(text: String) -> Observable<[WeatherPlace]> {
        let request = ServiceDefinitions.weatherSearch(text: text)
        
        return dataManager.runService(request: request)
    }
    
    func weatherDescriptionService(woeid: Int) -> Observable<WeatherDescription> {
        let request = ServiceDefinitions.weatherDescription(woeid: woeid)
        
        return dataManager.runService(request: request)
    }
}
