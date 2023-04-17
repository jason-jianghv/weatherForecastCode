//
//  UILabel+Convenient.swift
//  V天气预报
//
//  Created by jianghui on 2023/4/15.
//

import Foundation
import UIKit

extension UILabel {
    static func makeLabel(_ size: FontSize, _ align: NSTextAlignment = .left, _ color: UIColor = .white) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size.value)
        label.textColor = color
        label.textAlignment = align
        return label
    }
}
