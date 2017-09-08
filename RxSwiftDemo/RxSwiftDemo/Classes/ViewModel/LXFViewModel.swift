//
//  LXFViewModel.swift
//  RxSwiftDemo
//
//  Created by 林洵锋 on 2017/9/7.
//  Copyright © 2017年 LXF. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum LXFRefreshStatus {
    case none
    case beingHeaderRefresh
    case endHeaderRefresh
    case beingFooterRefresh
    case endFooterRefresh
    case noMoreData
}

class LXFViewModel: NSObject {
    // 存放着解析完成的模型数组
    let models = Variable<[LXFModel]>([])
    // 记录当前的索引值
    var index: Int = 1
}

extension LXFViewModel: LXFViewModelType {
    
    typealias Input = LXFInput
    typealias Output = LXFOutput

    struct LXFInput {
        // 网络请求类型
        let category: LXFNetworkTool.LXFNetworkCategory
        
        init(category: LXFNetworkTool.LXFNetworkCategory) {
            self.category = category
        }
    }

    struct LXFOutput {
        // tableView的sections数据
        let sections: Driver<[LXFSection]>
        // 外界通过该属性告诉viewModel加载数据（传入的值是为了标志是否重新加载）
        let requestCommond = PublishSubject<Bool>()
        // 告诉外界的tableView当前的刷新状态
        let refreshStatus = Variable<LXFRefreshStatus>(.none)
        
        init(sections: Driver<[LXFSection]>) {
            self.sections = sections
        }
    }
    
    func transform(input: LXFViewModel.LXFInput) -> LXFViewModel.LXFOutput {
        let sections = models.asObservable().map { (models) -> [LXFSection] in
            // 当models的值被改变时会调用
            return [LXFSection(items: models)]
        }.asDriver(onErrorJustReturn: [])
        
        let output = LXFOutput(sections: sections)
        
        output.requestCommond.subscribe(onNext: {[unowned self] isReloadData in
            self.index = isReloadData ? 1 : self.index+1
            lxfNetTool.request(.data(type: input.category, size: 10, index: self.index)).mapArray(LXFModel.self).subscribe({ [weak self] (event) in
                switch event {
                case let .next(modelArr):
                    self?.models.value = isReloadData ? modelArr : (self?.models.value ?? []) + modelArr
                    LXFProgressHUD.showSuccess("加载成功")
                case let .error(error):
                    LXFProgressHUD.showError(error.localizedDescription)
                case .completed:
                    output.refreshStatus.value = isReloadData ? .endHeaderRefresh : .endFooterRefresh
                }
            }).addDisposableTo(self.rx_disposeBag)
        }).addDisposableTo(rx_disposeBag)
        
        return output
    }
}


