//
//  Person+CoreDataProperties.swift
//  Learning Core Data
//
//  Created by Francisco De Freitas on 30/12/20.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16

}

extension Person : Identifiable {

}
