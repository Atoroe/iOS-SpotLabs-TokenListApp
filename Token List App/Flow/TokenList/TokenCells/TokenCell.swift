//
//  TokenCell.swift
//  Token List App
//
//  Created by Artem Poluyanovich on 18/12/2024.
//

import UIKit
import SDWebImage

// MARK: - TokenCell
final class TokenCell: BaseTableViewCell {
    
    // MARK: - Properties
    private let containerStackView = UIStackView()
    private let logoImageView = UIImageView()
    private let descriptionStackView = UIStackView()
    private let nameLabel = UILabel()
    private let symbolLabel = UILabel()
    private let priceLabel = UILabel()

    // MARK: - Life Cyrcle
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubview(containerStackView)
        [logoImageView, descriptionStackView].forEach { containerStackView.addArrangedSubview($0) }
        [nameLabel, symbolLabel, priceLabel].forEach { descriptionStackView.addArrangedSubview($0) }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        [
            containerStackView,
            logoImageView,
            descriptionStackView,
            nameLabel,
            symbolLabel,
            priceLabel
        ].forEach() { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        containerStackView.layoutMargins = Layout.containerStackViewInsets
        containerStackView.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: Layout.contentViewHeight),
            
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            logoImageView.widthAnchor.constraint(equalToConstant: Layout.logoImageViewSize.width),
            logoImageView.heightAnchor.constraint(equalToConstant: Layout.logoImageViewSize.height)
        ])
    }
    
    override func setupView() {
        super.setupView()
        
        selectionStyle = .none
        
        containerStackView.axis = .horizontal
        containerStackView.spacing = Layout.containerStackViewSpacing
        
        descriptionStackView.axis = .horizontal
        descriptionStackView.spacing = Layout.descriptionStackViewSpacing
        
        logoImageView.layer.cornerRadius = Layout.logoImageViewCornerRadius
        logoImageView.clipsToBounds = true
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = Image.placeholder
        
        nameLabel.font = Font.name
        nameLabel.textColor = Color.lightGray
        symbolLabel.font = Font.symbol
        symbolLabel.textColor = Color.white
        priceLabel.font = Font.symbol
        priceLabel.textColor = Color.white
    }
}

// MARK: Constants
private extension TokenCell {
    enum Layout {
        static let containerStackViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let logoImageViewSize: CGSize = CGSize(width: 64, height: 64)
        static let contentViewHeight: CGFloat = 96
        static let containerStackViewSpacing: CGFloat = 16
        static let descriptionStackViewSpacing: CGFloat = 5
        static let logoImageViewCornerRadius: CGFloat = 32
    }
    
    enum Color {
        static let lightGray: UIColor = .lightGray
        static let white: UIColor = .white
    }
    
    enum Image {
        static let placeholder = UIImage(named: "placeholder")
    }
    
    enum Font {
        static let name: UIFont = .boldSystemFont(ofSize: 16)
        static let symbol: UIFont = .boldSystemFont(ofSize: 16)
    }
}


// MARK: - Render
extension TokenCell {
    struct TokenCellContext {
        let logoUrl: String?
        let name: String?
        let symbol: String?
        let price: Double?
        
        init(token: Token) {
            self.logoUrl = token.logoURI
            self.name = token.name
            self.symbol = token.symbol
            self.price = token.price
        }
    }
    
    func render(_ context: TokenCellContext) {
        if let logoUrlString = context.logoUrl {
            logoImageView.sd_setImage(
                with: URL(string: logoUrlString),
                placeholderImage: Image.placeholder
            )
        }
        nameLabel.text = context.name
        symbolLabel.text = context.symbol
        priceLabel.text = Formatter.formatDoubleToString(context.price)
    }
}

// MARK: - Formatter
private extension TokenCell {
    enum Formatter {
        static func formatDoubleToString(_ value: Double?) -> String? {
            guard let value = value else { return nil }
            return String(format: "%.2f", value)
        }
    }
}
