//
//  SaveAndEditImageViewController.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import UIKit
import CropViewController

protocol SaveAndEditImageDisplayLogic: class {
    func bindImage(viewModel: ImageAsset.Fetch.ViewModel)
}

enum ImageSource: Equatable {
    case asset
    case camera
    case dbSource
}

class SaveAndEditImageViewController: UIViewController {
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var buttonReset: UIButton!
    @IBOutlet weak var buttonCrop: UIButton!
    @IBOutlet weak var buttonDoodle: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    
    var router: (SaveAndEditImageRoutingLogic & SaveAndEditImageDataPassing)!
    private var interactor: SaveAndEditImageBusinessLogic!
    
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
        self.setUpNavigationBar()
        self.setupNavigationTitle()
        self.bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        
        /// Do refresh the image only when there is an edit from doodle drawing
        if let datastore = router.dataStore {
            if let image = datastore.editedImageFromDoodle, datastore.isFromDoodle {
                self.imageView.image = image
                self.buttonReset.isEnabled = true
                interactor.setCurrentUIImage(image: image)
                interactor.setIsFromDoodle(to: false)
            }
        }
    }
    
    private func setUpNavigationBar() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupComments()
    }
    
    private func setup() {
        let interactor = SaveAndEditImageInteractor()
        let presenter = SaveAndEditImagePresenter()
        let router = SaveAndEditImageRouter()
        
        interactor.presenter = presenter
        presenter.controller = self
        
        router.controller = self
        router.dataStore = interactor
        
        self.router = router
        self.interactor = interactor
    }
    
    
    private func setupComments() {
        self.commentsTextView.layer.borderWidth = 1.0
        self.commentsTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.commentsTextView.layer.cornerRadius = 5.0
    }
    
    /// Bind image to the view according to its source type.
    private func bindData() {
        if let dataStore = router.dataStore {
            switch dataStore.imageSource! {
            case .dbSource:
                self.captionTextField.text = dataStore.editImageModel?.caption
                self.commentsTextView.text = dataStore.editImageModel?.comment
                buttonReset.isEnabled = false
                buttonDelete.isHidden = true
                self.getImage(of: .dbSource)
            case .asset:
                hideEditOptions()
                self.getImage(of: .asset)
            case .camera:
                hideEditOptions()
                self.getImage(of: .camera)
            }
        }
    }
    
    private func hideEditOptions() {
        buttonCrop.isHidden = true
        buttonReset.isHidden = true
        buttonDoodle.isHidden = true
    }
    
    private func setupNavigationTitle(){
        self.navigationItem.title = interactor.getNavigationTitle()
    }
    
    @IBAction func saveToolBarBtnTapped(_ sender: Any) {
        let captionText = captionTextField.text!
        let commentText = commentsTextView.text!
        
        if(interactor.isTextEmpty(text: captionText)) {
            showErrorAlert(with: IGConstants.AlertContants.TITLE_ERROR, message: IGConstants.AlertContants.PLEASE_ENTER_CAPTION)
        } else if(interactor.isTextEmpty(text: commentText)) {
            showErrorAlert(with: IGConstants.AlertContants.TITLE_ERROR, message: IGConstants.AlertContants.PLEASE_ENTER_COMMENT)
        } else {
            /// Get JPEG data of the image and compress to half of its size
            let compressedImage = imageView.image?.jpegData(compressionQuality: 0.5)
            
            let isTextEdited = interactor.isTextEdited(caption: captionText, comment: commentText)
            
            if let imageSource = router.dataStore?.imageSource {
                switch imageSource {
                case .asset:
                    saveImage(imageData: compressedImage, caption: captionText,
                    comment: commentText, date: Date())
                    interactor.setImageDataEdited(value: true)
                    
                    /// Check for the next image in the PHAsset list
                    if(interactor.isNextImageAvailable()){
                        captionTextField.text = ""
                        commentsTextView.text = ""
                        interactor.setCurrentIndex()
                        setupNavigationTitle()
                        getImage(of: .asset)
                    }else{
                        popViewController()
                    }
                case .camera:
                    saveImage(imageData: compressedImage, caption: captionText,
                    comment: commentText, date: Date())
                    interactor.setImageDataEdited(value: true)
                    
                    popViewController()
                case .dbSource:
                    if isTextEdited || buttonReset.isEnabled {
                        updateImage(imageData: compressedImage, caption: captionText,
                                    comment: commentText, date: Date())
                        
                        interactor.setImageDataEdited(value: true)
                    }
                    popViewController()
                }
            }
            
        }
    }
    
    @IBAction func removeToolBarBtnTapped(_ sender: Any) {
        self.showBottomAlert(with: IGConstants.AlertContants.TITLE_REMOVE, message: IGConstants.AlertContants.REMOVE_IMAGE)
    }
    
    @IBAction func buttonResetTapped(_ sender: Any) {
        /// Reset image to the original initial image
        if let imageSource = router.dataStore?.imageSource, imageSource == .dbSource {
            if let image = router.dataStore?.editImageModel?.imageData?.image {
                self.imageView.image = image
                 interactor.setCurrentUIImage(image: image)
            }
            buttonReset.isEnabled = false
        }
    }
    
    @IBAction func buttonDoodleTapped(_ sender: Any) {
        showDoodleViewController()
    }
    
    @IBAction func buttonCropTapped(_ sender: Any) {
        let cropViewController = CropViewController(image: self.imageView.image!)
        
        cropViewController.resetButtonHidden = false
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.rotateButtonsHidden = true
        
        cropViewController.delegate = self
        
        present(cropViewController, animated: true, completion: nil)
    }
}

