//
//  WeatherDescriptionWireframe.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import UIKit

protocol WeatherDescriptionWireframeProtocol {
    func showViewController(presenter: WeatherDescriptionPresenterProtocol)
}

final class WeatherDescriptionWireframe {
    private weak var baseController: UIViewController?
    
    private var navigationController: UINavigationController? {
        if let navigation = baseController?.presentedViewController as? UINavigationController {
            return navigation
        } else {
            return baseController as? UINavigationController
        }
    }
    
    init(with baseController: UIViewController) {
        self.baseController = baseController
    }
}

extension WeatherDescriptionWireframe: WeatherDescriptionWireframeProtocol {
    func showViewController(presenter: WeatherDescriptionPresenterProtocol) {
        let weatherDescriptionViewController = WeatherDescriptionViewController(presenter: presenter)
        
        navigationController?.pushViewController(weatherDescriptionViewController, animated: true)
    }
}
