//
//  WeatherDescriptionPresenter.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import Foundation
import RxSwift

protocol WeatherDescriptionPresenterProtocol: WeatherDescriptionViewOutput {
    func showViewController()
}

final class WeatherDescriptionPresenter {
    private let wireframe: WeatherDescriptionWireframeProtocol
    private let weatherDescription: WeatherDescription
    
    var weatherTodaySubject = PublishSubject<ConsolidatedWeather>()
    var placeSubject = PublishSubject<String>()
    
    init(wireframe: WeatherDescriptionWireframe,
         weatherDescription: WeatherDescription) {
        self.wireframe = wireframe
        self.weatherDescription = weatherDescription
    }
}

private extension WeatherDescriptionPresenter {
    func setupHeaderViewContent() {
        placeSubject.onNext(weatherDescription.title)
        
        if let weatherToday = weatherDescription.consolidatedWeather.first {
            weatherTodaySubject.onNext(weatherToday)
        }
    }
}

extension WeatherDescriptionPresenter: WeatherDescriptionPresenterProtocol {
    func showViewController() {
        wireframe.showViewController(presenter: self)
    }
    
    func didLoad() {
        setupHeaderViewContent()
    }
}
