//
//  LeftAllignedLayout.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 10.07.2024.
//

import UIKit

final class LearAllignedLayout: UICollectionViewFlowLayout {

    required override init() {
        super.init()
        common()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        common()
    }

    private func common() {
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let att = super.layoutAttributesForElements(in:rect) else { return [] }
        var xPoint: CGFloat = sectionInset.left
        var yPoint: CGFloat = -1.0

        for attribute in att {
            if attribute.representedElementCategory != .cell { continue }

            if attribute.frame.origin.y >= yPoint { xPoint = sectionInset.left }
            attribute.frame.origin.x = xPoint
            xPoint += attribute.frame.width + minimumInteritemSpacing
            yPoint = attribute.frame.maxY
        }
        return att
    }
}
