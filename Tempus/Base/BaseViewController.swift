//
//  BaseViewController.swift
//  Tempus
//
//  Created by Giancarlo on 27.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(activityIndicatorStyle: .white)
        av.startAnimating()
        return av
    }()
    
    lazy var customActivityIndicator: NVActivityIndicatorView = {
        let nv = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .white, padding: nil)
        nv.startAnimating()
        return nv
    }()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "logo_big")
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Temp.main
    }
}
