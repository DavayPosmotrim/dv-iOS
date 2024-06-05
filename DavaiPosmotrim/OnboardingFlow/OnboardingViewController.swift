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

    var presenter: OnboardingPresenterProtocol?

    private let pages: [PageModel] = [
        PageModel(
            image: .firstOnboarding,
            upperText: Resources.Onboarding.firstOnboardingUpperLabelText,
            upperColoredText: Resources.Onboarding.coloredFirstUpperText,
            lowerText: Resources.Onboarding.firstOnboardingLowerLabelText
        ),

        PageModel(
            image: .secondOnboarding,
            upperText: Resources.Onboarding.secondOnboardingUpperLabelText,
            upperColoredText: Resources.Onboarding.coloredSecondUpperText,
            lowerText: Resources.Onboarding.secondOnboardingLowerLabelText
        ),

        PageModel(
            image: .thirdOnboarding,
            upperText: Resources.Onboarding.thirdOnboardingUpperLabelText,
            upperColoredText: Resources.Onboarding.coloredThirdUpperText,
            lowerText: Resources.Onboarding.thirdOnboardingLowerLabelText
        )
    ]

    // MARK: - Lazy properties

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
        button.setupView(with: button.purpleButton)
        button.purpleButton.setTitle(Resources.Onboarding.nextButtonText, for: .normal)
        button.purpleButton.addTarget(self, action: #selector(didTapNextButton(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var beginButton: UIView = {
        let button = CustomButtons()
        button.setupView(with: button.purpleButton)
        button.purpleButton.setTitle(Resources.Onboarding.beginButtonText, for: .normal)
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
            forCellWithReuseIdentifier: OnboardingCollectionViewCell.reuseIdentifier
        )
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

    // MARK: - Initializers

    init(presenter: OnboardingPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baseBackground

        navigationController?.setNavigationBarHidden(true, animated: true)

        collectionView.dataSource = self
        collectionView.delegate = self

        setupSubviews()
        setupConstraints()
        toggleButtons()
    }

    // MARK: - Private methods

    private func setupSubviews() {
        [
            upperPaddingView,
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

    private func setupConstraints() {
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

    private func toggleButtons() {
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            beginButton.isHidden = false
            nextButton.isHidden = true
        } else {
            beginButton.isHidden = true
            nextButton.isHidden = false
        }
    }

    // MARK: - Handlers

    @objc private func didTapNextButton(sender: AnyObject) {
        guard let currentIndexPath = collectionView.indexPathsForVisibleItems.first else { return }
        let newIndexPath = IndexPath(item: currentIndexPath.item + 1, section: .zero)

        if newIndexPath.item < pages.count {
            collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
            pageControl.currentPage += 1
        }
        toggleButtons()
    }

    @objc private func didTapBeginButton(sender: AnyObject) {
        UserDefaults.standard.setValue(true, forKey: Resources.Onboarding.onboardingUserDefaultsKey)
        DispatchQueue.main.async {
            self.presenter?.onboardingFinish()
        }
    }

    @objc private func pageChanged(sender: AnyObject) {
        guard let pageControl = sender as? UIPageControl else { return }
        collectionView.scrollToItem(
            at: IndexPath(item: pageControl.currentPage, section: .zero),
            at: .centeredHorizontally,
            animated: true
        )
        toggleButtons()
    }
}

    // MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingCollectionViewCell.reuseIdentifier,
            for: indexPath) as? OnboardingCollectionViewCell else {
            return UICollectionViewCell()
        }

        let currentPage = pages[indexPath.item]
        cell.configureCell(with: currentPage)

        return cell
    }
}

    // MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: collectionView.frame.width,
            height: collectionView.frame.height
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return .zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return .zero
    }
}

    // MARK: - UIScrollViewDelegate

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
        toggleButtons()
    }
}
