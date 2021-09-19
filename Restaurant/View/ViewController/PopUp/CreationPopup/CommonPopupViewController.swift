//
//  CommonPopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/28.
//

import UIKit
import RxSwift

enum PopupButtonType {
    case creationFeed
    case confirmExit
    case none
}

class CommonPopupViewController: BaseViewController, Storyboard {
    weak var coordinator: CommonPopupCoordinator?
    var isTwoButton: Bool = true
    var buttonType: PopupButtonType = .none
    
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var popupTitleLabel: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        cancelView.isHidden = !isTwoButton
        switch buttonType {
        case .creationFeed:
            setButton(buttonType)
            creationFeedBindingView()
        case .confirmExit:
            setButton(buttonType)
            confirmExitBindingView()
        case .none: break
        }

        backgroundButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    func creationFeedBindingView() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)

        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] userModel in
                    if userModel.id == 0 {
                        self?.dismiss(animated: false, completion: nil)
                        self?.coordinator?.presentLogin()
                    } else {
                        self?.dismiss(animated: false, completion: nil)
                        self?.coordinator?.presenter.tabBarController?.selectedIndex = 2
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func confirmExitBindingView() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)

        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false) {
                    Common.currentViewController()?.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }

    private func setButton(_ buttonType: PopupButtonType) {
        switch buttonType {
        case .creationFeed:
            popupTitleLabel.text = "용기낸 경험을 들려주시겠어요?"
            cancelButton.setTitle("나중에요", for: .normal)
            okButton.setTitle("네, 좋아요!", for: .normal)
        case .confirmExit:
            let attributedString = NSMutableAttributedString()
                .bold(string: "작성을 종료할까요?\n", fontColor: .colorGrayGray07, fontSize: 16)
                .regular(string: "지금까지 작성한 내용은 저장되지 않아요.", fontColor: .colorGrayGray06, fontSize: 14)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.paragraphSpacing = 4
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

            popupTitleLabel.attributedText = attributedString
            cancelButton.setTitle("취소", for: .normal)
            okButton.setTitle("확인", for: .normal)
        case .none: break
        }
    }

    deinit {
        print("CreationPopupViewController Deinit")
    }
}