//
//  SecondViewController.swift
//  VkPhotoTest
//
//  Created by Чаусов Николай on 07.04.2022.
//

import UIKit

class SecondViewController: UIViewController {
    
    var model = Model()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    let safeAreaView = UIView()
    let changeAvatarArea = UIView()
    let currentAvatar : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 32)
        
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        
        return collection
    }()
    
    
    let viewForLabels = UIView()
    var safeAreaGuide = UILayoutGuide()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(safeAreaView)
        safeAreaView.addSubview(changeAvatarArea)
        changeAvatarArea.addSubview(currentAvatar)
        changeAvatarArea.addSubview(viewForLabels)
        viewForLabels.addSubview(nameLabel)
        safeAreaView.addSubview(collectionView)
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "MyCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        exitButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: exitButton)
        
        safeAreaGuide = view.safeAreaLayoutGuide
        
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = model.getLastLogin()
        viewForLabels.backgroundColor = .white
        viewForLabels.translatesAutoresizingMaskIntoConstraints = false
        currentAvatar.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.backgroundColor = .blue
        changeAvatarArea.translatesAutoresizingMaskIntoConstraints = false
        changeAvatarArea.backgroundColor = .white
        
        makeConstraints()
    }
    
    @objc private func goBack(){
        self.dismiss(animated: true)
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
    
}

extension SecondViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! PhotoCell
        cell.configurate()
        
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
