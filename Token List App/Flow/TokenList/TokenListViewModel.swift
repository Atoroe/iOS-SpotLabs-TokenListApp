//
//  TokenListViewModel.swift
//  Token List App
//
//  Created by Artem Poluyanovich on 18/12/2024.
//

import Combine
import Foundation

// MARK: - TokenListViewModelInputs
protocol TokenListViewModelInputs {
    func loadTokens()
}

// MARK: - TokenListViewModelOutputs
protocol TokenListViewModelOutputs {
    typealias State = TokenListViewModelState
    
    var state: State? { get }
    var errorPublisher: AnyPublisher<String?, Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool?, Never> { get }
    var reloadDataPublisher: AnyPublisher<Void, Never> { get }
}

// MARK: - TokenListViewModelType
protocol TokenListViewModelType {
    var inputs: TokenListViewModelInputs { get }
    var outputs: TokenListViewModelOutputs { get }
}

// MARK: - ViewModelConformance
private typealias ViewModelConformance = (
    TokenListViewModelInputs &
    TokenListViewModelOutputs &
    TokenListViewModelType
)

// MARK: - TokenListViewModel
final class TokenListViewModel: ViewModelConformance {
    
    // MARK: - Private properties
    private let tokensService: TokensUseCase
    
    private var cancellables = Set<AnyCancellable>()
    private var reloadDataSubject = PassthroughSubject<Void, Never>()
    @Published private var errorMessage: String?
    @Published private var isLoading: Bool?
    @Published private var tokens: [Token]?

    // MARK: - Init
    init(tokensService: TokensUseCase) {
        self.tokensService = tokensService
        
        subscribeToChanches()
    }
    
    // MARK: - Outputs
    @Published private(set) var state: State?
    var isLoadingPublisher: AnyPublisher<Bool?, Never> { $isLoading.eraseToAnyPublisher() }
    var errorPublisher: AnyPublisher<String?, Never> { $errorMessage.eraseToAnyPublisher() }
    var reloadDataPublisher: AnyPublisher<Void, Never> { reloadDataSubject.eraseToAnyPublisher() }
    
    // MARK: - Inputs
    func loadTokens() {
        isLoading = true
        Task {
            do {
                defer { isLoading = false }
                tokens = try await tokensService.loadTokens()
            } catch {
                handleAPI(error)
            }
        }
    }
}

// MARK: - Private methods
private extension TokenListViewModel {
    func subscribeToChanches() {
        $tokens
            .compactMap() { $0 }
            .sink { [weak self] tokens in
                self?.state = .init(sections: [.init(
                    id: .main,
                    items: tokens.map { .token(context: $0)}
                )])
                self?.reloadDataSubject.send()
            }
            .store(in: &cancellables)
        
        $state
            .sink { [weak self] state in
                self?.reloadDataSubject.send(())
            }
            .store(in: &cancellables)
    }
    
    func handleAPI(_ error: Error) {
        if let localizedError = error as? LocalizedError {
            errorMessage = localizedError.errorDescription ?? Text.error
        } else {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Constants
extension TokenListViewModel {
    enum Text {
        static let error = "An unexpected error occurred."
    }
}

// MARK: - TokenListViewModel
extension TokenListViewModel {
    var inputs: TokenListViewModelInputs { return self }
    var outputs: TokenListViewModelOutputs { return self }
}
