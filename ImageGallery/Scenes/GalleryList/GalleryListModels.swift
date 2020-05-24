//
//  GalleryListModels.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import UIKit

struct GalleryList {
    
    struct Fetch {
        
        struct Request {}
        
        struct Response {}
        
        struct ViewModel {
            var imageList: [DisplayImageModel]
            
            struct DisplayImageModel {
                var image: UIImage? = nil
                let caption: String?
                let comment: String?
                let modifiedDate: String?
                
                init(imageModel: ImageModel?) {
                    if let image = imageModel?.imageData {
                        self.image = UIImage(data: image)
                    }
                    self.caption = imageModel?.caption
                    self.comment = imageModel?.comment
                    self.modifiedDate = imageModel?.modifiedDate?.convertToString()
                }
            }
        }
    }
}
