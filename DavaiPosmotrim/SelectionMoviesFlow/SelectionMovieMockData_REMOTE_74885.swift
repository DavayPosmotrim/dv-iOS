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
        ],
        details: SelectionMovieDetailsCellModel(
            description: "После окончания колледжа Эмори один из его ведущих студентов и атлетов Кристофер МакКэндлесс оставляет все свое имущество, отдает накопленные за время учебы 24 тыс. ",
            ratingKp: 8.9,
            ratingImdb: 5.6,
            votesKp: 12125,
            votesImdb: 353535,
            directors: ["Шон Пенн"],
            actors: ["Эмиль Хирш", "Хэл Холбрук", "Марша Гей Харден", "Уильям Хёрт"]
        )
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
        ],
        details: SelectionMovieDetailsCellModel(
            description: """
Наследник знаменитого дома Атрейдесов Пол отправляется вместе с семьей на одну из самых опасных планет во Вселенной — Арракис.
Здесь нет ничего, кроме песка, палящего солнца, гигантских чудовищ и основной причины межгалактических конфликтов — невероятно ценного ресурса, который называется меланж.
В результате захвата власти Пол вынужден бежать и скрываться, и это становится началом его эпического путешествия.
Враждебный мир Арракиса приготовил для него множество тяжелых испытаний, но только тот, кто готов взглянуть в глаза своему страху, достоин стать избранным.
""",
            ratingKp: 6.6,
            ratingImdb: 7.7,
            votesKp: 151,
            votesImdb: 235554,
            directors: ["Дени Вильнёв"],
            actors: ["Тимоти Шаломе", "Джош Борлин", "Ребекка Фергюсон", "Оскар Айзек"])
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
        ],
        details: SelectionMovieDetailsCellModel(
            description: """
Реальная история Рона Вудруфа, техасского электрика, у которого в 1985 году обнаружили СПИД.
Врачи отвели ему всего 30 дней, но он не пожелал смириться со смертным приговором и сумел продлить свою жизнь, принимая нетрадиционные лекарства,
а затем наладил подпольный бизнес по продаже их другим больным.
""",
            ratingKp: 7.0,
            ratingImdb: 5.0,
            votesKp: 501126,
            votesImdb: 301792,
            directors: ["Жак-Марк Валле"],
            actors: ["Меттью Макконахи", "Джаред Лето", "Дженифер Гарнер", "Дэнис О'Хер"])
    )
]
