//
//  GalleryDataSource.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation
import CoreData

class GalleryDataSource {
    
    var context: NSManagedObjectContext {
        CoreDataManager.sharedInstance.persistentContainer.viewContext
    }
    
    /// Saves the image data
    /// - Parameter
    /// - data: jepeg image data
    /// - caption:  caption text
    /// - comment:  comment text
    /// - date: current date and time
    func saveImage(data: Data?, caption: String?, comment: String?, date: Date?) {
        
        if let imageEntity = NSEntityDescription.insertNewObject(forEntityName: Image.className, into: context) as? Image {
            imageEntity.imageData = data
            imageEntity.caption = caption
            imageEntity.comment = comment
            imageEntity.modifiedDate = date
        }
        saveContext()
    }
    
    /// Get all the images from the DB
    /// - Returns: list of image model
    func getAllImages() -> [Image] {
        var images = [Image]()
        let imageFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Image.className)
        let sortDescriptors = NSSortDescriptor(key: #keyPath(Image.modifiedDate), ascending: false)
        imageFetchRequest.sortDescriptors = [sortDescriptors]
        do {
            let result = try context.fetch(imageFetchRequest)
            for image in result {
                images.append(image as! Image)
            }
        } catch {
            debugPrint("Error fetching images")
        }
        return images
    }
    
    func saveContext() {
         CoreDataManager.sharedInstance.saveContext()
    }
}
