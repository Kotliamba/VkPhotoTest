import Foundation

struct Model{
    private let defualts = UserDefaults.standard
    private let nameForDefaults = "UserData"
    
    func saveLastLogin(_ login:String){
        defualts.set(login, forKey: "LastLogin")
    }
    
    func unLogin(){
        defualts.set("", forKey: "LastLogin")
    }
    
    
    func initialize() -> Bool{
        guard defualts.dictionary(forKey: nameForDefaults) != nil else {
            print("No data")
            print("Adding test case")
            let dict:[String:String] = ["admin":"1234"]
            defualts.set(dict, forKey: "UserData")
            return false
        }
        if defualts.string(forKey: "LastLogin") != nil {
            guard let last = defualts.string(forKey: "LastLogin") else {return false}
            guard let dictOfUserts = defualts.dictionary(forKey: nameForDefaults) else {return false}
            guard let lastPass = dictOfUserts[last] as? String else {return false}
            if login(login: last, password: lastPass) {
                return true
            }
        }
        return false
    }
    
    func login(login: String, password: String) -> Bool{
        guard let userList = defualts.dictionary(forKey: nameForDefaults) else {
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
        var dict = defualts.dictionary(forKey: nameForDefaults) as! [String:String]
        if dict[login] == nil {
            dict[login] = password
            defualts.set(dict, forKey: nameForDefaults)
        } else {
            print("User with this name is existing")
        }
    }
    
}
