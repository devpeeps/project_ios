//
//  UrlStrings+CoreDataProperties.swift
//  elysium
//
//  Created by Joshua Eleazar Bosinos on 22/01/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UrlStrings {

    @NSManaged var url: String?
    @NSManaged var refid: String?
    @NSManaged var datecreated: String?
    @NSManaged var datesuccess: String?

}
