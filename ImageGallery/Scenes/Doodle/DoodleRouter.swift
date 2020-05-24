//
//  DoodleRouter.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import UIKit

protocol DoodleRoutingLogic {
    func routeToSaveAndEdit()
}

protocol DoodleDataPassing {
    var dataStore: DoodleDataStore? { get }
}

class DoodleRouter: DoodleRoutingLogic, DoodleDataPassing {
    
    weak var controller: DoodleViewController?
    var dataStore: DoodleDataStore?
    
    func routeToSaveAndEdit() {
        let destinationVC = (controller?.parent as! UINavigationController).getViewController(of: SaveAndEditImageViewController.self) as! SaveAndEditImageViewController
        var dataStore = destinationVC.router!.dataStore!
        passDataToSaveEdit(source: self.dataStore!, destination: &dataStore)
        navigateToSaveAndEdit(source: controller!, destination: destinationVC)
    }
    
    private func passDataToSaveEdit(source: DoodleDataStore,
                                      destination: inout SaveAndEditImageDataStore) {
        destination.editedImageFromDoodle = source.editedImage
        destination.isFromDoodle = true
    }
    
    private func navigateToSaveAndEdit(source: UIViewController, destination: UIViewController) {
        controller?.navigationController?.popViewController(animated: true)
    }
}

