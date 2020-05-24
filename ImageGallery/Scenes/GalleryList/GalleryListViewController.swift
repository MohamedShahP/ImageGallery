//
//  GalleryListViewController.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import UIKit
import BSImagePicker

protocol GalleryListDisplayLogic: class {
    func bindImagesInList()
}

class GalleryListViewController: UIViewController {
    
    var router: (GalleryListRoutingLogic & GalleryListDataPassing)!
    private var interactor: GalleryListBusinessLogic!
    
    @IBOutlet weak var buttonFilter: UIBarButtonItem!
    @IBOutlet weak var lableNoImages: UILabel!
    @IBOutlet weak var collectionViewGalleryList: UICollectionView!
    @IBOutlet weak var loaderView: UIView!
    
    private var imagePickerController = UIImagePickerController()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        fetchImagesFromDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        
        if let dataSource = router.dataStore, dataSource.isDBSourceEdited {
            loaderView.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let dataSource = router.dataStore, dataSource.isDBSourceEdited {
            fetchImagesFromDB()
            interactor.setIsDataSourceEdited(with: false)
        }
    }
    
    private func setup() {
        let interactor = GalleryListInteractor()
        let presenter = GalleryListPresenter()
        let router = GalleryListRouter()
        
        interactor.presenter = presenter
        presenter.controller = self
        
        router.controller = self
        router.dataStore = interactor
        
        self.router = router
        self.interactor = interactor
    }
    
    private func setUpNavigationBar() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    @IBAction func addImageClickAction(_ sender: Any) {
        let alertView = IGAlertController(message: IGConstants.AlertContants.TITLE_ADD_IMAGE_MESSAGE,
                                          style: .actionSheet,
                                          buttonTitles: IGConstants.AlertContants.BUTTON_TITLE_PHOTOS, IGConstants.AlertContants.BUTTON_TITLE_CAMERA, IGConstants.AlertContants.BUTTON_TITLE_CANCEL)
        alertView.delegate = self
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func buttonSortByDateClickAction(_ sender: Any) {
        self.loaderView.isHidden = false
        self.interactor.sortImagesByDate()
        self.collectionViewGalleryList.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.loaderView.isHidden = true
        }
    }
}

extension GalleryListViewController {
    
    private func fetchImagesFromDB() {
        loaderView.isHidden = false
        interactor.getImages()
    }
    
    /// Option to pick images from photo gallery
    private func selectImageFromPhotos() {
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image,]
        imagePicker.settings.preview.enabled = true
        
        self.presentImagePicker(imagePicker, select: { (asset) in
            //print("Selected: \(asset)")
        }, deselect: { (asset) in
            //print("Deselected: \(asset)")
        }, cancel: { (assets) in
            //print("Canceled with selections: \(assets)")
        }, finish: { (assets) in
            self.interactor.setSelectedImagesFromPhotos(assets: assets)
            self.interactor.setImageSource(source: .asset)
            self.showSaveAndEditScreen()
        }, completion: {
            
        })
    }
    
    private func showSaveAndEditScreen() {
        let galleryListToSaveAndEditSegue = UIStoryboardSegue(identifier: "ListToSaveAndEditSegue", source: self, destination: SaveAndEditImageViewController.instantiateVC(from: .Main))
        router.routeToSaveAndEdit(segue: galleryListToSaveAndEditSegue)
    }
}

extension GalleryListViewController: GalleryListDisplayLogic {
    /// Initally the image list will be zero, in that case need to show no item in gallery text
    func bindImagesInList() {
        if interactor.getImageListCount() > 0 {
            collectionViewGalleryList.isHidden = false
            lableNoImages.isHidden = true
            collectionViewGalleryList.reloadData()
            buttonFilter.isEnabled = true
        } else {
            buttonFilter.isEnabled = false
            collectionViewGalleryList.isHidden = true
            lableNoImages.isHidden = false
        }
        loaderView.isHidden = true
    }
}

extension GalleryListViewController: IGAlertControllerDelegate {
    func onPositiveActionOneClicked(action: IGAlertButtonAction?) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            selectImageFromPhotos()
        }
    }
    
    func onPostiveActionTwoClicked() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func onNegativeActionClicked() {}
}

extension GalleryListViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        interactor.setSelectedImage(image: userPickedImage)
        interactor.setImageSource(source: .camera)
        showSaveAndEditScreen()
        
        picker.dismiss(animated: true)
    }
}

extension GalleryListViewController: UINavigationControllerDelegate {}

extension GalleryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.setEditImageIndex(index: indexPath.row)
        interactor.setImageSource(source: .dbSource)
        showSaveAndEditScreen()
    }
}

extension GalleryListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interactor.getImageListCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = GalleryListCell.className
        let galleryListCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                                 for: indexPath) as! GalleryListCell
        if let imageItem = interactor.getImage(at: indexPath.row) {
            galleryListCell.imageModel = imageItem
        }
        return galleryListCell
    }
}

extension GalleryListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.view.frame.width, height: 280.0)
    }
}
