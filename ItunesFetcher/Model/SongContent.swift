//
//  SongContent.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 30.08.2022.
//

import Foundation

struct SongContent: Codable, Identifiable {
    let id: Int
    let image: URL?
    let title: String?
    let subtitle: String?
    var isFavorite: Bool = false
}

extension SongContent: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

