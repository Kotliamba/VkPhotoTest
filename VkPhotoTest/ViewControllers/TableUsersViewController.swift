import UIKit

class TableUsersViewController: UIViewController {

    private let safeAreaView = UIView()

    private var safeAreaGuide = UILayoutGuide()
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let model = Model()
    
    private var listOfUsers = [String:String]()
    private var users = [String]()
    private var avatars = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(safeAreaView)
        self.view.backgroundColor = .white
        safeAreaView.backgroundColor = .cyan
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.addSubview(tableView)
        
        tableView.register(TableCell.self, forCellReuseIdentifier: "TableCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        
        safeAreaGuide = view.safeAreaLayoutGuide
        
        prepareRowData()
        makeConstraints()
        

    }

    @objc private func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
    private func prepareRowData(){
        guard let list = model.getListOfUsers() else {return}
        listOfUsers = list
        
        for (key, value) in listOfUsers {
            users.append(key.capitalized)
            avatars.append(value)
        }
    }
    
    private func makeConstraints(){
        NSLayoutConstraint.activate([
            safeAreaView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: safeAreaView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
            ])
    }
}

extension TableUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension TableUsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        let strImage = self.avatars[indexPath.row]
        let image = Converter.stringToImage(string: strImage)
        let name = self.users[indexPath.row]
        cell.configurate(name: name, image: image)
        return cell
    }
    
    
}
