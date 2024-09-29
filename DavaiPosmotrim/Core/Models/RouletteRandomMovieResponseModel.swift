//
//  RouletteRandomMovieResponseModel.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 27.09.2024.
//

import Foundation

struct RouletteRandomMovieResponseModel: Codable {
    let randomMovieId: Int

    private enum CodingKeys: String, CodingKey {
        case randomMovieId = "random_movie_id"
    }
}
