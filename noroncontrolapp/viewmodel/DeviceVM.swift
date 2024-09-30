import Foundation

class DeviceVM: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var addDeviceResponse: AddDeviceResponse? = nil
    @Published var errorMessage: String? = nil

    func addDevice(username: String, password: String, devid: String) {
        self.isLoading = true
        self.errorMessage = nil

        let addDeviceParams: [String: String] = [
            "username": username,
            "password": password,
            "devid": devid,
            "process": "ADD"
        ]

        APIService.shared.makeRequest(
            endpoint: "adddelclienttodevice.php",
            method: "POST",
            body: addDeviceParams
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
                        let response = try decoder.decode(AddDeviceResponse.self, from: data)

                        // Handle login responses
                        if response.login == "ERROR" {
                            self.errorMessage = "Kullanıcı bulunamadı."
                        } else if response.login != "OK" {
                            self.errorMessage = "Kullanıcı doğrulama hatası."
                        }

                        // Handle device responses
                        if response.device == "ERROR" {
                            self.errorMessage = "Cihaz veritabanında bulunamadı."
                        } else if response.device != "OK" {
                            self.errorMessage = "Cihaz doğrulama hatası."
                        }

                        // Handle client permission and adding responses
                        if response.added == "OK" {
                            if response.clientPermission == "USER" {
                                print("Kullanıcı başarıyla kullanıcı olarak eklendi.")
                            } else if response.clientPermission == "ADMIN" {
                                print("Kullanıcı başarıyla admin olarak eklendi.")
                            }
                        } else if response.added == "NONE" {
                            self.errorMessage = "Kullanıcı eklenemedi veya işlem yapılmadı."
                        } else if response.clientPermission == "NONE" {
                            self.errorMessage = "Bu cihazda bağlı olan ID'de kullanıcı yok."
                        }

                        // Handle existing user responses
                        if response.clientPerExist == "YES" {
                            self.errorMessage = "Bu kullanıcı zaten var."
                        }

                        // Handle deletion responses
                        if response.deleted == "YES" {
                            print("Kullanıcı başarıyla silindi.")
                        } else if response.deleted == "NOTPOSSIBLE" {
                            self.errorMessage = "Admin kullanıcı silinemez."
                        } else if response.deleted == "NONE" {
                            self.errorMessage = "Silme işlemi yapılmadı."
                        }

                    } catch {
                        self.errorMessage = "Yanıt çözümlenemedi: \(error.localizedDescription)"
                        print("Parsing error: \(error)")
                    }
                case .failure(let error):
                    self.errorMessage = "Cihaz ekleme sırasında hata oluştu: \(error.localizedDescription)"
                }
            }
        }
    }

    func deleteDevice(username: String, password: String, devid: String) {
        self.isLoading = true
        self.errorMessage = nil

        let deleteDeviceParams: [String: String] = [
            "username": username,
            "password": password,
            "devid": devid,
            "process": "DELETE"
        ]

        APIService.shared.makeRequest(
            endpoint: "adddelclienttodevice.php",
            method: "POST",
            body: deleteDeviceParams
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
                        let response = try decoder.decode(AddDeviceResponse.self, from: data)

                        // Handle login responses
                        if response.login == "ERROR" {
                            self.errorMessage = "Kullanıcı bulunamadı."
                        } else if response.login != "OK" {
                            self.errorMessage = "Kullanıcı doğrulama hatası."
                        }

                        // Handle device responses
                        if response.device == "ERROR" {
                            self.errorMessage = "Cihaz veritabanında bulunamadı."
                        } else if response.device != "OK" {
                            self.errorMessage = "Cihaz doğrulama hatası."
                        }

                        // Handle deletion responses
                        if response.deleted == "YES" {
                            print("Kullanıcı başarıyla silindi.")
                        } else if response.deleted == "NOTPOSSIBLE" {
                            self.errorMessage = "Admin kullanıcı silinemez."
                        } else if response.deleted == "NONE" {
                            self.errorMessage = "Silme işlemi yapılmadı."
                        }

                    } catch {
                        self.errorMessage = "Yanıt çözümlenemedi: \(error.localizedDescription)"
                        print("Parsing error: \(error)")
                    }
                case .failure(let error):
                    self.errorMessage = "Cihaz silme sırasında hata oluştu: \(error.localizedDescription)"
                }
            }
        }
    }
}
