//
//  BaseView.swift
//  WDCalendarView
//
//  Created by Jaeyong Lee on 2022/11/22.
//

import UIKit

protocol CodeBased {
    func setLayout()
    func setAttribute()
}

class BaseView: UIView, CodeBased {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setLayout()
        setAttribute()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLayout() {}

    func setAttribute() {}
}
