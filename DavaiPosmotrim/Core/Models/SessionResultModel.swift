//
//  SessionResultModel.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 19.09.2024.
//

import Foundation

struct SessionResultModel: Codable {
    let id: String
    let users: [String]
    let matchedMovies: [MovieDetailModel]
    let date: String
    let image: String
    let matchedMoviesCount: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case users
        case matchedMovies = "matched_movies"
        case date
        case image
        case matchedMoviesCount = "matched_movies_count"
    }
}
