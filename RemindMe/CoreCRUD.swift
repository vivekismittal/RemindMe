//
//  CoreCRUD.swift
//  RemindMe
//
//  Created by VM on 21/07/23.
//

import UIKit
import CoreData



enum ReminderEntityAttributes: String{
    case dateOfRemind
    case detail
    case title
    case priority
    case isCompleted
}

class CRUD{
    let enityName = "Reminder"
    
    var managedContext: NSManagedObjectContext?
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func create(reminderData: ReminderModel,completionHandler: ((ReminderModel)->Void)?){
        
        if let managedContext{
            let reminderEntity = NSEntityDescription.entity(forEntityName: self.enityName, in: managedContext)!
            
            let reminder = NSManagedObject(entity: reminderEntity, insertInto: managedContext)
     
            reminderData.id = reminder.objectID
            reminder.setValue(reminderData.title, forKey: ReminderEntityAttributes.title.rawValue)
            reminder.setValue(reminderData.dateForRemind, forKey: ReminderEntityAttributes.dateOfRemind.rawValue)
            reminder.setValue(reminderData.detail, forKey: ReminderEntityAttributes.detail.rawValue)
            reminder.setValue(reminderData.priority.rawValue, forKey: ReminderEntityAttributes.priority.rawValue)
            reminder.setValue(reminderData.isCompleted, forKey: ReminderEntityAttributes.isCompleted.rawValue)
            
            do{
                try managedContext.save()
                completionHandler?(reminderData)
            }
            catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        }
        
    }
    
    func retrieveReminders()->[ReminderModel]{
        if let managedContext{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: enityName)
            //            fetchRequest.predicate = NSPredicate(format: "\(ReminderEntityAttributes.dateOfRemind.rawValue) = %@", date as NSDate)
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                var reminders: [ReminderModel] = []
                for data in result as! [NSManagedObject]
                {
                    let id = data.objectID
                    let title = data.value(forKey: ReminderEntityAttributes.title.rawValue) as! String
                    let dateOfRemind = data.value(forKey: ReminderEntityAttributes.dateOfRemind.rawValue) as! Date
                    let detail = data.value(forKey: ReminderEntityAttributes.detail.rawValue) as! String
                    let isCompleted = data.value(forKey: ReminderEntityAttributes.isCompleted.rawValue) as! Bool
                    guard let priorityCase = ReminderPriority(rawValue: data.value(forKey: ReminderEntityAttributes.priority.rawValue) as! String) else {
                        return []
                        
                    }
                   
                    reminders.append(
                        ReminderModel(
                            title: title,
                            dateForRemind: dateOfRemind,
                            detail:detail,
                            priorityCase:priorityCase,
                            isCompleted:isCompleted,
                            id: id
                        )
                    )
                }
                return reminders
                
            } catch {
                print("Failed")
            }
        }
        return []
    }
    
    func update(objectId: NSManagedObjectID,updatedReminder:ReminderModel,completionHandler: (()->Void)?){
        if let managedContext{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: enityName)
            let reminder = try? managedContext.existingObject(with: objectId)
            if let reminder{
                reminder.setValue(updatedReminder.title, forKey: ReminderEntityAttributes.title.rawValue)
                reminder.setValue(updatedReminder.dateForRemind, forKey: ReminderEntityAttributes.dateOfRemind.rawValue)
                reminder.setValue(updatedReminder.detail, forKey: ReminderEntityAttributes.detail.rawValue)
                reminder.setValue(updatedReminder.priority.rawValue, forKey: ReminderEntityAttributes.priority.rawValue)
                reminder.setValue(updatedReminder.isCompleted, forKey: ReminderEntityAttributes.isCompleted.rawValue)
                do{
                    try managedContext.save()
                    completionHandler?()
                }
                catch let error as NSError{
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            
        }
    }

}
