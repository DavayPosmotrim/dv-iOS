//
//  MovieDetailsCellModel.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 02.07.2024.
//

import Foundation

struct SelectionMovieDetailsCellModel: Codable {
    let description: String?
    let ratingKp: Double?
    let ratingImdb: Double?
    let votesKp: Int?
    let votesImdb: Int?
    let directors: [String?]
    let actors: [String?]
}
