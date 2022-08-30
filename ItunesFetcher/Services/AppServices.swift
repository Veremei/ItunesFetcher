//
//  AppServices.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 30.08.2022.
//

import Foundation

class AppServices {
    static let shared = AppServices()
    private init() { }

    lazy var networkService: NetworkServiceProtocol = {
        NetworkService(urlSession: URLSession.shared)
    }()

    lazy var favoritesStorage: FavoritesStoreProtocol = {
        FavoritesUserDefaultsStore(songs: AppStorageData.favoriteSongs)
    }()
}
