//
//  ItunesSearchResponse.swift
//  ItunesFetcher
//
//  Created by Daniil Veramei on 29.08.2022.
//

import Foundation

struct ItunesSearchResponse: Codable {
    let results: [ItunesSearchResult]
}

struct ItunesSearchResult: Codable {
    let trackId: Int
    let artistName: String
    let trackName: String
    let artworkUrl60: String?
}
