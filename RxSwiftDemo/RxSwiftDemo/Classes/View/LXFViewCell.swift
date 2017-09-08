//
//  LXFViewCell.swift
//  RxSwiftDemo
//
//  Created by 林洵锋 on 2017/9/7.
//  Copyright © 2017年 LXF. All rights reserved.
//

import UIKit
import Reusable

class LXFViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

extension LXFViewCell {
    static func cellHeigh() -> CGFloat {
        return 240
    }
}
