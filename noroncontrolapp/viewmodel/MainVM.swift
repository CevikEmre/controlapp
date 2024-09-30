import Foundation

class MainVM: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var devices: [Device] = []
    @Published var errorMessage: String? = nil

    func getAllDevicesForClient(username: String, password: String) {
        self.isLoading = true
        self.errorMessage = nil

        let loginData = ["username": username, "password": password]

        APIService.shared.makeRequest(
            endpoint: "getalldevicesforclient.php",
            method: "POST",
            body: loginData
        ) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(DeviceResponse.self, from: data)
                        self.devices = response.toDevices()
                        print(response)
                    } catch {
                        self.errorMessage = "Failed to parse response"
                    }
                case .failure(let error):
                    self.errorMessage = "Error fetching devices: \(error.localizedDescription)"
                }
            }
        }
    }
}
