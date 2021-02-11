//
//  AppSession.swift
//  GBShop
//
//  Created by Maxim Safronov on 16.12.2020.
//

import UIKit

class AppService {
    // MARK: - Properties
    static var shared = AppService()
    let session = AppSession()
    var window: UIWindow?
    var rootViewController: UIViewController?

    // MARK: - Methods
    func start(_ window: UIWindow? = nil) {
        if let window = window {
            self.window = window
            configure()
        }
        return
    }
    
    func getScreenPage(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier)
    }
    
    // MARK: - Private methods
    private func configure() {
        
        let catalog = getScreenPage(identifier: "catalogScreen")
        let profile = getScreenPage(identifier: "profileScreen")
        let basket = getScreenPage(identifier: "basketScreen")
        
        let tabBarBuilder = TabBarBuilder()
        
        tabBarBuilder.addNavController(viewController: catalog, title: "Каталог",
                                       image: "folder", selectedImage: "folder.fill")
        
        tabBarBuilder.addNavController(viewController: basket, title: "Корзина",
                                       image: "cart", selectedImage: "cart.fill")
        
        tabBarBuilder.addNavController(viewController: profile, title: "Профиль",
                                       image: "person", selectedImage: "person.fill")
        
        let tabBar = tabBarBuilder.build()
        self.rootViewController = tabBar
        
        window?.rootViewController = self.rootViewController
        window?.makeKeyAndVisible()
    }
}
