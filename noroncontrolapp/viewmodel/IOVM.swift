import Foundation

class IOVM: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var setIOResponse: SetIOResponse? = nil
    @Published var getIOResponse: GetIOResponse? = nil
    @Published var errorMessage: String? = nil

    func setIO(setIOParams: SetIOParams) {
        self.isLoading = true
        self.errorMessage = nil

        let setIOParams: [String: String] = [
            "username": setIOParams.username,
            "password": setIOParams.password,
            "devid": setIOParams.devid,
            "clientid": setIOParams.clientId,
            "message" : setIOParams.message
        ]

        APIService.shared.makeRequest(
            endpoint: "setio.php",
            method: "POST",
            body: setIOParams
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
                        let response = try decoder.decode(SetIOResponse.self, from: data)
                        self.setIOResponse = response
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
    func getIO(getIOParams: GetIOParams) {
        self.isLoading = true
        self.errorMessage = nil

        let getIOParams: [String: String] = [
            "username": getIOParams.username,
            "password": getIOParams.password,
            "devid": getIOParams.devid,
            "clientid": getIOParams.clientId,
        ]

        APIService.shared.makeRequest(
            endpoint: "getio.php",
            method: "POST",
            body: getIOParams
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
                        let response = try decoder.decode(GetIOResponse.self, from: data)
                        self.getIOResponse = response
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

