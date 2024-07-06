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
    let code: String
    let date: String
    let matches: Int
    let imageName: String?
    let users: [User]
    let movies: [SessionMovieModel]
}

struct SessionMovieModel: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String?
}

struct SessionsListModel {
    let sessions: [SessionModel]
}

// MARK: - Mock data
extension SessionModel {
    static let mockData: [SessionModel] = [
        SessionModel(
            code: "VMst456",
            date: "23 сентября 2023",
            matches: 1,
            imageName: "Mok_5",
            users: [User(name: "Артём (вы)"), User(name: "Анна"), User(name: "Никита"), User(name: "Руслан")],
            movies: SessionMovieModel.mockData
        ),
        SessionModel(
            code: "VMst456",
            date: "22 сентября 2023",
            matches: 12,
            imageName: "Mok_6",
            users: [User(name: "Артём (вы)"), User(name: "Анна")],
            movies: SessionMovieModel.mockData
        ),
        SessionModel(
            code: "VMst456",
            date: "20 сентября 2023",
            matches: 3,
            imageName: "Mok_3",
            users: [User(name: "Артём (вы)"), User(name: "Анна"), User(name: "Никита")],
            movies: SessionMovieModel.mockData
        ),
        SessionModel(
            code: "VMst456",
            date: "22 сентября 2023",
            matches: 5555555,
            imageName: nil,
            users: [User(name: "Артём (вы)"), User(name: "Анна")],
            movies: SessionMovieModel.mockData
        )
    ]
}

extension SessionMovieModel {
    static let mockData: [SessionMovieModel] = [
        SessionMovieModel(name: "Общество мёртвых поэтов", imageName: "Mok_5"),
        SessionMovieModel(name: "Супербродяга", imageName: "Mok_6"),
        SessionMovieModel(name: "Скотт Пилигрим против всех", imageName: "Mok_3"),
        SessionMovieModel(name: "Дюна", imageName: "Mok_5"),
        SessionMovieModel(name: "Дюна 2", imageName: nil),
        SessionMovieModel(name: "Властелин колец: Две крепости", imageName: nil),
        SessionMovieModel(name: "Властелин колец: Четыре крепости", imageName: nil),
        SessionMovieModel(name: "Властелин колец: Двадцать две крепости", imageName: nil)
    ]
}
