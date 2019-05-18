import UIKit
import HandyJSON
import XTInputKit


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
        hostName = "design.tcoding.cn"
        serviceName = "rxswift/login/index"
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

var userRequest:XTIUserRequest? = XTIUserRequest()
userRequest?.iSLogRawData = false
userRequest?.login.username = "username"
userRequest?.login.passwd = "123456"
userRequest?.login {(_, result, error) in
    print(result as Any)
    print(error as Any)
}

userRequest = nil

struct InvestList:HandyJSON{
    var InvestUuid: String?
    var Title: String?
    var DayRate: String?
    var InvestNum: String?
}

struct DataT:HandyJSON{
    var YesterdayIncome: String?
    var InvestList:[InvestList]?
}

let data = "{\"YesterdayIncome\": \"暂无收益\", \"InvestList\": [{\"InvestUuid\": \"81de907e9c00130d\", \"Title\": \"尊享孵化-200\", \"DayRate\": \"1\", \"InvestNum\": \"200\"}, {\"InvestUuid\": \"03e752e2cec1cfaa\", \"Title\": \"尊享孵化-500\", \"DayRate\": \"1\", \"InvestNum\": \"500\"}, {\"InvestUuid\": \"f279a573b125f654\", \"Title\": \"尊享孵化-2000\", \"DayRate\": \"1\", \"InvestNum\": \"2000\"} ] }"

let d = DataT.deserialize(from: data)

print(d?.InvestList)

public protocol LocalValue{
    var value: String { get }
}

enum KeyLocale: String, LocalValue {
    case unkown
    
    enum Home: String, LocalValue {
        case home
        
        var value: String {
           return self.rawValue
        }
    }
    
    var value: String {
        return self.rawValue
    }
}

func getLocal(_ key: LocalValue) -> String {
    print(key.value)
    return NSLocalizedString(key.value, comment: "")
}

getLocal(KeyLocale.Home.home)

struct TTTT: HandyJSON {
    var date: Date?
    var onlineTime: Int?
    
    mutating func didFinishMapping() {
        if let time = self.onlineTime{
            self.date = Date(timeIntervalSince1970: TimeInterval(time))
        }
    }
}

let hh = TTTT.deserialize(from: "{\"onlineTime\":1556523161}")
var hhh: TTTT?

// MARK :-  XTILoger测试
var str = "error"
xtiloger.info(hh)
xtiloger.info(str)
xtiloger.info(format: "%d %.2lf %p %.3f %@ %u", 123, 123.0, 12, 123.0, "123", -123)

xtiloger.debug("123123")
xtiloger.warning("123123")
xtiloger.error("123123")

xtiloger.debug(format: "%d %.2lf %p %.3f %@ %u", 123, 123.0, 123, 123.0, "123", -123)
xtiloger.warning(format: "%d %.2lf %p %.3f %@ %u", 123, 123.0, 1231, 123.0, "123", -123)
xtiloger.error(format: "%d %.2lf %p %.3f %@ %u", 123, 123.0, 1233, 123.0, "123", -123)

print("1234567890".xti.substring(fromPosition: 1))
print("1234567890".xti.substring(toPosition: 10))
print("1234567890".xti.substring(startPosition: 1, endPosition: 3))
print("1234567890".xti.substring(startPosition: 1, rangeLength: 10))
print("1234567890".xti.substringIndexToEnd(rangeLength: 9))
print("1234567890".xti.substringBetween("2", endString: "4"))
print("1234567890".xti[6])

