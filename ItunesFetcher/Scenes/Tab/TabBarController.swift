//
//  TabBarViewController.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 30.08.2022.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let search = SearchViewController()
        let searchNavigation = UINavigationController(rootViewController: search)
        searchNavigation.title = "Search"
        searchNavigation.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)



        let favorites = FavoritesViewController()
        let favoritesNavigation = UINavigationController(rootViewController: favorites)

        favoritesNavigation.title = "Favorites"
        favoritesNavigation.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)

        viewControllers = [searchNavigation, favoritesNavigation]
    }

}
