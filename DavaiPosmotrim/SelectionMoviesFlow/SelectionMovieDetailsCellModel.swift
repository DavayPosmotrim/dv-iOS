//
//  MovieDetailsCellModel.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 02.07.2024.
//

import Foundation

struct SelectionMovieDetailsCellModel {
    let descreption: String
    let mainRoles: [String]
    let derictor: String
    let rating: [RatingCell]
}

struct RatingCell {
    let name: String
    let rating: String
    let votesAmount: Int
}
