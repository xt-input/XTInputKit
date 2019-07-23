//
//  XTIString+.swift
//  XTInputKit
//
//  Created by xt-input on 2017/3/7.
//  Copyright © 2017年 tcoding.cn. All rights reserved.
//

import Foundation
extension String: XTIBaseNameNamespace {}

public extension XTITypeWrapperProtocol where WrappedType == String {
    // MARK: 获取字符串的长度

    var length: Int {
        return (wrappedValue as NSString).length
    }

    /// 判断是否存在子串
    ///
    /// - Parameter sub: 子串
    /// - Returns: true or false
    func hasSubstring(_ sub: String) -> Bool {
        let range = wrappedValue.range(of: sub)
        if range == nil || (range?.isEmpty)! {
            return false
        }
        return true
    }

    func substringIndex(_ sub: String) -> String.Index {
        let range = wrappedValue.range(of: sub)
        if range == nil {
            return wrappedValue.endIndex
        }
        return (range?.lowerBound)!
    }

    func substringBetween(_ startString: String, endString endStr: String) -> String {
        var str = wrappedValue.prefix(upTo: substringIndex(endStr))
        str = str.suffix(from: (wrappedValue.range(of: startString)?.upperBound)!)
        return "\(str)"
    }

    // MARK: 字符串的截取

    /// 字符串的截取
    /// 从startPosition截取到endPosition，如果endPosition超出字符串长度就取最长
    /// - Parameters:
    ///   - start: 开始位置(包括)
    ///   - end: 结束位置(不包括)
    /// - Returns: 截取后的string字符串

    func substring(startPosition start: Int, endPosition end: Int) -> String {
        var tempstart = start > length ? length : start
        if tempstart < 1 {
            tempstart = 0
        }
        var tempend = (end + 1) > length ? length : (end + 1)
        tempend = tempend - tempstart
        if tempend < 1 {
            tempend = 0
        }
        var str = wrappedValue
        str = "\(str.suffix(from: wrappedValue.xti[tempstart]))"
        str = "\(str.prefix(upTo: wrappedValue.xti[tempend]))"
        return str
    }

    /// 字符串的截取
    /// 从开始截取到toPosition，如果toPosition超出字符串长度就取最长
    /// - Parameter to: 结束位置(不包括)
    /// - Returns: 截取后的string字符串
    func substring(toPosition to: Int) -> String {
        return substring(startPosition: 0, endPosition: to)
    }

    /// 字符串的截取
    /// 从fromPosition位置开始截取到字符串尾部，如果fromPosition大于字符串长度就为""
    /// - Parameter fromPosition: 开始位置(包括)
    /// - Returns: 截取后的string字符串
    func substring(fromPosition from: Int) -> String {
        return substring(startPosition: from, endPosition: length - 1)
    }

    /// 字符串的截取
    /// 从startPosition开始取rangeLength长度的子串
    /// - Parameters:
    ///   - start: 开始位置(包括)
    ///   - length: 子串长度
    /// - Returns: 截取后的string字符串
    func substring(startPosition start: Int, rangeLength length: Int) -> String {
        return substring(startPosition: start, endPosition: start + length - 1)
    }

    /// 字符串的截取
    /// 取字符串尾部的rangeLength长的子串
    /// - Parameter length: 子串长度
    /// - Returns:
    func substringIndexToEnd(rangeLength length: Int) -> String {
        return substring(startPosition: self.length - length, endPosition: self.length - 1)
    }

    /// 获取字符串指定位置的index
    subscript(_ index: Int) -> String.Index {
        let temp = index > length ? length : index
        return wrappedValue.index(wrappedValue.startIndex, offsetBy: temp)
    }

    // MARK: - 正则验证

    var isPhone: Bool {
        let phone = wrappedValue.replacingOccurrences(of: "-", with: "")
        if phone.xti.length != 11 {
            return false
        }
        /**
         移动号段：
         134 135 136 137 138 139 147 150 151 152 157 158 159 178 182 183 184 187 188
         联通号段：
         130 131 132 145 155 156 171 175 176 185 186
         电信号段：
         133 149 153 173 177 180 181 189
         虚拟运营商:
         170
         */

        let mobile = "^(13[0-9]|14[579]|15[012356789]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$"

        let regexMobile = NSPredicate(format: "SELF MATCHES %@", mobile)
        if regexMobile.evaluate(with: phone) {
            return true
        } else {
            return false
        }
    }

