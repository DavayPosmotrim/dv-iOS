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

// MARK: - Mock data
extension SessionModel {
    static let mockData: [SessionModel] = [
        SessionModel(
            code: "VMst456",
            date: "23 сентября 2023",
            matches: 1,
            imageName: "Mok_5",
            users: [
                ReusableCollectionCellModel(id: "", title: "Артём (вы)"),
                ReusableCollectionCellModel(id: "", title: "Анна"),
                ReusableCollectionCellModel(id: "", title: "Никита"),
                ReusableCollectionCellModel(id: "", title: "Руслан")
            ],
            movies: mockMoviesData
        ),
        SessionModel(
            code: "VMst456",
            date: "22 сентября 2023",
            matches: 12,
            imageName: "Mok_6",
            users: [
                ReusableCollectionCellModel(id: "", title: "Артём (вы)"),
                ReusableCollectionCellModel(id: "", title: "Анна")
            ],
            movies: mockMoviesData
        ),
        SessionModel(
            code: "VMst456",
            date: "20 сентября 2023",
            matches: 3,
            imageName: "Mok_3",
            users: [
                ReusableCollectionCellModel(id: "", title: "Артём (вы)"),
                ReusableCollectionCellModel(id: "", title: "Анна"),
                ReusableCollectionCellModel(id: "", title: "Никита")
            ],
            movies: mockMoviesData
        ),
        SessionModel(
            code: "VMst456",
            date: "22 сентября 2023",
            matches: 5555555,
            imageName: nil,
            users: [
                ReusableCollectionCellModel(id: "", title: "Артём (вы)"),
                ReusableCollectionCellModel(id: "", title: "Анна")
                   ],
            movies: mockMoviesData
        )
    ]

    static let mockMoviesData: [ReusableLikedMoviesCellModel] = [
        ReusableLikedMoviesCellModel(id: 1, title: "Into the wild", imageName: "Mok_7"),
        ReusableLikedMoviesCellModel(id: 2, title: "Дюна", imageName: "Mok_8"),
        ReusableLikedMoviesCellModel(id: 3, title: "Даласский клуб покупателей", imageName: "Mok_9"),
        ReusableLikedMoviesCellModel(id: 4, title: "Властелин колец: Две крепости", imageName: nil),
        ReusableLikedMoviesCellModel(id: 5, title: "Into the wild", imageName: "Mok_7"),
        ReusableLikedMoviesCellModel(id: 6, title: "Дюна", imageName: "Mok_8"),
        ReusableLikedMoviesCellModel(id: 7, title: "Очень длинное название фильма. Такое длинное, что такие, наверное, просто не смотрят", imageName: "Mok_9"),
        ReusableLikedMoviesCellModel(id: 8, title: "Властелин колец: Братство кольца", imageName: nil),
        ReusableLikedMoviesCellModel(id: 9, title: "1917", imageName: nil),
        ReusableLikedMoviesCellModel(id: 10, title: "Грань будущего", imageName: nil),
        ReusableLikedMoviesCellModel(id: 11, title: "Звездные войны: Возвращение джедая", imageName: "Mok_8"),
        ReusableLikedMoviesCellModel(id: 12, title: "Властелин колец: Возвращение короля", imageName: "Mok_7")
    ]
}
