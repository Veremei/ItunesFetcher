//
//  FavoritesViewController.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 30.08.2022.
//

import UIKit
import Combine

protocol FavoritesDisplayLogic: AnyObject {
    func displaySongs(viewModel: [SongContent])
}

final class FavoritesViewController: UIViewController {

    var interactor: FavoritesInteractorLogic?

    private let collection = SongListCollectionViewController()

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
    }

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
        let interactor = FavoritesInteractor(storage: AppServices.shared.favoritesStorage)
        let presenter = FavoritesPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchSongs()
    }
}

extension FavoritesViewController: FavoritesDisplayLogic {
    func displaySongs(viewModel: [SongContent]) {
        collection.updateSongs(songs: viewModel)
    }
}

extension FavoritesViewController: SongListDelegate {
    func didMarkFavorite(song: SongContent) {
        interactor?.markAsFavorite(song: song)
    }
}

