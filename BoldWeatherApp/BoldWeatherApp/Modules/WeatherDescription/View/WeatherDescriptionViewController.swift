//
//  WeatherDescriptionViewController.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol WeatherDescriptionViewOutput {
    var placeSubject: PublishSubject<String> { get set }
    var weatherTodaySubject: PublishSubject<ConsolidatedWeather> { get set }
    var weatherNextDaysList: Driver<[ConsolidatedWeather]> { get }
    
    func didLoad()
}

final class WeatherDescriptionViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var placeLabel: UILabel! {
        didSet {
            placeLabel.font = UIFont.boldSystemFont(ofSize: 35.0)
            placeLabel.textColor = .black
            placeLabel.textAlignment = .center
        }
    }
    
    @IBOutlet private weak var tempLabel: UILabel! {
        didSet {
            tempLabel.font = UIFont.boldSystemFont(ofSize: 80.0)
            tempLabel.textColor = .black
            tempLabel.textAlignment = .center
        }
    }
    
    @IBOutlet private weak var stateNameLabel: UILabel! {
        didSet {
            stateNameLabel.font = UIFont.systemFont(ofSize: 25.0)
            stateNameLabel.textColor = .black
            stateNameLabel.textAlignment = .center
        }
    }
    
    @IBOutlet private weak var minMaxTempLabel: UILabel! {
        didSet {
            minMaxTempLabel.font = UIFont.systemFont(ofSize: 20.0)
            minMaxTempLabel.textColor = .black
            minMaxTempLabel.textAlignment = .center
        }
    }
    
    @IBOutlet weak var nextDaysCollectionView: UICollectionView! {
        didSet {
            nextDaysCollectionView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        }
    }
    
    private let presenter: WeatherDescriptionViewOutput
    private let disposeBag = DisposeBag()

    init(presenter: WeatherDescriptionViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: String(describing: WeatherDescriptionViewController.self),
                   bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        presenter.didLoad()
    }
}

private extension WeatherDescriptionViewController {
    func setup() {
        title = "Weather Description"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        bindRxComponents()
        registerNextDaysCollectionView()
        setupSearchCollectionView()
    }
    
    func bindRxComponents() {
        presenter
            .placeSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] title in
                self?.placeLabel.text = title
            }).disposed(by: disposeBag)
        
        presenter
            .weatherTodaySubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] consolidatedWeather in
                self?.tempLabel.text = "\(Double(round(10 * consolidatedWeather.theTemp) / 10))º"
                self?.stateNameLabel.text = consolidatedWeather.weatherStateName.rawValue
                self?.minMaxTempLabel.text = "H:\(Double(round(10 * consolidatedWeather.maxTemp) / 10))º L:\(Double(round(10 * consolidatedWeather.minTemp) / 10))º"
            }).disposed(by: disposeBag)
    }
    
    func registerNextDaysCollectionView() {
        nextDaysCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        nextDaysCollectionView.register(WeatherNextDayDescriptionCell.self, forCellWithReuseIdentifier: "nextDayCell")
    }
    
    func setupSearchCollectionView() {
        let cellIdentifier = "nextDayCell"
        let cellType = WeatherNextDayDescriptionCell.self
        let dataSource = presenter.weatherNextDaysList
        
        dataSource
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: nextDaysCollectionView.rx.items(cellIdentifier: cellIdentifier,
                                                      cellType: cellType)) { (_, element, cell) in
                
                cell.setup(consolidatedWeather: element)
            }.disposed(by: disposeBag)
    }
}

extension WeatherDescriptionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 80)
    }
}
