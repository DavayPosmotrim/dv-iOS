//
//  CustomButtons.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 23.04.2024.
//

import UIKit

final class CustomButtons: UIView {

    // MARK: - Stored properties

    private let tappedButtonAlpha = 0.7
    private let unTappedButtonAlpha = 1.0
    private let progressLayer = CAShapeLayer()
    private var progress: CGFloat = 0 {
        didSet {
            progressLayer.strokeEnd = progress
        }
    }

    var onProgressComplete: (() -> Void)?

    // MARK: - Lazy properties

    lazy var purpleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .basePrimaryAccent
        button.setTitleColor(.whiteText, for: .normal)
        button.titleLabel?.font = .textButtonMediumFont
        button.layer.cornerRadius = 12
        return button
    }()

    lazy var blackButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .baseTertiaryAccent
        button.setTitleColor(.whiteText, for: .normal)
        button.titleLabel?.font = .textButtonMediumFont
        button.layer.cornerRadius = 12
        return button
    }()

    lazy var grayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .baseBackground
        button.setTitleColor(.baseText, for: .normal)
        button.titleLabel?.font = .textButtonMediumFont
        button.layer.cornerRadius = 14
        return button
    }()

    lazy var progressButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .baseTertiaryAccent
        button.setTitleColor(.whiteText, for: .normal)
        button.titleLabel?.font = .textButtonMediumFont
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
            super.layoutSubviews()
            setupProgressLayer()
        }

    // MARK: - Public methods

    func setupView(with button: UIButton) {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        setupTapHandling(for: button)
    }

    // MARK: - Private methods

    private func setupTapHandling(for button: UIButton) {
        button.addTarget(self, action: #selector(tap), for: .touchDown)
        button.addTarget(self, action: #selector(unTap), for: .touchUpInside)
    }

    private func setupProgressLayer() {
        progressLayer.removeFromSuperlayer()
        let width = bounds.size.width
        let height = bounds.size.height
        let cornerRadius: CGFloat = 12
        let startPoint = CGPoint(x: width / 2, y: 0)
        let progressPath = UIBezierPath()
        progressPath.move(to: startPoint)
        progressPath.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        progressPath.addArc(
            withCenter: CGPoint(x: width - cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: -CGFloat.pi / 2,
            endAngle: 0,
            clockwise: true
        )
        progressPath.addLine(to: CGPoint(x: width, y: height - cornerRadius))
        progressPath.addArc(
            withCenter: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
            radius: cornerRadius,
            startAngle: 0,
            endAngle: CGFloat.pi / 2,
            clockwise: true
        )
        progressPath.addLine(to: CGPoint(x: cornerRadius, y: height))
        progressPath.addArc(
            withCenter: CGPoint(x: cornerRadius, y: height - cornerRadius),
            radius: cornerRadius,
            startAngle: CGFloat.pi / 2,
            endAngle: CGFloat.pi,
            clockwise: true
        )
        progressPath.addLine(to: CGPoint(x: 0, y: cornerRadius))
        progressPath.addArc(
            withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: CGFloat.pi,
            endAngle: -CGFloat.pi / 2,
            clockwise: true
        )
        progressPath.close()
        progressLayer.path = progressPath.cgPath
        progressLayer.strokeColor = UIColor.baseSecondaryAccent.cgColor
        progressLayer.lineWidth = 3
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
    }

    func startProgress(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        progressLayer.add(animation, forKey: "progressAnim")
    }

    // MARK: - Handlers

    @objc private func tap() {
        alpha = tappedButtonAlpha
    }

    @objc private func unTap() {
        alpha = unTappedButtonAlpha
    }
}

// MARK: - CAAnimationDelegate

extension CustomButtons: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            onProgressComplete?()
        }
    }
}
