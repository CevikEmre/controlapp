import Foundation

class LoginVM: ObservableObject {
    
    @Published var isLoginSuccessful: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func login(username: String, password: String) {
        let userInfo = UserDefaults.standard
        self.isLoading = true
        self.errorMessage = nil
        
        let loginData = ["username": username, "password": password]
        
        APIService.shared.makeRequest(
            endpoint: "checkclient.php",
            method: "POST",
            body: loginData
        ) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(CheckClientResponse.self, from: data)
                        
                        print("Server response: \(response)")
                        
                        if response.login == "OK" {
                            self.isLoginSuccessful = true
                            self.errorMessage = nil
                        
                            userInfo.set(response.name, forKey: "name")
                            userInfo.set(username, forKey: "username")
                            userInfo.set(password, forKey: "password")
                            
                            print("Successfully saved to UserDefaults:")
                            print("Username: \(username), Name: \(response.name)")
                            
                        } else if response.login == "ERROR" {
                            self.errorMessage = "Login failed: Invalid credentials"
                            self.isLoginSuccessful = false
                        } else {
                            self.errorMessage = "Unexpected response from server"
                            self.isLoginSuccessful = false
                        }
                    } catch {
                        print("Error parsing response: \(error.localizedDescription)")
                        self.errorMessage = "Login failed: Unable to parse server response"
                        self.isLoginSuccessful = false
                    }
                    
                case .failure(let error):
                    print("Error occurred: \(error.localizedDescription)")
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                    self.isLoginSuccessful = false
                }
            }
        }
    }
}
