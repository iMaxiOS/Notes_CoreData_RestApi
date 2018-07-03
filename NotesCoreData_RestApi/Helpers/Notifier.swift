//
//  Notifier.swift
//  NotesCoreData_RestApi
//
//  Created by Oleg Granchenko on 7/2/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import Foundation

func == (lhs: NotifyReceiverWrapper, rhs: NotifyReceiverWrapper) -> Bool {
    return lhs.receiver === rhs.receiver
}

struct NotifyReceiverWrapper: Equatable {
    weak var receiver: AnyObject?
}

class Notifier: NSObject {
    
    internal var receivers = [NotifyReceiverWrapper]()
    
    func addReceiver(_ receiver: AnyObject?) {
        guard let receiver = receiver else { return }
        receivers.append(NotifyReceiverWrapper(receiver: receiver))
    }
    
    func insertReceiver(_ receiver: AnyObject?) {
        guard let receiver = receiver else { return }
        receivers.insert(NotifyReceiverWrapper(receiver: receiver), at: 0)
    }
    
    func removeReceiver(_ receiver: AnyObject?) {
        guard let receiver = receiver else { return }
        if let index = receivers.index(where: { $0.receiver === receiver }) {
            receivers.remove(at: index)
        }
    }
    
    func notify(_ enumerator: (_ receiver: AnyObject) -> Void) {
        var emptyWrappers = [NotifyReceiverWrapper]()
        for wrapper in receivers {
            if let receiver = wrapper.receiver {
                enumerator(receiver)
            } else {
                emptyWrappers.append(wrapper)
            }
        }
        emptyWrappers.removeAll()
    }
}

private var _uid: Int = 0

private func generetaeUid() -> Int {
    let uid = _uid
    _uid += 1
    return uid
}

private func ==<T> (lhs: BlockNotifierReceiver<T>, rhs: BlockNotifierReceiver<T>) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

private struct BlockNotifierReceiver<T>: Hashable {
    fileprivate var hashValue: Int = generetaeUid()
    weak var owner: AnyObject?
    var block: (AnyObject, T) -> Void
    init(owner: AnyObject, block: @escaping (AnyObject, T) -> Void) {
        self.owner = owner
        self.block = block
    }
}

class BlockNotifier<T> {
    
    fileprivate var receivers = [BlockNotifierReceiver<T>]()
    
    func subscribe<OwnerType: AnyObject>(_ owner: OwnerType,
                                         block: @escaping (_ owner: OwnerType, _ value: T) -> Void) {
        receivers.append(BlockNotifierReceiver(owner: owner, block: { block($0 as! OwnerType, $1) }))
    }
    
    func unsubscribe(_ owner: AnyObject) {
        receivers = receivers.filter({ $0.owner !== owner })
    }
    
    func notify(_ value: T) {
        
        var garbage = [BlockNotifierReceiver<T>]()
        
        for receiver in receivers {
            if let owner = receiver.owner {
                receiver.block(owner, value)
            } else {
                garbage.append(receiver)
            }
        }
        
        garbage.removeAll()
    }
}

