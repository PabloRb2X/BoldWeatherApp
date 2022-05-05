//
//  WeatherSearchPresenter.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol WeatherSearchPresenterProtocol: WeatherSearchViewOutput {
    func retrySearch()
    func retryWeatherDescription()
}

final class WeatherSearchPresenter {
    private let interactor: WeatherSearchInteractorProtocol
    private let wireframe: WeatherSearchWireframeProtocol
    
    private var weatherPlacesListSubject = BehaviorSubject<[WeatherPlace]>(value: [])
    private var currentSearchText = ""
    private var currentSelectedIndex = 0
    
    var showLoadingViewPublisher = PublishSubject<Void>()
    var hideLoadingViewPublisher = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    init(interactor: WeatherSearchInteractor,
         wireframe: WeatherSearchWireframe) {
        self.interactor = interactor
        self.wireframe = wireframe
        
        showViewController()
    }
    
    func showViewController() {
        wireframe.showViewController(presenter: self)
    }
}

extension WeatherSearchPresenter: WeatherSearchPresenterProtocol {
    var weatherPlacesList: Driver<[WeatherPlace]> {
        weatherPlacesListSubject.asDriver(onErrorJustReturn: [])
    }
    
    func beginSearching(text: String) {
        guard !text.isEmpty else { return }
        
        currentSearchText = text
        
        interactor
            .weatherSearchService(text: text)
            .subscribe(onNext: { [weak self] response in
                 
                self?.weatherPlacesListSubject.onNext(response)
            }, onError: { [weak self] _ in
                guard let self = self else { return }
                
                self.wireframe.showAlert(title: "Error",
                                         message: "Ocurrió un error, ¿deseas intentarlo nuevamente?",
                                         type: .search,
                                         presenter: self)
            }).disposed(by: disposeBag)
    }
    
    func retrySearch() {
        beginSearching(text: currentSearchText)
    }
    
    func retryWeatherDescription() {
        selectWeatherPlace(index: currentSelectedIndex)
    }
    
    func resetSearch() {
        weatherPlacesListSubject.onNext([])
    }
    
    func selectWeatherPlace(index: Int) {
        currentSelectedIndex = index
        
        let weatherPlaces = try? weatherPlacesListSubject.value()
        
        guard let weatherPlace = weatherPlaces?[currentSelectedIndex] else {
            wireframe.showAlert(title: "Error",
                                message: "Ocurrió un error, ¿deseas obtener la información nuevamente?",
                                type: .fetchInfo,
                                presenter: self)
            
            return
        }
        
        showLoadingViewPublisher.onNext(())
        
        interactor
            .weatherDescriptionService(woeid: weatherPlace.woeid)
            .subscribe(onNext: { [weak self] response in
                self?.hideLoadingViewPublisher.onNext(())
                self?.wireframe.showWeatherDescription(weatherDescription: response)
            }, onError: { [weak self] _ in
                self?.hideLoadingViewPublisher.onNext(())
                guard let self = self else { return }
                
                self.wireframe.showAlert(title: "Error",
                                         message: "Ocurrió un error, ¿deseas obtener la información nuevamente?",
                                         type: .fetchInfo,
                                         presenter: self)
            }).disposed(by: disposeBag)
    }
}
