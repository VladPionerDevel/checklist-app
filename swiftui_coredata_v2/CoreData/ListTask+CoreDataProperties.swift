//
//  ListTask+CoreDataProperties.swift
//  swiftui_coredata_v2
//
//  Created by pioner on 22.03.2021.
//
//

import Foundation
import CoreData


extension ListTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListTask> {
        return NSFetchRequest<ListTask>(entityName: "ListTask")
    }

    @NSManaged public var selected: Bool
    @NSManaged public var title: String?
    @NSManaged public var task: NSSet?
    
    public var wrapedTitle: String {
        title ?? "Uncnown list"
    }
    
    public var taskArray: [Task] {
        let set = task as? Set<Task> ?? []
        
        return set.sorted {
            $0.wrapedTitle < $1.wrapedTitle
        }
    }

}

// MARK: Generated accessors for task
extension ListTask {

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: Task)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTask(_ value: Task)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTask(_ values: NSSet)

}

extension ListTask : Identifiable {

}
