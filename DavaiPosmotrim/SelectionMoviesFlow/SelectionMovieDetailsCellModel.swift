//
//  MovieDetailsCellModel.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 02.07.2024.
//

import Foundation

struct SelectionMovieDetailsCellModel {
    let description: String
    let ratingKp: Float
    let ratingImdb: Float
    let votesKp: Int
    let votesImdb: Int
    let directors: [String]
    let actors: [String]
}
