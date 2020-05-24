//
//  GalleryListRouter.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import UIKit

protocol GalleryListRoutingLogic {
    func routeToSaveAndEdit(segue: UIStoryboardSegue)
}

protocol GalleryListDataPassing {
    var dataStore: GalleryListDataStore? { get }
}

class GalleryListRouter: GalleryListRoutingLogic, GalleryListDataPassing {
    
    weak var controller: GalleryListViewController?
    var dataStore: GalleryListDataStore?
    
    func routeToSaveAndEdit(segue: UIStoryboardSegue) {
        let destinationVC = segue.destination as! SaveAndEditImageViewController
        var dataStore = destinationVC.router!.dataStore!
        passDataToSaveAndEdit(source: self.dataStore!, destination: &dataStore)
        navigateToSaveAndEdit(source: controller!, destination: destinationVC)
    }
    
    private func passDataToSaveAndEdit(source: GalleryListDataStore,
                                      destination: inout SaveAndEditImageDataStore) {
        destination.selectedImageArray = source.selectedImageArray
        destination.selectedImage = source.selectedImage
        destination.imageSource = source.imageSource
        if let index = source.editImageIndex {
            destination.editImageModel = source.imageModelList?[index]
            destination.imageDBObject = source.imageListFromDB?[index]
        }
    }
    
    private func navigateToSaveAndEdit(source: UIViewController, destination: UIViewController) {
        source.show(destination, sender: nil)
    }
    
}

