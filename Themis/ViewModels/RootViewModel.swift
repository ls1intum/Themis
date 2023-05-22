//
//  RootViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 13.05.23.
//

import Foundation
import Combine
import UserStore
import SharedServices

@MainActor
class RootViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var isLoggedIn = false

    private var cancellables: Set<AnyCancellable> = Set()

    init() {
        UserSession.shared.objectWillChange.sink {
            DispatchQueue.main.async { [weak self] in
                self?.isLoggedIn = UserSession.shared.isLoggedIn
            }
        }
        .store(in: &cancellables)
        
        
        Task(priority: .high) {
            let user = await AccountServiceFactory.shared.getAccount()

            switch user {
            case .loading, .failure:
                UserSession.shared.setTokenExpired(expired: false)
            case .done:
                isLoggedIn = UserSession.shared.isLoggedIn
            }
            isLoading = false
        }
    }
}
