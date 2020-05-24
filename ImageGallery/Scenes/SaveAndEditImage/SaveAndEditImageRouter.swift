//
//  SaveAndEditImageRouter.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import UIKit

protocol SaveAndEditImageRoutingLogic {
    func routeToDoodle(segue: UIStoryboardSegue)
     func routeToGalleryList()
}

protocol SaveAndEditImageDataPassing {
    var dataStore: SaveAndEditImageDataStore? { get }
}

class SaveAndEditImageRouter: SaveAndEditImageRoutingLogic, SaveAndEditImageDataPassing {
    
    weak var controller: SaveAndEditImageViewController?
    var dataStore: SaveAndEditImageDataStore?
    
    func routeToDoodle(segue: UIStoryboardSegue) {
        let destinationVC = segue.destination as! DoodleViewController
        var dataStore = destinationVC.router!.dataStore!
        passDataToDoodle(source: self.dataStore!, destination: &dataStore)
        navigateToDoodle(source: controller!, destination: destinationVC)
    }
    
    func routeToGalleryList() {
        let destinationVC = (controller?.parent as! UINavigationController).getViewController(of: GalleryListViewController.self) as! GalleryListViewController
        var dataStore = destinationVC.router!.dataStore!
        passDataToGalleryList(source: self.dataStore!, destination: &dataStore)
        navigateToGalleryList(source: controller!, destination: destinationVC)
    }
    
    private func passDataToDoodle(source: SaveAndEditImageDataStore,
                                      destination: inout DoodleDataStore) {
        destination.image = source.currentUIImage
    }
    
    private func passDataToGalleryList(source: SaveAndEditImageDataStore,
                                      destination: inout GalleryListDataStore) {
        destination.isDBSourceEdited = source.isImageDataEdited
    }
    
    private func navigateToDoodle(source: UIViewController, destination: UIViewController) {
        source.show(destination, sender: nil)
    }
    
    private func navigateToGalleryList(source: UIViewController, destination: UIViewController) {
        controller?.navigationController?.popViewController(animated: true)
    }
}

