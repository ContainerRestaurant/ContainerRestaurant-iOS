//
//  MyCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/16.
//

import UIKit
import RxSwift

class MyCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    
    let userDataSubject: PublishSubject<UserModel> = PublishSubject<UserModel>()
    let disposeBag = DisposeBag()
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
//        API().askUser(userDataSubject: userDataSubject)
        
//        self.userDataSubject.subscribe(onNext: { [weak self] _ in
            var my = MyViewController.instantiate()
            my.coordinator = self
            my.bind(viewModel: MyViewModel(viewModel: UserModel()))
            
            self.presenter.pushViewController(my, animated: false)
//        })
//        .disposed(by: disposeBag)
    }
}

extension MyCoordinator {
    func presentLogin() {
        let coordinator = LoginPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
