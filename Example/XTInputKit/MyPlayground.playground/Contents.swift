import UIKit
import XTInputKit
import XTIObjectMapper

struct T:Mappable {
    var string : String?
    var int : Int?
    var double : Double?
    var float : Float?
    var bool :  Bool?
    init?(map: Map) { }
    mutating func mapping(map: Map) {
        string <- map["string"]
        int <- map["int"]
        double <- map["double"]
        float <- map["float"]
        bool <- map["bool"]
        print( map["double"].value() ?? "123")
    }
}
var t = T(JSONString: #"{"bool":true,"string":"string","double":"1.22","int":1,"float":1.2}"#)

print(t!.toJSONString()!)

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

// MARK :-  XTILoger测试
var str = "error"
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

