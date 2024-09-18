//
//  CustomSegmentedControl.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 17.05.24.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {

    private let segmentInset: CGFloat = 8
    private let segmentImage: UIImage? = UIImage(color: .baseTertiaryAccent)

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 15
        backgroundColor = .baseBackground

        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex),
            let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
            foregroundImageView.frame = foregroundImageView.frame.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = segmentImage
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = 12
        }
    }
}

private extension UIImage {

    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
