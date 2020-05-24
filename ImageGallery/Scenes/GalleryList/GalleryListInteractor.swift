//
//  GalleryListInteractor.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import Photos
import UIKit

protocol GalleryListBusinessLogic {
    var isListSortedDescending: Bool { get set }
    
    func getImages()
    func getImageListCount() -> Int
    func getImage(at index: Int) -> GalleryList.Fetch.ViewModel.DisplayImageModel?
    
    func setSelectedImagesFromPhotos(assets: [PHAsset])
    func setEditImageIndex(index: Int)
    func setImageSource(source: ImageSource)
    func setSelectedImage(image: UIImage)
    func setIsDataSourceEdited(with value: Bool)
    func sortImagesByDate()
}

protocol GalleryListDataStore {
    var imageListFromDB: [Image]? { get set }
    var imageModelList: [ImageModel]? { get set }
    var selectedImageArray:[PHAsset]? { get set }
    var selectedImage: UIImage? { get set }
    var editImageIndex: Int? { get set }
    var imageSource: ImageSource? { get set }
    var isDBSourceEdited: Bool { get set }
}

class GalleryListInteractor: GalleryListDataStore, GalleryListBusinessLogic {
    
    var isListSortedDescending: Bool = true
    
    var selectedImageArray: [PHAsset]?
    
    var imageListFromDB: [Image]?
    var imageModelList: [ImageModel]?
    var imageSource: ImageSource?
    var selectedImage: UIImage?
    var editImageIndex: Int?
    var isDBSourceEdited: Bool = false
    
    var presenter: GalleryListPresentationLogic!
    
    func setSelectedImagesFromPhotos(assets: [PHAsset]) {
        self.selectedImageArray = assets
    }
}

extension GalleryListInteractor {
    
    func getImages() {
        let galleryDataSource = GalleryDataSource()
        let imageList = galleryDataSource.getAllImages()
        self.imageListFromDB = imageList
        
        var images = [ImageModel]()
        imageList.forEach { (image) in
            images.append(ImageModel(image: image))
        }
        self.imageModelList = images
        
        presenter.presentOnImageFetchSuccess()
    }
    
    func getImageListCount() -> Int {
        self.imageModelList?.count ?? 0
    }
    
    func getImage(at index: Int) -> GalleryList.Fetch.ViewModel.DisplayImageModel? {
        if let image = self.imageModelList?[index] {
            return GalleryList.Fetch.ViewModel.DisplayImageModel(imageModel: image)
        }
        return nil
    }
        
    func sortImagesByDate() {
        let imageList = self.imageModelList
        
        if isListSortedDescending {
            self.imageModelList =  imageList?.sorted(by:
                { $0.modifiedDate!.compare($1.modifiedDate!) == .orderedAscending })
        } else {
            self.imageModelList =  imageList?.sorted(by:
                { $0.modifiedDate!.compare($1.modifiedDate!) == .orderedDescending })
        }
        
        isListSortedDescending = !isListSortedDescending
    }
    
    func setEditImageIndex(index: Int) {
        self.editImageIndex = index
    }
    
    func setImageSource(source: ImageSource) {
        self.imageSource = source
    }
    
    func setSelectedImage(image: UIImage) {
        self.selectedImage = image
    }
    
    func setIsDataSourceEdited(with value: Bool) {
        self.isDBSourceEdited = value
    }
}

