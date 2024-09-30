import Foundation

class PhoneOperationsVM: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var addPhoneOperationResponse: PhoneOperationsResponse? = nil
    @Published var deletePhoneOperationResponse: PhoneOperationsResponse? = nil
    @Published var errorMessage: String? = nil
    @Published var successMessage: String? = nil

    func addPhoneToDevice(phoneParams: PhoneParams) {
        self.isLoading = true
        self.errorMessage = nil

        let addPhoneParams: [String: String] = [
            "username": phoneParams.username,
            "password": phoneParams.password,
            "devid": phoneParams.devid,
            "process": "ADD",
            "phone": phoneParams.phone
        ]

        APIService.shared.makeRequest(
            endpoint: "adddelphonetodevice.php",
            method: "POST",
            body: addPhoneParams
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
                        let response = try decoder.decode(PhoneOperationsResponse.self, from: data)
                        self.addPhoneOperationResponse = response
                        self.handleAddResponse(response)
                    } catch {
                        self.errorMessage = "Yanıt işlenemedi: \(error.localizedDescription)"
                        print("Parsing error: \(error)")
                    }
                case .failure(let error):
                    self.errorMessage = "Cihazlar alınırken hata oluştu: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func deletePhoneToDevice(phoneParams: PhoneParams) {
        self.isLoading = true
        self.errorMessage = nil

        let deletePhoneToDeviceParams: [String: String] = [
            "username": phoneParams.username,
            "password": phoneParams.password,
            "devid": phoneParams.devid,
            "process": "DELETE",
            "phone": phoneParams.phone
        ]

        APIService.shared.makeRequest(
            endpoint: "adddelphonetodevice.php",
            method: "POST",
            body: deletePhoneToDeviceParams
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
                        let response = try decoder.decode(PhoneOperationsResponse.self, from: data)
                        self.deletePhoneOperationResponse = response
                        self.handleDeleteResponse(response)
                    } catch {
                        self.errorMessage = "Yanıt işlenemedi: \(error.localizedDescription)"
                        print("Parsing error: \(error)")
                    }
                case .failure(let error):
                    self.errorMessage = "Cihazlar alınırken hata oluştu: \(error.localizedDescription)"
                }
            }
        }
    }

    private func handleAddResponse(_ response: PhoneOperationsResponse) {
        if response.login == "ERROR" {
            self.errorMessage = "Kullanıcı doğrulanamadı."
        } else if response.device == "ERROR" {
            self.errorMessage = "Cihaz kayıtlı değil."
        } else if response.permission == "ERROR" {
            self.errorMessage = "Admin yetkiniz yok."
        } else if response.clientPerExist == "YES" {
            self.errorMessage = "Bu kullanıcı zaten USER yetkisine sahip."
        } else if response.added == "NONE" {
            self.errorMessage = "Ekleme işlemi yapılamadı."
        } else if response.added == "OK" {
            self.successMessage = "Kullanıcı başarıyla eklendi."
        }
    }

    // Silme yanıtını işleme
    private func handleDeleteResponse(_ response: PhoneOperationsResponse) {
        if response.login == "ERROR" {
            self.errorMessage = "Kullanıcı doğrulanamadı."
        } else if response.device == "ERROR" {
            self.errorMessage = "Cihaz kayıtlı değil."
        } else if response.permission == "ERROR" {
            self.errorMessage = "Admin yetkiniz yok."
        } else if response.deleted == "NONE" {
            self.errorMessage = "Silme işlemi yapılamadı."
        } else if response.deleted == "OK" {
            self.successMessage = "Kullanıcı başarıyla silindi."
        }
    }
}
