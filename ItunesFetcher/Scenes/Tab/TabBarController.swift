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
        viewControllers = [makeSearch(), makeFavorites()]
    }

    func makeSearch() -> UIViewController {
        let search = SearchSceneBuilder.make()
        let searchNavigation = UINavigationController(rootViewController: search)

        searchNavigation.title = "Search"
        searchNavigation.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        return searchNavigation
    }

    func makeFavorites() -> UIViewController {
        let favorites = FavoritesSceneBuilder.make()
        let favoritesNavigation = UINavigationController(rootViewController: favorites)

        favoritesNavigation.title = "Favorites"
        favoritesNavigation.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)

        return favoritesNavigation
    }
}
