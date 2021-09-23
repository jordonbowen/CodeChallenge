//
//  RedditFeedTableViewCell.swift
//  CodeChallenge
//
//  Created by Jordon Bowen on 9/22/21.
//

import UIKit

class RedditFeedTableViewCell: UITableViewCell {
    
    static let identifier = "RedditFeedTableViewCell"
    
    // MARK: - private properties
    lazy private var mainStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8.0
        return stackView
    }()
    
    lazy private var feedImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy private var feedTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy private var feedCommentNumberLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.lineBreakMode = .byWordWrapping
        label.textColor = .blue
        return label
    }()
    
    lazy private var feedScoreLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.lineBreakMode = .byWordWrapping
        label.textColor = .darkText
        return label
    }()
    
    // MARK: - internal funcs
    func configureCell(title: String?, commentNumber: String?, score: String?, imageData: Data?) {
        setUpUI()
        
        feedTitleLabel.text = title
        feedCommentNumberLabel.text = commentNumber
        feedScoreLabel.text = score
        feedImageView.image = UIImage(named: "imagenotfound")
        if let data = imageData {
            feedImageView.image = UIImage(data: data)
        }
    }
    
    // MARK: - private funcs
    private func setUpUI() {
        
        mainStackView.addArrangedSubview(feedTitleLabel)
        mainStackView.addArrangedSubview(feedImageView)
        mainStackView.addArrangedSubview(feedCommentNumberLabel)
        mainStackView.addArrangedSubview(feedScoreLabel)
        
        contentView.addSubview(mainStackView)
        
        // set contraints
        let safeArea = contentView.safeAreaLayoutGuide
        feedImageView.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
        mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8.0).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8.0).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8.0).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8.0).isActive = true
        
    }
}
