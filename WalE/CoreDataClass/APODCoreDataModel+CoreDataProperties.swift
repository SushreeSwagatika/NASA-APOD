//
//  APODCoreDataModel+CoreDataProperties.swift
//  WalE
//
//  Created by Sushree Swagatika on 26/03/23.
//
//

import Foundation
import CoreData


extension APODCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<APODCoreDataModel> {
        return NSFetchRequest<APODCoreDataModel>(entityName: "APODCoreDataModel")
    }

    @NSManaged public var explanation: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

}

extension APODCoreDataModel : Identifiable {

}
