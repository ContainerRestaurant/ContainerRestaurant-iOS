//
//  HomeViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/10.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewModel {
    var modules: [UICollectionViewCell] = []
    var recommendFeeds: [FeedPreviewModel] = []
    var bannerInfo: [BannerInfoModel] = []

//    var recommendFeeds: Driver<[FeedPreviewModel]> {
//        return Observable
//            .just(recommendFeed)
//            .asDriver(onErrorJustReturn: [])
//    }
    
    init(_ recommendFeeds: [FeedPreviewModel], _ banner: [BannerInfoModel]) {
        appendModule()

        self.recommendFeeds = recommendFeeds
        self.bannerInfo = banner
    }
}

//MARK: - Module Size
extension HomeViewModel {
    func appendModule() {
        self.modules.append(MainTitleSection())
        self.modules.append(MainBanner())
        self.modules.append(Title16Bold())
        self.modules.append(MainFeedCollectionView())
    }

    func mainTitleSectionSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 251)
    }

    func mainBannerSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width-CGFloat(32), height: 88)
    }

    func title16BoldSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 21)
    }

    func MainFeedCollectionViewSize() -> CGSize {
        let height: CGFloat = { () -> CGFloat in
            let line = round(Double(self.recommendFeeds.count)/2.0)
            let cellHeight: CGFloat = 273 * CGFloat(line)
            let spacingHeight: CGFloat = 20 * CGFloat(line-1)

            return cellHeight + spacingHeight
        }()

        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}
