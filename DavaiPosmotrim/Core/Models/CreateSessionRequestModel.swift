//
//  CreateSessionRequestModel.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.09.2024.
//

import Foundation

struct CreateSessionRequestModel: Codable {
    let genres: [String]?
    let collections: [String]?

    private enum CodingKeys: CodingKey {
        case genres
        case collections
    }
}
