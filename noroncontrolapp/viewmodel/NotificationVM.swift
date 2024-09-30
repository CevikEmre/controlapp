import Foundation

class NotificationVM: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var notificationResponse: GetMessagesResponse? = nil
    @Published var errorMessage: String? = nil
    
    
    

    func getMessagesForAllDevices(username: String, password: String) {
        self.isLoading = true
        self.errorMessage = nil

        let getMessagesForAllDevices: [String: String] = [
            "username": username,
            "password": password,
        ]

        APIService.shared.makeRequest(
            endpoint: "getmessages.php",
            method: "POST",
            body: getMessagesForAllDevices
        ) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("JSON Response: \(jsonString)")
                    }
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(GetMessagesResponse.self, from: data)
                        self.notificationResponse = response
                    } catch {
                        self.errorMessage = "Failed to parse response: \(error.localizedDescription)"
                        print("Parsing error: \(error)")
                    }
                case .failure(let error):
                    self.errorMessage = "Error fetching devices: \(error.localizedDescription)"
                }
            }
        }
    }
}

