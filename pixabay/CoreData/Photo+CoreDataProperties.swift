//
//  Photo+CoreDataProperties.swift
//  pixabay
//
//  Created by Dmitriy Zadoroghnyy on 04/04/2019.
//  Copyright © 2019 Dmitriy Zadoroghnyy. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var id: Int64
    @NSManaged public var tags: String?
    @NSManaged public var photo: NSData?
    @NSManaged public var largeImageURL: String?
    @NSManaged public var createdAt: NSDate?

}
