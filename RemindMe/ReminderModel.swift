//
//  ReminderModel.swift
//  RemindMe
//
//  Created by VM on 21/07/23.
//

import Foundation
import CoreData

enum ReminderPriority: String,CaseIterable{
    case LOW
    case NORMAL
    case HIGH
}

class ReminderModel{
    var title: String = ""
    var detail: String = ""
    var dateForRemind: Date = Date()
    var priority: ReminderPriority = .NORMAL
    var isCompleted: Bool
    var id: NSManagedObjectID?
    
    init(title: String,dateForRemind: Date, detail: String = "", priorityCase: ReminderPriority = .NORMAL ,isCompleted: Bool = false, id:NSManagedObjectID? = nil) {
        self.title = title
        self.detail = detail
        self.dateForRemind = dateForRemind
        self.priority = priorityCase
        self.isCompleted = isCompleted
        self.id = id
    }
}
