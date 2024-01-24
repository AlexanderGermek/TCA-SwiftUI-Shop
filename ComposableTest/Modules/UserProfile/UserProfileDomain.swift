//
//  UserProfileDomain.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 21.01.2024.
//

import Foundation
import ComposableArchitecture

struct UserProfileDomain: Reducer {

	// MARK: - State
	struct State: Equatable {
		var profileState: UserProfileModel = .default

		var fullName: String {
			return profileState.firstName + " " + profileState.lastName
		}

	}

	// MARK: - Action
	enum Action: Equatable {
		case loadUserProfile
		case loadUserProfileSuccess(TaskResult<UserProfileModel>)
	}

	// MARK: - Dependencies
	 @Dependency(\.userProfileService) var userProfileService

	// MARK: - Reducer
	var body: some Reducer<State, Action> {
		Reduce { state, action in

			switch action {
				
			case .loadUserProfile:
				return .run { send in
					let result = await TaskResult { try await self.userProfileService.fetchUserProfile() }
					await send(.loadUserProfileSuccess(result))
				}

			case .loadUserProfileSuccess(let result):
				switch result {
				case .success(let profile):
					state.profileState = profile
				case .failure(let error):
					print(error)
				}
			}

			return .none
		}
	}
}
