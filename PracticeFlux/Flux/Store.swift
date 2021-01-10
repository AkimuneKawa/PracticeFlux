//
//  Store.swift
//  PracticeFlux
//
//  Created by 河明宗 on 2021/01/10.
//  Copyright © 2021 河明宗. All rights reserved.
//

import Foundation

typealias Subscription = NSObjectProtocol

class Store {
    private enum NotificationName {
        static let storeChanged = Notification.Name("store-changed")
    }
    
    private lazy var dispatchToken: DispatchToken = {
        return dispatcher.register(callback: { [weak self] action in
            self?.onDispatch(action)
        })
    }()
    
    private let notificationCenter: NotificationCenter
    private let dispatcher: Dispatcher
    
    deinit {
        dispatcher.unregister(dispatchToken)
    }
    
    init(dispatcher: Dispatcher) {
        self.dispatcher = dispatcher
        self.notificationCenter = NotificationCenter()
        _ = dispatchToken
    }
    
    func onDispatch(_ action: Action) {
        fatalError("must override")
    }
    
    final func emitChange() {
        notificationCenter.post(name: NotificationName.storeChanged, object: nil)
    }
    
    final func addListner(callback: @escaping () -> ()) -> Subscription {
        let using: (Notification) -> () = { notification in
            if notification.name == NotificationName.storeChanged {
                callback()
            }
        }
        
        return notificationCenter.addObserver(
            forName: NotificationName.storeChanged,
            object: nil,
            queue: nil,
            using: using)
    }
    
    final func removeListner(_ subscription: Subscription) {
        notificationCenter.removeObserver(subscription)
    }
}
