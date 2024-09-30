import Foundation

import Foundation

struct DeviceResponse: Codable {
    let login: String
    let deviceIDs: [String]
    let deviceSerials: [String]
    let devicePermissions: [String]
    let deviceStatus: [String]


    enum CodingKeys: String, CodingKey {
        case login
        case deviceIDs = "deviceids"
        case deviceSerials = "deviceserials"
        case devicePermissions = "devicepermissions"
        case deviceStatus = "devicestatus"
    }

    func toDevices() -> [Device] {
        var devices: [Device] = []
        for i in 0..<min(deviceIDs.count, deviceSerials.count, devicePermissions.count,deviceStatus.count) {
            devices.append(Device(deviceID: deviceIDs[i], deviceSerial: deviceSerials[i], devicePermission: devicePermissions[i], deviceStatus: deviceStatus[i]))
        }
        return devices
    }
}

