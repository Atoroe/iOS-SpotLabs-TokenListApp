//
//  TokenListViewController.swift
//  Token List App
//
//  Created by Artem Poluyanovich on 18/12/2024.
//

import UIKit
import Combine

// MARK: - TokenListViewController
final class TokenListViewController: BaseViewController {
    
    // MARK: - Private Properties
    
    private let tableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: TokenListViewModelType
    
    // MARK: - Init
    
    init(viewModel: TokenListViewModelType) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubview(tableView)
        view.addSubview(spinner)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        [tableView, spinner].forEach { $0.translatesAutoresizingMaskIntoConstraints = false}
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = Color.background
        
        title = Text.title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Color.title
        ]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TokenCell.self, forCellReuseIdentifier: "TokenCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = Color.background
        
        spinner.color = .white
    }
    
    // MARK: - Binding
    override func bind() {
        super.bind()
        
        // MARK: Outputs
        
        viewModel.outputs.isLoadingPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                isLoading ? spinner.startAnimating()  : spinner.stopAnimating()
            }.store(in: &cancellables)
        
        viewModel.outputs.reloadDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.outputs.errorPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self else { return }
                let alert = UIAlertController(title: Text.errorTitle, message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Text.okButton, style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputs.loadTokens()
    }
}

// MARK: - UITableViewDataSource
extension TokenListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.outputs.state?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = viewModel.outputs.state?.sections[section]
        return sectionData?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = viewModel.outputs.state?.sections[indexPath.section]
        let item = sectionData?.items[indexPath.row]
        switch item {
        case .token(let token):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TokenCell", for: indexPath) as? TokenCell else { return UITableViewCell() }
            cell.render(.init(token: token))
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension TokenListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Layout.Table.variableCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Layout.Table.variableFooterHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Layout.Table.heightForHeaderInSection
    }
}

// MARK: - Constants
private extension TokenListViewController {
    enum Layout {
        enum Table {
            static let variableCellHeight: CGFloat = 100
            static let variableFooterHeight: CGFloat = 4
            static let heightForHeaderInSection: CGFloat = 0
        }
    }
    
    enum Color {
        static let background: UIColor = .black
        static let title: UIColor = .white
    }
    
    enum Font {
        static let title: UIFont = .systemFont(ofSize: 24, weight: .bold)
    }
    
    enum Text {
        static let title: String = "TOKENS"
        static let errorTitle: String = "Error"
        static let okButton: String = "OK"
    }
}
