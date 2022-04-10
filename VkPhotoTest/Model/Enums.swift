enum Task {
    case register
    case login
}

enum DefaultsData: String {
    case users = "UserData"
    case lastLogin = "LastLogin"
    case avatar = "avatar"
}

enum AlertsReasons {
    case loginAndPassDoesnotMatch
    case wrongUser
    case userAlreadyExist
    case defaultsFall
    case noLogin
    case noPassword
    case passwordDoesNotMatch
    case imageLoadFalled
    case noImages
    case noPermission
}
