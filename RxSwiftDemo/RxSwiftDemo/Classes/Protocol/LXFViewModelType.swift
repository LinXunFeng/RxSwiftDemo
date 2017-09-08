//
//  LXFViewModelType.swift
//  RxSwiftDemo
//
//  Created by 林洵锋 on 2017/9/8.
//  Copyright © 2017年 LXF. All rights reserved.
//

import Foundation

protocol LXFViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
