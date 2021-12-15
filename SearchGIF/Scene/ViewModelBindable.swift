//
//  ViewModelBindable.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/15.
//

import Foundation
import UIKit

protocol ViewModelBindable{
    associatedtype ViewModel
    
    var viewModel: ViewModel! {get set}
    func bindViewModel()
}

extension ViewModelBindable where Self: UIViewController{
    mutating func bind(viewModel: Self.ViewModel){
        self.viewModel = viewModel
        // ?:
        loadViewIfNeeded()
        
        self.bindViewModel()
    }
}
