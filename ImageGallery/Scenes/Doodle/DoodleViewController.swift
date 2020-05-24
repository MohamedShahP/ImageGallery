//
//  DoodleViewController.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import UIKit

protocol DoodleDisplayLogic: class {
    
}

class DoodleViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    @IBOutlet weak var constraintTempImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintMainImageViewHeight: NSLayoutConstraint!
    
    var router: (DoodleRoutingLogic & DoodleDataPassing)!
    private var interactor: DoodleBusinessLogic!
    
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
        bindOriginalImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        let image = router.dataStore?.image
        let imageWidth = self.view.frame.width
        let imageHeight = imageWidth * (CGFloat(image?.size.height ?? 0) / CGFloat(image?.size.width ?? 0))
        
        constraintMainImageViewHeight.constant = imageHeight
        constraintTempImageViewHeight.constant = imageHeight
        
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setup() {
        let interactor = DoodleInteractor()
        let router = DoodleRouter()
        
        router.controller = self
        router.dataStore = interactor
        
        self.router = router
        self.interactor = interactor
    }
    
    var lastPoint = CGPoint.zero
    var color = UIColor.green
    var brushWidth: CGFloat = 3.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    // MARK: - Actions
    @IBAction func resetPressed(_ sender: Any) {
        bindOriginalImage()
    }
    
    @IBAction func donePressed(_ sender: Any) {
        guard let image = mainImageView.image else {
            return
        }
        interactor.setEditedImage(image: image)
        router.routeToSaveAndEdit()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        router.routeToSaveAndEdit()
    }
    
    private func bindOriginalImage() {
        self.mainImageView.image = router.dataStore?.image
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: mainImageView.bounds)
        
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        
        UIGraphicsEndImageContext()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        swiped = false
        lastPoint = touch.location(in: mainImageView)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        swiped = true
        let currentPoint = touch.location(in: mainImageView)
        drawLine(from: lastPoint, to: currentPoint)
        
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLine(from: lastPoint, to: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: mainImageView.bounds, blendMode: .normal, alpha: 1.0)
        tempImageView?.image?.draw(in: mainImageView.bounds, blendMode: .normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
}

extension DoodleViewController: DoodleDisplayLogic {
    
}
