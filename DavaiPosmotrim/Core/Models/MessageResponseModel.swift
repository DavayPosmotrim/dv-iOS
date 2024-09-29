//
//  MessageResponseModel.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.09.2024.
//

import Foundation

struct MessageResponseModel: Codable {
    let message: String

    private enum CodingKeys: CodingKey {
        case message
    }
}
