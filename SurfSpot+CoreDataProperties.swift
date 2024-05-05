//
//  SurfSpot+CoreDataProperties.swift
//  SurfingApp
//
//  Created by Piotr Eliasz on 21/04/2024.
//
//

import Foundation
import CoreData


extension SurfSpot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SurfSpot> {
        return NSFetchRequest<SurfSpot>(entityName: "SurfSpot")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var spotDescription: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var country: String?
    @NSManaged public var continent: String?

}

extension SurfSpot : Identifiable {

}
