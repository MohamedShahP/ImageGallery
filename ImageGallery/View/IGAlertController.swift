//
//  IGAlertController.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import UIKit

enum IGAlertButtonAction: Equatable {
    case focusCaptionTextField
    case focusCommentTextField
    case removeImage
}

protocol IGAlertControllerDelegate {
    func onPositiveActionOneClicked(action: IGAlertButtonAction?)
    func onPostiveActionTwoClicked()
    func onNegativeActionClicked()
}

class IGAlertController: UIAlertController {
    
    convenience init(title: String? = nil, message: String? = nil,
                     style: UIAlertController.Style, buttonTitles: String...) {
        self.init(title: title, message: message, preferredStyle: style)
        
        addActions(actionTitles: buttonTitles)
    }
    
    var delegate: IGAlertControllerDelegate?
    
    private func addActions(actionTitles: [String]) {
        for (index, title) in actionTitles.enumerated() {
            let actionButton: UIAlertAction!
            switch index {
            case 0:
                actionButton = UIAlertAction(title: title, style: .default) { (action) in
                    var buttonAction: IGAlertButtonAction?
                    switch self.message {
                    case IGConstants.AlertContants.PLEASE_ENTER_CAPTION:
                        buttonAction = .focusCaptionTextField
                    case IGConstants.AlertContants.PLEASE_ENTER_COMMENT:
                        buttonAction = .focusCommentTextField
                    case IGConstants.AlertContants.REMOVE_IMAGE:
                        buttonAction = .removeImage
                    default:
                        buttonAction = nil
                    }
                     
                    self.delegate?.onPositiveActionOneClicked(action: buttonAction)
                }
            case 1 where actionTitles.count == 3:
                actionButton = UIAlertAction(title: title, style: .default) { (action) in
                    self.delegate?.onPostiveActionTwoClicked()
                }
            default:
                actionButton = UIAlertAction(title: title, style: .cancel) { (action) in
                    self.delegate?.onNegativeActionClicked()
                }
            }
            self.addAction(actionButton)
        }
    }
    
    private func getActionButton(with text: String) -> UIAlertAction {
        return UIAlertAction.init(title: text, style: .default, handler: nil)
    }
}
