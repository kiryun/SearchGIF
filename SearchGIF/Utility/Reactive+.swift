//
//  Reactive+.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/15.
//

import Foundation
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController{
    var viewDidLoad: ControlEvent<Void>{
        
        // ?:
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map{_ in}
        return ControlEvent(events: source)
    }
}
