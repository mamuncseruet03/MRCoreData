//
//  Task.swift
//  MRCoreData
//
//  Created by Mamun Ar Rashid on 7/23/17.
//  Copyright © 2017 Fantasy Apps. All rights reserved.
//
import CoreData

open class Task: NSManagedObject {
    @NSManaged open var taskName: String
    @NSManaged open var taskDescription: String
    @NSManaged open var created: Date
    
    public convenience required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//extension Task {
////    @nonobjc class func fetchRequest() -> NSFetchRequest<Task> {
////        return NSFetchRequest<Task>(entityName: "Task");
////    }
//    @NSManaged var timeStamp: NSDate?
//}
