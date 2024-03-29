//
//  FeedDetailCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/14.
//

import UIKit
import RxSwift

class FeedDetailCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var feedID: Int?
    var feedDetailViewWillAppearSubject = PublishSubject<Void>()
    var justReloadSubject: PublishSubject<Void>?
    var selectedCell: TwoFeedCollectionViewCell?
    var isHiddenNavigationBarBeforePush: Bool = true
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
        
        print("FeedDetailCoordinator init")
    }
    
    deinit {
        print("FeedDetailCoordinator Deinit")
    }
    
    func start() {
        guard let feedID = self.feedID else { return }
        
        APIClient.feedDetail(feedID: feedID) { [weak self] feedDetailData in
            if let feedDetailData = feedDetailData,
               let cell = self?.selectedCell {
                var feedDetail = FeedDetailViewController.instantiate()
                feedDetail.coordinator = self
                feedDetail.feedDetailViewWillAppearSubject = self?.feedDetailViewWillAppearSubject
                feedDetail.hidesBottomBarWhenPushed = true
                feedDetail.selectedCell = cell
                feedDetail.bind(viewModel: FeedDetailViewModel(feedDetailData))
                
                self?.presenter.pushViewController(feedDetail, animated: true)
            }
        }
    }

    func startTest() {
        guard let feedID = self.feedID else { return }

        APIClient.feedDetail(feedID: feedID) { [weak self] feedDetailData in
            if let feedDetailData = feedDetailData,
               let cell = self?.selectedCell {
                var feedDetail = FeedDetailViewController.instantiate()
                feedDetail.coordinator = self
                feedDetail.feedDetailViewWillAppearSubject = self?.feedDetailViewWillAppearSubject
                feedDetail.hidesBottomBarWhenPushed = true
                feedDetail.selectedCell = cell
                feedDetail.bind(viewModel: FeedDetailViewModel(feedDetailData))

                feedDetail.modalPresentationStyle = .overFullScreen
                self?.presenter.dismiss(animated: false, completion: nil)
                self?.presenter.pushViewController(feedDetail, animated: true)
            }
        }
    }
}

extension FeedDetailCoordinator {
    func presentLogin() {
        let coordinator = LoginPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        coordinator.feedDetailViewWillAppearSubject = self.feedDetailViewWillAppearSubject
        coordinator.fromWhere = .feedDetail
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func presentDeleteFeedPopup(feedID: String) {
        let coordinator = CommonPopupCoordinator(presenter: presenter, isTwoButton: true, buttonType: .deleteFeed)
        coordinator.delegate = self
        coordinator.feedID = feedID
        coordinator.justReloadSubject = justReloadSubject
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func presentDeleteCommentPopup(commentID: Int, reloadSubject: PublishSubject<Void>) {
        let coordinator = CommonPopupCoordinator(presenter: presenter, isTwoButton: true, buttonType: .deleteComment)
        coordinator.delegate = self
        coordinator.commentID = commentID
        coordinator.reloadSubject = reloadSubject
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func presentReportCommentPopup(commentID: Int) { //, reloadSubject: PublishSubject<Void>) {
        let coordinator = CommonPopupCoordinator(presenter: presenter, isTwoButton: true, buttonType: .reportComment)
        coordinator.delegate = self
        coordinator.commentID = commentID
//        coordinator.reloadSubject = reloadSubject
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func presentReportFeedPopup(feedID: String) {
        let coordinator = CommonPopupCoordinator(presenter: presenter, isTwoButton: true, buttonType: .reportFeed)
        coordinator.delegate = self
        coordinator.feedID = feedID
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func pushToInquiryProfile(userID: Int) {
        let coordinator = InquiryProfileCoordinator(presenter: presenter, userID: userID)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func presentImagePopup(image: UIImage) {
        let coordinator = FeedImagePopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        coordinator.image = image
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
