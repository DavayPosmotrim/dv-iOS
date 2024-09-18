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
    let alternativeName: String?
    let ratingKp: Double?
    let ratingImdb: Double?
    let votesKp: Int?
    let votesImdb: Int?
    let movieLength: Int?
    let genres: [GenreModel]
    let directors: [String?]
    let actors: [String?]

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case year
        case countries
        case poster
        case alternativeName = "alternative_name"
        case ratingKp = "rating_kp"
        case ratingImdb = "rating_imdb"
        case votesKp = "votes_kp"
        case votesImdb = "votes_imdb"
        case movieLength = "movie_length"
        case genres
        case directors
        case actors
    }
}
