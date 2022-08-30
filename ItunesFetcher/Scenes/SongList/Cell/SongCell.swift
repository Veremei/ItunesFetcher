//
//  SongCell.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 28.08.2022.
//

import UIKit
import Kingfisher

final class SongCell: UICollectionViewCell {

    @IBOutlet private var songImageView: UIImageView!
    @IBOutlet private var textStackView: UIStackView!
    @IBOutlet private var songNameLabel: UILabel!
    @IBOutlet private var songAuthorLabel: UILabel!
    @IBOutlet private var accessoryButton: UIButton!

    var accessoryTapped: (() -> Void)? = nil

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

    func setup(from content: SongContent) {
        songNameLabel.text = content.title
        songAuthorLabel.text = content.subtitle
        isFavorite = content.isFavorite
        loadImage(url: content.image)
    }

    private func loadImage(url: URL?) {
        let processor = DownsamplingImageProcessor(size: songImageView.bounds.size)
        songImageView.kf.setImage(with: url,
                                  placeholder: nil,
                                  options: [
                                    .processor(processor),
                                    .scaleFactor(UIScreen.main.scale),
                                    .transition(.fade(1)),
                                    .cacheOriginalImage
                                  ],
                                  completionHandler: nil)
    }

    @IBAction private func accessoryButtonTapped(_ sender: Any) {
        isFavorite = !isFavorite
        if let accessoryTapped = accessoryTapped {
            accessoryTapped()
        }
    }
}
