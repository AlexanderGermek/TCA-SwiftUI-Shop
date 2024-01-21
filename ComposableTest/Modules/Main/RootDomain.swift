//
//  RootDomain.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 21.01.2024.
//

import ComposableArchitecture

struct RootDomain: Reducer {

	// MARK: - State
	struct State: Equatable {
		var currentTab = Tab.products
		var productListState = ProductListDomain.State()

		enum Tab {
			case products
			case profile
		}
	}

	// MARK: - Action
	enum Action: Equatable {
		case test
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
