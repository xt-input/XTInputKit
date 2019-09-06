import CoreTelephony
import Foundation
import XTInputKit

//let array1 = ["123", "234"]
//let array2 = ["123", "234"]
//print(array1 + array2)
//print("\(array1 + array2)")

//array2.xti.toString()
var str = ""
for i in 0 ... 20 {
    str.append("\(i)")
    if i == 11 { str.append("--\(i)--") }
}
print(str)
