//
//  GalleryListCell.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import UIKit

class GalleryListCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewGalleryItem: UIImageView!
    @IBOutlet weak var labelCaption: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var shadowView: UIView!
    
    private var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        parentView.layer.cornerRadius = 20
        parentView.layer.masksToBounds = true
        
//        shadowView.layer.shadowColor = UIColor.black.cgColor
//        shadowView.layer.shadowOffset = .zero
//        shadowView.layer.shadowRadius = 20
//        shadowView.layer.shadowOpacity = 1
    }
    
    var imageModel: GalleryList.Fetch.ViewModel.DisplayImageModel! {
        didSet {
            bindData(imageModel: imageModel)
        }
    }
    
    func bindData(imageModel: GalleryList.Fetch.ViewModel.DisplayImageModel) {
        imageViewGalleryItem.image = imageModel.image
        labelCaption.text = imageModel.caption
        labelComment.text = imageModel.comment
        labelTime.text = imageModel.modifiedDate
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let featuredHeight = GalleryListViewLayoutConstants.Cell.featuredHeight
        let standardHeight = GalleryListViewLayoutConstants.Cell.standardHeight
        
        let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
        
        let scale = max(delta, 0.8)
        labelCaption.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        labelComment.alpha = delta
        labelTime.alpha = delta
    }
}
