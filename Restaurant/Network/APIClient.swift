//
//  APIClient.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/01.
//

import Foundation
import Alamofire
import RxSwift

class APIClient {
    //로그인 토큰 생성
    static func createLoginToken(provider: String, accessToken: String, completion: @escaping (LoginModel) -> Void) {
        AF.request(Router.CreateLoginToken(provider: provider, accessToken: accessToken))
            .responseDecodable { (response: DataResponse<LoginModel, AFError>) in
                switch response.result {
                case .success(let loginModel):
                    completion(loginModel)
                case .failure(let error):
                    completion(LoginModel())
                    print("Create Login Token's Error: \(error)")
                }
            }
    }

    //내 정보 조회
    static func checkLogin(loginToken: String, completion: @escaping (UserModel) -> Void) {
        AF.request(Router.CheckLogin)
            .responseDecodable { (response: DataResponse<UserModel, AFError>) in
                switch response.result {
                case .success(let userModel):
                    completion(userModel)
                case .failure(let error):
                    completion(UserModel())
                    print("Check Login's Error: \(error)")
                }
            }
    }

    //사용자 정보 변경
    static func updateUserInformation(userID: Int, nickname: String, completion: @escaping (UserModel) -> Void) {
        AF.request(Router.UpdateUserInformation(userID: userID, nickname: nickname))
            .responseDecodable { (response: DataResponse<UserModel, AFError>) in
                switch response.result {
                case .success(let userModel):
                    completion(userModel)
                case .failure(let error):
                    completion(UserModel())
                    print("Update User Information's Error: \(error)")
                }
            }
    }

    //사용자 정보 조회
    static func checkUser(userID: Int, completion: @escaping (UserModel) -> Void) {
        AF.request(Router.CheckUser(userID: userID))
            .responseDecodable { (response: DataResponse<UserModel, AFError>) in
                switch response.result {
                case .success(let userModel):
                    completion(userModel)
                case .failure(let error):
                    completion(UserModel())
                    print("Check User's Error: \(error)")
                }
            }
    }

    //홈 탭 메인 데이터
    static func homeMainData(completion: @escaping (HomeMainDataModel) -> Void) {
        AF.request(Router.HomeMainData)
            .responseDecodable { (response: DataResponse<HomeMainDataModel, AFError>) in
                switch response.result {
                case .success(let homeMainData):
                    completion(homeMainData)
                case .failure(let error):
                    completion(HomeMainDataModel())
                    print("Home Main Data's Error: \(error)")
                }
            }
    }

    //모두의 용기 화면 데이터
    static func containerOfEveryone(completion: @escaping (ContainerOfEveryoneModel) -> Void) {
        AF.request(Router.ContainerOfEveryone)
            .responseDecodable { (response: DataResponse<ContainerOfEveryoneModel, AFError>) in
                switch response.result {
                case .success(let containerOfEveryoneModel):
                    completion(containerOfEveryoneModel)
                case .failure(let error):
                    completion(ContainerOfEveryoneModel())
                    print("Most Feed Creation User's Error: \(error)")
                }
            }
    }

    //홈 탭 메인 피드
    static func recommendFeed(completion: @escaping ([FeedPreviewModel]) -> Void ) {
        AF.request(Router.RecommendFeed)
            .responseDecodable { (response: DataResponse<TwoFeedModel, AFError>) in
                switch response.result {
                case .success(let recommendFeed):
                    completion(recommendFeed.feedPreviewList)
                case .failure(let error):
                    completion([])
                    print("Recommend Feed's Error: \(error)")
                }
            }
    }

    //홈 탭 메인 피드
    static func userFeed(userID: Int, completion: @escaping ([FeedPreviewModel]) -> Void ) {
        AF.request(Router.UserFeed(userID: userID))
            .responseDecodable { (response: DataResponse<TwoFeedModel, AFError>) in
                switch response.result {
                case .success(let userFeed):
                    completion(userFeed.feedPreviewList)
                case .failure(let error):
                    completion([])
                    print("User Feed's Error: \(error)")
                }
            }
    }
    
    //피드 탭 카테고리 피드
    static func categoryFeed(category: String, completion: @escaping ([FeedPreviewModel]) -> Void ) {
        AF.request(Router.CategoryFeed(category: category))
            .responseDecodable { (response: DataResponse<TwoFeedModel, AFError>) in
                switch response.result {
                case .success(let categoryFeed):
                    completion(categoryFeed.feedPreviewList)
                case .failure(let error):
                    completion([])
                    print("Category Feed's Error: \(error)")
                }
            }
    }

