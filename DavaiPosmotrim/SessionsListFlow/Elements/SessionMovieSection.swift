//
//  SessionMovieSectionView.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 23.06.2024.
//

import UIKit

final class SessionMovieSection: UICollectionReusableView {

    // MARK: - Type properties
    static let sectionID = "SessionMovieSection"

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteBackground
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = .radiusLarge
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
