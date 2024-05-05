//
//  NoInternetViewController.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 03.05.2024.
//

import UIKit

final class NoInternetViewController: UIViewController {
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 12
        return stack
    }()

    lazy var image: UIImage = {
        let image = UIImage(resource: .noInternetPlug)
        return image
    }()

    lazy var header: UILabel = {
        let label = UILabel()
        label.textColor = .headingText
        label.font = .
        return label
    }()

    private lazy var button: CustomButtons = {
        let button = CustomButtons()
        button.setupView(with: button.purpleButton)
//        button.purpleButton.setTitle(Keys.beginButtonText, for: .normal)
        button.purpleButton.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        return button
    }()

    private @objc func didTapButton(sender: AnyObject) {
        print("Button tapped")
    }

}
