import Foundation

struct Model{
    private let defaults = UserDefaults.standard
    private let keyUsers = DefaultsData.users.rawValue
    private let keyLastLogin = DefaultsData.lastLogin.rawValue
    private let userAvatar = DefaultsData.avatar.rawValue
    
    weak var alertDelegate: AlertErrorDelegate?
    
    func saveLastLogin(_ login:String){
        defaults.set(login, forKey: keyLastLogin)
    }
    
    func getLastLogin() -> String?{
        guard let login = defaults.string(forKey: keyLastLogin) else {
            alertDelegate?.presentAlert(reason: .defaultsFall)
            return nil
        }
        return login
    }
    
    func unLogin(){
        defaults.set("", forKey: keyLastLogin)
    }
    
    func setAvatar(string: String){
        guard let currentUser = getLastLogin() else {
            alertDelegate?.presentAlert(reason: .defaultsFall)
            return
        }
        var dictOfAvatars = defaults.dictionary(forKey: userAvatar) as! [String:String]
        dictOfAvatars[currentUser] = string
        defaults.set(dictOfAvatars, forKey: userAvatar)
    }
    
    func getAvatar() -> String? {
        guard let currentUser = getLastLogin() else {
            alertDelegate?.presentAlert(reason: .defaultsFall)
            return nil
        }
        guard let dictOfAvatars = defaults.dictionary(forKey: userAvatar) as? [String:String] else {return nil}
        return dictOfAvatars[currentUser]
    }
    
    func initialize() -> Bool{
        if defaults.dictionary(forKey: userAvatar) == nil {
            let dictOfAvatars:[String:String] = ["admin":""]
            defaults.set(dictOfAvatars, forKey: userAvatar)
        }
        guard defaults.dictionary(forKey: keyUsers) != nil else {
            let dict:[String:String] = ["admin":"1234"]
            defaults.set(dict, forKey: keyUsers)
            return false
        }
        if defaults.string(forKey: keyLastLogin) != nil {
            guard let last = defaults.string(forKey: keyLastLogin) else {return false}
            guard let dictOfUserts = defaults.dictionary(forKey: keyUsers) else {return false}
            guard let lastPass = dictOfUserts[last] as? String else {return false}
            if login(login: last, password: lastPass) {
                return true
            }
        }
        return false
    }
    
    func login(login: String, password: String) -> Bool{
        guard let userList = defaults.dictionary(forKey: keyUsers) else {
            alertDelegate?.presentAlert(reason: .defaultsFall)
            return false
        }
        guard let currentUser = userList[login] else {
            alertDelegate?.presentAlert(reason: .wrongUser)
            return false
        }
        if currentUser as! String == password {
            return true
        }
        alertDelegate?.presentAlert(reason: .loginAndPassDoesnotMatch)
        return false
    }
    
    func register(login: String, password: String){
        var dict = defaults.dictionary(forKey: keyUsers) as! [String:String]
        if dict[login] == nil {
            dict[login] = password
            defaults.set(dict, forKey: keyUsers)
        } else {
            alertDelegate?.presentAlert(reason: .userAlreadyExist)
        }
    }
    
    func getListOfUsers() -> [String:String]? {
        guard let avatars = defaults.dictionary(forKey: userAvatar) as? [String:String] else {
                alertDelegate?.presentAlert(reason: .defaultsFall)
                return nil
            
        }
        
        return avatars
    }
    
}
