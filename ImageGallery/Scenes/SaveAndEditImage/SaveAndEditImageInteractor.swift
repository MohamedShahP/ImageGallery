//
//  SaveAndEditImageInteractor.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import Photos
import UIKit

protocol SaveAndEditImageBusinessLogic: class {
    var currentIndex: Int { get set }
    
    func getNavigationTitle() -> String
    func isNextImageAvailable() -> Bool
    func setCurrentIndex()
    func removeCurrentImage()
    func setIsFromDoodle(to value: Bool)
    func setCurrentUIImage(image: UIImage)
    func isTextEdited(caption: String, comment: String) -> Bool
    func setImageDataEdited(value: Bool)
    func isTextEmpty(text: String) -> Bool
    
    func saveImage(request: ImageAsset.Save.Request)
    func getImage(request: ImageAsset.Fetch.Request)
    func updateDBImageObject(request: ImageAsset.Save.Request)
}

protocol SaveAndEditImageDataStore {
    var selectedImageArray:[PHAsset]? { get set }
    var selectedImage: UIImage? { get set }
    var imageSource: ImageSource? { get set }
    var editImageModel: ImageModel? { get set }
    var editedImageFromDoodle: UIImage? { get set }
    var isFromDoodle: Bool { get set }
    var currentUIImage: UIImage? { get set }
    var imageDBObject: Image? { get set }
    var isImageDataEdited: Bool { get set }
}

class SaveAndEditImageInteractor: NSObject, SaveAndEditImageBusinessLogic, SaveAndEditImageDataStore {
    var selectedImageArray: [PHAsset]?
    var selectedImage: UIImage?
    var imageSource: ImageSource?
    var editImageModel: ImageModel?
    var editedImageFromDoodle: UIImage?
    var isFromDoodle: Bool = false
    var currentUIImage: UIImage?
    var imageDBObject: Image?
    var isImageDataEdited: Bool = false
    
    var presenter: SaveAndEditImagePresentationLogic!
    
    var currentIndex: Int = 0
    
    func getNavigationTitle() -> String {
        switch imageSource! {
        case .asset:
            return "\(currentIndex + 1)/\(selectedImageArray?.count ?? 0)"
        case .camera:
            return IGConstants.SaveAndEditViewContants.ADD_IMAGE
        case .dbSource:
            return IGConstants.SaveAndEditViewContants.EDIT_IMAGE
        }
    }
    
    func isNextImageAvailable() -> Bool {
        currentIndex < self.selectedImageArray!.count-1
    }
    
    func setCurrentIndex() {
        currentIndex += 1
    }
    
    func removeCurrentImage() {
        selectedImageArray?.remove(at: currentIndex)
    }
    
    func getImage(request: ImageAsset.Fetch.Request) {
        if let assetFinish = selectedImageArray?[request.imageAssetIndex]{
            PHImageManager.default().requestImage(for: assetFinish, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { (image, info) in
                let response = ImageAsset.Fetch.Response(asset: image!)
                self.presenter.onGetImageSuccess(response: response)
            }
        }
    }
    
    func saveImage(request: ImageAsset.Save.Request) {
        let galleryDataSource = GalleryDataSource()
        
        galleryDataSource.saveImage(data: request.image.imageData, caption: request.image.caption,
                                    comment: request.image.comment, date: request.image.dateTime)
    }
    
    func setIsFromDoodle(to value: Bool) {
        self.isFromDoodle = value
    }
    
    func setCurrentUIImage(image: UIImage) {
        self.currentUIImage = image
    }
    
    func isTextEmpty(text: String) -> Bool {
        text.isEmpty
    }
    
    func updateDBImageObject(request: ImageAsset.Save.Request) {
        let image = request.image
        self.imageDBObject?.caption = image.caption
        self.imageDBObject?.comment = image.comment
        self.imageDBObject?.imageData = image.imageData
        self.imageDBObject?.modifiedDate = image.dateTime

        let galleryDataSource = GalleryDataSource()
        galleryDataSource.saveContext()
    }
    
    func isTextEdited(caption: String, comment: String) -> Bool {
        return caption != self.editImageModel?.caption || comment != self.editImageModel?.comment
    }
    
    func setImageDataEdited(value: Bool) {
        self.isImageDataEdited = value
    }
    
}

