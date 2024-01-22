//
//  MainDomain.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 21.01.2024.
//

import ComposableArchitecture

struct MainDomain: Reducer {

	// MARK: - State
	struct State: Equatable {
		var currentTab = Tab.products
		var productListState = ProductListDomain.State()
		var profileState = UserProfileDomain.State()

		enum Tab {
			case products
			case profile
		}
	}

	// MARK: - Action
	enum Action: Equatable {
		case tabSelected(State.Tab)
		case productList(ProductListDomain.Action)
		case userProfile(UserProfileDomain.Action)
	}

	// MARK: - Dependencies
	@Dependency(\.productService) var productService
	@Dependency(\.userProfileService) var userProfileService

	// MARK: - Reducer
	var body: some Reducer<State, Action> {
		Scope(state: \.productListState, action: /MainDomain.Action.productList) {
			ProductListDomain()
		}
		Scope(state: \.profileState, action: /MainDomain.Action.userProfile) {
			UserProfileDomain()
		}
		Reduce { state, action in
			switch action {
			case .tabSelected(let tab):
				state.currentTab = tab

			case .productList(let productAction): break

			case .userProfile(let userAction): break
			}

			return .none
		}
	}
}
