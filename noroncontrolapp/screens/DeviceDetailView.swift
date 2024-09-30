import SwiftUI

struct DeviceDetailView: View {
    @StateObject private var deviceDetailsVM = DeviceDetailVM()
    @StateObject private var deviceVM = DeviceVM()
    @StateObject private var ioVM = IOVM()
    @StateObject private var phoneOperatiosVM = PhoneOperationsVM()
    
    let username: String
    let password: String
    let serial: String
    
    @State private var selectedTab: BottomBarItem = .details
    
    enum BottomBarItem: String, CaseIterable {
        case details = "Detaylar"
        case settings = "Ayarlar"
        case logs = "Kayıtlı\nCihazlar"
        
        var iconName: String {
            switch self {
            case .details: return "info.circle"
            case .settings: return "gearshape"
            case .logs: return "doc.text"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    if let deviceDetail = deviceDetailsVM.deviceDetail, selectedTab == .details {
                        deviceDetailSection(deviceDetail)
                    } else if selectedTab == .settings {
                        Text("Settings View Placeholder")
                            .padding()
                    } else if selectedTab == .logs {
                        savedClientsTab(deviceDetail: deviceDetailsVM.deviceDetail)
                    } else if deviceDetailsVM.isLoading {
                        ProgressView("Loading device details...")
                            .padding()
                    } else if let errorMessage = deviceDetailsVM.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        Text("No device details available")
                            .padding()
                    }
                }
            }
            bottomBar
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Device Details")
        .onAppear {
            deviceDetailsVM.getDeviceDetails(
                username: username,
                password: password,
                devid: serial
            )
        }
    }
    
    @ViewBuilder
    private func deviceDetailSection(_ deviceDetail: DeviceDetails) -> some View {
        VStack(spacing: 6) {
            DeviceDetailCard(title: "Login", value: deviceDetail.login)
            DeviceDetailCard(title: "Device", value: deviceDetail.device)
            DeviceDetailCard(title: "Client ID", value: deviceDetail.clientID ?? "N/A")
            DeviceDetailCard(title: "Created DateTime", value: deviceDetail.createdDateTime ?? "N/A")
            DeviceDetailCard(title: "Activated DateTime", value: deviceDetail.activatedDateTime ?? "N/A")
            DeviceDetailCard(title: "Active Days", value: deviceDetail.activeDays ?? "N/A")
            DeviceDetailCard(title: "Yearly Price ($)", value: deviceDetail.yearlyPrice ?? "N/A")
            DeviceDetailCard(title: "M2M Serial", value: deviceDetail.m2mSerial ?? "N/A")
            DeviceDetailCard(title: "M2M Number", value: deviceDetail.m2mNumber ?? "N/A")
            DeviceDetailCard(title: "Connected", value: deviceDetail.connected ?? "N/A")
            DeviceDetailCard(title: "Enable", value: deviceDetail.enable ?? "N/A")
            DeviceDetailCard(title: "Device Type", value: deviceDetail.devType ?? "N/A")
            
            //
            Button(action: {
                ioVM.getIO(
                    getIOParams: GetIOParams(
                        username: username,
                        password: password,
                        devid: serial,
                        clientId: deviceDetail.clientID ?? ""
                    )
                )
            }
            ) {
                Text("Get IO Message")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            Button(action: {
                ioVM.setIO(
                    setIOParams: SetIOParams(
                        username: username,
                        password: password,
                        devid: serial,
                        clientId: deviceDetail.clientID ?? "",
                        message: "<|ROLE|01|1|0000000|>"
                    )
                )
            }
            ) {
                Text("Set IO Message")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    private func savedClientsTab(deviceDetail: DeviceDetails?) -> some View {
        VStack(spacing: 8) {
            if let clientIDs = deviceDetail?.otherClientIDs, let phones = deviceDetail?.otherPhones {
                HStack {
                    Text("Telefon eklemek için tıklayın ->")
                    Spacer()
                    NavigationLink(destination: AddPhoneToDeviceView(serial: serial)) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                            .shadow(radius: 4)
                    }
                }
                .padding()

                ForEach(Array(zip(clientIDs.indices, clientIDs)), id: \.0) { index, clientID in
                    HStack {
                        VStack(alignment: .leading,spacing: 4) {
                            if let clientID = clientID {
                                Text("ClientID: \(clientID)")
                            } else {
                                Text("ClientID: N/A")
                            }

                            if phones.indices.contains(index), let phone = phones[index] {
                                Text("Telefon: \(phone)")
                            } else {
                                Text("Telefon: N/A")
                            }
                        }

                        Spacer()

                        Button(action: {
                            phoneOperatiosVM.deletePhoneToDevice(phoneParams: PhoneParams(username: username, password: password, devid: serial, process: "DELETE", phone: phones[index] ?? ""))
                            print("Delete Client ID: \(clientID ?? 0)")
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
            } else {
                Text("No client IDs or phones available")
                    .padding()
            }
            
            if let errorMessage = deviceVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 8)
                    .padding(.horizontal)
            }
        }
    }

    private var bottomBar: some View {
        HStack {
            ForEach(BottomBarItem.allCases, id: \.self) { item in
                Spacer()
                Button(action: {
                    withAnimation {
                        selectedTab = item
                    }
                }) {
                    VStack {
                        Image(systemName: item.iconName)
                            .font(.system(size: 24))
                        Text(item.rawValue)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }
                    .foregroundColor(selectedTab == item ? .blue : .gray)
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .background(Color(UIColor.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 8)
    }
}
