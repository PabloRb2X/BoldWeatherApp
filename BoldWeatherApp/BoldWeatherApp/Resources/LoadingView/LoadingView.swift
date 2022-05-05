//
//  LoadingView.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 05/05/22.
//

import UIKit

final class LoadingView: UIView {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        setup()
    }
    
    private func setup() {
        let view = Bundle.main.loadNibNamed(String(describing: LoadingView.self), owner: self, options: nil)?[0] as! UIView
        addSubview(view)
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        activityIndicator.startAnimating()
    }
}
