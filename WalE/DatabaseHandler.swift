//
//  DatabaseHandler.swift
//  WalE
//
//  Created by Sushree Swagatika on 25/03/23.
//

import Foundation
import CoreData

protocol DatabaseDelegate: AnyObject {
    func saveAstronomyPicture(url: String, title: String, description: String)
}

class DatabaseHandler: DatabaseDelegate {
    let coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack
    
    func saveAstronomyPicture(url: String, title: String, description: String) {
        let entity = NSEntityDescription.entity(forEntityName: "APODCoreDataModel", in: coreDataStack.managedContext)
        let newAPOD = NSManagedObject(entity: entity!, insertInto: coreDataStack.managedContext)
        
        newAPOD.setValue(url, forKey: "url")
        newAPOD.setValue(title, forKey: "title")
        newAPOD.setValue(description, forKey: "explanation")
        
        DispatchQueue.main.async {
            self.coreDataStack.saveContext()
        }
    }
}
