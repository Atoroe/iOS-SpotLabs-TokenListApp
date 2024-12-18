//
//  BaseTableViewCell.swift
//  Token List App
//
//  Created by Artem Poluyanovich on 18/12/2024.
//

import UIKit

// MARK: - BaseTableViewCell
open class BaseTableViewCell: UITableViewCell {

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHierarchy()
        setupLayout()
        setupView()
        localize()
        bind()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
        setupView()
        localize()
        bind()
    }

    open override func layoutSubviews() {
        setupLayout()
    }

    // MARK: - Methods
    open func setupHierarchy() {}
    
    open func setupLayout() {}

    open func setupView() {}

    open func localize() {}

    open func bind() {}
}
