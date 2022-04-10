import UIKit

class PhotoController: UIViewController {
    
    private var safeAreaView = UIView()

    private var imageView = UIImageView()
    
    weak var avatarSetterDelegate: avatarSetterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(goBack))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(setAvatar))
        
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

