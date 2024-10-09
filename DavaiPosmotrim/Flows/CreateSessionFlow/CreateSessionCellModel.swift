//
//  CreateSessionCellModel.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 07.05.24.
//

import Foundation

struct TableViewCellModel {
    let id = UUID()
    let title: String
    let slug: String
    let movieImage: String
}

struct CollectionsCellModel {
    let id = UUID()
    let title: String
}

struct CreateSessionModel {
    var collectionsMovie: [CollectionsMovie]
    var genresMovie: [GenresMovie]
}

struct CollectionsMovie {
    let id: UUID
    let slug: String
    let title: String
}

struct GenresMovie {
    let id: UUID
    let title: String
}
