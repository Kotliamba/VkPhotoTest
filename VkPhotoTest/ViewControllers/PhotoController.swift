import UIKit

class PhotoController: UIViewController {
    
    private var safeAreaView = UIView()

    private var imageView = UIImageView()
    
    weak var avatarSetterDelegate: avatarSetterDelegate?
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    private let setAvatarButton: UIButton = {
        let button = UIButton()
        button.setTitle("Set Avatar", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        exitButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        setAvatarButton.addTarget(self, action: #selector(setAvatar), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: exitButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: setAvatarButton)
        
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        
        makeConstraints()
    }
    
    @objc private func setAvatar(){
        avatarSetterDelegate?.setAvatar(imageView.image)
    }
    
    @objc private func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
    convenience init(image: UIImage){
        self.init()
        imageView.image = image
    }
    
    private func makeConstraints(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
}

