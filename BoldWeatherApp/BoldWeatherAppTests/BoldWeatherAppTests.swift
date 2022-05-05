//
//  BoldWeatherAppTests.swift
//  BoldWeatherAppTests
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import XCTest
import RxSwift
import Alamofire
@testable import BoldWeatherApp

enum DummyWeatherSearchInteractorError: Error {
    case serverFailure
}

class DummyWeatherSearchInteractor: WeatherSearchInteractorProtocol {
    func weatherSearchService(text: String) -> Observable<[WeatherPlace]> {
        return Observable<[WeatherPlace]>.create { observer in
            let disposables = Disposables.create()
            
            let places = [
                WeatherPlace(title: "London", locationType: "City", woeid: 44418, lattLong: "51.506321,-0.12714")
            ]
            
            observer.onNext(places)
            observer.onCompleted()
            
            return disposables
        }
    }
    
    func weatherDescriptionService(woeid: Int) -> Observable<WeatherDescription> {
        return Observable<WeatherDescription>.create { observer in
            let disposables = Disposables.create()
            
            observer.onError(DummyWeatherSearchInteractorError.serverFailure)
            observer.onCompleted()
            
            return disposables
        }
    }
}

class BoldWeatherAppTests: XCTestCase {
    
    private var interactor = DummyWeatherSearchInteractor()
    private let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
    }
    
    func test_weatherSearchSuccess() {
        let interactorExpectation: XCTestExpectation = expectation(description: "success")
        var weatherPlaces: [WeatherPlace] = []
        
        interactor
            .weatherSearchService(text: "London")
            .subscribe(onNext: { response in
                
                weatherPlaces = response
                interactorExpectation.fulfill()
            }, onError: { _ in
                XCTFail("Error in service")
            }).disposed(by: disposeBag)
        
        wait(for: [interactorExpectation], timeout: 5)
        
        XCTAssert(weatherPlaces.count > 0)
    }

    func test_WeatherDescriptionFailure() {
        let interactorExpectation: XCTestExpectation = expectation(description: "false")
        var weatherDescription: WeatherDescription?
        
        interactor
            .weatherDescriptionService(woeid: 10000)
            .subscribe(onNext: { response in
                
                weatherDescription = response
                interactorExpectation.fulfill()
            }, onError: { _ in
                interactorExpectation.fulfill()
            }).disposed(by: disposeBag)
        
        wait(for: [interactorExpectation], timeout: 5)
        
        XCTAssertNil(weatherDescription)
    }
}
