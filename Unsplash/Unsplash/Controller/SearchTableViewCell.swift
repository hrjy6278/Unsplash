//
//  SearchTableViewCell.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/19.
//

import UIKit
import Kingfisher

protocol SearchTableViewCellDelegate: AnyObject {
    func didTapedLikeButton(_ id: String)
}

class SearchTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    weak var delegate: SearchTableViewCellDelegate?
    
    private var imageId: String = ""
    
    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private var likeCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(didTapedLikeButton), for: .touchUpInside)
        
        return button
    }()
    
    private var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 8
        
        return stackView
    }()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("스토리보드는 지원하지 않습니다.")
    }
}

//MARK: - Method
extension SearchTableViewCell: HierarchySetupable {
    func setupViewHierarchy() {
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(likeCountLabel)
        contentStackView.addArrangedSubview(likeButton)
        
        addSubview(thumbnailImageView)
        contentView.addSubview(contentStackView)
    }
    
    func setupLayout() {
        let stackViewTopConstant: CGFloat = 16
        let stackViewLeadingConstant: CGFloat = 16
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: topAnchor,
                                                  constant: stackViewTopConstant),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                      constant: stackViewLeadingConstant),
        ])
    }
    
    func configure(id: String, title: String?, likeCount: String?, isUserLike: Bool, imageUrl: URL?) {
        imageId = id
        titleLabel.text = title
        likeCountLabel.text = likeCount
        
        configureUserLikeButtonView(isUserLike: isUserLike)
        configureThumbnailImageView(imageUrl)
    }
    
    private func configureThumbnailImageView(_ imageUrl: URL?) {
        thumbnailImageView.kf.indicatorType = .activity
        thumbnailImageView.kf.setImage(with: imageUrl,
                                       options: [.keepCurrentImageWhileLoading])
    }
    
    private func configureUserLikeButtonView(isUserLike: Bool) {
        var image: UIImage?
        
        isUserLike ? (image = UIImage(systemName: "heart.fill")) : (image = UIImage(systemName: "heart"))
        
        likeButton.setImage(image, for: .normal)
    }
    
    @objc func didTapedLikeButton() {
        delegate?.didTapedLikeButton(imageId)
    }
    
    override func prepareForReuse() {
        self.thumbnailImageView.image = nil
        self.titleLabel.text = nil
        self.likeCountLabel.text = nil
        self.likeButton.imageView?.image = nil
    }
}
