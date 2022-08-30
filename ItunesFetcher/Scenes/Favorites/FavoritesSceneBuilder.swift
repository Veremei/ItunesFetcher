//
//  FavoritesSceneBuilder.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 30.08.2022.
//

import Foundation
import UIKit

final class FavoritesSceneBuilder {
    static func make() -> UIViewController {
        let viewController = FavoritesViewController()
        let interactor = FavoritesInteractor(storage: AppServices.shared.favoritesStorage)
        let presenter = FavoritesPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }
}
