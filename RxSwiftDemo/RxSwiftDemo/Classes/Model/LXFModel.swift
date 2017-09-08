//
//  LXFModel.swift
//  RxSwiftDemo
//
//  Created by 林洵锋 on 2017/9/7.
//  Copyright © 2017年 LXF. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

struct LXFModel: Mappable {
    var _id         = ""
    var createdAt   = ""
    var desc        = ""
    var publishedAt = ""
    var source      = ""
    var type        = ""
    var url         = ""
    var used        = ""
    var who         = ""
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        _id         <- map["_id"]
        createdAt   <- map["createdAt"]
        desc        <- map["desc"]
        publishedAt <- map["publishedAt"]
        source      <- map["source"]
        type        <- map["type"]
        url         <- map["url"]
        used        <- map["used"]
        who         <- map["who"]
    }
}


/* ============================= SectionModel =============================== */

struct LXFSection {
    
    var items: [Item]
}

extension LXFSection: SectionModelType {
    
    typealias Item = LXFModel
    
    init(original: LXFSection, items: [LXFSection.Item]) {
        self = original
        self.items = items
    }
}

