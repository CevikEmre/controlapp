import SwiftUI

struct DeviceDetailCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.body)
                .bold()
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .shadow(radius: 2)
        }
    }
}


