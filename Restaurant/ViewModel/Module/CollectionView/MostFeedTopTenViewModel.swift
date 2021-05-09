//
//  MostFeedTopTenViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/09.
//

import UIKit

class MostFeedTopTenViewModel {
    var modules: [UICollectionViewCell] = [
        MostFeedTopTenTitleCollectionViewCell(),
        MostFeedTopTenCollectionView()
    ]
    
    func mostFeedTopTenTitleSize() -> CGSize {
        return CGSize(width: 100, height: 180)
    }
    
    func mostFeedTopTenSize() -> CGSize {
        return CGSize(width: 136, height: 180)
    }
}