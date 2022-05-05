//
//  WeatherDescriptionModule.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import UIKit

final class WeatherDescriptionModule {
    private let presenter: WeatherDescriptionPresenter
    
    init(with baseController: UIViewController,
         weatherDescription: WeatherDescription) {
        let wireframe = WeatherDescriptionWireframe(with: baseController)
        
        presenter = WeatherDescriptionPresenter(wireframe: wireframe,
                                                weatherDescription: weatherDescription)
    }
    
    func showViewController() {
        presenter.showViewController()
    }
}