extension SaveAndEditImageViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        self.imageView.image = image
        self.buttonReset.isEnabled = true
        interactor.setCurrentUIImage(image: image)
        self.dismiss(animated: true, completion: nil)
    }
}

extension SaveAndEditImageViewController {
    private func getImage(of type: ImageSource) {
        
        switch type {
        case .asset:
            let request = ImageAsset.Fetch.Request(imageAssetIndex: interactor.currentIndex)
            interactor.getImage(request: request)
        case .camera:
            if let image = router.dataStore?.selectedImage {
                self.imageView.image = image
                interactor.setCurrentUIImage(image: image)
            }
        case .dbSource:
            if let image = router.dataStore?.editImageModel?.imageData?.image {
                self.imageView.image = image
                interactor.setCurrentUIImage(image: image)
            }
        }
    }
        
    private func showErrorAlert(with title: String, message: String) {
        let alertView = IGAlertController(title: title, message: message, style: .alert,
                                          buttonTitles: IGConstants.AlertContants.BUTTON_TITTLE_OK)
        alertView.delegate = self
        self.present(alertView, animated: true, completion: nil)
    }
    
    private func showBottomAlert(with title: String, message: String) {
        let alertView = IGAlertController(title: title, message: message, style: .alert,
                                          buttonTitles: IGConstants.AlertContants.BUTTON_TITLE_YES, IGConstants.AlertContants.BUTTON_TITLE_NO)
        alertView.delegate = self
        self.present(alertView, animated: true, completion: nil)
    }
    
    private func saveImage(imageData: Data?, caption: String, comment: String, date: Date) {
        let imageModel = ImageAsset.Save.Request.ImageModel(imageData: imageData, caption: caption,
                                                             comment: comment, dateTime: date)
        let saveRequest = ImageAsset.Save.Request(image: imageModel)
        interactor.saveImage(request: saveRequest)
    }
    
    private func updateImage(imageData: Data?, caption: String, comment: String, date: Date) {
        let imageModel = ImageAsset.Save.Request.ImageModel(imageData: imageData, caption: caption,
                                                            comment: comment, dateTime: date)
        let updateRequest = ImageAsset.Save.Request(image: imageModel)
        interactor.updateDBImageObject(request: updateRequest)
    }
    
    private func popViewController() {
        router.routeToGalleryList()
    }
    
    private func removeCurrentImage() {
        if let imageSource = router.dataStore?.imageSource {
            switch imageSource {
            case .asset:
                if(interactor.isNextImageAvailable()){
                    self.interactor.removeCurrentImage()
                    self.setupNavigationTitle()
                    self.getImage(of: .asset)
                }else{
                    popViewController()
                }
            case .camera, .dbSource:
                popViewController()
            }
        }
    }
    
    private func showDoodleViewController() {
        let editToDoodleSegue = UIStoryboardSegue(identifier: "EditToDoodleSegue", source: self, destination: DoodleViewController.instantiateVC(from: .Main))
        router.routeToDoodle(segue: editToDoodleSegue)
    }
}

extension SaveAndEditImageViewController: IGAlertControllerDelegate {
    func onPositiveActionOneClicked(action: IGAlertButtonAction?) {
        guard let action = action else {
            return
        }
        
        switch action {
        case .focusCaptionTextField:
            captionTextField.becomeFirstResponder()
        case .focusCommentTextField:
            commentsTextView.becomeFirstResponder()
        case .removeImage:
            removeCurrentImage()
        }
    }
    
    func onPostiveActionTwoClicked() {}
    
    func onNegativeActionClicked() {}
}

extension SaveAndEditImageViewController: SaveAndEditImageDisplayLogic {
    
    func bindImage(viewModel: ImageAsset.Fetch.ViewModel) {
        self.imageView.image = viewModel.image
        interactor.setCurrentUIImage(image: viewModel.image)
    }
}

extension SaveAndEditImageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        commentsTextView.becomeFirstResponder()
        return true
    }
}
