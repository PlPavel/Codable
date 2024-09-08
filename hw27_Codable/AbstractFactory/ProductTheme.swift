//
//  ProductTheme.swift
//  hw27_Codable
//
//  Created by Pavel Plyago on 14.07.2024.
//

import Foundation
import UIKit

protocol ThemeTableView {
    func create() -> UITableView
}

protocol ThemeLabel {
    func create() -> UILabel
}

protocol ThemeButton {
    func create() -> UIButton
}

class LightTableViewTheme: ThemeTableView {
    func create() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.separatorColor = .black
        return tableView
    }
}

class LightLabel: ThemeLabel {
    func create() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.text = "Posts"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }
}

class LightButton: ThemeButton {
    func create() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Create Post", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        return button
    }
}


class DarkTableViewTheme: ThemeTableView {
    func create() -> UITableView {
        let tableView = UITableView(frame:.zero)
        tableView.backgroundColor = .black
        tableView.separatorColor = .white
        return tableView
    }
}

class DarkLabel: ThemeLabel {
    func create() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .black
        label.text = "Posts"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }
}

class DarkButton: ThemeButton {
    func create() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Create Post", for: .normal)
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        return button
    }
}
