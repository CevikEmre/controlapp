import SwiftUI

struct DeviceCard: View {
    let device: Device
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Cihaz ID: \(device.deviceID)")
                .font(.headline)
                .padding(.bottom, 2)
            Text("Seri Numarası: \(device.deviceSerial)")
                .font(.subheadline)
                .padding(.bottom, 2)
            Text("Yetki: \(device.devicePermission)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
    }
}
