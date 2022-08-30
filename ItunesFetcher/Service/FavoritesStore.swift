//
//  FavoritesStore.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 30.08.2022.
//

import Foundation

protocol FavoritesStoreProtocol {
    var songContentPublisher: Published<[SongContent]>.Publisher { get }

    func fetch() -> [SongContent]
    func save(song: SongContent)
    func remove(song: SongContent)
}

final class FavoritesUserDefaultsStore: FavoritesStoreProtocol {

    init(songs: [SongContent]) {
        self.songs = songs
    }

    var songContentPublisher: Published<[SongContent]>.Publisher { $songs }
    @Published private(set) var songs: [SongContent] = [] {
        didSet {
            favoriteSongs = songs
        }
    }

    @Storage(key: "FavoriteSongs", defaultValue: [])
    private var favoriteSongs: [SongContent]

    func fetch() -> [SongContent] {
        AppStorageData.favoriteSongs
    }

    func save(song: SongContent) {
        songs.append(song)
    }

    func remove(song: SongContent) {
        songs.removeAll(where: { $0.id == song.id })
    }
}
