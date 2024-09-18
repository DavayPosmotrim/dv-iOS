//
//  MistakesViewController.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 03.05.2024.
//

import UIKit

// MARK: - Class

final class MistakesViewController: UIViewController {

    // MARK: - Constants

    enum MistakeType {
        case noInternet
        case serviceUnavailable
        case oldVersion
        case noCollections
    }

    enum Constants {
        static let verticalShift: CGFloat = -72.0
    }

    // MARK: - Public property

    var type: MistakeType

    // MARK: - Private properties

    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = .spacingBase
        return stack
    }()

    private lazy var image = UIImageView()

    private lazy var header: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .headingText
        label.font = .textLabelFont
        return label
    }()

    private lazy var text: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .baseText
        label.font = .textParagraphRegularFont
        return label
    }()

    private lazy var button = RoundedButton()

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
        setupLabels()
        setupButton()
    }
}

// MARK: - Private methods

private extension MistakesViewController {

    // MARK: - Actions

    @objc func didTapNoInternetButton(sender: AnyObject) {
        // TODO: - add code later
    }

    @objc func didTapOldVersionButton(sender: AnyObject) {
        // TODO: - add code later
    }

    @objc func didTapNoCollectionsButton(sender: AnyObject) {
        // TODO: - add code later
    }

    // MARK: - Setup UI

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
            vStack.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: Constants.verticalShift),

            image.topAnchor.constraint(equalTo: vStack.topAnchor),
            image.heightAnchor.constraint(equalToConstant: .placeholderSize),
            image.widthAnchor.constraint(equalToConstant: .placeholderSize),

            header.heightAnchor.constraint(equalToConstant: .textHeadingHeight),

            text.heightAnchor.constraint(equalToConstant: .textParagraphHeightTwoLines),

            button.heightAnchor.constraint(equalToConstant: .buttonHeight),
            button.topAnchor.constraint(equalTo: text.bottomAnchor, constant: .spacingExtraLarge),
            button.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .spacingMedium),
            button.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -.spacingMedium)
        ])
    }

    func setupLabels() {
        switch type {
        case .noInternet:
            image.image = UIImage(resource: .noInternetPlug)
            header.text = Resources.Mistakes.noInternetHeader
            text.text = Resources.Mistakes.noInternetText
        case .serviceUnavailable:
            image.image = UIImage(resource: .unavailableServicePlug)
            header.text = Resources.Mistakes.serviceUnavailableHeader
            text.text = Resources.Mistakes.serviceUnavailableText
        case .oldVersion:
            image.image = UIImage(resource: .oldAppVersionPlug)
            header.text = Resources.Mistakes.oldVersionHeader
            text.text = Resources.Mistakes.oldVersionText
        case .noCollections:
            image.image = UIImage(resource: .unavailableServicePlug)
            header.text = Resources.Mistakes.noCollectionsHeader
            text.text = Resources.Mistakes.noCollectionsText
        }
    }

    func setupButton() {
        switch type {
        case .noInternet:
            button.isHidden = false
            button.configure(title: Resources.Mistakes.noInternetButtonTitle, type: .accentPrimary)
            button.addTarget(self, action: #selector(didTapNoInternetButton(sender:)), for: .touchUpInside)
        case .serviceUnavailable:
            button.isHidden = true
        case .oldVersion:
            button.isHidden = false
            button.configure(title: Resources.Mistakes.oldVersionButtonTitle, type: .accentPrimary)
            button.addTarget(self, action: #selector(didTapOldVersionButton(sender:)), for: .touchUpInside)
        case .noCollections:
            button.isHidden = false
            button.configure(title: Resources.Mistakes.noCollectionsButtonTitle, type: .accentPrimary)
            button.addTarget(self, action: #selector(didTapNoCollectionsButton(sender:)), for: .touchUpInside)
        }
    }
}
