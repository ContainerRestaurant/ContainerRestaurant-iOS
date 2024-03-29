//
//  UserDataManager.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/15.
//
import UIKit

class UserDataManager: NSObject {
    static let sharedInstance = UserDataManager()
    
    override init() {
        super.init()
    }
    
//    var userID: Int = Int.max //Default Int.max, 로그인 시에 세팅
//    var loginToken: String = ""
    var userID: Int {
        get { return UserDefaults.standard.object(forKey: "userID") == nil ? 0 : UserDefaults.standard.object(forKey: "userID") as! Int }
        set { UserDefaults.standard.set(newValue, forKey: "userID") }
    }
    var loginToken: String {
        get { return UserDefaults.standard.object(forKey: "loginToken") == nil ? "" : UserDefaults.standard.object(forKey: "loginToken") as! String }
        set { UserDefaults.standard.set(newValue, forKey: "loginToken") }
    }
    var pushToken: String {
        get { return UserDefaults.standard.object(forKey: "pushToken") == nil ? "" : UserDefaults.standard.object(forKey: "pushToken") as! String }
        set { UserDefaults.standard.set(newValue, forKey: "pushToken") }
    }
    var pushTokenID: Int {
        get { return UserDefaults.standard.object(forKey: "pushTokenID") == nil ? 0 : UserDefaults.standard.object(forKey: "pushTokenID") as! Int }
        set { UserDefaults.standard.set(newValue, forKey: "pushTokenID") }
    }
    var fromWhereLogin: String {
        get { return UserDefaults.standard.object(forKey: "fromWhereLogin") == nil ? "" : UserDefaults.standard.object(forKey: "fromWhereLogin") as! String }
        set { UserDefaults.standard.set(newValue, forKey: "fromWhereLogin") }
    }
    
    //앱 첫 진입 여부(온보딩 체크)
    var isFirstEntry: Bool {
        get { return UserDefaults.standard.object(forKey: "isFirstEntry") == nil ? true : false }
        set { UserDefaults.standard.set(newValue, forKey: "isFirstEntry") }
    }
    
    // 자동 로그인 여부
//    var autoLogin: Bool {
//        get { return UserDefaults.standard.bool(forKey: "autoLogin") }
//        set { UserDefaults.standard.set(newValue, forKey: "autoLogin") }
//    }

    // 개인정보 사용 동의
//    var userAgree : Bool {
//        get { return UserDefaults.standard.bool(forKey: "userAgree") }
//        set { UserDefaults.standard.set(newValue, forKey: "userAgree") }
//    }
}