    //해당 식당에 쓰인 피드
    static func restaurantFeed(restaurantID: Int, completion: @escaping ([FeedPreviewModel]) -> Void ) {
        AF.request(Router.RestaurantFeed(restaurantID: restaurantID))
            .responseDecodable { (response: DataResponse<TwoFeedModel, AFError>) in
                switch response.result {
                case .success(let categoryFeed):
                    completion(categoryFeed.feedPreviewList)
                case .failure(let error):
                    completion([])
                    print("Restaurant Feed's Error: \(error)")
                }
            }
    }

    //피드 좋아요
    static func likeFeed(feedID: Int, cancel: Bool) {
        AF.request(Router.LikeFeed(feedID: feedID, cancel: cancel))
            .response(completionHandler: { response in
                switch response.result {
                case .success(let result):
                    print("Like Feed's Success: \(String(describing: result))")
                case .failure(let error):
                    print("Like Feed's Error: \(error)")
                }
            })
    }
    
    //피드 상세
    static func feedDetail(feedID: Int, completion: @escaping (FeedDetailModel?) -> Void ) {
        AF.request(Router.FeedDetail(feedID: feedID))
            .responseDecodable { (response: DataResponse<FeedDetailModel, AFError>) in
                switch response.result {
                case .success(let feedDetail):
                    completion(feedDetail)
                case .failure(let error):
                    completion(FeedDetailModel())
                    print("Feed Detail's Error: \(error)")
                }
            }
    }
    
    //피드 상세 Rx로 감싸보기
//    static func feedDetailRx(feedID: Int) -> Observable<FeedDetailModel> {
//        return Observable.create() { emitter in
//            feedDetail(feedID: feedID) { feedDetail in
//                emitter.onNext(feedDetail!)
//                emitter.onCompleted()
//            }
//            return Disposables.create()
//        }
//    }

    //댓글 작성
    static func createFeedComment(feedID: String, content: String, completion: @escaping (CommentModel) -> Void) {
        AF.request(Router.CreateFeedComment(feedID: feedID, content: content))
            .responseDecodable { (response: DataResponse<CommentModel, AFError>) in
                switch response.result {
                case .success(let commentModel):
                    completion(commentModel)
                case .failure(let error):
                    completion(CommentModel())
                    print("Create Feed Comment's Error: \(error)")
                }
            }
    }

    //대댓글 작성
    static func createFeedReplyComment(feedID: String, content: String, upperReplyID: Int, completion: @escaping (CommentModel) -> Void) {
        AF.request(Router.CreateFeedReplyComment(feedID: feedID, content: content, uppperReplyID: upperReplyID))
            .responseDecodable { (response: DataResponse<CommentModel, AFError>) in
                switch response.result {
                case .success(let replyCommentModel):
                    completion(replyCommentModel)
                case .failure(let error):
                    completion(CommentModel())
                    print("Create Feed Reply Comment's Error: \(error)")
                }
            }
    }

    //댓글 조회
    static func commentsOfFeed(feedID: String, completion: @escaping ([CommentModel]) -> Void) {
        AF.request(Router.FeedComment(feedID: feedID))
            .responseDecodable { (response: DataResponse<CommentOfFeedModel, AFError>) in
                switch response.result {
                case .success(let commentOfFeed):
                    completion(commentOfFeed.comments)
                case .failure(let error):
                    completion([])
                    print("Comments Of Feed's Error: \(error)")
                }
            }
    }
    
    //주변 식당 검색
    static func nearbyRestaurants(latitude: Double, longitude: Double, radius: Int, completion: @escaping ([RestaurantModel]) -> Void) {
        AF.request(Router.NearbyRestaurants(latitude: latitude, longitude: longitude, radius: radius))
            .responseDecodable { (response: DataResponse<NearybyRestaurantModel, AFError>) in
                switch response.result {
                case .success(let nearbyRestaurant):
                    completion(nearbyRestaurant.nearbyRestaurants)
                case .failure(let error):
                    completion([])
                    print("Nearby Restaurants's Error: \(error)")
                }
            }
    }
}
