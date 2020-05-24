//
//  SaveAndEditImageModels.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import Photos
import UIKit

struct ImageAsset {
    
    struct Fetch {
        
        struct Request {
            let imageAssetIndex: Int
        }
        
        struct Response {
            let asset: UIImage
        }
        
        struct ViewModel {
            let image: UIImage
        }
    }
    
    struct Save {
        struct Request {
            var image: ImageModel
            
            struct ImageModel {
                let imageData: Data?
                let caption: String?
                let comment: String?
                let dateTime: Date?
            }
        }
    }
}

