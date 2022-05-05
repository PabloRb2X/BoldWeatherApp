//
//  WeatherSearchWireframe.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import UIKit

protocol WeatherSearchWireframeProtocol {
    func showViewController(presenter: WeatherSearchPresenterProtocol)
    func showWeatherDescription(weatherDescription: WeatherDescription)
    func showAlert(title: String,
                   message: String,
                   type: WeatherServiceType,
                   presenter: WeatherSearchPresenterProtocol)
}

final class WeatherSearchWireframe {
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

extension WeatherSearchWireframe: WeatherSearchWireframeProtocol {
    func showViewController(presenter: WeatherSearchPresenterProtocol) {
        let weatherSearchViewController = WeatherSearchViewController(presenter: presenter)
        
        navigationController?.pushViewController(weatherSearchViewController, animated: true)
    }
    
    func showWeatherDescription(weatherDescription: WeatherDescription) {
        guard let navigationController = navigationController else { return }
        
        let weatherDescriptionModule = WeatherDescriptionModule(with: navigationController,
                                                                weatherDescription: weatherDescription)
        
        weatherDescriptionModule.showViewController()
    }
    
    func showAlert(title: String,
                   message: String,
                   type: WeatherServiceType,
                   presenter: WeatherSearchPresenterProtocol) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: { action in
            switch type {
            case .search:
                presenter.retrySearch()
            case .fetchInfo:
                presenter.retryWeatherDescription()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel, handler: nil))
        
        navigationController?.present(alert, animated: true, completion: nil)
    }
}
