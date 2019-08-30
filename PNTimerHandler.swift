//
//  PNTimerHandler.swift
//  MeetingSystem
//
//  Created by Mike on 2017/12/13.
//  Copyright © 2017年 汉普电子. All rights reserved.
//

import Foundation

@objc public protocol PNTimerHandlerDelegate: NSObjectProtocol {
    
    @objc optional func timerHandlerFired(timer: Timer)
}

class PNTimerHandler: NSObject {
    
    private struct Event {
        weak var delegate: PNTimerHandlerDelegate?
        var timer: Timer?
    }
    
    private static var events: [String:Event] = [:]
    
    ///推荐方法
    private class func className(for delegate: PNTimerHandlerDelegate) -> String {
        let obj = delegate as AnyObject
        if let ccc = obj.classForCoder {
            return "\(ccc)"
        } else {
            return UUID.init().uuidString
        }
    }
    
    ///在deinit或dealloc中调用
    class func cancelTimerWith(identifier: String) {
        guard var ev = events[identifier] else { return }
        ev.timer?.invalidate()
        ev.timer = nil
        events.removeValue(forKey: identifier)
    }
    
    ///在deinit或dealloc中调用
    class func cancelTimerWith(delegate: PNTimerHandlerDelegate) {
        let identifier = className(for: delegate)
        guard var ev = events[identifier] else { return }
        ev.timer?.invalidate()
        ev.timer = nil
        events.removeValue(forKey: identifier)
    }
    ///如果你传入了identifier，那么请用cancelTimerWith(identifier:)，否则请用cancelTimerWith(delegate:)
    class func setupTimerWith(delegate: PNTimerHandlerDelegate,
                              identifier: String? = nil,
                              timeInterval: TimeInterval = 1) {
        let id = identifier ?? className(for: delegate)
        cancelTimerWith(identifier: id)
        let timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                         target: self,
                                         selector: #selector(timerFired(_:)),
                                         userInfo: id,
                                         repeats: true)
        events[id] = Event.init(delegate: delegate, timer: timer)
        timer.fire()
    }
    
    @objc private class func timerFired(_ sender: Timer?) {
        guard let timer = sender else { return }
        guard let identifier = timer.userInfo as? String else { return }
        guard let ev = events[identifier] else { return }
        ev.delegate?.timerHandlerFired?(timer: timer)
    }
}

