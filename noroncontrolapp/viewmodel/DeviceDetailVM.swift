import Foundation

class DeviceDetailVM: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var deviceDetail: DeviceDetails? = nil
    @Published var errorMessage: String? = nil

    func getDeviceDetails(username: String, password: String, devid: String) {
        self.isLoading = true
        self.errorMessage = nil

        let deviceDetailParams: [String: String] = [
            "username": username,
            "password": password,
            "devid": devid
        ]

        APIService.shared.makeRequest(
            endpoint: "checkdevid.php",
            method: "POST",
            body: deviceDetailParams
        ) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    // Gelen JSON verisini kontrol edin
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("JSON Response: \(jsonString)")
                    }
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(DeviceDetails.self, from: data)
                        self.deviceDetail = response
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

