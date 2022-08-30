//
//  FavoritesService.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 30.08.2022.
//

import Foundation

final class FavoritesService {
    static let shared = FavoritesService()

    var saved: [Int] = []

    var savedSongs: [ItunesSearchResult] = []

    private init() {}


    func updateState(for song: ItunesSearchResult, isSelected: Bool) {
        isSelected
        ? save(song: song)
        : remove(song: song)
    }

    private func save(song: ItunesSearchResult) {
        savedSongs.append(song)
    }

    private func remove(song: ItunesSearchResult) {
        savedSongs.removeAll(where: { $0.trackId == song.trackId })
    }
}
