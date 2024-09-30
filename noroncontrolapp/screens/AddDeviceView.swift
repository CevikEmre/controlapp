import SwiftUI

struct AddDeviceView: View {
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var password: String = UserDefaults.standard.string(forKey: "password") ?? ""
    @State private var deviceID: String = ""
    @ObservedObject var deviceVM = DeviceVM()
    @ObservedObject var mainVM = MainVM()
    
    var body: some View {
        VStack(spacing : 8) {
            Text("Yeni cihaz ekle")
                .font(.title)
                .padding(.top, 20)
            
            TextField("Cihaz IDsi giriniz", text: $deviceID)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            
            Button(action: {
                if !deviceID.isEmpty {
                    deviceVM.addDevice(username: username, password: password, devid: deviceID)
                    mainVM.getAllDevicesForClient(username: username, password: password)
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
            .disabled(deviceID.isEmpty)
            
            // Loading indicator
            if deviceVM.isLoading {
                ProgressView()
                    .padding()
            }
            
            // Error message if any
            if let errorMessage = deviceVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }
}

