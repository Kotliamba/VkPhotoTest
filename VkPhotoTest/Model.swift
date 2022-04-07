import Foundation

struct Model{
    private let defaults = UserDefaults.standard
    private let keyUsers = DefaultsData.users.rawValue
    private let keyLastLogin = DefaultsData.lastLogin.rawValue
    
    func saveLastLogin(_ login:String){
        defaults.set(login, forKey: keyLastLogin)
    }
    
    func getLastLogin() -> String?{
        guard let login = defaults.string(forKey: keyLastLogin) else {return nil}
        return login
    }
    
    func unLogin(){
        defaults.set("", forKey: keyLastLogin)
    }
    
    
    func initialize() -> Bool{
        guard defaults.dictionary(forKey: keyUsers) != nil else {
            print("No data")
            print("Adding test case")
            let dict:[String:String] = ["admin":"1234"]
            defaults.set(dict, forKey: "UserData")
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
            print("No userList")
            return false
        }
        print(userList)
        guard let currentUser = userList[login] else {
            print("Wrong User")
            return false
        }
        if currentUser as! String == password {
            print("U can go")
            return true
        }
        return false
    }
    
    func register(login: String, password: String){
        var dict = defaults.dictionary(forKey: keyUsers) as! [String:String]
        if dict[login] == nil {
            dict[login] = password
            defaults.set(dict, forKey: keyUsers)
        } else {
            print("User with this name is existing")
        }
    }
    
}
