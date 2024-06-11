//
//  UIImage+Extension.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 10.06.24.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
