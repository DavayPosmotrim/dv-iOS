//
//  SessionsListResponseModel.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.09.2024.
//

import Foundation

struct SessionListUserResponseModel: Codable {
    let name: String
}

struct SessionsListResponseModel: Codable {
    let id: String
    let users: [SessionListUserResponseModel]
    let date: String
    let image: String?
    let matchedMoviesCount: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case users
        case date
        case image
        case matchedMoviesCount = "matched_movies_count"
    }
}
