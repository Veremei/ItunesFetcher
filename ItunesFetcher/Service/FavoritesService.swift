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

    func save(song: ItunesSearchResult) {
        savedSongs.append(song)
    }
}
