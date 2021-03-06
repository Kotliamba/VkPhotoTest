import UIKit
import Photos

class ViewController: UIViewController {

    private var textFieldLogin: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Enter your login", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.autocorrectionType = .no
        textField.textContentType = .name
        textField.textColor = .black

        return textField
    }()
    
    private var textFieldPassword: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Enter your password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.autocorrectionType = .no
        //textField.textContentType = .password
        //Some bugs withouts keychain enabled
        textField.isSecureTextEntry = true
        textField.textColor = .black

        return textField
    }()
    
    private var textFieldVerifyPassword: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Verify your password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.autocorrectionType = .no
        //textField.textContentType = .newPassword
        //Some bugs withouts keychain enabled
        textField.isSecureTextEntry = true
        textField.textColor = .black
        return textField
    }()
    
    private var labelAppName: UILabel = {
        let label = UILabel()
        label.text = "Vk Photo App"
        label.font = .systemFont(ofSize: 48)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Login", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 5
        return button
    }()
    
    private var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Register", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 5
        return button
    }()
    
    private var signUpOrSignInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Regitster", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()
    
    private var model = Model()
    
    private var margins = UILayoutGuide()
    private var safeArea = UILayoutGuide()
    
    private var currentTask = Task.login
    
    private var secondScreenFlag = false
    
    private var registerConstraints: [NSLayoutConstraint] = []
    private var loginConstraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        view.addSubview(labelAppName)
        self.view.addSubview(textFieldLogin)
        self.view.addSubview(textFieldPassword)
        self.view.addSubview(loginButton)
        self.view.addSubview(signUpOrSignInButton)
        self.view.addSubview(textFieldVerifyPassword)
        self.view.addSubview(registerButton)
        
        model.alertDelegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        signUpOrSignInButton.addTarget(self, action: #selector(changeView), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
                
        margins = view.layoutMarginsGuide
        safeArea = view.safeAreaLayoutGuide
        
        makeConstraints(to: .login)
        
        if model.initialize(){
            secondScreenFlag = true
        }
        
        askForPhotoPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearTextFields()
    }
    
    private func clearTextFields(){
        textFieldLogin.text = ""
        textFieldPassword.text = ""
        textFieldVerifyPassword.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if secondScreenFlag{
            secondScreenFlag = false
            goToSecondScreen()
        }
    }
    
    @objc private func changeView(){
        if currentTask == .login {
            currentTask = .register
        } else {
            currentTask = .login
        }
        makeConstraints(to: currentTask)
    }
    
    @objc private func register(){
        guard let login = textFieldLogin.text else {return}
        guard let pass = textFieldPassword.text else {return}
        guard let verifedPass = textFieldVerifyPassword.text else {return}
        checkTextField(login: login, pass: pass, verifyPass: verifedPass)
        if !login.isEmpty && !pass.isEmpty && !verifedPass.isEmpty {
            if pass == verifedPass{
                model.register(login: login.lowercased(), password: pass)
                model.saveLastLogin(login.lowercased())
                goToSecondScreen()
            } else {
                presentAlert(reason: .passwordDoesNotMatch)
            }
        }
    }
    
    private func askForPhotoPermission(){
        let _: PHFetchResult = PHAsset.fetchAssets(with: .image, options: PHFetchOptions())
    }
    
    @objc private func login(){
        guard let loginSample = textFieldLogin.text else {return}
        let login = loginSample.trimmingCharacters(in: .whitespaces)
        guard let pass = textFieldPassword.text else {return}
        checkTextField(login: login, pass: pass, verifyPass: nil)
        if !login.isEmpty && !pass.isEmpty{
            if model.login(login: login.lowercased(), password: pass) {
                model.saveLastLogin(login.lowercased())
                goToSecondScreen()
            }
        }
    }
    
    private func checkTextField(login: String, pass: String, verifyPass: String?){
        if login.isEmpty {
            presentAlert(reason: .noLogin)
        }
        if pass.isEmpty {
            presentAlert(reason: .noPassword)
        }
        if verifyPass != nil {
            if verifyPass!.isEmpty {
                presentAlert(reason: .noPassword)
            }
        }
    }
    
    private func goToSecondScreen(){
 
        
        let secondVc = SecondViewController()
        let nav = UINavigationController(rootViewController: secondVc)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func makeConstraints(to task:Task){
        if task == .register {
            clearTextFields()
            loginButton.isHidden = true
            textFieldVerifyPassword.isHidden = false
            registerButton.isHidden = false
            signUpOrSignInButton.setTitle("Login", for: .normal)
            textFieldPassword.textContentType = .newPassword
            
            registerConstraints = [
                labelAppName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                labelAppName.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
                
                textFieldLogin.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30),
                textFieldLogin.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30),
                textFieldLogin.topAnchor.constraint(equalTo: labelAppName.bottomAnchor, constant: 30),
                textFieldLogin.bottomAnchor.constraint(equalTo: textFieldLogin.topAnchor, constant: 40),
                
                textFieldPassword.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30),
                textFieldPassword.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30),
                textFieldPassword.topAnchor.constraint(equalTo: textFieldLogin.bottomAnchor, constant: 10),
                textFieldPassword.bottomAnchor.constraint(equalTo: textFieldPassword.topAnchor, constant: 40),
                
                textFieldVerifyPassword.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30),
                textFieldVerifyPassword.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30),
                textFieldVerifyPassword.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 10),
                textFieldVerifyPassword.bottomAnchor.constraint(equalTo: textFieldVerifyPassword.topAnchor, constant: 40),
                
                registerButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30),
                registerButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30),
                registerButton.topAnchor.constraint(equalTo: textFieldVerifyPassword.bottomAnchor, constant: 30),
                registerButton.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: 40),
                
                signUpOrSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                signUpOrSignInButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 10),
                signUpOrSignInButton.bottomAnchor.constraint(equalTo: signUpOrSignInButton.topAnchor, constant: 40),

            ]
            NSLayoutConstraint.deactivate(loginConstraints)
            NSLayoutConstraint.activate(registerConstraints)
        } else {
            clearTextFields()
            textFieldVerifyPassword.isHidden = true
            registerButton.isHidden = true
            loginButton.isHidden = false
            signUpOrSignInButton.setTitle("Register", for: .normal)
            textFieldPassword.textContentType = .password
            
            loginConstraints = [
                labelAppName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                labelAppName.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
                textFieldLogin.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30),
                textFieldLogin.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30),
                textFieldLogin.topAnchor.constraint(equalTo: labelAppName.bottomAnchor, constant: 30),
                textFieldLogin.bottomAnchor.constraint(equalTo: textFieldLogin.topAnchor, constant: 40),
                textFieldPassword.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30),
                textFieldPassword.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30),
                textFieldPassword.topAnchor.constraint(equalTo: textFieldLogin.bottomAnchor, constant: 10),
                textFieldPassword.bottomAnchor.constraint(equalTo: textFieldPassword.topAnchor, constant: 40),
                loginButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30),
                loginButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30),
                loginButton.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 30),
                loginButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: 40),
                signUpOrSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                signUpOrSignInButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
                signUpOrSignInButton.bottomAnchor.constraint(equalTo: signUpOrSignInButton.topAnchor, constant: 40),
            ]
            NSLayoutConstraint.deactivate(registerConstraints)
            NSLayoutConstraint.activate(loginConstraints)
        }
        
    }
    
}



