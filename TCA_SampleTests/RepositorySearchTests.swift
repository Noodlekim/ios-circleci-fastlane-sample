//
//  RepositorySearchTests.swift
//  TCA_Sample
//
//  Created by NoodleKim on 2026/01/08.
//

import Combine
import ComposableArchitecture
import Testing
import XCTest
@testable import TCA_Sample

struct RepositorySearchTests {

    @MainActor
    @Test func リポジトリ画面_画面ロード時_OK() async throws {
        let repoURL = "https://api.github.com/users/noodlekim/repos"
        let store = TestStore(initialState: RepositoryFeature.State(reposUrl: repoURL),
                                    reducer: { RepositoryFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        testUseCase.repositoryResults = .success([RepositoryEntity.mock])
        store.dependencies.gitHubUseCase = testUseCase
        // テスト開始
        await store.send(.onAppear)
        await store.receive(.repositoriesResponse(.success([RepositoryEntity.mock]))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .loaded([RepositoryEntity.mock])
        }
    }
    
    @MainActor
    @Test func リポジトリ画面_画面ロード時_urlError() async throws {
        let repoURL = "https://api.github.com/users/noodlekim/repos"
        let store = TestStore(initialState: RepositoryFeature.State(reposUrl: repoURL),
                                    reducer: { RepositoryFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.urlError
        testUseCase.repositoryResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase
        // テスト開始
        await store.send(.onAppear)
        await store.receive(.repositoriesResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }
    
    @MainActor
    @Test func リポジトリ画面_画面ロード時_responseDataEmpty() async throws {
        let repoURL = "https://api.github.com/users/noodlekim/repos"
        let store = TestStore(initialState: RepositoryFeature.State(reposUrl: repoURL),
                                    reducer: { RepositoryFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.responseDataEmpty
        testUseCase.repositoryResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase
        // テスト開始
        await store.send(.onAppear)
        await store.receive(.repositoriesResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    @MainActor
    @Test func リポジトリ画面_画面ロード時_jsonParseError() async throws {
        let repoURL = "https://api.github.com/users/noodlekim/repos"
        let store = TestStore(initialState: RepositoryFeature.State(reposUrl: repoURL),
                                    reducer: { RepositoryFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.jsonParseError("Json Parse Error")
        testUseCase.repositoryResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase
        // テスト開始
        await store.send(.onAppear)
        await store.receive(.repositoriesResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    @MainActor
    @Test func リポジトリ画面_画面ロード時_responseError() async throws {
        let repoURL = "https://api.github.com/users/noodlekim/repos"
        let store = TestStore(initialState: RepositoryFeature.State(reposUrl: repoURL),
                                    reducer: { RepositoryFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.responseError(ResponseError.invalidResponse)
        testUseCase.repositoryResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase
        // テスト開始
        await store.send(.onAppear)
        await store.receive(.repositoriesResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

}
