//
//  SearchViewController.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 29.08.2022.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {

    private let collection = SongListCollectionViewController()

    private(set) lazy var searchController: UISearchController = {
        var controller = UISearchController(searchResultsController: nil)
        controller.delegate = self
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false

        controller.searchBar.placeholder = "Search for a song..."
//        controller.searchBar.barTintColor = .bgPrimary
        controller.searchBar.keyboardAppearance = .dark
        controller.searchBar.textContentType = .none
        controller.searchBar.autocorrectionType = .no
        controller.searchBar.barStyle = .black
        controller.hidesNavigationBarDuringPresentation = false

        return controller
    }()

    @Published private var searchTerm = ""

    private var cancellables: Set<AnyCancellable> = []

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

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        $searchTerm
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] query in
                guard let self = self else {
                    return
                }

                if query.isEmpty {
                    self.collection.updateSongs(songs: [])
                } else {
                self.load(search: query)
                }
            }
            .store(in: &cancellables)
    }

    func load(search: String) {
        let endpoint = Endpoint(host: "itunes.apple.com",
                                path: "/search",
                                headers: [:],
                                queryItems: [URLQueryItem(name: "term", value: search),
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

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let querry = searchController.searchBar.text else { return }
//        searchListViewController.performSearch(for: querry)
//        load(search: querry)
        searchTerm = querry
    }

}

// MARK: - UISearchControllerDelegate

extension SearchViewController: UISearchControllerDelegate {

    func willPresentSearchController(_ searchController: UISearchController) {
//        searchContainerView.isHidden = false
    }

    func willDismissSearchController(_ searchController: UISearchController) {
//        searchContainerView.isHidden = true
    }

}
