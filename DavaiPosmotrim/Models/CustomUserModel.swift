//
//  CustomUserModel.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 15.07.2024.
//

import Foundation

struct CustomUserModel: Codable {
    let name: String
    let deviceId: String

    private enum CodingKeys: String, CodingKey {
        case name
        case deviceId = "device_id"
    }
}
