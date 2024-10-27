//
//  RotatingIndicator.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 23.10.2024.
//

import UIKit
import Kingfisher

final class RotatingIndicator: Indicator {

    // MARK: - Public properties

    var view: IndicatorView {
        return containerView
    }

    var centerOffset: CGPoint {
        return customCenterOffset ?? .zero
    }

    // MARK: - Private properties

    private let containerView = UIView()
    private let imageView = UIImageView()
    private var size: Int
    private var customCenterOffset: CGPoint?

    // MARK: - Initializers

    init(image: UIImage, size: Int) {
        self.size = size
        setupLoaderView(with: image)
    }

    // MARK: - Public methods

    func startAnimatingView() {
        imageView.isHidden = false
        containerView.isHidden = false
        let rotationAnimation = CABasicAnimation(keyPath: Resources.LoadingKeys.keyPath)
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 1
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: Resources.LoadingKeys.forKey)
    }

    func stopAnimatingView() {
        imageView.layer.removeAnimation(forKey: Resources.LoadingKeys.forKey)
        imageView.isHidden = true
        containerView.isHidden = true
    }

    func sizeStrategy(in imageView: KFCrossPlatformImageView) -> IndicatorSizeStrategy {
        return .size(CGSize(width: size, height: size))
    }

    func updateCenterOffset(_ offset: CGPoint) {
        customCenterOffset = offset
    }

    // MARK: - Private methods

    private func setupLoaderView(with image: UIImage) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true

        containerView.backgroundColor = .baseTertiaryAccent.withAlphaComponent(0.3)
        containerView.layer.cornerRadius = 10
        containerView.addSubview(imageView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.isHidden = true

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -5),
            containerView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -5),
            containerView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5)
        ])
    }
}
