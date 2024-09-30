struct DeviceDetails: Codable {
    let login: String
    let device: String
    let clientID: String?
    let createdDateTime: String?
    let activatedDateTime: String?
    let otherClientIDs: [Int?]?
    let otherPhones: [String?]?
    let activeDays: String?
    let yearlyPrice: String?
    let m2mSerial: String?
    let m2mNumber: String?
    let connected: String?
    let enable: String?
    let devType: String?

    enum CodingKeys: String, CodingKey {
        case login
        case device
        case clientID = "clientid"
        case createdDateTime = "createddatetime"
        case activatedDateTime = "activateddatetime"
        case otherClientIDs = "otherclientids"
        case otherPhones = "otherphones"
        case activeDays = "activedays"
        case yearlyPrice = "yearlyprice"
        case m2mSerial = "m2mserial"
        case m2mNumber = "m2mnumber"
        case connected
        case enable
        case devType = "devtype"
    }
}
