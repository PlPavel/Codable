//
//  FactoryTheme.swift
//  hw27_Codable
//
//  Created by Pavel Plyago on 14.07.2024.
//

import Foundation
import UIKit

protocol ThemeFactory {
    func createLabel() -> ThemeLabel
    func createTableView() -> ThemeTableView
    func createButton() -> ThemeButton
}

class LightThemeFactory: ThemeFactory {
    func createLabel() -> any ThemeLabel {
        return LightLabel()
    }
    
    func createTableView() -> any ThemeTableView {
        return LightTableViewTheme()
    }
    
    func createButton() -> any ThemeButton {
        return LightButton()
    }
    
}

class DarkThemeFactory: ThemeFactory {
    func createLabel() -> any ThemeLabel {
        return DarkLabel()
    }
    
    func createTableView() -> any ThemeTableView {
        return DarkTableViewTheme()
    }
    
    func createButton() -> any ThemeButton {
        return DarkButton()
    }
    
}
