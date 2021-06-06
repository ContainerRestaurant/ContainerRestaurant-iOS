//
//  LevelOfDifficultyAndWelcome.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/05.
//

import UIKit
import RxSwift

class LevelOfDifficultyAndWelcome: UICollectionViewCell {
    let disposeBag = DisposeBag()
    var isWelcome = false
    var isWelcomeSubject: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)

    @IBOutlet weak var levelOfDifficultyLabel: UIButton!
    @IBOutlet weak var levelOfDifficulty1: UIButton!
    @IBOutlet weak var levelOfDifficulty2: UIButton!
    @IBOutlet weak var levelOfDifficulty3: UIButton!
    @IBOutlet weak var levelOfDifficulty4: UIButton!
    @IBOutlet weak var levelOfDifficulty5: UIButton!
    @IBOutlet weak var welcomeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        welcomeButton.applySketchShadow(color: .colorGrayGray08, alpha: 0.1, x: 0, y: 0, blur: 8, spread: 0)
        setButtonAction()
    }
}

extension LevelOfDifficultyAndWelcome {
    private func setButtonAction() {
        levelOfDifficulty1.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.levelOfDifficultyLabel.setTitle("쉬워요", for: .normal)
                self?.buttonImage(index: 0)
            })
            .disposed(by: disposeBag)

        levelOfDifficulty2.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.levelOfDifficultyLabel.setTitle("할 만 해요", for: .normal)
                self?.buttonImage(index: 1)
            })
            .disposed(by: disposeBag)

        levelOfDifficulty3.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.levelOfDifficultyLabel.setTitle("보통이에요", for: .normal)
                self?.buttonImage(index: 2)
            })
            .disposed(by: disposeBag)

        levelOfDifficulty4.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.levelOfDifficultyLabel.setTitle("까다로워요", for: .normal)
                self?.buttonImage(index: 3)
            })
            .disposed(by: disposeBag)

        levelOfDifficulty5.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.levelOfDifficultyLabel.setTitle("많이 어려워요", for: .normal)
                self?.buttonImage(index: 4)
            })
            .disposed(by: disposeBag)

        welcomeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isWelcome = !(self!.isWelcome)
                self?.isWelcomeSubject.onNext(self!.isWelcome)
            })
            .disposed(by: disposeBag)

        isWelcomeSubject.subscribe(onNext: { [weak self] in
            self?.welcomeButton.setImage(UIImage(named: $0 ? "badgeFilled32Px" : "badgeOutline32Px"), for: .normal)
        })
        .disposed(by: disposeBag)
    }

    private func buttonImage(index: Int) {
        self.levelOfDifficulty2.setImage(UIImage(named: index >= 1 ? "hardFilled32Px" : "hardDisabled32Px"), for: .normal)
        self.levelOfDifficulty3.setImage(UIImage(named: index >= 2 ? "hardFilled32Px" : "hardDisabled32Px"), for: .normal)
        self.levelOfDifficulty4.setImage(UIImage(named: index >= 3 ? "hardFilled32Px" : "hardDisabled32Px"), for: .normal)
        self.levelOfDifficulty5.setImage(UIImage(named: index >= 4 ? "hardFilled32Px" : "hardDisabled32Px"), for: .normal)
    }
}