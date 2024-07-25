//
//  CollectionModel.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 15.07.2024.
//

import Foundation

struct CollectionModel: Codable {
    let name: String
    let slug: String?
    let cover: String

    private enum CodingKeys: CodingKey {
        case name
        case slug
        case cover
    }
}
