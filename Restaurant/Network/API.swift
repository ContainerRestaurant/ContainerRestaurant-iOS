//
//  API.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/21.
//

import Foundation
import Alamofire
import RxSwift

var baseURL = "http://prod.hellozin.net"

struct API {
    
}

//MARK: 피드쓰기
extension API {
    //지역검색
    func localSearch(text: String, subject: PublishSubject<LocalSearch>) {
        let url = "https://openapi.naver.com/v1/search/local"
        let httpHeaders: HTTPHeaders = [
            "X-Naver-Client-Id": "zJ4xl5NeU12vREYMTgji",
            "X-Naver-Client-Secret": "UFCyKRkPkk"
        ]
        let param: Parameters = [
            "query": text,
            "display": 5
        ]

        AF.request(url, parameters: param, headers: httpHeaders).responseJSON { (response) in
            switch response.result {
            case .success(let obj):
                do {
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .fragmentsAllowed)
                    let instanceData = try JSONDecoder().decode(LocalSearch.self, from: dataJSON)

                    subject.onNext(instanceData)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    //이미지 업로드
    func uploadImage(image: UIImage, completion: @escaping (Int) -> Void) {
        let url = "\(baseURL)/api/image/upload"
        let header: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Accept": "application/json",
            "Authorization": "Bearer \(UserDataManager.sharedInstance.loginToken)"
        ]

        AF.upload(multipartFormData: { multipartFormData in
            if let data = image.jpegData(compressionQuality: 0.3) {
                multipartFormData.append(data, withName: "image", fileName: "file.jpeg", mimeType: "image/jpeg")
            }
        }, to: url, method: .post, headers: header).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let obj):
                do {
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .fragmentsAllowed)
                    let instanceData = try JSONDecoder().decode(UploadingImageModel.self, from: dataJSON)
                    
                    completion(instanceData.id)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let e):
                print(e.localizedDescription)
                //JSON could not be serialized because of error:
                //The data couldn’t be read because it isn’t in the correct format.
                //Todo: 특정 사진에 위와 같은 에러가 떨어질 때 있음... 나중에 확인 !
            }
        })
    }
    
    //피드 업로드
    func uploadFeed(feedModel: FeedModel, completion: @escaping (CreationFeedResponseModel) -> Void) {
        let url = "\(baseURL)/api/feed"
        let params = feedModel

        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Content-Type": "application/json",
                             "Accept":"application/json",
                             "Authorization": "Bearer \(UserDataManager.sharedInstance.loginToken)"])
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let obj):
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .fragmentsAllowed)
                        let instanceData = try JSONDecoder().decode(CreationFeedResponseModel.self, from: dataJSON)

                        completion(instanceData)
                    } catch {
                        completion(CreationFeedResponseModel())
                        print(error.localizedDescription)
                    }
                case .failure(let e):
                    completion(CreationFeedResponseModel())
                    print(e.localizedDescription)
                }
            })
    }
}

//MARK: 로그인
extension API {
    //계정탈퇴
    func deleteUser() {
        let url = "\(baseURL)/api/user/\(UserDataManager.sharedInstance.userID)"

        AF.request(url,
                   method: .delete,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success(let obj):
                    print("계정탈퇴 성공: \(obj)")
                case .failure(let e):
                    print("계정탈퇴 실패: \(e.localizedDescription)")
                }
            }
    }

    //닉네임 유효성 검사
    func validateNickName(nickName: String, subject: PublishSubject<Bool>) {
        let url = "\(baseURL)/api/user/nickname/exists"
        let param: Parameters = [
            "nickname": nickName
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let obj):
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .fragmentsAllowed)
                        let instanceData = try JSONDecoder().decode(NickNameValidationModel.self, from: dataJSON)

                        subject.onNext(instanceData.exists)
                    } catch {
                        print(error.localizedDescription)
                        subject.onNext(true)
                    }
                case .failure(let e):
                    print(e.localizedDescription)
                    subject.onNext(true)
                }
            }
    }
}
