//
//  XTIBaseModelProtocol.swift
//  XTInputKit
//
//  Created by xt-input on 2019/7/8.
//

import Foundation
#if canImport(XTIObjectMapper) || canImport(ObjectMapper)
    import XTIObjectMapper

    public protocol XTIBaseModelProtocol: Mappable {
        mutating func didHandleResult()
        mutating func isEmpty() -> Bool
    }

    extension XTIBaseModelProtocol {
        static func handleResult(_ value: String) -> Self? {
            var result = Mapper<Self>().map(JSONString: value)
            result?.didHandleResult()
            return result
        }

        public mutating func didHandleResult() {}

        public mutating func isEmpty() -> Bool {
            return ["{}", "[]", "", "[:]", "{:}", "nil", "null"].contains(self.toJSONString() ?? "nil")
        }
    }

#else
    public protocol XTIBaseModelProtocol: Codable {
        mutating func didHandleResult()
        mutating func isEmpty() -> Bool
        mutating func toJson() -> [String: Any]?
        mutating func toJsonString() -> String?
    }

    extension XTIBaseModelProtocol {
        static func handleResult(_ value: String) -> Self? {
            let data = value.data(using: .utf8) ?? Data()

            do {
                let result = try JSONDecoder().decode(self, from: data)
                return result
            } catch {
                return nil
            }
        }

        public mutating func didHandleResult() {}

        public mutating func isEmpty() -> Bool {
            return ["{}", "[]", "", "[:]", "{:}", "nil", "null"].contains(self.toJsonString() ?? "nil")
        }

        public mutating func toJson() -> [String: Any]? {
            guard let data = try? JSONEncoder().encode(self) else {
                return nil
            }
            return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        }

        public mutating func toJsonString() -> String? {
            guard let data = try? JSONEncoder().encode(self) else {
                return nil
            }
            return String(data: data, encoding: .utf8)
        }
    }
#endif
