import Foundation

struct Device : Encodable,Identifiable {
    var id : UUID = UUID()
    var deviceID: String
    var deviceSerial: String
    var devicePermission: String
    var deviceStatus: String
}
