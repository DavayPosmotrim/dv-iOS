//
//  CustomMovieCollectionFooter.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 10.07.2024.
//

import UIKit

final class CustomMovieDetailsCollectionFooter: UICollectionReusableView {

    static let identifier = "CustomMovieDetailsCollectionFooter"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
