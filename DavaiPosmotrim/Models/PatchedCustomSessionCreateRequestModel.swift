//
//  PatchedCustomSessionCreateRequestModel.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 15.07.2024.
//

import Foundation
struct PatchedCustomSessionCreateRequestModel: Codable {
    let date: String?
    let genres: [String]
    let collections: [String]
    let status: StatusEnumModel

    private enum CodingKeys: CodingKey {
        case date
        case genres
        case collections
        case status
    }
}
