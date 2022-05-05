//
//  WeatherSearchModule.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import UIKit

final class WeatherSearchModule {
    private let presenter: WeatherSearchPresenter
    
    init(with baseController: UIViewController) {
        let wireframe = WeatherSearchWireframe(with: baseController)
        let interactor = WeatherSearchInteractor()
        
        presenter = WeatherSearchPresenter(interactor: interactor, wireframe: wireframe)
    }
    
    func showViewController() {
        
    }
}
