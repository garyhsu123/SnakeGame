//
//  WeakObject.swift
//  Snake
//
//  Created by Yu-Chun Hsu on 2022/10/21.
//

import Foundation

class WeakObject<T>: NSObject {
    
    var obj: T
    
    init(obj: T) {
        self.obj = obj
        super.init()
    }
}
