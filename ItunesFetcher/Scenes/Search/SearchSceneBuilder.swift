//
//  SearchSceneBuilder.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 30.08.2022.
//

import Foundation
import UIKit

final class SearchSceneBuilder {
    static func make() -> UIViewController {
        let viewController = SearchViewController()
        let interactor = SearchInteractor(networking: AppServices.shared.networkService,
                                          storage: AppServices.shared.favoritesStorage)
        let router = SearchRouter()
        let presenter = SearchPresenter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.source = viewController
        return viewController
    }
}
