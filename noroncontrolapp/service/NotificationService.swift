import SwiftUI
import UserNotifications
import BackgroundTasks

class NotificationService {
    static let shared = NotificationService()
    @StateObject var notificationVM = NotificationVM()

    private var username: String {
        UserDefaults.standard.string(forKey: "username") ?? ""
    }
    
    private var password: String {
        UserDefaults.standard.string(forKey: "password") ?? ""
    }
    
    func startBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.noronsoft.noroncontrolapp.backgroundFetch", using: nil) { task in
            self.handleBackgroundTask(task: task as! BGProcessingTask)
        }
    }

    private func handleBackgroundTask(task: BGProcessingTask) {
        scheduleNextBackgroundTask()
        notificationVM.getMessagesForAllDevices(username: username, password: password)

        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        if let response = notificationVM.notificationResponse {
            if response.messages.count == response.deviceserials.count {
                for (index, message) in response.messages.enumerated() {
                    let serial = response.deviceserials[index]
                    sendNotification(message: message, deviceSerial: serial)
                }
            }
        }
    }

    func scheduleNextBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: "com.noronsoft.noroncontrolapp.backgroundFetch")
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background task: \(error)")
        }
    }

    func sendNotification(message: String, deviceSerial: String) {
        let content = UNMutableNotificationContent()
        content.title = "Uyarı | \(deviceSerial)"
        content.body = message
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error)")
            }
        }
    }
    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Uyarısı"
        content.body = "Bu bir test bildirimidir."
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim gönderme hatası: \(error.localizedDescription)")
            } else {
                print("Bildirim başarıyla gönderildi.")
            }
        }
    }

}
