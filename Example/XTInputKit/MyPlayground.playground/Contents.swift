import UIKit
import XTInputKit

print("1234567890".xti.substring(fromPosition: 1))
print("1234567890".xti.substring(toPosition: 10))
print("1234567890".xti.substring(startPosition: 1, endPosition: 3))
print("1234567890".xti.substring(startPosition: 1, rangeLength: 10))
print("1234567890".xti.substringIndexToEnd(rangeLength: 9))
print("1234567890".xti.substringBetween("2", endString: "4"))
print("1234567890".xti[6])

