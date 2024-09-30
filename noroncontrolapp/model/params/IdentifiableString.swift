import Foundation

struct IdentifiableString: Identifiable {
    let id = UUID()  // Her mesajın benzersiz bir kimliği
    let value: String
}

