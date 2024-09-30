import Foundation

struct PhoneOperationsResponse: Codable {
    let login: String
    let device: String
    let permission: String
    let clientPerExist: String
    let added: String
    let deleted: String

    enum CodingKeys: String, CodingKey {
        case login
        case device
        case permission
        case clientPerExist = "clientperexist"
        case added
        case deleted
    }
}

