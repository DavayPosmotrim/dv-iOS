//
//  TempModels.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.07.2024.
//

import Foundation

struct CustomUserRequestModel: Codable {
    let name: String

    private enum CodingKeys: CodingKey {
        case name
    }
}

struct CustomUserModel: Codable {
    let name: String
    let deviceId: String

    private enum CodingKeys: String, CodingKey {
        case name
        case deviceId = "device_id"
    }
}
