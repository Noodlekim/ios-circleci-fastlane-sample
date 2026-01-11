//
//  RepositoryFeature.swift
//  TCA_Sample
//
//  Created by NoodleKim on 2026/01/08.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct RepositoryFeature {
    @ObservableState
    struct State: Equatable {
        /// GitHubレポジトリURL
        var reposUrl: String
        /// Viewのステート
        var loadState: LoadingState<[RepositoryEntity]> = .initial
    }
    
    public enum Action: Equatable {
        /// 画面表示時
        case onAppear
        
        // MARK: - State更新
        
        /// GitHubレポジトリのレスポンス設定
        case repositoriesResponse(TaskResult<[RepositoryEntity]>)
    }

    @Dependency(\.gitHubUseCase) var gitHubUseCase

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let repoUrl = state.reposUrl
                return .run { send in
                    switch await
                    fetchRepository(urlString: repoUrl) {
                    case .success(let repository):
                        await send(.repositoriesResponse(.success(repository)))
                    case .failure(let error):
                        await send( .repositoriesResponse(.failure(error)))
                    }
                }
            case .repositoriesResponse(.success(let repositories)):
                state.loadState = .loaded(repositories)
                return .none
            case .repositoriesResponse(.failure(let error)):
                state.loadState = .failed(error)
                return .none
            }
        }
    }
    
    private func fetchRepository(urlString: String) async -> Result<[RepositoryEntity], GitHubAPIError> {
        // TCAでは非同期処理はasync/awaitで行わせるべき
        return await withCheckedContinuation { continuation in
            gitHubUseCase.fetchRepository(urlString: urlString) { result in
                switch result {
                case .success(let repositories):
                    continuation.resume(returning: .success(repositories))
                case .failure(let error):
                    continuation.resume(returning: .failure(error))
                }
            }
        }
    }
}
