//
//  UserSearchRepositoryProtocol.swift
//  TCA_Sample
//
//  Created by NoodleKim on 2026/01/08.
//

import Foundation

public protocol UserSearchRepositoryProtocol: Sendable {
    func fetchUser(query: String, completion: @escaping (Result<[UserEntity], GitHubAPIError>) -> Void)
}

extension GitHubRepository: UserSearchRepositoryProtocol {
    /// QueryをもとにGithubのユーザー検索APIを叩いて、結果をcallbackする
    func fetchUser(query: String, completion: @escaping (Result<[UserEntity], GitHubAPIError>) -> Void) {
        guard !query.isEmpty,
              let url = userSearchEndpoint(query: query) else {
            completion(.failure(.urlError))
            return
        }

        Task {
            let result = await fetch(url: url)

            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let users = try? decoder.decode(UsersEntity.self, from: data) else {
                    completion(.failure(.jsonParseError(String(data: data, encoding: .utf8) ?? "")))
                    return
                }
                completion(.success(users.items))
            case .failure(let error):
                completion(.failure(.responseError(error)))
            }
        }
    }
}
