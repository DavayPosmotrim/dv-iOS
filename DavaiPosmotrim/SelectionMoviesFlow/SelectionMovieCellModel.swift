//
//  SelectionMovieCellModel.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 02.06.24.
//

import Foundation

struct SelectionMovieCellModel {
    let id = UUID()
    let movieImage: String
    let nameMovieRu: String
    let ratingMovie: String
    let nameMovieEn: String
    let yearMovie: String
    let countryMovie: [String]
    let timeMovie: String
    let genre: [CollectionsCellModel]
    let details: SelectionMovieDetailsCellModel
}
