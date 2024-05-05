//
//  MistakesViewController.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 03.05.2024.
//

import UIKit

final class MistakesViewController: UIViewController {

    enum MistakeType {
        case noInternet
        case serviceUnavailable
        case oldVersion
    }

    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
         stack.spacing = 12
        return stack
    }()

    private lazy var image = UIImageView(image: .noInternetPlug)

    private lazy var header: UILabel = {
        let label = UILabel()
        label.textColor = .headingText
        label.font = .textLabelFont
        label.text = Resources.Strings.Mistakes.noInternetHeader
        return label
    }()

    private lazy var text: UILabel = {
        let label = UILabel()
        label.textColor = .baseText
        label.font = .textParagraphRegularFont
        label.text = Resources.Strings.Mistakes.noInternetText
        label.numberOfLines = 2
        return label
    }()

    private lazy var button: RoundedButton = RoundedButton()
    var type: MistakeType

    // MARK: - Inits

    init(type: MistakeType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
    }
}

// MARK: - Private methods

private extension MistakesViewController {
    @objc func didTapButton(sender: AnyObject) {
        print("Button tapped")
    }

    func setupUI() {
        view.backgroundColor = .whiteBackground

        [vStack, button].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [image, header, text].forEach {
            vStack.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -72),

            image.topAnchor.constraint(equalTo: vStack.topAnchor),
            image.heightAnchor.constraint(equalToConstant: 200),
            image.widthAnchor.constraint(equalToConstant: 200),

            header.heightAnchor.constraint(equalToConstant: 24),
            header.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 36),

            text.heightAnchor.constraint(equalToConstant: 40),
            text.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),

            button.heightAnchor.constraint(equalToConstant: 48),
            button.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 32),
            button.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
    }

    func setupButton() {
        button.configure(title: Resources.Strings.Mistakes.noInternetButtonTitle, type: .accentPrimary)
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
    }
}
