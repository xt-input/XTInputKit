//
//  XTObserverTest.swift
//  XTInputKit
//
//  Created by Input on 2018/4/27.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

class XTIObserverTest: XTIObserver {
    private static var _default: XTIObserverTest!
    static var `default`: XTIObserverTest {
        if _default == nil {
            _default = XTIObserverTest()
        }
        return _default
    }
}
