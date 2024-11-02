//
//  SelectionMovieCellModel.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 02.06.24.
//

import Foundation

struct SelectionMovieCellModel: Codable {
    let id: Int
    let movieImage: String?
    let nameMovieRu: String
    let ratingMovie: Double?
    let nameMovieEn: String?
    let yearMovie: Int?
    let countryMovie: [String]?
    let timeMovie: Int?
    let genre: [CollectionsCellModel]
    let details: SelectionMovieDetailsCellModel
}
