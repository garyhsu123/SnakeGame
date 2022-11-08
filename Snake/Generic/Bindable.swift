//
//  Bindable.swift
//  Splashy
//
//  Created by Pedro Carrasco on 27/01/18.
//  Copyright © 2018 Pedro Carrasco. All rights reserved.
//

import Foundation

class Bindable<T> {
    typealias Observer = (T) -> ()

    // MARK: - PROPERTIES
    var observers: [Observer]? = []
    var value: T {
        didSet {
            observers?.forEach{
                $0(value)
            }
        }
    }

    // MARK: - INITIALIZATION
    init(_ value: T) {
        self.value = value
    }

    // MARK: - FUNCTIONS
    func bind(observer: @escaping Observer) {
        self.observers?.append(observer)
        observer(value)
    }
}
