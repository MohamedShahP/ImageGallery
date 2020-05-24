//
//  ViewControllerExtensions.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard: String {
    
    case Main
    
    var instance: UIStoryboard {
        UIStoryboard.init(name: self.rawValue, bundle: .main)
    }
    
    func viewController<T: UIViewController>(classType: T.Type) -> T {
        let storyboardID = (classType as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}

extension UIViewController {
    
    // IMPORTANT: In the storyboards assign storyboard ID as same as the viewcontroller class name.
    class var storyboardID: String {
        "\(self)"
    }
    
    class var name: String {
        NSStringFromClass(self)
    }
    
    static func instantiateVC(from storyboard: AppStoryboard) -> Self {
        return storyboard.viewController(classType: Self.self)
    }
}
