//
//  SessionsListModel.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 07.06.2024.
//

import Foundation

struct SessionModel: Identifiable, Equatable, Hashable {
    let id = UUID()
    let code: String
    let date: String
    let matches: Int
    let imageName: String?
    let users: [ReusableCollectionCellModel]
    let movies: [ReusableLikedMoviesCellModel]
}

struct SessionsListModel {
    let sessions: [SessionModel]
}
