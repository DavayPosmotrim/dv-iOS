//
//  MovieRouletteModel.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 15.07.2024.
//

import Foundation
struct MovieRouletteModel {
    let name: String
    let year: Int?
    let countries: [String]?
    let poster: String?
    let alternativeName: String?
    let ratingKp: Double?
    let movieLength: Int?
    let genres: [GenreModel]

    private enum CodingKeys: String, CodingKey {
        case name
        case year
        case countries
        case poster
        case alternativeName = "alternative_name"
        case ratingKp = "rating_kp"
        case movieLength = "movie_length"
        case genres

    }
}
