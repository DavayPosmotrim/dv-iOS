//
//  SessionsListModel.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 07.06.2024.
//

import Foundation

struct User: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
}

struct SessionModel: Identifiable, Equatable, Hashable {
    let id = UUID()
    let date: String
    let matches: Int
    let imageName: String?
    let users: [User]
}

struct SessionsListModel {
    let sessions: [SessionModel]
}

