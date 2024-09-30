struct GetMessagesResponse: Codable {
    let login: String
    let deviceserials: [String]
    let messages: [String]
    let ids: [String]
    let msgids: [String]
    let notificationtypes: [String]
    let device: String
}
