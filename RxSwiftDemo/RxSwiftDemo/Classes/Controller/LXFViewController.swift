//
//  LXFViewController.swift
//  RxSwiftDemo
//
//  Created by 林洵锋 on 2017/9/7.
//  Copyright © 2017年 LXF. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources
import Then
import SnapKit
import Moya
import Kingfisher
import MJRefresh

class LXFViewController: UIViewController {
    
    let viewModel = LXFViewModel()
    let tableView = UITableView().then {
        $0.backgroundColor = UIColor.red
        $0.register(cellType: LXFViewCell.self)
        $0.rowHeight = LXFViewCell.cellHeigh()
    }
    let dataSource = RxTableViewSectionedReloadDataSource<LXFSection>()
    var vmOutput : LXFViewModel.LXFOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindView()
        
        // 加载数据
        tableView.mj_header.beginRefreshing()
    }
}

extension LXFViewController {
    fileprivate func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view.snp.top).offset(20);
        }
    }
    
    fileprivate func bindView() {
        // 绑定cell
        dataSource.configureCell = { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(for: ip) as LXFViewCell
            cell.picView.kf.setImage(with: URL(string: item.url))
            cell.descLabel.text = "描述: \(item.desc)"
            cell.sourceLabel.text = "来源: \(item.source)"
            return cell
        }
        
        // 设置代理
        tableView.rx.setDelegate(self).addDisposableTo(rx_disposeBag)
        
        
        let vmInput = LXFViewModel.LXFInput(category: .welfare)
        let vmOutput = viewModel.transform(input: vmInput)
        
        vmOutput.sections.asDriver().drive(tableView.rx.items(dataSource: dataSource)).addDisposableTo(rx_disposeBag)
        
        vmOutput.refreshStatus.asObservable().subscribe(onNext: {[weak self] status in
            switch status {
            case .beingHeaderRefresh:
                self?.tableView.mj_header.beginRefreshing()
            case .endHeaderRefresh:
                self?.tableView.mj_header.endRefreshing()
            case .beingFooterRefresh:
                self?.tableView.mj_footer.beginRefreshing()
            case .endFooterRefresh:
                self?.tableView.mj_footer.endRefreshing()
            case .noMoreData:
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            default:
                break
            }
        }).addDisposableTo(rx_disposeBag)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            vmOutput.requestCommond.onNext(true)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            vmOutput.requestCommond.onNext(false)
        })
    }
}

extension LXFViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
