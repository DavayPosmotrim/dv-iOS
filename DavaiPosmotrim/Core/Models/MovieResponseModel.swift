//
//  MatchedMovieResponseModel.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 27.09.2024.
//

import Foundation

struct MovieResponseModel: Codable {
    let id: Int
    let name: String
    let poster: String?

    private enum CodingKeys: CodingKey {
        case id
        case name
        case poster
    }
}
