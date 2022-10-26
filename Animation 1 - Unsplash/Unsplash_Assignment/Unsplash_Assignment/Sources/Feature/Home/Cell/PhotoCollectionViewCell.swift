//
//  PhotoCollectionViewCell.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/07.
//

import UIKit

final class PhotoCollectionViewCell: BaseCollectionViewCell {
    private let imageView: UnsplashImageView = {
        let imageView = UnsplashImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    func configure(_ photo: PhotoData, isDetail: Bool = false, animated: Bool = false) {
        if !isDetail {
            setName(photo.name, animated: animated)
        }
        imageView.photoData = photo
        imageView.setPhoto(animated: animated)
    }
    
    private func setName(_ name: String, animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.animateNameLabel(animated: animated)
            self?.nameLabel.text = name
        }
    }
    
    private func animateNameLabel(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.33) {
                self.nameLabel.alpha = 1
            }
        } else {
            self.nameLabel.alpha = 1
        }
    }
    
    override func layout() {
        super.layout()
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16)
        ])
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.photoData = nil
        imageView.image = nil
        imageView.resetVisualEffectView()
        nameLabel.text = ""
    }
}

extension PhotoCollectionViewCell {
    private enum Design {
        enum Asset: String {
            case test_image_long_height_1
            case test_image_short_height
            var image: UIImage? { .init(named: rawValue) }
        }
    }
}
