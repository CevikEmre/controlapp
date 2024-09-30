import SwiftUI
import UserNotifications

@main
struct NoronControlApp: App {
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        if let error = error {
                            print("Bildirim izni hatası: \(error.localizedDescription)")
                        } else if granted {
                            print("Bildirim izni verildi.")
                        } else {
                            print("Bildirim izni reddedildi.")
                        }
                    }
                case .denied:
                    print("Bildirim izni reddedildi.")
                case .authorized, .provisional:
                    print("Bildirim izni zaten verilmiş.")
                default:
                    break
                }
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .onAppear {
                    requestNotificationPermission()
                }
        }
    }
}
