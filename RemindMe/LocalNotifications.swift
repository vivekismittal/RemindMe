//
//  LocalNotifications.swift
//  RemindMe
//
//  Created by VM on 02/08/23.
//

import Foundation
import UserNotifications

class LocalNotifications{
    
    private static func checkForPermissions( completionHandler: @escaping (()->Void) ){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { setting in
            switch setting.authorizationStatus{
            case .authorized:
                completionHandler()
                break
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert,.badge,.sound]){ isAllow, error in
                    if isAllow{
                        completionHandler()
                    }
                }
                break
            case .denied:
                break
            default:
                break
            }
        }
    }
    
    static func dispatchNotification(reminder: ReminderModel){
        checkForPermissions(){
            let notificationCenter = UNUserNotificationCenter.current()
            if let identifier = reminder.id?.uriRepresentation().absoluteString{
                notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
                let content = UNMutableNotificationContent()
                content.title = reminder.title
                content.sound = .defaultCritical
                content.body = reminder.detail
                let calendar = Calendar.current
                let dateComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute] , from: reminder.dateForRemind)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                notificationCenter.add(request)
                
            }
        }
    }
    
}

//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(
//        _ center: UNUserNotificationCenter,
//        willPresent notification: UNNotification,
//        withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
//      ) {
//          completionHandler([.badge, .sound,.banner])
//      }
//    
//    
//    
//     func configureUserNotifications() {
//      UNUserNotificationCenter.current().delegate = self
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        completionHandler()
//    }
//}
