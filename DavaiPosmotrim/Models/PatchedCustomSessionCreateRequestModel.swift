//
//  PatchedCustomSessionCreateRequestModel.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 15.07.2024.
//

import Foundation
struct PatchedCustomSessionCreateRequestModel: Codable {
    let date: String? // FORMAT - date
    let genres: [String]
    let collections: [String]
    let status: StatusEnumModel
}
