//
//  AnimatedSearchBar.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/12.
//

import UIKit

protocol SearchBarDelegate: AnyObject {
    func tapSearch(_ keyword: String)
    func tapCancelButton()
}

final class SearchBar: BaseView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.init(white: 0.12, alpha: 1)
        return view
    }()
    private let iconImageView: UIImageView = {
        let image = UIImage.init(systemName: "magnifyingglass")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white.withAlphaComponent(0.4)
        return imageView
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.setAttributedPlaceholder(text: "Search Photos",
                                           color: .white.withAlphaComponent(0.4),
                                           font: UIFont.systemFont(ofSize: 17))
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.delegate = self
        return textField
    }()
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.isHidden = true
        button.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        return button
    }()
    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }
    weak var searchBarDelegate: SearchBarDelegate?
    
    override func layout() {
        super.layout()
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Constant.searchBarHeight)
        ])
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        stackView.addArrangedSubview(containerView)
        
        containerView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 6),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        containerView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        stackView.addArrangedSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setCacncelButtonHidden(_ isHidden: Bool) {
        self.cancelButton.isHidden = isHidden
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
    
    func setPlaceholder(_ placeholder: String) {
        textField.placeholder = placeholder
    }
    
    func setReturnKeyType(_ type: UIReturnKeyType) {
        textField.returnKeyType = type
    }
    
}

extension SearchBar: UITextFieldDelegate {
    
    @objc func tapCancel() {
        self.endEditing(true)
        setCacncelButtonHidden(true)
        searchBarDelegate?.tapCancelButton()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setCacncelButtonHidden(false)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        guard let text = textField.text,
              !text.isEmpty else {
                  return true
              }
        searchBarDelegate?.tapSearch(text)
        return true
    }
}
