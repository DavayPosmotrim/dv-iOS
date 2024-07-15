//
//  MovieModel.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 15.07.2024.
//

import Foundation

struct MovieModel: Codable {
    let id: Int
    let name: String
    let poster: String? // FORMAT - uri
}
