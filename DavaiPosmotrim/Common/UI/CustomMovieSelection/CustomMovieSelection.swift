//
//  CustomMovieSelection.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 01.06.24.
//

import UIKit
import Kingfisher

protocol CustomMovieSelectionDelegate: AnyObject {
    func noButtonTapped(withId id: Int)
    func yesButtonTapped(withId id: Int)
    func comeBackButtonTapped()
}

// swiftlint: disable file_length

final class CustomMovieSelection: UIView {

    // MARK: - Public Properties

    weak var delegate: CustomMovieSelectionDelegate?
    var showButtons: Bool = true {
        didSet {
            noButton.isHidden = !showButtons
            comeBackButton.isHidden = !showButtons
            yesButton.isHidden = !showButtons
            updateAdditionalConstraints()
        }
    }

    var showCollection: Bool = true {
        didSet {
            collectionView.isHidden = !showCollection
            updateAdditionalConstraints()
        }
    }

    var showMovieCountries: Bool = true {
        didSet {
            guard let additionalModel else { return }
            configureUpdatedModel(model: additionalModel)
            clearAdditionalConstraints()
        }
    }

    // MARK: - Private Properties

    private var genresMovie: [CollectionsCellModel] = []
    private var currentMovieId: Int
    private var additionalModel: SelectionMovieCellModel?

    private var collectionViewHeightConstraint: NSLayoutConstraint?
    private var paddingViewHeightConstraint: NSLayoutConstraint?
    private var collectionViewToButtonConstraint: NSLayoutConstraint?
    private var collectionViewToBottomConstraint: NSLayoutConstraint?
    private var informationLabelToCollectionConstraint: NSLayoutConstraint?
    private var informationLabelToBottomConstraint: NSLayoutConstraint?

    // MARK: - Layout variables

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var paddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()

    private lazy var plugImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .noImagePlugWithText
        imageView.contentMode = .center
        imageView.isHidden = true
        return imageView
    }()

    private lazy var nameMovieLabel: UILabel = {
        let label = UILabel()
        label.font = .textHeadingFont
        label.textColor = .headingText
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .textParagraphBoldFont
        return label
    }()

    private lazy var nameMovieEnLabel: UILabel = {
        let label = UILabel()
        label.font = .textParagraphRegularFont
        label.textColor = .baseText
        return label
    }()

    private lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.font = .textCaptionRegularFont
        label.textColor = .baseText
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout.createLeftAlignedLayout(itemHeight: 28)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            CustomMovieCollectionCell.self,
            forCellWithReuseIdentifier: CustomMovieCollectionCell.reuseIdentifier
        )
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    private lazy var noButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.inactiveNoSelectionIcon, for: .normal)
        button.setImage(UIImage.activeNoSelectionIcon, for: .highlighted)
        button.addTarget(
            self,
            action: #selector(noButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var comeBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.inactiveRotateIcon, for: .normal)
        button.setImage(UIImage.activeRotateIcon, for: .highlighted)
        button.addTarget(
            self,
            action: #selector(comeBackButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var yesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.inactiveLikeIcon, for: .normal)
        button.setImage(UIImage.activeLikeIcon, for: .highlighted)
        button.addTarget(
            self,
            action: #selector(yesButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var linearGradientView = UIView()

    private lazy var overlayYesView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteBackground.withAlphaComponent(0.7)
        return view
    }()

    private lazy var overlayNoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteBackground.withAlphaComponent(0.7)
        return view
    }()

    // MARK: - Initializers

    init(model: SelectionMovieCellModel) {
        self.currentMovieId = model.id
        super.init(frame: .zero)
        backgroundColor = .whiteBackground
        layer.cornerRadius = 24
        collectionView.dataSource = self
        setupSubviews()
        setupConstraints()
        updateModel(model)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.layoutIfNeeded()
        setElementsHeight()
        linearGradientView.layer.sublayers?.first?.frame = linearGradientView.bounds
    }

    func updateModel(_ model: SelectionMovieCellModel) {
        configureWithModel(model: model)
        collectionView.reloadData()
    }

    func updateButtonImage(for percentage: CGFloat) {
        switch percentage {
        case let percentage where percentage > 0:
            yesButton.setImage(UIImage.activeLikeIcon, for: .normal)
            noButton.setImage(UIImage.inactiveNoSelectionIcon, for: .normal)
            overlayNoView.alpha = 0
            overlayYesView.alpha = 1 - percentage
        case let percentage where percentage < 0:
            noButton.setImage(UIImage.activeNoSelectionIcon, for: .normal)
            yesButton.setImage(UIImage.inactiveLikeIcon, for: .normal)
            overlayYesView.alpha = 0
            overlayNoView.alpha = 1 + percentage
        default:
            yesButton.setImage(UIImage.inactiveLikeIcon, for: .normal)
            noButton.setImage(UIImage.inactiveNoSelectionIcon, for: .normal)
            overlayYesView.alpha = 0
            overlayNoView.alpha = 0
        }
    }

    // MARK: - Actions

    @objc private func noButtonTapped() {
        noButton.setImage(UIImage.activeNoSelectionIcon, for: .normal)
        delegate?.noButtonTapped(withId: currentMovieId)
    }

    @objc private func comeBackButtonTapped() {
        delegate?.comeBackButtonTapped()
    }

    @objc private func yesButtonTapped() {
        yesButton.setImage(UIImage.activeLikeIcon, for: .normal)
        delegate?.yesButtonTapped(withId: currentMovieId)
    }
}

    // MARK: - Private Methods

