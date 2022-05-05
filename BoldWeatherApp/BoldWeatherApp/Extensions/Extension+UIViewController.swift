//
//  Extension+UIViewController.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import UIKit

extension UIViewController {
    public func showLoadingView() {
        self.view.endEditing(true)
        
        let loadingView = LoadingView()
        loadingView.tag = 500
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        loadingView.frame = CGRect.init(x: keyWindow.bounds.origin.x, y: keyWindow.bounds.origin.y, width: keyWindow.bounds.size.width, height: keyWindow.bounds.size.height)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                keyWindow.rootViewController?.view.isUserInteractionEnabled = false
                keyWindow.addSubview(loadingView)
            }
        }
    }
    
    public func dismissLoadingView(){
        DispatchQueue.main.async {
            if let viewWithTag = UIApplication.shared.keyWindow?.viewWithTag(500) {
                UIApplication.shared.keyWindow?.rootViewController?.view.isUserInteractionEnabled = true
                viewWithTag.removeFromSuperview()
            }
        }
    }
}
