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

class SongCell: UICollectionViewCell {

    @IBOutlet private weak var songImageView: UIImageView!
    @IBOutlet private weak var textStackView: UIStackView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var songAuthorLabel: UILabel!
    @IBOutlet private weak var accessoryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(from content: ItunesSearchResult) {
        songNameLabel.text = content.trackName
        songAuthorLabel.text = content.artistName
    }

    @IBAction private func accessoryButtonTapped(_ sender: Any) {
    }
}