    /// 字符串的Md5
    var md5: String {
        if let data = wrappedValue.data(using: .utf8, allowLossyConversion: true) {
            let message = data.withUnsafeBytes {
                $0.load(as: [UInt8].self)
            }

            let MD5Calculator = MD5(message)
            let MD5Data = MD5Calculator.calculate()

            var MD5String = String()
            for c in MD5Data {
                MD5String += String(format: "%02x", c)
            }
            return MD5String

        } else {
            return wrappedValue
        }
    }
}

// The following is an altered source version that only includes MD5. The original software can be found at:
// https://github.com/krzyzanowskim/CryptoSwift
// This is the original copyright notice:

/*
 Copyright (C) 2014 Marcin Krzyżanowski <marcin.krzyzanowski@gmail.com>
 This software is provided 'as-is', without any express or implied warranty.
 In no event will the authors be held liable for any damages arising from the use of this software.
 Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
 - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 - This notice may not be removed or altered from any source or binary distribution.
 */

/** array of bytes, little-endian representation */
func arrayOfBytes<T>(_ value: T, length: Int? = nil) -> [UInt8] {
    let totalBytes = length ?? (MemoryLayout<T>.size * 8)

    let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
    valuePointer.pointee = value

    let bytes = valuePointer.withMemoryRebound(to: UInt8.self, capacity: totalBytes) { (bytesPointer) -> [UInt8] in
        var bytes = [UInt8](repeating: 0, count: totalBytes)
        for j in 0 ..< min(MemoryLayout<T>.size, totalBytes) {
            bytes[totalBytes - 1 - j] = (bytesPointer + j).pointee
        }
        return bytes
    }

    valuePointer.deinitialize(count: 1)
    valuePointer.deallocate()

    return bytes
}

extension Int {
    /** Array of bytes with optional padding (little-endian) */
    func bytes(_ totalBytes: Int = MemoryLayout<Int>.size) -> [UInt8] {
        return arrayOfBytes(self, length: totalBytes)
    }
}

extension NSMutableData {
    /** Convenient way to append bytes */
    func appendBytes(_ arrayOfBytes: [UInt8]) {
        append(arrayOfBytes, length: arrayOfBytes.count)
    }
}

protocol HashProtocol {
    var message: Array<UInt8> { get }

    /** Common part for hash calculation. Prepare header data. */
    func prepare(_ len: Int) -> Array<UInt8>
}

extension HashProtocol {
    func prepare(_ len: Int) -> Array<UInt8> {
        var tmpMessage = message

        // Step 1. Append Padding Bits
        tmpMessage.append(0x80) // append one bit (UInt8 with one bit) to message

        // append "0" bit until message length in bits ≡ 448 (mod 512)
        var msgLength = tmpMessage.count
        var counter = 0

        while msgLength % len != (len - 8) {
            counter += 1
            msgLength += 1
        }

        tmpMessage += Array<UInt8>(repeating: 0, count: counter)
        return tmpMessage
    }
}

func toUInt32Array(_ slice: ArraySlice<UInt8>) -> Array<UInt32> {
    var result = Array<UInt32>()
    result.reserveCapacity(16)

    for idx in stride(from: slice.startIndex, to: slice.endIndex, by: MemoryLayout<UInt32>.size) {
        let d0 = UInt32(slice[idx.advanced(by: 3)]) << 24
        let d1 = UInt32(slice[idx.advanced(by: 2)]) << 16
        let d2 = UInt32(slice[idx.advanced(by: 1)]) << 8
        let d3 = UInt32(slice[idx])
        let val: UInt32 = d0 | d1 | d2 | d3

        result.append(val)
    }
    return result
}

struct BytesIterator: IteratorProtocol {
    let chunkSize: Int
    let data: [UInt8]

    init(chunkSize: Int, data: [UInt8]) {
        self.chunkSize = chunkSize
        self.data = data
    }

    var offset = 0

    mutating func next() -> ArraySlice<UInt8>? {
        let end = min(chunkSize, data.count - offset)
        let result = data[offset ..< offset + end]
        offset += result.count
        return result.count > 0 ? result : nil
    }
}

struct BytesSequence: Sequence {
    let chunkSize: Int
    let data: [UInt8]

    func makeIterator() -> BytesIterator {
        return BytesIterator(chunkSize: chunkSize, data: data)
    }
}

func rotateLeft(_ value: UInt32, bits: UInt32) -> UInt32 {
    return ((value << bits) & 0xFFFFFFFF) | (value >> (32 - bits))
}

