//
//  SaveAndEditImagePresenter.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation

protocol SaveAndEditImagePresentationLogic: class {
    func onGetImageSuccess(response: ImageAsset.Fetch.Response)
}

class SaveAndEditImagePresenter {
    weak var controller: SaveAndEditImageDisplayLogic?
}

extension SaveAndEditImagePresenter: SaveAndEditImagePresentationLogic {
    
    func onGetImageSuccess(response: ImageAsset.Fetch.Response) {
        let viewModel = ImageAsset.Fetch.ViewModel(image: response.asset)
        controller?.bindImage(viewModel: viewModel)
    }
}
