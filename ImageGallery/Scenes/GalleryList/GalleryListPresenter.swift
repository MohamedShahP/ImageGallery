//
//  GalleryListPresenter.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import UIKit

protocol GalleryListPresentationLogic: class {
    func presentOnImageFetchSuccess()
}

class GalleryListPresenter {
    weak var controller: GalleryListDisplayLogic?
}

extension GalleryListPresenter: GalleryListPresentationLogic {
    
    func presentOnImageFetchSuccess() {
        controller?.bindImagesInList()
    }
}
