//
//  FavoritesInteractor.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 30.08.2022.
//

import Combine
import UIKit

protocol FavoritesInteractorLogic {
    func fetchSongs()
    func markAsFavorite(song: SongContent)
}

final class FavoritesInteractor: FavoritesInteractorLogic {
    var presenter: FavoritesPresenterProtocol?

    private let favoritesStorage: FavoritesStoreProtocol
    private var songs: [SongContent] = [] {
        didSet {
            presenter?.presentSongs(songs: songs)
        }
    }

    private var cancellables: Set<AnyCancellable> = []

    init(storage: FavoritesStoreProtocol) {
        self.favoritesStorage = storage

        bind()
    }

    func fetchSongs() {
        songs = favoritesStorage.fetch()
    }

    func markAsFavorite(song: SongContent) {
        var updatedSong = song
        updatedSong.isFavorite = !song.isFavorite
        
        updatedSong.isFavorite
        ? favoritesStorage.save(song: updatedSong)
        : favoritesStorage.remove(song: updatedSong)
    }

    private func bind() {
        favoritesStorage.songContentPublisher
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                    self?.songs.removeAll()
                }
            }, receiveValue: { [weak self] songs in
                guard let self = self else { return }
                self.songs = songs
            })
            .store(in: &cancellables)
    }
}
