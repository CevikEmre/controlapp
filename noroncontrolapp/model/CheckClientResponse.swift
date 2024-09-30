import Foundation

struct CheckClientResponse : Decodable {
    let login: String
    let name: String
    let createdDateTime: String
    let address: String
    let city: String
    let country: String
    let email: String
    let phone: String
    let enable: String
    let credit: String
    }

