import Foundation

struct AddDeviceResponse: Codable {
    let login: String
    let device: String
    let clientPermission: String
    let added: String
    let clientPerExist: String
    let deleted: String

    enum CodingKeys: String, CodingKey {
        case login
        case device
        case clientPermission = "clientpermission"
        case added
        case clientPerExist = "clientperexist"
        case deleted
    }
}
