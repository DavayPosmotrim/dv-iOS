//
//  ConnectUserResponseModel.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 09.10.2024.
//

import Foundation

struct ConnectUserResponseModel: Codable {
    let message: String
    let users: [CustomUserModel]

    private enum CodingKeys: CodingKey {
        case message
        case users
    }
}
