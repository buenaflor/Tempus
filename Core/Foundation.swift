//
//  Foundation.swift
//  Tempus
//
//  Created by Giancarlo on 03.06.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    var format: String {
        return "dd MMM yyyy"
    }
}

struct DateFormat {
    static let shared = DateFormatter()
}
