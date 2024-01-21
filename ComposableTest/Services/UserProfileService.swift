//
//  UserProfileService.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 21.01.2024.
//

import Foundation
import ComposableArchitecture

/// Сервис для работы с API профиля пользователя
struct UserProfileService {

	enum Constants {
		static let profileURL = "https://fakestoreapi.com/products"
	}

	var fetchUserProfile: @Sendable () async throws -> UserProfileModel
}

// MARK: - DependencyValues
extension DependencyValues {
	var userProfileService: UserProfileService {
		get { self[UserProfileService.self] }
		set { self[UserProfileService.self] = newValue }
	}
}

// MARK: - DependencyKey
extension UserProfileService: DependencyKey {

	static var liveValue: UserProfileService = Self(

		// Получить профиль пользователя
		fetchUserProfile: {

			guard let url = URL(string: Constants.profileURL) else {
				throw NetworkError.invalidURL
			}

			guard let (data, _) = try? await URLSession.shared.data(from: url) else {
				throw NetworkError.networkError
			}

			guard let profile = try? JSONDecoder().decode(UserProfileModel.self, from: data) else {
				throw NetworkError.decodeError
			}

			return profile
		})
}
