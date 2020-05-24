//
//  UINavigationControllerExtensions.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func getViewController(of viewControllerClass: AnyClass) -> UIViewController? {
        var searchedViewController: UIViewController?
        
        for viewController in self.children {
            if viewController.isKind(of: viewControllerClass) {
                searchedViewController = viewController
                break
            }
        }
        return searchedViewController
    }
}
