//
//  MainCellModel.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 01.05.24.
//

import UIKit

struct MainCellModel {
    let title: String
    let textColor: UIColor
    let paddingBackgroundColor: UIColor
    let buttonImage: UIImage
    let buttonColor: UIColor
}

private struct Keys {
    static let titleLabelTextCellOne = "Создать сеанс"
    static let titleLabelTextCellTwo = "Понравившиеся фильмы"
    static let titleLabelTextCellThree = "Присоединиться к сеансу"
}

let mainCellModels: [MainCellModel] = [
    MainCellModel(
        title: Keys.titleLabelTextCellOne,
        textColor: .whiteText,
        paddingBackgroundColor: .basePrimaryAccent,
        buttonImage: UIImage.circledForwardIcon.withRenderingMode(.alwaysTemplate),
        buttonColor: .whiteBackground
    ),
    MainCellModel(
        title: Keys.titleLabelTextCellTwo,
        textColor: .baseText,
        paddingBackgroundColor: .baseSecondaryAccent,
        buttonImage: UIImage.circledHeartIcon.withRenderingMode(.alwaysTemplate),
        buttonColor: .baseTertiaryAccent
    ),
    MainCellModel(
        title: Keys.titleLabelTextCellThree,
        textColor: .whiteText,
        paddingBackgroundColor: .baseTertiaryAccent,
        buttonImage: UIImage.circledForwardIcon.withRenderingMode(.alwaysTemplate),
        buttonColor: .whiteBackground
    )
]
