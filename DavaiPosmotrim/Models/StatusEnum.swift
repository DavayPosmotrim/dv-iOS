//
//  StatusEnum.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 15.07.2024.
//

import Foundation

enum StatusEnumModel: String, Codable {
    case waiting = "waiting"
    case voting = "voting"
    case closed = "closed"
    // TODO: Посмотреть как будет работать и убрать/оставить строки
}
