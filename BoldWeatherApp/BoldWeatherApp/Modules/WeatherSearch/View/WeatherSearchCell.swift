//
//  WeatherSearchCell.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import UIKit

class WeatherSearchCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            titleLabel.textColor = .black
        }
    }
    
    @IBOutlet private weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.font = UIFont.systemFont(ofSize: 16.0)
            subtitleLabel.textColor = .black
        }
    }
    
    @IBOutlet private weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        }
    }
    
    @IBOutlet private weak var arrowImageView: UIImageView! {
        didSet {
            arrowImageView.image = UIImage(named: "rightIcon")
            arrowImageView.contentMode = .scaleToFill
        }
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        subtitleLabel.text = ""
    }

    func setup(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
