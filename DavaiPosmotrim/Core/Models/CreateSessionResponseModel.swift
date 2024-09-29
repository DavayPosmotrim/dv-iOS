//
//  CreateSessionResponseModel.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.09.2024.
//

import Foundation

struct CreateSessionResponseModel: Codable {
    let id: String
    let users: [String]
    let movies: [Int]
    let matchedMovies: [Int]?
    let date: String
    let status: String
    let image: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case users
        case movies
        case matchedMovies = "matched_movies"
        case date
        case status
        case image
    }
}
