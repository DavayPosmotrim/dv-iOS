//
//  SelectionMovieMockData.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 02.06.24.
//

import Foundation

let selectionMovieMockData = [
    SelectionMovieCellModel(
        movieImage: "Mok_7",
        nameMovieRu: "В диких условиях",
        ratingMovie: "7.9",
        nameMovieEn: "Into the Wild",
        yearMovie: "2007 год",
        countryMovie: ["США"],
        timeMovie: "2 ч 28 мин",
        genre: [
            CollectionsCellModel(title: "Исторический"),
            CollectionsCellModel(title: "Биография"),
            CollectionsCellModel(title: "Драма")
        ]
    ),
    SelectionMovieCellModel(
        movieImage: "Mok_8",
        nameMovieRu: "Дюна",
        ratingMovie: "5.5",
        nameMovieEn: "Dune",
        yearMovie: "2021 год",
        countryMovie: ["США", "Канада", "Венгрия"],
        timeMovie: "2 ч 35 мин",
        genre: [
            CollectionsCellModel(title: "Фантастика"),
            CollectionsCellModel(title: "Боевик"),
            CollectionsCellModel(title: "Драма"),
            CollectionsCellModel(title: "Приключения")
        ]
    ),
    SelectionMovieCellModel(
        movieImage: "Mok_9",
        nameMovieRu: "Даллаский клуб покупателей",
        ratingMovie: "9.0",
        nameMovieEn: "Dallas Buyers Club",
        yearMovie: "2013 год",
        countryMovie: ["США"],
        timeMovie: "1 ч 58 мин",
        genre: [
            CollectionsCellModel(title: "Драма"),
            CollectionsCellModel(title: "Биография")
        ]
    )
]
