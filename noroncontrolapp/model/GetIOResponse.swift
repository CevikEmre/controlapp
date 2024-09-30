import Foundation

struct GetIOResponse: Codable {
    let login: String
    let device: String
    let message: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case login = "login"
        case device = "device"
        case message = "message"
        case id = "id"
    }
}
