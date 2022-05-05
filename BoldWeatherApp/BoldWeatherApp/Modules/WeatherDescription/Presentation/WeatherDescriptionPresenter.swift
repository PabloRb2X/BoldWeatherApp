//
//  WeatherDescriptionPresenter.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol WeatherDescriptionPresenterProtocol: WeatherDescriptionViewOutput {
    func showViewController()
}

final class WeatherDescriptionPresenter {
    private let wireframe: WeatherDescriptionWireframeProtocol
    private let weatherDescription: WeatherDescription
    
    var weatherTodaySubject = PublishSubject<ConsolidatedWeather>()
    var placeSubject = PublishSubject<String>()
    private var weatherNextDaysListSubject = BehaviorSubject<[ConsolidatedWeather]>(value: [])
    
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
    
    func setupNextDaysContent() {
        var nextDaysList = weatherDescription.consolidatedWeather
        nextDaysList.removeFirst()
        
        weatherNextDaysListSubject.onNext(nextDaysList)
    }
}

extension WeatherDescriptionPresenter: WeatherDescriptionPresenterProtocol {
    var weatherNextDaysList: Driver<[ConsolidatedWeather]> {
        weatherNextDaysListSubject.asDriver(onErrorJustReturn: [])
    }
    
    func showViewController() {
        wireframe.showViewController(presenter: self)
    }
    
    func didLoad() {
        setupHeaderViewContent()
        setupNextDaysContent()
    }
}
