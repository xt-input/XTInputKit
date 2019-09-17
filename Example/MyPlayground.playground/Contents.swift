//: [Previous](@previous)
/*:
 # Usage
 
 ## Unordered List
 - First Item
 - Secound Item
 
 ## ordered List
 1. First Item
 2. Secound Item
 
 ## Note
 > This is a note
 ---
 
 ## Image
 ![Image](image.png "Local image")
 
 ## Link
 * [How about a link](https://github.com/LeoMobileDeveloper)
 
 ## Bold/italic
 So my name is **Leo**,you notice that Leo is bold, and this word *italic* is italic.
 
 [Go back to Main Page](MainPage)
 */

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
