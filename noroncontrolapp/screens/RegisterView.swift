import SwiftUI
import AlertToast

struct RegisterView: View {
    @State private var registerParams = SaveNewClientParams(
        username: "",
        password: "",
        name: "",
        address: "",
        city: "",
        country: "",
        email: "",
        phone: ""
    )
    @State private var showPassword = false
    @State private var showLoginView = false
    @State private var isErrorAlertPresented = false
    @State private var isSuccessAlertPresented = false
    @State private var shouldNavigateToLogin = false
    @ObservedObject private var viewModel = SaveNewClientVM()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    
                    Section(header: Text("Kullanıcı Bilgileri")) {
                        TextField("Kullanıcı Adı", text: $registerParams.username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        HStack {
                            if showPassword {
                                TextField("Şifre", text: $registerParams.password)
                            } else {
                                SecureField("Şifre", text: $registerParams.password)
                            }
                            
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        TextField("Email", text: $registerParams.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    
                    
                    Section(header: Text("Kişisel Bilgiler")) {
                        TextField("İsim", text: $registerParams.name)
                        TextField("Telefon", text: $registerParams.phone)
                            .keyboardType(.phonePad)
                    }
                    
                    Section(header: Text("Adres Bilgileri")) {
                        TextField("Adres", text: $registerParams.address)
                        TextField("Şehir", text: $registerParams.city)
                        TextField("Ülke", text: $registerParams.country)
                    }
                    
                    Button(action: {
                        if validateFields() {
                            viewModel.saveNewClient(registerParams: registerParams)
                        }
                    }) {
                        Text("Kayıt Ol")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                Spacer()
                
                HStack {
                    Text("Mevcut hesabınız var mı?")
                    Button(action: {
                        showLoginView = true
                    }) {
                        Text("Giriş Yap")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationBarTitle("Kayıt Ol", displayMode: .inline)
            .fullScreenCover(isPresented: $showLoginView) {
                LoginView()
            }
            .onChange(of: viewModel.errorMessage) { newValue in
                if newValue != nil {
                    isErrorAlertPresented = true
                }
            }
            .onChange(of: viewModel.successMessage) { newValue in
                if newValue != nil {
                    isSuccessAlertPresented = true
                }
            }
            .toast(isPresenting: $isErrorAlertPresented) {
                AlertToast(type: .error(Color.red), title: "Hata", subTitle: viewModel.errorMessage)
            }
            .toast(isPresenting: $isSuccessAlertPresented) {
                AlertToast(type: .complete(Color.green), title: "Başarılı", subTitle: viewModel.successMessage)
            }
            .onChange(of: isSuccessAlertPresented) { newValue in
                if !newValue {
                    shouldNavigateToLogin = true
                }
            }
            .fullScreenCover(isPresented: $shouldNavigateToLogin) {
                LoginView()
            }
        }
    }
    
    private func validateFields() -> Bool {
        if registerParams.username.isEmpty ||
            registerParams.password.isEmpty ||
            registerParams.email.isEmpty ||
            registerParams.name.isEmpty ||
            registerParams.phone.isEmpty ||
            registerParams.address.isEmpty ||
            registerParams.city.isEmpty ||
            registerParams.country.isEmpty {
            viewModel.errorMessage = "Lütfen tüm alanları doldurun."
            return false
        }
        return true
    }
}
