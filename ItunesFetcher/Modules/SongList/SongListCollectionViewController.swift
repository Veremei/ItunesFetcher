//
//  SongListCollectionViewController.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 28.08.2022.
//

import UIKit

final class SongListCollectionViewController: UIViewController {
    private enum Constants {
        static let reuseIdentifier = "SongCell"
    }

    private lazy var collection: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 72)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: "SongCell", bundle: nil), forCellWithReuseIdentifier: Constants.reuseIdentifier)
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()

    private var songs: [ItunesSearchResult] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
    }

    private func setupCollection() {
        collection.delegate = self
        collection.dataSource = self

        view.addSubview(collection)

        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

    }

    func updateSongs(songs: [ItunesSearchResult]) {
        self.songs = songs
        collection.reloadData()
    }
}

extension SongListCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath)

        guard let songCell = cell as? SongCell else {
            return cell
        }
        let item = songs[indexPath.item]
        songCell.setup(from: item,
                       isFavorite: FavoritesService.shared.savedSongs
            .contains(where: { $0.trackId == item.trackId }))

        songCell.accessoryTapped = {
            FavoritesService.shared.save(song: item)
        }

        return songCell
    }
}



extension SongListCollectionViewController: UICollectionViewDelegate {

}
