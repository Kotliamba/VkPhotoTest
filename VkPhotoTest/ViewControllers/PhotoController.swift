import UIKit

class PhotoController: UIViewController {
    
    private var safeAreaView = UIView()

    private var imageView = UIImageView()
    
    private var safeAreaGuide = UILayoutGuide()
    
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
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(safeAreaView)
        safeAreaView.addSubview(imageView)
        exitButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        setAvatarButton.addTarget(self, action: #selector(setAvatar), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: exitButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: setAvatarButton)
        
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        
        safeAreaGuide = view.safeAreaLayoutGuide
        
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
            safeAreaView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: safeAreaView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
        ])
    }
    
}

