//
//  ThumbnailLocal+CoreDataProperties.swift
//  
//
//  Created by Altran3496 on 27/04/21.
//
//

import Foundation
import CoreData


extension ThumbnailLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ThumbnailLocal> {
        return NSFetchRequest<ThumbnailLocal>(entityName: "ThumbnailLocal")
    }

    @NSManaged public var path: String?
    @NSManaged public var extensionThumbnail: String?

}
