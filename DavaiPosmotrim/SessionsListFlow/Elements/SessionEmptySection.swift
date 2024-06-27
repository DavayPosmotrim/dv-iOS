//
//  SessionEmptySection.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 27.06.2024.
//

import UIKit

final class SessionEmptySection: UICollectionReusableView {

    static let sectionID = "SessionEmptySection"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .baseBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
