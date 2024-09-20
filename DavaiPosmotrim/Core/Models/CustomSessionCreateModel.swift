//
//  CustomSessionCreateModel.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 15.07.2024.
//

import Foundation

struct CustomSessionCreateModel: Codable {
    let id: String
    let users: [CustomUserModel]
    let movies: [Int]
    let matchedMovies: [Int]
    let date: String?
    let status: StatusEnumModel

    private enum CodingKeys: String, CodingKey {
        case id
        case users
        case movies
        case matchedMovies = "matched_movies"
        case date
        case status
    }
}