private extension CustomMovieSelection {
    func configureWithModel(model: SelectionMovieCellModel) {
        plugImageView.isHidden = true
        additionalModel = model
        currentMovieId = model.id

        guard let encodedImagePath = model.movieImage,
              let decodedImagePath = encodedImagePath.removingPercentEncoding
        else {
            plugImageView.isHidden = false
            return
        }
        let imagePath = String(decodedImagePath.dropFirst())
        let imageURL = URL(string: imagePath)
        let activityIndicator = RotatingIndicator(image: UIImage.loader, size: 60)
        activityIndicator.updateCenterOffset(calculateLoaderOffset())
        imageView.kf.indicatorType = .custom(indicator: activityIndicator)
        imageView.kf.setImage(
            with: imageURL,
            options: [
                .transition(.fade(1)),
                .cacheMemoryOnly
            ]) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let value):
                    self.imageView.image = value.image
                case .failure:
                    plugImageView.isHidden = false
                }
                self.imageView.kf.indicatorType = .none
            }

        guard let rating = model.ratingMovie,
              let year = model.yearMovie,
              let countries = model.countryMovie?.prefix(3),
              let movieLength = model.timeMovie
        else { return }

        nameMovieLabel.text = model.nameMovieRu
        ratingLabel.text = String(format: "%.1f", rating)
        ratingLabel.textColor =  model.ratingMovie ?? 0 < 7 ? .captionDarkText : .doneAdditional
        nameMovieEnLabel.text = model.nameMovieEn

        // swiftlint: disable line_length

        informationLabel.text = "\(year) · \(countries.joined(separator: " · ")) · \(calculateHoursAndMinutes(from: movieLength))"

        // swiftlint: enable line_length

        genresMovie = model.genre
        updateButtonImage(for: 0)
    }

    func configureUpdatedModel(model: SelectionMovieCellModel) {
        guard let yearMovie = model.yearMovie,
              let timeMovie = model.timeMovie
        else { return }
        informationLabel.text = "\(yearMovie) · \(calculateHoursAndMinutes(from: timeMovie))"
    }

    func setupSubviews() {
        [
            imageView,
            paddingView,
            linearGradientView,
            plugImageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        [
            nameMovieLabel,
            ratingLabel,
            nameMovieEnLabel,
            informationLabel,
            collectionView,
            noButton,
            comeBackButton,
            yesButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            paddingView.addSubview($0)
        }
        overlayYesView.translatesAutoresizingMaskIntoConstraints = false
        yesButton.addSubview(overlayYesView)
        overlayNoView.translatesAutoresizingMaskIntoConstraints = false
        noButton.addSubview(overlayNoView)
        gradientLayer(linearGradientView)
    }

    // swiftlint: disable function_body_length

    func setupConstraints() {
        paddingViewHeightConstraint = paddingView.heightAnchor.constraint(
            equalToConstant: 0
        )

        collectionViewToButtonConstraint = collectionView.bottomAnchor.constraint(
            equalTo: noButton.topAnchor,
            constant: -8
        )
        collectionViewToBottomConstraint = collectionView.bottomAnchor.constraint(
            equalTo: paddingView.bottomAnchor,
            constant: 8
        )

        informationLabelToCollectionConstraint = informationLabel.bottomAnchor.constraint(
            equalTo: collectionView.topAnchor
        )
        informationLabelToBottomConstraint = informationLabel.bottomAnchor.constraint(
            equalTo: paddingView.bottomAnchor,
            constant: -24
        )

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            paddingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            paddingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            paddingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            paddingView.topAnchor.constraint(equalTo: linearGradientView.bottomAnchor),
            paddingViewHeightConstraint!,

            linearGradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            linearGradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            linearGradientView.heightAnchor.constraint(equalToConstant: 150),

            plugImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 78),
            plugImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -78),
            plugImageView.topAnchor.constraint(equalTo: topAnchor, constant: 97.5),
            plugImageView.bottomAnchor.constraint(equalTo: paddingView.topAnchor, constant: -97.5),

            noButton.widthAnchor.constraint(equalToConstant: 48),
            noButton.heightAnchor.constraint(equalToConstant: 48),
            noButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            noButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),

            comeBackButton.widthAnchor.constraint(equalToConstant: 40),
            comeBackButton.heightAnchor.constraint(equalToConstant: 40),
            comeBackButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            comeBackButton.centerYAnchor.constraint(equalTo: noButton.centerYAnchor),

            yesButton.widthAnchor.constraint(equalToConstant: 48),
            yesButton.heightAnchor.constraint(equalToConstant: 48),
            yesButton.centerYAnchor.constraint(equalTo: noButton.centerYAnchor),
            yesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            overlayYesView.widthAnchor.constraint(equalTo: yesButton.widthAnchor),
            overlayYesView.heightAnchor.constraint(equalTo: yesButton.heightAnchor),
            overlayYesView.centerXAnchor.constraint(equalTo: yesButton.centerXAnchor),
            overlayYesView.centerYAnchor.constraint(equalTo: yesButton.centerYAnchor),

            overlayNoView.widthAnchor.constraint(equalTo: noButton.widthAnchor),
            overlayNoView.heightAnchor.constraint(equalTo: noButton.heightAnchor),
            overlayNoView.centerXAnchor.constraint(equalTo: noButton.centerXAnchor),
            overlayNoView.centerYAnchor.constraint(equalTo: noButton.centerYAnchor),

            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),

            informationLabel.leadingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
            informationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),

            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            ratingLabel.bottomAnchor.constraint(equalTo: informationLabel.topAnchor, constant: -8),
            ratingLabel.widthAnchor.constraint(equalToConstant: 25),

            nameMovieEnLabel.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            nameMovieEnLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 8),
            nameMovieEnLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),

            nameMovieLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameMovieLabel.bottomAnchor.constraint(equalTo: ratingLabel.topAnchor, constant: -12),
            nameMovieLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameMovieLabel.topAnchor.constraint(equalTo: paddingView.topAnchor)
        ])
        updateAdditionalConstraints()
    }

    // swiftlint: enable function_body_length

    func updateAdditionalConstraints() {
        collectionViewToButtonConstraint?.isActive = showButtons
        collectionViewToBottomConstraint?.isActive = !showButtons
        informationLabelToCollectionConstraint?.isActive = showCollection
        informationLabelToBottomConstraint?.isActive = !showCollection
    }

    func clearAdditionalConstraints() {
        collectionViewToButtonConstraint?.isActive = false
        collectionViewToBottomConstraint?.isActive = false
        informationLabelToCollectionConstraint?.isActive = false
        informationLabelToBottomConstraint?.isActive = false
    }

    func calculatePaddingHeight(for collectionHeight: CGFloat) -> CGFloat {
        let verticalPadding: CGFloat = showButtons ? 52 : 28
        let nameMovieLabelHeight = nameMovieLabel.intrinsicContentSize.height
        let ratingLabelHeight = ratingLabel.intrinsicContentSize.height
        let informationLabelHeight = informationLabel.intrinsicContentSize.height
        let buttonHeight = showButtons ? noButton.intrinsicContentSize.height : 0
        let elementsHeight = nameMovieLabelHeight +
        ratingLabelHeight +
        informationLabelHeight +
        buttonHeight +
        collectionHeight
        let totalHeight = elementsHeight + verticalPadding
        return totalHeight
    }

    func setElementsHeight() {
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        print(contentHeight)
        collectionViewHeightConstraint?.constant = contentHeight

        let height = calculatePaddingHeight(for: contentHeight)
        print(height)
        paddingViewHeightConstraint?.constant = height
    }

    func gradientLayer(_ view: UIView) {
        let gradientLayer = CAGradientLayer()
        let startColor: UIColor = .white.withAlphaComponent(.zero)
        let endColor: UIColor = .white
        let gradientColors: [CGColor] = [startColor.cgColor, endColor.cgColor]
        gradientLayer.colors = gradientColors
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func calculateHoursAndMinutes(from totalMinutes: Int) -> String {
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        var parts = [String]()
        if hours > 0 {
            let hourWord: String
            switch hours % 10 {
            case 1 where hours % 100 != 11:
                hourWord = "час"
            case 2...4 where !(hours % 100 == 12 || hours % 100 == 13 || hours % 100 == 14):
                hourWord = "часа"
            default:
                hourWord = "часов"
            }
            parts.append("\(hours) \(hourWord)")
        }

        if minutes > 0 {
            let minuteWord: String
            switch minutes % 10 {
            case 1 where minutes % 100 != 11:
                minuteWord = "минута"
            case 2...4 where !(minutes % 100 == 12 || minutes % 100 == 13 || minutes % 100 == 14):
                minuteWord = "минуты"
            default:
                minuteWord = "минут"
            }
            parts.append("\(minutes) \(minuteWord)")
        }

        return parts.joined(separator: " ")
    }

    func calculateLoaderOffset() -> CGPoint {
        let viewHeight = self.frame.height
        let distance = viewHeight - paddingView.frame.minY
        let centerY = distance / 2
        return CGPoint(x: 0, y: -centerY)
    }
}

// MARK: - UICollectionViewDataSource

extension CustomMovieSelection: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return genresMovie.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomMovieCollectionCell.reuseIdentifier,
            for: indexPath
        ) as? CustomMovieCollectionCell else {
            return UICollectionViewCell()
        }
        let genre = genresMovie[indexPath.item]
        cell.configure(model: genre)
        setNeedsLayout()
        return cell
    }
}

// swiftlint: enable file_length
