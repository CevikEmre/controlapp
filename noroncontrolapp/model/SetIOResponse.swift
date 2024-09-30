
import Foundation

struct SetIOResponse: Codable {
    let login: String
    let device: String
    let confirmed: String

    enum CodingKeys: String, CodingKey {
        case login
        case device
        case confirmed = "confirmed"
    }
}
