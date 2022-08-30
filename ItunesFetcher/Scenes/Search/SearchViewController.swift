//
//  SearchViewController.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 29.08.2022.
//

import UIKit
import Combine

protocol SearchDisplayLogic: AnyObject {
    func displaySongs(viewModel: [SongContent])
    func showError(message: String)
}

final class SearchViewController: UIViewController {

    var interactor: SearchInteractorLogic?
    var router: SearchRoutingLogic?

    private let collection = SongListCollectionViewController()

    private(set) lazy var searchController: UISearchController = {
        var controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search..."
        controller.searchBar.keyboardAppearance = .dark
        controller.searchBar.textContentType = .none
        controller.searchBar.autocorrectionType = .no
        controller.searchBar.barStyle = .black
        controller.hidesNavigationBarDuringPresentation = false

        return controller
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        let viewController = self
        let interactor = SearchInteractor(networking: AppServices.shared.networkService,
                                          storage: AppServices.shared.favoritesStorage)
        let router = SearchRouter()
        let presenter = SearchPresenter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.source = viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self

        addChild(collection)
        collection.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collection.view)
        NSLayoutConstraint.activate([
            collection.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.view.topAnchor.constraint(equalTo: view.topAnchor),
            collection.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        interactor?.searchFieldDidUpdate(text: searchText)
    }
}

extension SearchViewController: SongListDelegate {
    func didMarkFavorite(song: SongContent) {
        interactor?.markAsFavorite(song: song)
    }
}

extension SearchViewController: SearchDisplayLogic {
    func displaySongs(viewModel: [SongContent]) {
        self.collection.updateSongs(songs: viewModel)
    }

    func showError(message: String) {
        router?.showFailure(message: message)
    }
}
