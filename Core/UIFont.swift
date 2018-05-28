//
//  UIFont.swift
//  Tempus
//
//  Created by Giancarlo on 23.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

private struct Default {
    static let font = UIFont.systemFont(ofSize: 16)
}

extension UIFont {
    
    public class var TempRegular: UIFont {
        return UIFont(name: "PingFangTC-Regular" , size: 16) ?? Default.font
    }
    public class var TempSemiBold: UIFont {
        return UIFont(name: "PingFangTC-Semibold", size: 16) ?? Default.font
    }
}
