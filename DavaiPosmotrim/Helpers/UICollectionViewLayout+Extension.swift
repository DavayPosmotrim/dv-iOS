//
//  UICollectionViewLayout+Extension.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 14.05.24.
//

import UIKit

extension UICollectionViewLayout {

    static func createLeftAlignedLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(40), heightDimension: .absolute(36))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50)),
            subitems: [item]
        )
        group.contentInsets = .init(
            top: 0,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(
            top: 16,
            leading: 0,
            bottom: 16,
            trailing: 0
        )
        return UICollectionViewCompositionalLayout(section: section)
    }
}
