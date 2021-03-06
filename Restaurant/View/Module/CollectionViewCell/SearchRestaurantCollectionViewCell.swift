//
//  SearchRestaurantCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/01.
//

import UIKit
import RxSwift
import RxCocoa

class SearchRestaurantCollectionViewCell: UICollectionViewCell {
    let disposeBag = DisposeBag()

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAdressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(item: LocalSearchItem) {
        self.restaurantNameLabel.text = item.title.deleteBrTag()
        self.restaurantAdressLabel.text = item.address
    }
}
