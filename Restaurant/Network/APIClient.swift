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
    //앱 버전 체크
    static func appVersion(completion: @escaping (AppVersionModel) -> Void) {
        AF.request(Router.AppVersion)
            .responseDecodable { (response: DataResponse<AppVersionModel, AFError>) in
                switch response.result {
                case .success(let appVersion):
                    completion(appVersion)
                case .failure(let error):
                    completion(AppVersionModel())
                    print("App Version's Error: \(error)")
                }
            }
    }

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

    //사용자 닉네임 변경
    static func updateUserNickname(userID: Int, nickname: String, completion: @escaping (UserModel) -> Void) {
        AF.request(Router.UpdateUserNickname(userID: userID, nickname: nickname))
            .responseDecodable { (response: DataResponse<UserModel, AFError>) in
                switch response.result {
                case .success(let userModel):
                    completion(userModel)
                case .failure(let error):
                    completion(UserModel())
                    print("Update User Nickname's Error: \(error)")
                }
            }
    }
    
    //사용자 프로필 변경
    static func updateUserProfile(userID: Int, profileID: Int, completion: @escaping (UserModel) -> Void) {
        AF.request(Router.UpdateUserProfile(userID: userID, profileID: profileID))
            .responseDecodable { (response: DataResponse<UserModel, AFError>) in
                switch response.result {
                case .success(let userModel):
                    completion(userModel)
                case .failure(let error):
                    completion(UserModel())
                    print("Update User Profile's Error: \(error)")
                }
            }
    }

    //디바이스 토큰 저장
    static func updateDeviceToken(deviceToken: String, completion: @escaping (Int) -> Void) {
        AF.request(Router.UpdateDeviceToken(pushToken: deviceToken))
            .responseDecodable { (response: DataResponse<PushResponseModel, AFError>) in
                switch response.result {
                case .success(let pushResponseModel):
                    UserDataManager.sharedInstance.pushTokenID = pushResponseModel.id
                    print("*/등록/*")
                    print(pushResponseModel.id)
                    print("*/등록/*")
                    completion(pushResponseModel.id)
                case .failure(let error):
                    print("Update Device Token's Error: \(error)")
                }
            }
    }

    //유저 필드에 저장돼있는 디바이스 토큰 삭제
    static func deleteDeviceTokenOfUser(completion: @escaping (Bool) -> Void) {
        AF.request(Router.DeleteDeviceTokenOfUser(userID: UserDataManager.sharedInstance.userID))
            .validate(statusCode: 200..<300)
            .response(completionHandler: { response in
                switch response.result {
                case .success(let result):
                    completion(true)
                    print("Delete Device Token Of User's Success: \(String(describing: result))")
                case .failure(let error):
                    completion(false)
                    print("Delete Device Token Of User's Error: \(error)")
                }
            })
    }

    static func deleteDeviceTokenOfTable(completion: @escaping (Bool) -> Void) {
        AF.request(Router.DeleteDeviceTokenOfTable(pushTokenID: UserDataManager.sharedInstance.pushTokenID))
            .validate(statusCode: 200..<300)
            .response(completionHandler: { response in
                switch response.result {
                case .success(let result):
                    completion(true)
                    print("Delete Device Token Of Table's Success: \(String(describing: result))")
                case .failure(let error):
                    completion(false)
                    print("Delete Device Token Of Table's Error: \(error)")
                }
            })
    }
    
    //계정 탈퇴
    static func unregisterUser(userID: Int, completion: @escaping (Bool) -> Void) {
        AF.request(Router.UnregisterUser(userID: userID))
            .response(completionHandler: { response in
                switch response.result {
                case .success(let result):
                    completion(true)
                    print("Unregister User's Success: \(String(describing: result))")
                case .failure(let error):
                    completion(false)
                    print("Unregister User's Error: \(error)")
                }
            })
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

    //특정 유저 피드
    static func userFeed(userID: Int, completion: @escaping ([FeedPreviewModel]) -> Void ) {
        AF.request(Router.UserFeed(userID: userID, size: 1000))
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

    //피드쓰기 Todo: API -> APIClient
//    static func uploadFeed(feedModel: FeedModel, completion: @escaping (CreationFeedResponseModel) -> Void) {
//        AF.request(Router.UploadFeed(feedModel: feedModel))
//            .responseDecodable { (response: DataResponse<CreationFeedResponseModel, AFError>) in
//                switch response.result {
//                case .success(let creationFeedResponseModel):
//                    completion(creationFeedResponseModel)
//                case .failure(let error):
//                    completion(CreationFeedResponseModel())
//                    print("Upload Feed's Error: \(error)")
//                }
//            }
//    }

    //피드 신고하기
    static func reportFeed(feedID: String, completion: @escaping (Bool) -> Void) {
        AF.request(Router.ReportFeed(feedID: feedID))
            .response(completionHandler: { response in
                switch response.result {
                case .success(let result):
                    completion(true)
                    print("Report Feed's Success: \(String(describing: result))")
                case .failure(let error):
                    completion(false)
                    print("Report Feed's Error: \(error)")
                }
            })
    }

    //특정 유저가 스크랩한 피드
    static func scrapedFeed(userID: Int, completion: @escaping ([FeedPreviewModel]) -> Void ) {
        AF.request(Router.ScrapedFeed(userID: userID, size: 1000))
            .responseDecodable { (response: DataResponse<TwoFeedModel, AFError>) in
                switch response.result {
                case .success(let scrapedFeed):
                    completion(scrapedFeed.feedPreviewList)
                case .failure(let error):
                    completion([])
                    print("Scraped Feed's Error: \(error)")
                }
            }
    }

    //찜(즐겨찾기)한 식당
    static func favoriteRestaurant(completion: @escaping (FavoriteRestaurantModel) -> Void) {
        AF.request(Router.FavoriteRestaurant)
            .responseDecodable { (response: DataResponse<FavoriteRestaurantModel, AFError>) in
                switch response.result {
                case .success(let favoriteRestaurantModel):
                    completion(favoriteRestaurantModel)
                case .failure(let error):
                    completion(FavoriteRestaurantModel())
                    print("Favorite Restaurants's Error: \(error)")
                }
            }
    }

    //식당 즐겨찾기 추가
    static func postFavoriteRestaurant(restaurantID: Int, completion: @escaping (()) -> Void) {
        AF.request(Router.RegistFavoriteRestaurant(restaurantID: restaurantID))
            .response(completionHandler: { response in
                switch response.result {
                case .success(let result):
                    print("Post Favorite Restaurant's Success: \(String(describing: result))")
                    completion(())
                case .failure(let error):
                    print("Post Favorite Restaurant's Error: \(error)")
                }
            })
    }

    //식당 즐겨찾기 삭제
    static func deleteFavoriteRestaurant(restaurantID: Int, completion: @escaping (()) -> Void) {
        AF.request(Router.DeleteFavoriteRestaurant(restaurantID: restaurantID))
            .response(completionHandler: { response in
                switch response.result {
                case .success(let result):
                    print("Delete Favorite Restaurant's Success: \(String(describing: result))")
                    completion(())
                case .failure(let error):
                    print("Delete Favorite Restaurant's Error: \(error)")
                }
            })
    }
    
    //피드 탭 카테고리 피드
    static func feed(category: String = "", sort: String = "", page: Int = 0, completion: @escaping (TwoFeedModel) -> Void) {
        AF.request(Router.Feed(category: category, sort: sort, page: page))
            .responseDecodable { (response: DataResponse<TwoFeedModel, AFError>) in
                switch response.result {
                case .success(let categoryFeed):
                    completion(categoryFeed)
                case .failure(let error):
                    completion(TwoFeedModel())
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

    //피드 스크랩
    static func scrapFeed(feedID: Int, cancel: Bool) {
        AF.request(Router.ScrapFeed(feedID: feedID, cancel: cancel))
            .response(completionHandler: { response in
                switch response.result {
                case .success(let result):
                    print("Scrap Feed's Success: \(String(describing: result))")
                case .failure(let error):
                    print("Scrap Feed's Error: \(error)")
                }
            })
    }
                  
    //피드 삭제
    static func deleteFeed(feedID: String, completion: @escaping (Bool) -> ()) {
        AF.request(Router.DeleteFeed(feedID: feedID))
            .response(completionHandler: { response in
                switch response.result {
                case .success(let result):
                    print("Delete Feed's Success: \(String(describing: result))")
                    completion(true)
                case .failure(let error):
                    print("Delete Feed's Error: \(error)")
                    completion(false)
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

    //댓글,대댓글 수정
    static func updateFeedComment(commentID: Int, content: String, completion: @escaping (CommentModel) -> Void) {
        AF.request(Router.UpdateFeedComment(commentID: commentID, content: content))
            .responseDecodable { (response: DataResponse<CommentModel, AFError>) in
                switch response.result {
                case .success(let commentModel):
                    completion(commentModel)
                case .failure(let error):
                    completion(CommentModel())
                    print("Update Feed Comment's Error: \(error)")
                }
            }
    }

    //댓글,대댓글 삭제
    static func deleteFeedComment(commentID: Int, completion: @escaping (Bool) -> ()) {
        AF.request(Router.DeleteFeedComment(commentID: commentID))
            .response(completionHandler: { response in
                switch response.result {
                case .success(let result):
                    print("Delete Feed Comment's Success: \(String(describing: result))")
                    completion(true)
                case .failure(let error):
                    print("Delete Feed Comment's Error: \(error)")
                    completion(false)
                }
            })
    }

    //댓글,대댓글 신고
    static func reportComment(commentID: Int, completion: @escaping (Bool) -> Void) {
        AF.request(Router.ReportComment(commentID: commentID))
            .response(completionHandler: { response in
                switch response.result {
                case .success(let result):
                    completion(true)
                    print("Report Comment's Success: \(String(describing: result))")
                case .failure(let error):
                    completion(false)
                    print("Report Comment's Error: \(error)")
                }
            })
    }

    //댓글,대댓글 좋아요
    static func likeComment(commentID: Int, completion: @escaping (Bool) -> Void) {
        AF.request(Router.LikeComment(commentID: commentID))
            .response(completionHandler: { response in
                switch response.result {
                case .success(let result):
                    completion(true)
                    print("Like Comment's Success: \(String(describing: result))")
                case .failure(let error):
                    completion(false)
                    print("Like Comment's Error: \(error)")
                }
            })
    }

    //댓글,대댓글 좋아요 취소
    static func deleteCommentLike(commentID: Int, completion: @escaping (Bool) -> Void) {
        AF.request(Router.DeleteCommentLike(commentID: commentID))
            .response(completionHandler: { response in
                switch response.result {
                case .success(let result):
                    completion(true)
                    print("Delete Comment Like's Success: \(String(describing: result))")
                case .failure(let error):
                    completion(false)
                    print("Delete Comment Like's Error: \(error)")
                }
            })
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

    //개인정보 취급방침 & 이용약관
    static func fetchContract(completion: @escaping ([ContractInfo]) -> Void) {
        AF.request(Router.Contract)
            .responseDecodable { (response: DataResponse<ContractInfoModel, AFError>) in
                switch response.result {
                case .success(let contractInfoModel):
                    completion(contractInfoModel.contractInfoList)
                case .failure(let error):
                    completion([])
                    print("Nearby Restaurants's Error: \(error)")
                }
            }
    }
}
