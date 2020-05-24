//
//  ImageModel.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation

struct ImageModel {
    let imageData: Data?
    let caption: String?
    let comment: String?
    let modifiedDate: Date?
    
    init(image: Image) {
        self.imageData = image.imageData
        self.caption = image.caption
        self.comment = image.comment
        self.modifiedDate = image.modifiedDate
    }
}
