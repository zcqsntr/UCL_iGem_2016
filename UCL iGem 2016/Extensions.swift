//
//  Extensions.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 06/08/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import Foundation
import UIKit
extension Array where Element : Equatable {
    mutating func removeObject(_ object : Iterator.Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}
