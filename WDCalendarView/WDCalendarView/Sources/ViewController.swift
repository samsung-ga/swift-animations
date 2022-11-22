//
//  ViewController.swift
//  WDCalendarView
//
//  Created by Jaeyong Lee on 2022/11/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private let blueView = UIView()
    private let calendarView = CalendarView(
        today: .init(),
        frame: .init(
            origin: .zero,
            size: .init(width: DeviceInfo.screenWidth - 40, height: 0)
        )
    )
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        blueView.backgroundColor = .systemBlue

        view.addSubview(blueView)
        view.addSubview(calendarView)
        calendarView.delegate = self
        calendarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
        }
        blueView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
    }
}

extension ViewController: CalendarViewDelegate {
    func scrollViewDidEndDecelerating() {
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }

    func switchCalendarButtonDidTapped() {
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }

    func selectDate(_ date: Date?) {
        print(date)
    }
}
