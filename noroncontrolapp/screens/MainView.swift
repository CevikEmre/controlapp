import SwiftUI

struct MainView: View {
    @State private var name: String = UserDefaults.standard.string(forKey: "name") ?? "User"
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var password: String = UserDefaults.standard.string(forKey: "password") ?? ""
    @StateObject private var mainViewModel = MainVM()
    @StateObject private var navigationManager = NavigationManager()
    
    
    @State private var isMenuOpen = false
    
    enum MenuItem: String, CaseIterable {
        case home = "Home"
        case settings = "Settings"
        
        var iconName: String {
            switch self {
            case .home: return "house.fill"
            case .settings: return "gearshape.fill"
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            NavigationView {
                VStack {
                    Spacer()
                    contentView
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if navigationManager.currentView == .home {
                            Button(action: {
                                withAnimation {
                                    isMenuOpen.toggle()
                                }
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .font(.headline)
                            }
                        } else {
                            Button(action: {
                                withAnimation {
                                    navigationManager.pop()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }
                            }
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text(navigationManager.currentView.rawValue)
                            .font(.headline)
                    }
                }
            }
            .onAppear {
                name = UserDefaults.standard.string(forKey: "name") ?? "User"
                mainViewModel.getAllDevicesForClient(username: username, password: password)
            }
            .onChange(of: navigationManager.currentView) { newView in
                if newView == .home {
                    mainViewModel.getAllDevicesForClient(username: username, password: password)
                }
            }
            
            if isMenuOpen {
                Color.gray.opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isMenuOpen = false
                        }
                    }
            }
            
            if isMenuOpen {
                menu
                    .transition(.move(edge: .leading))
            }
            
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch navigationManager.currentView {
        case .home:
            deviceList
        case .settings:
            settingsView
            
        }
    }
    
    var deviceList: some View {
        ScrollView {
            if mainViewModel.devices.isEmpty {
                VStack {
                    Text("Kullanılabilir bir cihaz bulunamadı")
                        .padding()
                    NavigationLink(destination: AddDeviceView()) {
                        Text("Cihaz Ekle")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
            } else {
                VStack {
                    HStack {
                        Image(systemName: "person.fill")
                        Text("Hoşgeldin, \(name) !").font(.headline)
                        Spacer()
                        NavigationLink(destination: AddDeviceView()) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                                .shadow(radius: 4)
                        }
                    }.padding()
                }
                Button("Bildirim") {
                    NotificationService.shared.sendTestNotification()
                }
                ForEach(mainViewModel.devices) { device in
                    NavigationLink(destination: DeviceDetailView(
                        username: username,
                        password: password,
                        serial: device.deviceSerial
                    )) {
                        DeviceCard(device: device)
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    var settingsView: some View {
        VStack {
            Text("Settings Page")
                .font(.title)
                .padding()
            
            Spacer()
            
            Button(action: {
                UserDefaults.standard.removeObject(forKey: "name")
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.removeObject(forKey: "password")
                print("Logged out. Redirect to login screen.")
            }) {
                Text("Log Out")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(Color.white)  // Fix for Color.white
                    .cornerRadius(8)
            }
        }
    }
    
    var menu: some View {
        MenuView(isMenuOpen: $isMenuOpen, navigationManager: navigationManager)
            .frame(width: 200)
            .background(Color.gray.opacity(0.9))
            .foregroundColor(.white) // Fix for Color.white
            .offset(x: isMenuOpen ? 0 : -200)
    }
}

struct MenuView: View {
    @Binding var isMenuOpen: Bool
    var navigationManager: NavigationManager
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(MainView.MenuItem.allCases, id: \.self) { item in
                Button(action: {
                    withAnimation {
                        navigationManager.push(item)
                        isMenuOpen = false
                    }
                }) {
                    HStack {
                        Image(systemName: item.iconName)
                            .imageScale(.large)
                        Spacer()
                        Text(item.rawValue)
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.vertical)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.9))
    }
}
