//
//  ArticleTableViewCell.swift
//  News
//
//  Created by Владислав Кузьмичёв on 31.08.2022.
//

import Foundation
import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    // MARK: -  Properties
    static let identifier = "ArticleTableViewCell"
    
    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = #colorLiteral(red: 0.5999438763, green: 0.6000348926, blue: 0.599932313, alpha: 1)
        return label
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = #colorLiteral(red: 0.1333171129, green: 0.133343339, blue: 0.1333138049, alpha: 1)
        selectionStyle = .none
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        articleImageView.image = nil
    }
    
}

// MARK: - Priavate Methods
extension ArticleTableViewCell {
    private func setupConstraints() {
        contentView.addSubviews([
            articleImageView,
            titleLabel,
            dateLabel,
        ])
        NSLayoutConstraint.activate([
            articleImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            articleImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            articleImageView.widthAnchor.constraint(equalTo: articleImageView.heightAnchor),
            articleImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 7/8),
            
            dateLabel.bottomAnchor.constraint(equalTo: articleImageView.bottomAnchor),
            dateLabel.leftAnchor.constraint(equalTo: articleImageView.rightAnchor, constant: 5),
            dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            dateLabel.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.leftAnchor.constraint(equalTo: articleImageView.rightAnchor, constant: 5),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            titleLabel.topAnchor.constraint(equalTo: articleImageView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 0)
    
        ])
    }
    
    
}

// MARK: - Configure Cell
extension ArticleTableViewCell {
    func configure(article: Article) {
        titleLabel.text = article.title
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        
        if let dateObj = dateFormatter.date(from: article.publishedAt) {
            dateFormatter.dateFormat = "dd MMM, HH:mm"
            dateLabel.text = dateFormatter.string(from: dateObj)
        }
        
        guard let urlString = article.urlToImage else { return }
        guard let url = URL(string: urlString) else { return }
        
        ImageLoader.fetchImage(url: url) { image in
            if let image = image {
                self.articleImageView.image = image
            }
        }
        
    }
    
}
