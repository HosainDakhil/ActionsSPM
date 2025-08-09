//
//  ActionsSPM.swift
//
//  Created by Hussein Dakheel on 7/16/25.
//  Copyright © 2025. All rights reserved.
//
import UIKit
import ObjectiveC

private class ControlActionTrampoline {
    let action: (UIControl, UIEvent?) -> Void

    init(action: @escaping (UIControl, UIEvent?) -> Void) {
        self.action = action
    }

    @objc func invoke(_ sender: UIControl, forEvent event: UIEvent?) {
        action(sender, event)
    }
}

private class GestureActionTrampoline {
    let action: (UIGestureRecognizer) -> Void

    init(action: @escaping (UIGestureRecognizer) -> Void) {
        self.action = action
    }

    @objc func invoke(_ recognizer: UIGestureRecognizer) {
        action(recognizer)
    }
}

private var actionKey: UInt8 = 0

public extension UIControl {
    func add(event: UIControl.Event, action: @escaping (UIControl, UIEvent?) -> Void) {
        let trampoline = ControlActionTrampoline(action: action)
        addTarget(trampoline, action: #selector(ControlActionTrampoline.invoke(_:forEvent:)), for: event)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), trampoline, .OBJC_ASSOCIATION_RETAIN)
    }
}

public extension UIView {
    @discardableResult
    func add(gesture: UIGestureRecognizer, action: @escaping (UIGestureRecognizer) -> Void) -> UIGestureRecognizer {
        let trampoline = GestureActionTrampoline(action: action)
        gesture.addTarget(trampoline, action: #selector(GestureActionTrampoline.invoke(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), trampoline, .OBJC_ASSOCIATION_RETAIN)
        return gesture
    }

    @discardableResult
    func addTap(count: Int = 1, action: @escaping () -> Void) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = count
        return add(gesture: tap) { _ in action() }
    }
}
