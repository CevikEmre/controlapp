import SwiftUI

struct AddPhoneToDeviceView: View {
    let serial: String
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var password: String = UserDefaults.standard.string(forKey: "password") ?? ""
    @State private var phone: String = ""
    @ObservedObject var phoneOperationsVM = PhoneOperationsVM()
    
    @State private var showingErrorAlert = false
    @State private var showingSuccessAlert = false
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Yeni telefon numarası ekle")
                .font(.title)
                .padding(.top, 20)
            
            TextField("Telefon Numarası giriniz", text: $phone)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            
            Button(action: {
                if !phone.isEmpty {
                    phoneOperationsVM.addPhoneToDevice(
                        phoneParams: PhoneParams(
                            username: username,
                            password: password,
                            devid: serial,
                            process: "ADD",
                            phone: phone
                        )
                    )
                }
            }) {
                Text("Cihaz Ekle")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .disabled(phone.isEmpty)
            
            if phoneOperationsVM.isLoading {
                ProgressView()
                    .padding()
            }

            Spacer()
        }
        .padding()
        // Show success alert
        .alert(isPresented: $showingSuccessAlert) {
            Alert(
                title: Text("Başarılı"),
                message: Text(phoneOperationsVM.successMessage ?? "Başarıyla tamamlandı."),
                dismissButton: .default(Text("Tamam"))
            )
        }
        // Show error alert
        .alert(isPresented: $showingErrorAlert) {
            Alert(
                title: Text("Hata"),
                message: Text(phoneOperationsVM.errorMessage ?? "Bir hata oluştu."),
                dismissButton: .default(Text("Tamam"))
            )
        }
        .onChange(of: phoneOperationsVM.errorMessage) { newValue in
            if newValue != nil {
                showingErrorAlert = true
            }
        }
        .onChange(of: phoneOperationsVM.successMessage) { newValue in
            if newValue != nil {
                showingSuccessAlert = true
            }
        }
    }
}
