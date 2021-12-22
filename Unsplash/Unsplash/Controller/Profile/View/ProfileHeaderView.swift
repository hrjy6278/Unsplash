//
//  ProfileHeaderView.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/22.
//

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {
    //MARK: Properties
    static let identifier = "ProfileHeaderView"
    
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private var nameLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        return stackView
    }()
}

//MARK: - Setup View And Layout
extension ProfileHeaderView: HierarchySetupable {
    func setupViewHierarchy() {
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(nameLabel)
        
        contentView.addSubview(stackView)
    }
    
    func setupLayout() {
        let stackViewLeadingConstant: CGFloat = 16
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leftAnchor,
                                               constant: stackViewLeadingConstant)
        ])
    }
}
