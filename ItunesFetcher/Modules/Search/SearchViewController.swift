//
//  SearchViewController.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 29.08.2022.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []

    let collection = SongListCollectionViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
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


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }

    func load() {
        let endpoint = Endpoint(host: "itunes.apple.com",
                                path: "/search",
                                headers: [:],
                                queryItems: [URLQueryItem(name: "term", value: "Metallica"),
                                             URLQueryItem(name: "media", value: "music")])

        NetworkService.shared.request(endpoint: endpoint)
            .receive(on: DispatchQueue.main)
            .decode(type: ItunesSearchResponse.self, decoder: JSONDecoder())
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                print("response", response)
                self.collection.updateSongs(songs: response.results)

            }.store(in: &cancellables)

    }
}
