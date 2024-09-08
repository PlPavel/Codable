//
//  ViewController.swift
//  hw27_Codable
//
//  Created by Pavel Plyago on 01.07.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private let defaults = UserDefaults()
    private var posts: [Post] = []
    
    //реализация паттерна Абстрактная фабрика
    private var themeFactory: ThemeFactory
    
    init(posts: [Post], themeFactory: ThemeFactory) {
        self.posts = posts
        self.themeFactory = themeFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = themeFactory.createTableView().create()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var titleTable: UILabel = {
        let label = themeFactory.createLabel().create()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createPostButton: UIButton = {
        let button = themeFactory.createButton().create()
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var switcherTheme: UISwitch = {
        let switcher = UISwitch(frame: .zero)
        switcher.isOn = (themeFactory is DarkThemeFactory)
        switcher.addTarget(self, action: #selector(themeSwitched), for: .valueChanged)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    private let postService = PostService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = (themeFactory is LightThemeFactory) ? .white : .black
        view.addSubview(tableView)
        view.addSubview(titleTable)
        view.addSubview(createPostButton)
        view.addSubview(switcherTheme)
        
        setUpConstraint()
        fetchData()
    }
    
    @objc private func themeSwitched() {
        let factory: any ThemeFactory = switcherTheme.isOn ? DarkThemeFactory() : LightThemeFactory()
        let newViewController = ViewController(posts: posts, themeFactory: factory)
        newViewController.modalPresentationStyle = .fullScreen
        present(newViewController, animated: false, completion: nil)
    }
    
    func setUpConstraint(){
        NSLayoutConstraint.activate([
            titleTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            createPostButton.centerYAnchor.constraint(equalTo: titleTable.centerYAnchor),
            createPostButton.leadingAnchor.constraint(equalTo: titleTable.trailingAnchor, constant: 20),
            createPostButton.widthAnchor.constraint(equalToConstant: 100),
            createPostButton.heightAnchor.constraint(equalToConstant: 35),
            
            
            switcherTheme.centerYAnchor.constraint(equalTo: createPostButton.centerYAnchor),
            switcherTheme.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleTable.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: PROXY паттерн - перехватывает загрузку из сети и подставляет данные из USERDEFAULTS
    func fetchData(){
        if let postsDefualt = defaults.object(forKey: "posts") as? Data {
            if let postsDecode = try? JSONDecoder().decode([Post].self, from: postsDefualt) {
                self.posts = postsDecode
                print("Posts was add to defualt")
            }
        } else {
            
            //MARK: ФАСАД паттерн - использование простого интерфейса при обращении к сложной системе классов
            //то есть вызывается класс одной строкой, за которой скрыт большой функционал
            
            postService.fetchUser { [weak self] result in
                switch result {
                case .success(let posts):
                    self?.posts = posts
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        print("Posts didnt add yet")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    //по нажатию на клавишу создаем новый пост приведенный ниже
    
    @objc func createUser() {
        let newPost = Post(userId: 1, id: 101, title: "Example")
        
        postService.createUser(user: newPost) { [weak self] result in
            switch result {
            case .success(let createdPost):
                print("Created post \(createdPost)")
                DispatchQueue.main.async {
                    self?.posts.append(newPost)
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    

}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = (themeFactory is LightThemeFactory) ? .white : .black
        cell.textLabel?.textColor = (themeFactory is LightThemeFactory) ? .black : .white
        
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
        return cell
    }
    
    //По нажатию на яцейку пост изменяется на приведнный ниже
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let updatePost = Post(userId: post.userId, id: post.id, title: "New Title")
        
        postService.updateUser(id: post.id, post: updatePost) { [weak self] result in
            switch result{
            case .success:
                print("Post was updated\(updatePost)")
                DispatchQueue.main.async {
                    self?.posts[indexPath.row] = updatePost
                    tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    //при отведении ячеки влево можно удалить пост
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let post = posts[indexPath.row]
            
            postService.deleteUser(id: post.id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.posts.remove(at: indexPath.row)
                        print("\(post) was deleted")
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    case .failure(let error):
                        print("Faild to delete user \(error)")
                    }
                }
            }
        }
        
    }
    
}
