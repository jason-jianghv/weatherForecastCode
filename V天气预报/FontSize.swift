//
//  FontSize.swift
//  V天气预报
//
//  Created by jianghui on 2023/4/15.
//

import Foundation

public enum FontSize {
    /// 12.0
    case small
    /// 18.0
    case regular
    /// 26.0
    case large
}

public extension FontSize {
    var value: CGFloat {
        switch self {
        case .small:
            return 12.0
        case .regular:
            return 18.0
        case .large:
            return 26.0
        }
    }
}
