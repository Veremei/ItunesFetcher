//
//  SearchInteractor.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 30.08.2022.
//

import UIKit
import Combine

protocol SearchInteractorLogic {
    func searchFieldDidUpdate(text: String)
    func markAsFavorite(song: SongContent)
}

final class SearchInteractor: SearchInteractorLogic {
    var presenter: SearchPresenterProtocol?

    @Published private var searchTerm = ""

    private let networking: NetworkServiceProtocol
    private let storage: FavoritesStoreProtocol

    private var songs: [ItunesSearchResult] = [] {
        didSet {
            let songsContent = songs.map({
                SongContent(id: $0.trackId,
                            image: URL(string: $0.artworkUrl60 ?? ""),
                            title: $0.trackName,
                            subtitle: $0.artistName,
                            isFavorite: self.isFavorite(id: $0.trackId))
            })
            presenter?.presentSongs(songs: songsContent)
        }
    }
    
    private var favorites: [SongContent] = []

    private var cancellables: Set<AnyCancellable> = []

    init(networking: NetworkServiceProtocol,
         storage: FavoritesStoreProtocol) {
        self.networking = networking
        self.storage = storage
        
        bind()
    }

    func searchFieldDidUpdate(text: String) {
        searchTerm = text
    }

    func markAsFavorite(song: SongContent) {
        var updatedSong = song
        updatedSong.isFavorite = !song.isFavorite
        updatedSong.isFavorite ? storage.save(song: updatedSong) : storage.remove(song: updatedSong)
    }

    private func bind() {
        $searchTerm
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else {
                    return
                }

                if query.isEmpty {
                    self.songs.removeAll()
                } else {
                    self.performSearch(by: query)
                }
            }
            .store(in: &cancellables)

        storage.songContentPublisher
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                    self.favorites.removeAll()
                    self.presenter?.showError(error)
                }
            }, receiveValue: { [weak self] songs in
                guard let self = self else { return }
                self.favorites = songs
            })
            .store(in: &cancellables)
    }

    // MARK: - Perform Search

    private func performSearch(by query: String) {
        let endpoint = Endpoint(host: "itunes.apple.com",
                                path: "/search",
                                headers: [:],
                                queryItems: [URLQueryItem(name: "term", value: query),
                                             URLQueryItem(name: "media", value: "music")])
        
        networking.request(endpoint: endpoint)
            .receive(on: DispatchQueue.main)
            .decode(type: ItunesSearchResponse.self, decoder: JSONDecoder())
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                    self.songs.removeAll()
                    self.presenter?.showError(error)
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                print("response", response)
                self.songs = response.results
            }.store(in: &cancellables)
    }

    private func isFavorite(id: Int) -> Bool {
        favorites.contains(where: { $0.id == id })
    }
}
