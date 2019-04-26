//
//  XTINetWorkAction.swift
//  XTInputKitDemo
//
//  Created by xt-input on 2019/4/25.
//  Copyright © 2019 tcoding.cn. All rights reserved.
//

import UIKit


protocol ServiceName {
    var originalValue: String {get}
    var value: String {get}
    
    static var originalValue: String {get}
    static var value: String {get}
}

extension ServiceName {
    
    /// return "\(Self.self)/\(self)"       eg:  User.login.originalValue ==> "User/login"
    var originalValue: String {
        return "\(Self.self)/\(self)"
    }
    /// return "\(Self.self)/\(self)"的小写        eg:  User.login.value ==> "user/login"
    var value: String {
        return self.originalValue.lowercased()
    }
    
    /// return "\(Self.self)"       eg:  User.originalValue ==> "User"
    static var originalValue: String {
        return "\(Self.self)"
    }
    
    /// return "\(Self.self)"的小写        eg: User.value ==> "User"
    static var value: String {
        return Self.originalValue.lowercased()
    }
}

enum XTINetWorkServer {
    enum User: String, ServiceName {
        case login
    }
}
