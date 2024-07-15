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
    let matched_movies: [Int]
    let date: String? // FORMAT - date
    let status: StatusEnumModel
}
