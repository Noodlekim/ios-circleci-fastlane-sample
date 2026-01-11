//
//  TCA_SampleTests.swift
//  TCA_SampleTests
//
//  Created by NoodleKim on 2026/01/08.
//

import Combine
import ComposableArchitecture
import Testing
import XCTest
@testable import TCA_Sample

struct TCA_SampleTests {

    @MainActor
    @Test func ユーザー検索画面_画面ロード時_OK() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let mockUsers = [UserEntity.mock]
        testUseCase.userResults = .success(mockUsers)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.onAppear)
        await store.receive(.searchResponse(.success(mockUsers))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .loaded(mockUsers)
        }
    }

    @MainActor
    @Test func ユーザー検索画面_画面ロード時_urlError() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.urlError
        testUseCase.userResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.onAppear)
        await store.receive(.searchResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    @MainActor
    @Test func ユーザー検索画面_画面ロード時_jsonParseError() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.jsonParseError("Json Parse Error")
        testUseCase.userResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.onAppear)
        await store.receive(.searchResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    @MainActor
    @Test func ユーザー検索画面_画面ロード時_responseError() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.responseError(ResponseError.invalidResponse)
        testUseCase.userResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.onAppear)
        await store.receive(.searchResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    @MainActor
    @Test func ユーザー検索画面_画面ロード時_responseDataEmpty() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.responseDataEmpty
        testUseCase.userResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.onAppear)
        await store.receive(.searchResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    
    @MainActor
    @Test func ユーザー検索画面_キーワード入力時_OK() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        testUseCase.userResults = .success([UserEntity.mock])
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.searchUsers("test"))
        await store.receive(.searchResponse(.success([UserEntity.mock]))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .loaded([UserEntity.mock])
        }
    }

    @MainActor
    @Test func ユーザー検索画面_キーワード入力時_urlError() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.urlError
        testUseCase.userResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.searchUsers("test"))
        await store.receive(.searchResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    @MainActor
    @Test func ユーザー検索画面_キーワード入力時_jsonParseError() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.jsonParseError("Json Parse Error")
        testUseCase.userResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.searchUsers("test"))
        await store.receive(.searchResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    @MainActor
    @Test func ユーザー検索画面_キーワード入力時_responseError() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.responseError(ResponseError.invalidResponse)
        testUseCase.userResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.searchUsers("test"))
        await store.receive(.searchResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    @MainActor
    @Test func ユーザー検索画面_キーワード入力時_responseDataEmpty() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.responseDataEmpty
        testUseCase.userResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.searchUsers("test"))
        await store.receive(.searchResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    @MainActor
    @Test func ユーザー検索画面_キーワード入力時_NG() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.responseDataEmpty
        testUseCase.userResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.searchUsers("test"))
        await store.receive(.searchResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    
    @MainActor
    @Test func ユーザー検索画面_引っ張って更新時_OK() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        testUseCase.userResults = .success([UserEntity.mock])
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.pullToRefresh)
        await store.receive(.searchResponse(.success([UserEntity.mock]))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .loaded([UserEntity.mock])
        }
    }
    
    @MainActor
    @Test func ユーザー検索画面_引っ張って更新時_NG() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.jsonParseError("データ変化失敗")
        testUseCase.userResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.pullToRefresh)
        await store.receive(.searchResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    @MainActor
    @Test func ユーザー検索画面_引っ張って更新時_urlError() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.urlError
        testUseCase.userResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.pullToRefresh)
        await store.receive(.searchResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    @MainActor
    @Test func ユーザー検索画面_引っ張って更新時_jsonParseError() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.jsonParseError("Json Parse Error")
        testUseCase.userResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.pullToRefresh)
        await store.receive(.searchResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    @MainActor
    @Test func ユーザー検索画面_引っ張って更新時_responseError() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.responseError(ResponseError.invalidResponse)
        testUseCase.userResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.pullToRefresh)
        await store.receive(.searchResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    @MainActor
    @Test func ユーザー検索画面_引っ張って更新時_responseDataEmpty() async throws {
        let store = TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        var testUseCase = GitHubTestUseCase()
        // 期待値設定
        let error = GitHubAPIError.responseDataEmpty
        testUseCase.userResults = .failure(error)
        store.dependencies.gitHubUseCase = testUseCase

        // テスト開始
        await store.send(.pullToRefresh)
        await store.receive(.searchResponse(.failure(error))) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.loadState = .failed(error)
        }
    }

    @Test func ユーザー検索画面_あるユーザーをタップ時_OK() async throws {
        let store = await TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })

        // テスト開始
        let mockUser = UserEntity.mock
        await store.send(.onTapUserRow(mockUser)) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.path.append(RepositoryFeature.State(reposUrl: mockUser.reposUrl))
        }
    }

    // TODO: NGパターン追加
    @Test func ユーザー検索画面_あるユーザーをタップ時_NG() async throws {
        let store = await TestStore(initialState: UserSearchFeature.State(),
                                    reducer: { UserSearchFeature() })
        // テスト開始
        let mockUser = UserEntity.mock
        await store.send(.onTapUserRow(mockUser)) {
            // 期待値を指定すると比較してOK/ NG有無を判断
            $0.path.append(RepositoryFeature.State(reposUrl: mockUser.reposUrl))
        }
    }

}

enum ResponseError: Error {
    case invalidResponse
}
