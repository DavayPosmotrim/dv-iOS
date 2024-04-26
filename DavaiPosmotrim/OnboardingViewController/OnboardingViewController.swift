//
//  OnboardingViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 22.04.2024.
//

import UIKit

struct PageModel {
    let image: UIImage
    let upperText: String
    let upperColoredText: String
    let lowerText: String
}

final class OnboardingViewController: UIViewController {

    // MARK: - Stored properties

    private struct Keys {
        static let nextButtonText = "ПРОДОЛЖИТЬ"
        static let beginButtonText = "НАЧАТЬ"

        static let firstOnboardingLowerLabelText = "Никаких лишних разговоров и долгих поисков."
        static let secondOnboardingLowerLabelText = "Выбирать фильмы можно с любым количеством людей."
        static let thirdOnboardingLowerLabelText = "Только самые любимые жанры или готовые подборки."

        static let firstOnboardingUpperLabelText = "Выбирайте фильмы\nбез стресса"
        static let secondOnboardingUpperLabelText = "Вдвоём или\nв большой компании"
        static let thirdOnboardingUpperLabelText = "Библиотека фильмов на любой вкус"

        static let coloredFirstUpperText = "без стресса"
        static let coloredSecondUpperText = "Вдвоём"
        static let coloredThirdUpperText = "на любой вкус"
    }

    private let pages: [PageModel] = [
        PageModel(
            image: .firstOnboarding,
            upperText: Keys.firstOnboardingUpperLabelText,
            upperColoredText: Keys.coloredFirstUpperText,
            lowerText: Keys.firstOnboardingLowerLabelText
        ),

        PageModel(
            image: .secondOnboarding,
            upperText: Keys.secondOnboardingUpperLabelText,
            upperColoredText: Keys.coloredSecondUpperText,
            lowerText: Keys.secondOnboardingLowerLabelText
        ),

        PageModel(
            image: .thirdOnboarding,
            upperText: Keys.thirdOnboardingUpperLabelText,
            upperColoredText: Keys.coloredThirdUpperText,
            lowerText: Keys.thirdOnboardingLowerLabelText
        )
    ]

    // MARK: - Computed properties

    private lazy var upperPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true

        return view
    }()

    private lazy var lowerPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true

        return view
    }()

    private lazy var nextButton: UIView = {
        let button = CustomButtons()
        button.viewSetup(with: button.purpleButton)
        button.purpleButton.setTitle(Keys.nextButtonText, for: .normal)
        button.purpleButton.addTarget(self, action: #selector(didTapNextButton(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var beginButton: UIView = {
        let button = CustomButtons()
        button.viewSetup(with: button.purpleButton)
        button.purpleButton.setTitle(Keys.beginButtonText, for: .normal)
        button.purpleButton.addTarget(self, action: #selector(didTapBeginButton(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(
            OnboardingCollectionViewCell.self,
            forCellWithReuseIdentifier: OnboardingCollectionViewCell.reuseIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.bouncesZoom = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false

        return collectionView
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = .zero
        pageControl.currentPageIndicatorTintColor = .basePrimaryAccent
        pageControl.pageIndicatorTintColor = .lightTertiaryAccent
        pageControl.addTarget(self, action: #selector(pageChanged(sender:)), for: .valueChanged)
        return pageControl
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baseBackground

        collectionView.dataSource = self
        collectionView.delegate = self

        addSubviews()
        constraintsSetup()
        toogleButtons()
    }

    // MARK: - Private methods

    private func addSubviews() {
        [upperPaddingView,
         collectionView,
         pageControl,
         lowerPaddingView,
         nextButton,
         beginButton
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            upperPaddingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            upperPaddingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            upperPaddingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            upperPaddingView.bottomAnchor.constraint(equalTo: lowerPaddingView.topAnchor, constant: -16),

            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: upperPaddingView.topAnchor, constant: 32),
            collectionView.bottomAnchor.constraint(equalTo: upperPaddingView.bottomAnchor, constant: -73),

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: upperPaddingView.bottomAnchor, constant: -28),

            lowerPaddingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            lowerPaddingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lowerPaddingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lowerPaddingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),

            beginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            beginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            beginButton.topAnchor.constraint(equalTo: lowerPaddingView.topAnchor, constant: 16),
            beginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            nextButton.leadingAnchor.constraint(equalTo: beginButton.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: beginButton.trailingAnchor),
            nextButton.topAnchor.constraint(equalTo: beginButton.topAnchor),
            nextButton.bottomAnchor.constraint(equalTo: beginButton.bottomAnchor)
        ])
    }

    private func toogleButtons() {
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            beginButton.isHidden = false
            nextButton.isHidden = true
        } else {
            beginButton.isHidden = true
            nextButton.isHidden = false
        }
    }

    // MARK: - Handlers

    @objc func didTapNextButton(sender: AnyObject) {
        guard let currentIndexPath = collectionView.indexPathsForVisibleItems.first else { return }
        let newIndexPath = IndexPath(item: currentIndexPath.item + 1, section: .zero)

        if newIndexPath.item < pages.count {
            collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
            pageControl.currentPage += 1
        }
        toogleButtons()
    }

    @objc func didTapBeginButton(sender: AnyObject) {
        // TODO: - add code to go to next viewController
         UserDefaults.standard.setValue(true, forKey: "isOnboardingShown")
    }

    @objc func pageChanged(sender: AnyObject) {
        guard let pageControl = sender as? UIPageControl else { return }
        collectionView.scrollToItem(
            at: IndexPath(item: pageControl.currentPage, section: .zero),
            at: .centeredHorizontally,
            animated: true
        )
        toogleButtons()
    }
}

    // MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingCollectionViewCell.reuseIdentifier,
            for: indexPath) as? OnboardingCollectionViewCell else {
            return UICollectionViewCell()
        }

        let currentPage = pages[indexPath.item]
        cell.configureCell(with: currentPage, and: indexPath)

        return cell
    }
}

    // MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
    -> CGSize {
        return CGSize(
            width: collectionView.frame.width,
            height: collectionView.frame.height
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int)
    -> CGFloat {
        return .zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int)
    -> CGFloat {
        return .zero
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
        toogleButtons()
    }
}
