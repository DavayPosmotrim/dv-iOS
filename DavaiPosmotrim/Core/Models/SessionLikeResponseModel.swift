//
//  SessionLikeResponseModel.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.09.2024.
//

import Foundation

struct SessionLikeResponseModel: Codable {
    let id: Int
    let sessionId: String
    let userId: String
    let movieId: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case sessionId = "session_id"
        case userId = "user_id"
        case movieId = "movie_id"
    }
}
