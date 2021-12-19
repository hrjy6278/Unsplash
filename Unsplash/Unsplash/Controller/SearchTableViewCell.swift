//
//  SearchTableViewCell.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/19.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
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
    
    private var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        
        return button
    }()
    
    private var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
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
        addSubview(thumbnailImageView)
        addSubview(contentStackView)
    }
    
    func setupLayout() {
        let stackViewTopConstant: CGFloat = 8
        let stackViewLeadingConstant: CGFloat = 8
        let stackViewBottomConstant: CGFloat = -40
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: topAnchor,
                                                  constant: stackViewTopConstant),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                      constant: stackViewLeadingConstant),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                     constant: stackViewBottomConstant)
        ])
    }
}
