import Foundation
import Combine

class SaveNewClientVM: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var saveNewClientResponse: SaveNewClient? = nil
    @Published var errorMessage: String? = nil
    @Published var successMessage: String? = nil
    
    func saveNewClient(registerParams: SaveNewClientParams) {
        self.isLoading = true
        self.errorMessage = nil
        self.successMessage = nil
        
        let saveClientBody : [String : String] = [
            "username" : registerParams.username,
            "password" :registerParams.password,
            "name" : registerParams.name,
            "address" : registerParams.address,
            "city" : registerParams.city,
            "country" : registerParams.country,
            "email" : registerParams.email,
            "phone" : registerParams.phone
        ]
        
        APIService.shared.makeRequest(
            endpoint: "savenewclient.php",
            method: "POST",
            body: saveClientBody
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
                        let response = try decoder.decode(SaveNewClient.self, from: data)
                        self.saveNewClientResponse = response
                        self.handleServerResponse(response: response)
                    } catch {
                        self.errorMessage = "Failed to parse response: \(error.localizedDescription)"
                    }
                case .failure(let error):
                    self.errorMessage = "Error fetching devices: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func handleServerResponse(response: SaveNewClient) {
        if response.username == "OK" && response.text == "OK" && response.phone == "OK" && response.confirmed == "OK" {
            self.successMessage = "Kayıt Başarılı !"
        } else {
            var errorMessages = [String]()
            
            if response.username == "ERROR" && response.text == "NONE" {
                errorMessages.append("Kullanıcı adı zaten mevcut.")
            }
            if response.text == "ERROR" {
                errorMessages.append("Geçersiz karakterler.\n Lütfen alanları kontrol ediniz.")
            }
            if response.phone == "ERROR" {
                errorMessages.append("Bu telefon numarası zaten mevcut.")
            }
            if response.confirmed == "ERROR" {
                errorMessages.append("Kayıt başarısız.\n Lütfen alanları kontrol ediniz.")
            }
            
            self.errorMessage = errorMessages.joined(separator: "\n")
        }
    }
}
