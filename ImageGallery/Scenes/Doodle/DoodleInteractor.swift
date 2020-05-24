//
//  DoodleInteractor.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import UIKit

protocol DoodleBusinessLogic: class {
    func setEditedImage(image: UIImage)
}

protocol DoodleDataStore {
    var image: UIImage! { get set }
    var editedImage: UIImage? { get set }
}

class DoodleInteractor: NSObject, DoodleDataStore {
    var image: UIImage!
    var editedImage: UIImage?
}

extension DoodleInteractor: DoodleBusinessLogic {
    
    func setEditedImage(image: UIImage) {
        self.editedImage = image
    }
}

