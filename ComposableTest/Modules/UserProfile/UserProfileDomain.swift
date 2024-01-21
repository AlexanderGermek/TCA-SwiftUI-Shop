//
//  UserProfileDomain.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 21.01.2024.
//

import Foundation
import ComposableArchitecture

struct UserProfileDomain {

	// MARK: - State
	struct State: Equatable {
		var profileState: UserProfileModel = .default
		
	}

	// MARK: - Action
	enum Action: Equatable {
		case loadUserProfile
		case loadUserProfileSuccess(TaskResult<[Product]>)
	}

	// MARK: - Dependencies
	// @Dependency(\.) var

	// MARK: - Reducer
	var body: some Reducer<State, Action> {
		Reduce { state, action in
			return .send(.test)
		}
	}
}
