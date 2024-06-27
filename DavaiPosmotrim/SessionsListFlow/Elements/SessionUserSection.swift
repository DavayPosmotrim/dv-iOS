//
//  SessionUserSection.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 24.06.2024.
//

import UIKit

final class SessionUserSection: UICollectionReusableView {

    static let sectionID = "SessionUserSection"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteBackground
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = .radiusLarge
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
