//
//  UIViewController+Helpers.swift
//  Companies
//
//  Created by Jeff Kral on 12/11/17.
//  Copyright © 2017 Jeff Kral. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupPlusButtonInNavBar(selector: Selector) {
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
    
    }
    
    func setupCancelButtonInNavBar() {
         navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }
    
    @objc func handleCancelModal() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupLightBlueBackgroundView(height: CGFloat) -> UIView {
        
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = .lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return lightBlueBackgroundView
    }
    
}
