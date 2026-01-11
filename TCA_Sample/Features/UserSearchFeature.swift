//
//  UserSearchFeature.swift
//  TCA_Sample
//
//  Created by NoodleKim on 2026/01/08.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct UserSearchFeature {
    @Dependency(\.gitHubUseCase) var gitHubUseCase

    @ObservableState
    public struct State: Equatable {
        /// TextFieldのキーワード用
        var searchText: String = "noodlekim"
        /// Viewのステート
        var loadState: LoadingState<[UserEntity]> = .initial
        /// Navigation遷移ステート
        var path = StackState<RepositoryFeature.State>()
        /// RepositoryFeature.State: 画面遷移時itemとして使う感じ
        @Presents var repositoryViewState: RepositoryFeature.State?
    }
    
    public enum Action: BindableAction, Equatable {
        /// Navigation遷移
        case path(StackAction<RepositoryFeature.State, RepositoryFeature.Action>)
        /// `State` Binding
        case binding(BindingAction<State>)
        /// 画面表示時
        case onAppear
        
        // MARK: - User Interaction
        
        /// キーワード入力時
        case searchUsers(String)
        /// 引っ張って更新
        case pullToRefresh
        /// セルタップ時
        case onTapUserRow(UserEntity)
        
        // MARK: - State更新
        
        /// GitHubユーザーレスポンス設定
        case searchResponse(TaskResult<[UserEntity]>)
        /// 詳細画面のアクションキャッチアップ
        case repositoryViewAction(PresentationAction<RepositoryFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .path:
                return .none
            case .binding:
                return .none
            case .binding(\.searchText):
                let keyword = state.searchText
                return .run { send in
                    // GitHub APIのレンダー防止
                    try await Task.sleep(nanoseconds: 300_000_000)
                    await send(.searchUsers(keyword))
                }
            case .onAppear:
                return fetchUser(keyword: state.searchText)
            case .searchUsers(let keyword):
                return fetchUser(keyword: keyword)
            case .pullToRefresh:
                return fetchUser(keyword: state.searchText)
            case .onTapUserRow(let user):
                let reposUrl = user.reposUrl
                state.path.append(RepositoryFeature.State(reposUrl: reposUrl))
                return .none
            case .searchResponse(.success(let users)):
                state.loadState = .loaded(users)
                return .none
            case .searchResponse(.failure(let error)):
                state.loadState = .failed(error)
                return .none
                // `RepositoryView`からアクションを受けたい時はここで処理
            case .repositoryViewAction(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            RepositoryFeature()
        }
        .ifLet(\.$repositoryViewState, action: \.repositoryViewAction, destination: {
            RepositoryFeature()
        })
    }
    
    /// キーワードでGitHugユーザー検索
    /// - Parameter keyword: キーワード
    /// - Returns: レスポンス結果を`.searchResponse`で返す
    private func fetchUser(keyword: String) -> Effect<UserSearchFeature.Action> {
        .run { send in
            switch await fetchUser(searchText: keyword) {
            case .success(let user):
                await send(.searchResponse(.success(user)))
            case .failure(let error):
                await send(.searchResponse(.failure(error)))
            }
        }
    }

    /// キーワードでGitHubユーザー一覧を取得
    /// - Parameter searchText: キーワード
    /// - Returns: 成功: [UserEntity], 失敗: GitHubAPIError
    private func fetchUser(searchText: String) async -> Result<[UserEntity], GitHubAPIError> {
        return await withCheckedContinuation { continuation in
            gitHubUseCase.fetchUser(query: searchText) { result in
                switch result {
                case .success(let users):
                    continuation.resume(returning: .success(users))
                case .failure(let error):
                    continuation.resume(returning: .failure(error))
                }
            }
        }
    }
}
