//
//  Task+CoreDataProperties.swift
//  swiftui_coredata_v2
//
//  Created by pioner on 22.03.2021.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var isCheck: Bool
    @NSManaged public var number: Int64
    @NSManaged public var title: String?
    @NSManaged public var listTask: ListTask?
    
    public var wrapedTitle: String {
        title ?? "Uncnown task"
    }

}

extension Task : Identifiable {

}
