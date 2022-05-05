//
//  WeatherSearchViewController.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol WeatherSearchViewOutput {
    var weatherPlacesList: Driver<[WeatherPlace]> { get }
    var showLoadingViewPublisher: PublishSubject<Void> { get set }
    var hideLoadingViewPublisher: PublishSubject<Void> { get set }
    
    func beginSearching(text: String)
    func resetSearch()
    func selectWeatherPlace(index: Int)
}

class WeatherSearchViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.showsCancelButton = true
        }
    }
    
    @IBOutlet private weak var searchCollectionView: UICollectionView! {
        didSet {
            searchCollectionView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        }
    }
    
    private let presenter: WeatherSearchViewOutput
    private let disposeBag = DisposeBag()

    init(presenter: WeatherSearchViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: String(describing: WeatherSearchViewController.self),
                   bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

private extension WeatherSearchViewController {
    func setup() {
        searchBar.delegate = self
        title = "Weather App"
        
        bindRxComponents()
        registerSearchCollectionView()
        setupSearchCollectionView()
    }
    
    func bindRxComponents() {
        presenter
            .showLoadingViewPublisher
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.showLoadingView()
            }).disposed(by: disposeBag)
        
        presenter
            .hideLoadingViewPublisher
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.dismissLoadingView()
            }).disposed(by: disposeBag)
    }
    
    func registerSearchCollectionView() {
        searchCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        searchCollectionView.register(UINib(nibName: String(describing: WeatherSearchCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: "searchCell")
    }
    
    func setupSearchCollectionView() {
        let cellIdentifier = "searchCell"
        let cellType = WeatherSearchCell.self
        let dataSource = presenter.weatherPlacesList
        
        dataSource
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: searchCollectionView.rx.items(cellIdentifier: cellIdentifier,
                                                    cellType: cellType)) { (_, element, cell) in
                
                cell.setup(title: element.title, subtitle: element.locationType)
            }.disposed(by: disposeBag)
    }
}

extension WeatherSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        presenter.selectWeatherPlace(index: indexPath.row)
    }
}

extension WeatherSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.beginSearching(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.resetSearch()
    }
}
