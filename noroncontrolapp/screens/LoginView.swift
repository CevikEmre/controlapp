import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel = LoginVM()
    @State private var username: String = "emre"
    @State private var password: String = "123123"
    @State private var showRegisterView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Giriş Yap")
                    .font(.title)
                    .padding(.bottom, 40)
                
                if let errorMessage = loginViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 10)
                }
                
                TextField("Kullanıcı Adı", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
              
                SecureField("Şifre", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 10)
            
                if loginViewModel.isLoading {
                    ProgressView()
                        .padding(.bottom, 20)
                }
                
                Button(action: {
                    loginViewModel.login(username: username, password: password)
                }) {
                    Text("Giriş Yap")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, alignment: .center)
                       
                }
                .padding(.top, 20)
                
                Spacer()
                
                HStack {
                    Text("Henüz hesabınız yok mu?")
                    Button(action: {
                        showRegisterView = true
                    }) {
                        Text("Kayıt Ol")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 20)
            }
            .padding()
            .fullScreenCover(isPresented: $showRegisterView) {
                RegisterView()
            }
            .fullScreenCover(isPresented: $loginViewModel.isLoginSuccessful) {
                MainView()
            }
        }
    }
}
