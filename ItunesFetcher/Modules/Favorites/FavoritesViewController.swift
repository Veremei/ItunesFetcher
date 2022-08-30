//
//  FavoritesViewController.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 30.08.2022.
//

import UIKit
import Combine

final class FavoritesViewController: UIViewController {

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
}