fileprivate class MD5: HashProtocol {
    static let size = 16 // 128 / 8
    let message: [UInt8]

    init(_ message: [UInt8]) {
        self.message = message
    }

    /** specifies the per-round shift amounts */
    private let shifts: [UInt32] = [7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
                                    5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
                                    4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
                                    6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21]

    /** binary integer part of the sines of integers (Radians) */
    private let sines: [UInt32] = [0xD76AA478, 0xE8C7B756, 0x242070DB, 0xC1BDCEEE,
                                   0xF57C0FAF, 0x4787C62A, 0xA8304613, 0xFD469501,
                                   0x698098D8, 0x8B44F7AF, 0xFFFF5BB1, 0x895CD7BE,
                                   0x6B901122, 0xFD987193, 0xA679438E, 0x49B40821,
                                   0xF61E2562, 0xC040B340, 0x265E5A51, 0xE9B6C7AA,
                                   0xD62F105D, 0x02441453, 0xD8A1E681, 0xE7D3FBC8,
                                   0x21E1CDE6, 0xC33707D6, 0xF4D50D87, 0x455A14ED,
                                   0xA9E3E905, 0xFCEFA3F8, 0x676F02D9, 0x8D2A4C8A,
                                   0xFFFA3942, 0x8771F681, 0x6D9D6122, 0xFDE5380C,
                                   0xA4BEEA44, 0x4BDECFA9, 0xF6BB4B60, 0xBEBFBC70,
                                   0x289B7EC6, 0xEAA127FA, 0xD4EF3085, 0x4881D05,
                                   0xD9D4D039, 0xE6DB99E5, 0x1FA27CF8, 0xC4AC5665,
                                   0xF4292244, 0x432AFF97, 0xAB9423A7, 0xFC93A039,
                                   0x655B59C3, 0x8F0CCC92, 0xFFEFF47D, 0x85845DD1,
                                   0x6FA87E4F, 0xFE2CE6E0, 0xA3014314, 0x4E0811A1,
                                   0xF7537E82, 0xBD3AF235, 0x2AD7D2BB, 0xEB86D391]

    private let hashes: [UInt32] = [0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476]

    func calculate() -> [UInt8] {
        var tmpMessage = prepare(64)
        tmpMessage.reserveCapacity(tmpMessage.count + 4)

        // hash values
        var hh = hashes

        // Step 2. Append Length a 64-bit representation of lengthInBits
        let lengthInBits = (message.count * 8)
        let lengthBytes = lengthInBits.bytes(64 / 8)
        tmpMessage += lengthBytes.reversed()

        // Process the message in successive 512-bit chunks:
        let chunkSizeBytes = 512 / 8 // 64

        for chunk in BytesSequence(chunkSize: chunkSizeBytes, data: tmpMessage) {
            // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15
            var M = toUInt32Array(chunk)
            assert(M.count == 16, "Invalid array")

            // Initialize hash value for this chunk:
            var A: UInt32 = hh[0]
            var B: UInt32 = hh[1]
            var C: UInt32 = hh[2]
            var D: UInt32 = hh[3]

            var dTemp: UInt32 = 0

            // Main loop
            for j in 0 ..< sines.count {
                var g = 0
                var F: UInt32 = 0

                switch j {
                case 0 ... 15:
                    F = (B & C) | ((~B) & D)
                    g = j
                    break
                case 16 ... 31:
                    F = (D & B) | (~D & C)
                    g = (5 * j + 1) % 16
                    break
                case 32 ... 47:
                    F = B ^ C ^ D
                    g = (3 * j + 5) % 16
                    break
                case 48 ... 63:
                    F = C ^ (B | (~D))
                    g = (7 * j) % 16
                    break
                default:
                    break
                }
                dTemp = D
                D = C
                C = B
                B = B &+ rotateLeft(A &+ F &+ sines[j] &+ M[g], bits: shifts[j])
                A = dTemp
            }

            hh[0] = hh[0] &+ A
            hh[1] = hh[1] &+ B
            hh[2] = hh[2] &+ C
            hh[3] = hh[3] &+ D
        }

        var result = [UInt8]()
        result.reserveCapacity(hh.count / 4)

        hh.forEach {
            let itemLE = $0.littleEndian
            let r1 = UInt8(itemLE & 0xFF)
            let r2 = UInt8((itemLE >> 8) & 0xFF)
            let r3 = UInt8((itemLE >> 16) & 0xFF)
            let r4 = UInt8((itemLE >> 24) & 0xFF)
            result += [r1, r2, r3, r4]
        }
        return result
    }
}
