import UIKit

import XTInputKit


print("1234567890".xti.substring(fromPosition: 1))
print("1234567890".xti.substring(toPosition: 10))
print("1234567890".xti.substring(startPosition: 1, endPosition: 3))
print("1234567890".xti.substring(startPosition: 1, rangeLength: 10))
print("1234567890".xti.substringIndexToEnd(rangeLength: 9))
print("1234567890".xti.substringBetween("2", endString: "4"))
print("1234567890".xti[6])

enum XTINetWorkServer {
    enum User: String, XTIServiceName {
        static var app: String{
            return "index"
        }

        static var realValue: String {
            return "user_me"
        }

        var realValue: String {
            return self.rawValue
        }
        case login = "loginname"
    }
}

class XTIUserRequest: XTIBaseRequest {

    static let shared = XTIUserRequest()

    //登录接口的参数
    struct LoginParameter: HandyJSON {
        var username: String!
        var passwd: String!
    }


    var login = LoginParameter()

    override init() {
        super.init()
        // 一些公共的配置可以在这里设置
        hostName = "user.tcoding.cn"
    }

    func login(complete: @escaping XTIRequestCompleteCallback) {
        var parameters = buildParameters()

        if !self.login.isEmpty() {
            parameters += self.login.toJSON()!
        }
        XTILoger.default.debug(parameters)
        post(serviceName: XTINetWorkServer.User.login.value, parameters: parameters, completed: complete)
    }
}

let userRequest = XTIUserRequest.shared
userRequest.login.username = "username"
userRequest.login.passwd = "123456"
userRequest.login { (_, result, error) in

}
