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
    let poster: String? // FORMAT - uri
    let alternative_name: String?
    let rating_kp: Double? // MAYBE FLOAT
    let movie_length: Int?
    let genres: [GenreModel]
}
