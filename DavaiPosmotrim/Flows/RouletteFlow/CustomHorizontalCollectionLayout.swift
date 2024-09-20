//
//  CustomHorizontalCollectionLayout.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 18.07.2024.
//

import UIKit

final class CustomHorizontalCollectionLayout: UICollectionViewFlowLayout {

    let activeDistance: CGFloat = 200
    let zoomFactor: CGFloat = 0.2

    override init() {
        super.init()
        scrollDirection = .horizontal
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesArray = super.layoutAttributesForElements(in: rect),
              let contentOffset = collectionView?.contentOffset,
              let bounds = collectionView?.bounds.size else {
            return nil
        }

        let visibleRect = CGRect(origin: contentOffset, size: bounds)
        let centerX = visibleRect.midX

        for attributes in attributesArray {
            let distance = centerX - attributes.center.x
            let normalizedDistance = distance / activeDistance
            if abs(distance) < activeDistance {
                let zoom = 1 + zoomFactor * (1 - abs(normalizedDistance))
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                attributes.zIndex = Int(zoom.rounded())
            }
        }

        return attributesArray
    }

    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(
                forProposedContentOffset: proposedContentOffset,
                withScrollingVelocity: velocity
            )
        }

        let proposedRect = CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)
        guard let layoutAttributes = self.layoutAttributesForElements(in: proposedRect) else {
            return super.targetContentOffset(
                forProposedContentOffset: proposedContentOffset,
                withScrollingVelocity: velocity
            )
        }

        let centerX = proposedContentOffset.x + collectionView.bounds.width / 2
        let closestAttribute = layoutAttributes.min(by: {
            abs($0.center.x - centerX) < abs($1.center.x - centerX)
        }) ?? UICollectionViewLayoutAttributes()

        let targetContentOffsetX = closestAttribute.center.x - collectionView.bounds.width / 2

        return CGPoint(x: targetContentOffsetX, y: proposedContentOffset.y)
    }
}
