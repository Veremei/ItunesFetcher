//
//  SearchPresenter.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 30.08.2022.
//

import Foundation

protocol SearchPresenterProtocol {
    func presentSongs(songs: [SongContent])
}

final class SearchPresenter: SearchPresenterProtocol {

    weak var viewController: SearchDisplayLogic?

    func presentSongs(songs: [SongContent]) {
        viewController?.displaySongs(viewModel: songs)
    }

}
