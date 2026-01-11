//
//  RepositorySearchRepositoryProtocol.swift
//  TCA_Sample
//
//  Created by NoodleKim on 2026/01/08.
//

import Foundation

public protocol RepositorySearchRepositoryProtocol: Sendable {
    func fetchRepository(urlString: String, completion: @escaping (Result<[RepositoryEntity], GitHubAPIError>) -> Void)
}

extension GitHubRepository: RepositorySearchRepositoryProtocol {
    /// Githubのあるユーザーのリポジトリ一覧を取得して、結果をcallbackする
    func fetchRepository(urlString: String, completion: @escaping (Result<[RepositoryEntity], GitHubAPIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }

        Task {
            let result = await fetch(url: url)

            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let repositories = try? decoder.decode([RepositoryEntity].self, from: data) else {
                    completion(.failure(.jsonParseError(String(data: data, encoding: .utf8) ?? "")))
                    return
                }
                completion(.success(repositories))
            case .failure(let error):
                completion(.failure(.responseError(error)))
            }
        }
    }
}
