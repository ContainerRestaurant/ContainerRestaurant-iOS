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
    case logout
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
        case .logout:
            setButton(buttonType)
            logoutBindingView()
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

    func logoutBindingView() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false) {
                    UserDataManager.sharedInstance.userID = Int.max
                    UserDataManager.sharedInstance.loginToken = ""
                    
                    self?.coordinator?.presenter.popViewController(animated: false)
                    self?.coordinator?.presenter.tabBarController?.selectedIndex = 0
                }
            })

        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    private func setButton(_ buttonType: PopupButtonType) {
        switch buttonType {
        case .creationFeed:
            popupTitleLabel.text = "????????? ????????? ??????????????????????"
            cancelButton.setTitle("????????????", for: .normal)
            okButton.setTitle("???, ?????????!", for: .normal)
        case .confirmExit:
            let attributedString = NSMutableAttributedString()
                .bold(string: "????????? ????????????????\n", fontColor: .colorGrayGray07, fontSize: 16)
                .regular(string: "???????????? ????????? ????????? ???????????? ?????????.", fontColor: .colorGrayGray06, fontSize: 14)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.paragraphSpacing = 4
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

            popupTitleLabel.attributedText = attributedString
            cancelButton.setTitle("??????", for: .normal)
            okButton.setTitle("??????", for: .normal)
        case .logout:
            popupTitleLabel.text = "?????? ???????????? ????????????????"
            cancelButton.setTitle("????????????", for: .normal)
            okButton.setTitle("??????", for: .normal)
        case .none: break
        }
    }

    deinit {
        print("CreationPopupViewController Deinit")
    }
}
