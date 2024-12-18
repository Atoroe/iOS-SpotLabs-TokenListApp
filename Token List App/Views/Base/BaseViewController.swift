//
//  BaseViewController.swift
//  Token List App
//
//  Created by Artem Poluyanovich on 18/12/2024.
//

import UIKit

// MARK: - BaseViewController
open class BaseViewController: UIViewController {
    
    // MARK: - Init
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("This view can be initiated only from code")
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Lifecycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupView()
        localize()
        bind()
    }
    
    // MARK: - Methods
    open func setupHierarchy() {}
    
    open func setupLayout() {}

    open func setupView() {}

    open func localize() {}

    open func bind() {}
}
