//
//  MainTabBarViewController.swift
//  News
//
//  Created by Владислав Кузьмичёв on 01.09.2022.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarApperance = UITabBarAppearance()
        tabBarApperance.configureWithOpaqueBackground()
        tabBarApperance.backgroundColor = #colorLiteral(red: 0.1333171129, green: 0.133343339, blue: 0.1333138049, alpha: 1)
        UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
        UITabBar.appearance().standardAppearance = tabBarApperance
        tabBar.tintColor = .white
        
        setUpTabBarController()

    }

    //MARK: - Private funcs
    private func setUpTabBarController() {

        let articlesModule = ModuleBuilder.createArticleListModule()
        let articlesNavController = generateNavigationController(vc: articlesModule, title: "News", image: UIImage(named: "news")!)

        let favoritesModule = ModuleBuilder.createFavoriteArticelsModile()
        let favoritesCartNavController = generateNavigationController(vc: favoritesModule, title: "Favorites", image: UIImage(named: "favorite")!)

        viewControllers = [articlesNavController, favoritesCartNavController]

    }

    private func generateNavigationController(vc: UIViewController, title: String, image: UIImage) -> UINavigationController{
        let navController = UINavigationController(rootViewController: vc)
        navController.title = title
        navController.tabBarItem.image = image
        return navController
    }


}
