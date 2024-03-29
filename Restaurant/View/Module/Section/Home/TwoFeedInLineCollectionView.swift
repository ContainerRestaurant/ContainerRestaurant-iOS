//
//  TwoFeedInLineCollectionView.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/27.
//

import UIKit
import RxSwift

class TwoFeedInLineCollectionView: UICollectionViewCell {
    private var isFirstEnterToFeed = true
    private var feeds: [FeedPreviewModel] = []
    private let interItemSpacing: CGFloat = 15
    private let cellLineSpacing: CGFloat = 20
    var homeCoordinator: HomeCoordinator?
    var feedCoordinator: FeedCoordinator?
    var inquiryProfileCoordinator: InquiryProfileCoordinator?
    var selectedCategoryAndSortSubject: PublishSubject<(String, Int)>?
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionView()
        print("TwoFeedInLineCollectionView awakeFromNib()")
    }
    
    deinit {
        print("TwoFeedInLineCollectionView Deinit")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.disposeBag = DisposeBag()
    }
    
    //홈 탭 피드
    func configureHomeMainFeed(_ feeds: [FeedPreviewModel], _ coordinator: HomeCoordinator) {
        self.feeds = feeds
        self.homeCoordinator = coordinator
        
        self.emptyView.isHidden = self.feeds.count > 0
    }
    
    //피드 탭 카테고리 피드
    func configureFeedCategoryFeed(_ feeds: [FeedPreviewModel], _ selectedCategoryAndSortSubject: PublishSubject<(String, Int)>, _ reloadByTabSubject: PublishSubject<[FeedPreviewModel]>, _ coordinator: FeedCoordinator) {
        self.feeds = feeds
        self.selectedCategoryAndSortSubject = selectedCategoryAndSortSubject
        self.feedCoordinator = coordinator
        self.emptyView.isHidden = self.feeds.count > 0

        collectionView.reloadData()
        
        self.selectedCategoryAndSortSubject?
            .subscribe(onNext: { (category, sortIndex) in
                if sortIndex > 0 {
                    var sortString: String {
                        switch sortIndex {
                        case 1: return "likeCount,DESC"
                        case 2: return "difficulty,ASC"
                        case 3: return "difficulty,DESC"
                        default: return ""
                        }
                    }
                    APIClient.feed(category: category, sort: sortString) { [weak self] (twoFeedModel) in
                        self?.feeds = twoFeedModel.feedPreviewList
                        self?.collectionView.reloadData()
                        reloadByTabSubject.onNext(self?.feeds ?? [])
                    }
                } else {
                    APIClient.feed(category: category) { [weak self] (twoFeedModel) in
                        self?.feeds = twoFeedModel.feedPreviewList
                        self?.collectionView.reloadData()
                        reloadByTabSubject.onNext(self?.feeds ?? [])
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    //유저 피드
    func configureUserFeed(_ feeds: [FeedPreviewModel], _ coordinator: InquiryProfileCoordinator) {
        self.feeds = feeds
        self.inquiryProfileCoordinator = coordinator

        self.emptyView.isHidden = self.feeds.count > 0
    }
}

//MARK: - Instance Method
extension TwoFeedInLineCollectionView {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(TwoFeedCollectionViewCell.self)
    }
}

//MARK: - CollectionView Protocol
extension TwoFeedInLineCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.feeds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TwoFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let coordinator = homeCoordinator {
            cell.configure(self.feeds[indexPath.row], coordinator)
        } else if let coordinator = feedCoordinator {
            cell.configure(self.feeds[indexPath.row], coordinator)
        } else if let coordinator = inquiryProfileCoordinator {
            cell.configure(self.feeds[indexPath.row], coordinator)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let coordinator = feedCoordinator {
            coordinator.pushToFeedDetail(feedID: self.feeds[indexPath.row].id, cell: collectionView.cellForItem(at: indexPath) as! TwoFeedCollectionViewCell)
        } else if let coordinator = inquiryProfileCoordinator {
            coordinator.pushToFeedDetail(feedID: self.feeds[indexPath.row].id, cell: collectionView.cellForItem(at: indexPath) as! TwoFeedCollectionViewCell)
        } else if let coordinator = homeCoordinator {
            coordinator.pushToFeedDetail(feedID: self.feeds[indexPath.row].id, cell: collectionView.cellForItem(at: indexPath) as! TwoFeedCollectionViewCell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = CGFloat(164)
        let cellHeight = CGFloat(273)
        
        return CGSize(width: cellWidth.widthRatio(), height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.interItemSpacing.widthRatio()
    }
}
