//
//  User.swift
//  CodeDataSample
//
//  Created by Amol Tamboli on 08/06/21.
//

import CoreData

public class User: NSManagedObject{
    @NSManaged var id: Int16
    @NSManaged var avatar: String
    @NSManaged var email: String
    @NSManaged var first_name: String
    @NSManaged var last_name: String
}
