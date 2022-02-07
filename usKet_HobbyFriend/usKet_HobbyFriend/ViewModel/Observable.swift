//
//  Observable.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/01/19.
//

class Observable<T> {

    private var listener: ( (T) -> Void )?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
