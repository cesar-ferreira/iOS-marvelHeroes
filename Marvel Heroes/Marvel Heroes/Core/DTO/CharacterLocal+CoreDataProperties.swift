//
//  CharacterLocal+CoreDataProperties.swift
//  
//
//  Created by César Ferreira on 27/04/21.
//
//

import Foundation
import CoreData


extension CharacterLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterLocal> {
        return NSFetchRequest<CharacterLocal>(entityName: "CharacterLocal")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var descriptionCharacter: String?
    @NSManaged public var thumbnail: ThumbnailLocal?

}
