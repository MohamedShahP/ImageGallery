//
//  DataExtensions.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    
    var image: UIImage? {
        UIImage(data: self)
    }
}
