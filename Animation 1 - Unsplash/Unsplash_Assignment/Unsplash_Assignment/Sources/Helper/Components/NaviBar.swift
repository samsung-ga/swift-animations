//
//  NaviBar.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/11.
//

import UIKit

protocol NaviBarDelegate: AnyObject {
    func tapLeftItem()
}

final class NaviBar: BaseView {

    private lazy var leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(leftItemTapped), for: .touchUpInside)
        return button
    }()
    private let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let titleLbael: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    private let naviHeight: CGFloat = 56
    
    weak var navigationBarDelegate: NaviBarDelegate?
    
    override func attribute() {
        backgroundColor = .clear
        leftButton.isHidden = true
        rightButton.isHidden = true
    }
    
    override func layout() {
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: naviHeight)
        ])
        
        addSubview(leftButton)
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            leftButton.widthAnchor.constraint(equalToConstant: 30),
            leftButton.heightAnchor.constraint(equalToConstant: 30),
            leftButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        addSubview(rightButton)
        NSLayoutConstraint.activate([
            rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            rightButton.widthAnchor.constraint(equalToConstant: 24),
            rightButton.heightAnchor.constraint(equalToConstant: 24),
            rightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        addSubview(titleLbael)
        NSLayoutConstraint.activate([
            titleLbael.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLbael.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    /// 뒤로가기 버튼 추가
    func setupBackItemImage() {
        let image = UIImage(systemName: "xmark")
        leftButton.setImage(image, for: .normal)
        leftButton.tintColor = .white
        leftButton.isHidden = false
    }
    
    /// 공유 버튼 추가
    func setupShareItemImage() {
        let image = UIImage(systemName: "square.and.arrow.down")
        rightButton.setImage(image, for: .normal)
        rightButton.tintColor = .white
        rightButton.isHidden = false
    }
    
    /// 제목 문구 설정
    func setupTitle(_ title: String = "") {
        titleLbael.text = title
    }
}

extension NaviBar {
    @objc func leftItemTapped() {
        navigationBarDelegate?.tapLeftItem()
    }
}
