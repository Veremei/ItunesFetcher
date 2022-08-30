//
//  FavoritesPresenter.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 30.08.2022.
//

import Foundation

protocol FavoritesPresenterProtocol {
    func presentSongs(songs: [SongContent])
}

final class FavoritesPresenter: FavoritesPresenterProtocol {

    weak var viewController: FavoritesDisplayLogic?

    func presentSongs(songs: [SongContent]) {
        viewController?.displaySongs(viewModel: songs)
    }
}
