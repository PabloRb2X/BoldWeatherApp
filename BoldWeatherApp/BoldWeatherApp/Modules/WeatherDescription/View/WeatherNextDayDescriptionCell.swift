//
//  WeatherNextDayDescriptionCell.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 05/05/22.
//

import UIKit

class WeatherNextDayDescriptionCell: UICollectionViewCell {
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var weatherDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var weatherStateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var weatherTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var weatherMinMaxTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        weatherImageView.image = nil
        weatherDateLabel.text = ""
        weatherStateLabel.text = ""
        weatherMinMaxTempLabel.text = ""
    }
    
    func setup(consolidatedWeather: ConsolidatedWeather) {
        let imageUrl = consolidatedWeather.weatherStateName.getImageUrl(abbreviation: consolidatedWeather.weatherStateAbbr)
        
        weatherImageView.imageFromServerURL(imageUrl, placeHolder: nil)
        weatherDateLabel.text = consolidatedWeather.applicableDate
        weatherStateLabel.text = "\(consolidatedWeather.weatherStateName.rawValue)"
        weatherTempLabel.text = "\(Double(round(10 * consolidatedWeather.theTemp) / 10))º"
        weatherMinMaxTempLabel.text = "H:\(Double(round(10 * consolidatedWeather.maxTemp) / 10))º L:\(Double(round(10 * consolidatedWeather.minTemp) / 10))º"

        buildViewInHierarchy()
    }
    
    func buildViewInHierarchy() {
        addSubview(weatherImageView)
        addSubview(weatherDateLabel)
        addSubview(weatherStateLabel)
        addSubview(weatherTempLabel)
        addSubview(weatherMinMaxTempLabel)
        addSubview(separatorView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            weatherImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            weatherImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 60),
            weatherImageView.heightAnchor.constraint(equalToConstant: 60),
            
            weatherTempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            weatherTempLabel.bottomAnchor.constraint(equalTo: centerYAnchor),
            weatherTempLabel.widthAnchor.constraint(equalToConstant: 125),
            
            weatherMinMaxTempLabel.trailingAnchor.constraint(equalTo: weatherTempLabel.trailingAnchor),
            weatherMinMaxTempLabel.topAnchor.constraint(equalTo: weatherTempLabel.bottomAnchor),
            
            weatherDateLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 8),
            weatherDateLabel.bottomAnchor.constraint(equalTo: centerYAnchor),
            weatherDateLabel.trailingAnchor.constraint(equalTo: weatherTempLabel.leadingAnchor, constant: -8),
            
            weatherStateLabel.leadingAnchor.constraint(equalTo: weatherDateLabel.leadingAnchor),
            weatherStateLabel.topAnchor.constraint(equalTo: weatherDateLabel.bottomAnchor),
            weatherStateLabel.trailingAnchor.constraint(equalTo: weatherDateLabel.trailingAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: weatherImageView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: weatherTempLabel.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
