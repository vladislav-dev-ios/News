//
//  ArticleViewController.swift
//  News
//
//  Created by Владислав Кузьмичёв on 31.08.2022.
//

import Foundation
import UIKit

class ArticleDetailViewController: UIViewController {
    
    // MARK: -  Properties
    var presenter: ArticleDetailPresenterProtocol?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private lazy var sourceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sourceButtonTapped), for: .touchUpInside)
        
        let yourAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        
        let attributeString = NSMutableAttributedString(string: "Read in source",
                                                            attributes: yourAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1333171129, green: 0.133343339, blue: 0.1333138049, alpha: 1)
       
        configure()
        
        presenter?.setArticle()
    }
    
    override func viewDidLayoutSubviews() {
        let height = contentView.subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY
        if let height = height {
            scrollView.contentSize.height = height
        }
        
    }
    
}

// MARK: -  Private methods
extension ArticleDetailViewController {
    func configure() {
        contentView.addSubviews([
            articleImageView,
            titleLabel,
            contentLabel,
            dateLabel,
            sourceButton
        ])
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            dateLabel.leftAnchor.constraint(equalTo: contentView.safeLeftAnchor, constant: 10),
            dateLabel.topAnchor.constraint(equalTo: contentView.safeTopAnchor, constant: 5),
            
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: dateLabel.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.safeRightAnchor, constant: -10),
            
            contentLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            contentLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            articleImageView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10),
            articleImageView.leftAnchor.constraint(equalTo: contentLabel.leftAnchor),
            articleImageView.rightAnchor.constraint(equalTo: contentLabel.rightAnchor),
            
            sourceButton.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 5),
            sourceButton.rightAnchor.constraint(equalTo: articleImageView.rightAnchor),
            
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeTopAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
        
    }
    
    @objc
    private func sourceButtonTapped() {
        presenter?.sourceButtonTapped()
    }
}

// MARK: -  ArticleDetailView Protocol
extension ArticleDetailViewController: ArticleDetailViewProtocol {
    
    func setArticle(article: Article) {
        title = article.title
        titleLabel.text = article.title
        
        if let content = article.content {
            contentLabel.text = content
        }
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
                self.articleImageView.heightAnchor.constraint(equalTo: self.articleImageView.widthAnchor, multiplier: image.size.height/image.size.width).isActive = true
            }
        }
    }
    
    func presentView(vc: UIViewController) {
        vc.view.backgroundColor = #colorLiteral(red: 0.1333171129, green: 0.133343339, blue: 0.1333138049, alpha: 1)
        present(vc, animated: true)
    }
    
}
