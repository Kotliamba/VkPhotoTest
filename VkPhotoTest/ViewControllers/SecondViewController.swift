import UIKit
import Photos

protocol avatarSetterDelegate: AnyObject {
    func setAvatar(_ newImage: UIImage?)
}


class SecondViewController: UIViewController {
    
    private var model = Model()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    private let allUsersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Users", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    private let safeAreaView = UIView()
    private let changeAvatarArea = UIView()
    private let currentAvatar : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 32)
        
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        
        return collection
    }()
    
    private var imagesCount = 0
    private var images = [UIImage]()
    private let viewForLabels = UIView()
    private var safeAreaGuide = UILayoutGuide()
    private var counter = 100

    override func viewDidLoad() {
        super.viewDidLoad()

        print(images.count)

        view.backgroundColor = .white
        
        view.addSubview(safeAreaView)
        safeAreaView.addSubview(changeAvatarArea)
        changeAvatarArea.addSubview(currentAvatar)
        changeAvatarArea.addSubview(viewForLabels)
        viewForLabels.addSubview(nameLabel)
        safeAreaView.addSubview(collectionView)
        model.alertDelegate = self
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "MyCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        allUsersButton.addTarget(self, action: #selector(showAllUsers), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: exitButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: allUsersButton)
        
        safeAreaGuide = view.safeAreaLayoutGuide
        
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = model.getLastLogin()?.capitalized
        viewForLabels.backgroundColor = .white
        viewForLabels.translatesAutoresizingMaskIntoConstraints = false
        currentAvatar.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.backgroundColor = .blue
        changeAvatarArea.translatesAutoresizingMaskIntoConstraints = false
        changeAvatarArea.backgroundColor = .white
        
        setBaseAvatar()
        
        makeConstraints()
        
        fetchPhotoPrivacyStatus(PHPhotoLibrary.authorizationStatus())
        getPhotos()
    }
    
    private func setBaseAvatar(){
        guard let lastAvatar = model.getAvatar() else {
            guard let baseAvatar = UIImage(named: "placeholder") else {
                presentAlert(reason: .defaultsFall)
                return
            }
            saveNewAvatar(with: baseAvatar)
            return
        }
        if !lastAvatar.isEmpty {
            currentAvatar.image = Converter.stringToImage(string: lastAvatar)
        }
    }
    
    @objc private func showAllUsers(){
        let tableVC = TableUsersViewController()
        
        navigationController?.pushViewController(tableVC, animated: true)
    }
    
    @objc private func presentPhotoScreen(with image: UIImage){
        let newVC = PhotoController(image: image)
        newVC.avatarSetterDelegate = self
        
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc private func goBack(){
        self.dismiss(animated: true)
    }
    
    private func fetchPhotoPrivacyStatus(_ status: PHAuthorizationStatus){
        switch status {
        case .notDetermined:
            presentAlert(reason: .noPermission)
        case .restricted:
            presentAlert(reason: .noPermission)
        case .denied:
            presentAlert(reason: .noPermission)
        case .authorized:
            break
        case .limited:
            break
        @unknown default:
            presentAlert(reason: .noPermission)
        }
    }
    
    private func getPhotos() {
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        self.imagesCount = results.count
        if results.count <= 100 {
            self.counter = results.count
        }
        if results.count > 0 {
            for i in 0..<self.counter {
                let object = results.object(at: i)
                manager.requestImage(for: object, targetSize: CGSize(width: 600, height: 600), contentMode: .aspectFill, options: requestOptions) { (image, _) in
                    if let image = image {
                        self.images.append(image)
                        self.collectionView.reloadData()
                    } else {
                        self.presentAlert(reason: .imageLoadFalled)
                    }
                }
            }
        } else {
            self.presentAlert(reason: .noImages)
        }

    }
    
    private func saveNewAvatar(with image: UIImage){
        let strImage = image.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
        model.setAvatar(string: strImage)
    }
    
    private func makeConstraints(){
        NSLayoutConstraint.activate([
            safeAreaView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            changeAvatarArea.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            changeAvatarArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            changeAvatarArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            changeAvatarArea.heightAnchor.constraint(equalToConstant: view.frame.height/5),
            
            currentAvatar.centerYAnchor.constraint(equalTo: changeAvatarArea.centerYAnchor),
            currentAvatar.leadingAnchor.constraint(equalTo: changeAvatarArea.leadingAnchor),
            currentAvatar.heightAnchor.constraint(equalToConstant: view.frame.width/4),
            currentAvatar.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            
            viewForLabels.leadingAnchor.constraint(equalTo: currentAvatar.trailingAnchor),
            viewForLabels.trailingAnchor.constraint(equalTo: changeAvatarArea.trailingAnchor),
            viewForLabels.bottomAnchor.constraint(equalTo: changeAvatarArea.bottomAnchor),
            viewForLabels.topAnchor.constraint(equalTo: changeAvatarArea.topAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: viewForLabels.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: viewForLabels.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: viewForLabels.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: changeAvatarArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
        ])
    }
}

extension SecondViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        presentPhotoScreen(with: image)
    }
    
}

extension SecondViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.counter
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! PhotoCell
        if images.count == self.counter {
            cell.configurate(with: images[indexPath.row])
        }
        return cell
    }
    
    
}

extension SecondViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.width/3-2, height: self.view.frame.width/3 - 2)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

extension SecondViewController: avatarSetterDelegate {
    func setAvatar(_ newImage: UIImage?) {
        if newImage != nil {
            self.currentAvatar.image = newImage!
            self.saveNewAvatar(with: newImage!)
        }
    }
}


