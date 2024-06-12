//
//  SessionsListModel.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 07.06.2024.
//

import Foundation

struct User: Identifiable, Equatable {
    let id = UUID()
    let name: String
}

struct SessionModel: Identifiable, Equatable {
    let id = UUID()
    let date: String
    let intersections: Int
    let imageName: String
    let user: [User]
}

struct SessionsListModel {
    let sessions: [SessionModel]
}
