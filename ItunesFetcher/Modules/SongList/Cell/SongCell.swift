//
//  SongCell.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 28.08.2022.
//

import UIKit

struct SongCellContent {
    let id: String
    let image: URL?
    let title: String?
    let subtitle: String?
}

final class SongCell: UICollectionViewCell {

    @IBOutlet private weak var songImageView: UIImageView!
    @IBOutlet private weak var textStackView: UIStackView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var songAuthorLabel: UILabel!
    @IBOutlet private weak var accessoryButton: UIButton!

    var accessoryTapped: ((Bool) -> Void)? = nil

    private var isFavorite = false {
        didSet {
            let img = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            accessoryButton.setImage(img, for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isFavorite = false
    }

    func setup(from content: ItunesSearchResult, isFavorite: Bool) {
        songNameLabel.text = content.trackName
        songAuthorLabel.text = content.artistName
        self.isFavorite = isFavorite
    }

    @IBAction private func accessoryButtonTapped(_ sender: Any) {
        isFavorite = !isFavorite
        if let accessoryTapped = accessoryTapped {
            accessoryTapped(isFavorite)
        }
    }
}
