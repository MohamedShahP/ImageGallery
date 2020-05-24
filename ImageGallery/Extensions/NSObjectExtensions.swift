//
//  NSObjectExtensions.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation

extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
}
