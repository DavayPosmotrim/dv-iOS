//
//  MovieDetailModel.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 15.07.2024.
//

import Foundation

struct MovieDetailModel: Codable {
    let id: Int
    let name: String
    let description: String?
    let year: Int?
    let countries: [String]?
    let poster: String?
    let alternative_name: String?
    let rating_kp: Double? // MAYBE FLOAT?
    let rating_imdb: Double? // MAYBE FLOAT?
    let votes_kp: Int?
    let votes_imdb: Int?
    let movie_length: Int?
    let genres: [GenreModel]
    let directors: [String]?
    let actors: [String]?
}
