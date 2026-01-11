//
//  GitHubUsecCase.swift
//  TCA_Sample
//
//  Created by NoodleKim on 2026/01/08.
//

import ComposableArchitecture
import Foundation


/// GitHubUseCaseProtocol
public protocol GitHubUseCaseProtocol: Sendable {
    associatedtype RepositoryTypes
    var repository: RepositoryTypes { get }
    var userResults: Result<[UserEntity], GitHubAPIError> { get set }
    var repositoryResults: Result<[RepositoryEntity], GitHubAPIError> { get set }
    func fetchUser(query: String, completion: @escaping (Result<[UserEntity], GitHubAPIError>) -> Void)
    func fetchRepository(urlString: String, completion: @escaping (Result<[RepositoryEntity], GitHubAPIError>) -> Void)
}

extension GitHubUseCase: DependencyKey {
    public static var liveValue: any GitHubUseCaseProtocol = GitHubUseCase()
}

extension DependencyValues {
    var gitHubUseCase: any GitHubUseCaseProtocol {
    get { self[GitHubUseCase.self] }
    set { self[GitHubUseCase.self] = newValue }
  }
}

public struct GitHubUseCase: GitHubUseCaseProtocol {
    public typealias RepositoryTypes = UserSearchRepositoryProtocol & RepositorySearchRepositoryProtocol
    public var repository: RepositoryTypes = GitHubRepository()
    public var userResults: Result<[UserEntity], GitHubAPIError> = .success([])
    public var repositoryResults: Result<[RepositoryEntity], GitHubAPIError> = .success([])

    public func fetchUser(query: String, completion: @escaping (Result<[UserEntity], GitHubAPIError>) -> Void) {
        repository.fetchUser(query: query, completion: completion)
    }

    public func fetchRepository(urlString: String, completion: @escaping (Result<[RepositoryEntity], GitHubAPIError>) -> Void) {
        repository.fetchRepository(urlString: urlString, completion: completion)
    }
}

public struct GitHubTestUseCase: GitHubUseCaseProtocol {
    public typealias RepositoryTypes = UserSearchRepositoryProtocol & RepositorySearchRepositoryProtocol
    public let repository: RepositoryTypes = GitHubRepository()
    public var userResults: Result<[UserEntity], GitHubAPIError> = .success([])
    public var repositoryResults: Result<[RepositoryEntity], GitHubAPIError> = .success([])

    public func fetchUser(query: String, completion: @escaping (Result<[UserEntity], GitHubAPIError>) -> Void) {
        completion(userResults)
    }

    public func fetchRepository(urlString: String, completion: @escaping (Result<[RepositoryEntity], GitHubAPIError>) -> Void) {
        completion(repositoryResults)
    }
}
