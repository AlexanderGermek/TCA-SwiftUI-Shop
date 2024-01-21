//
//  AddToCartFeature.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 19.10.2023.
//

import SwiftUI
import ComposableArchitecture

/// Слой логики для кнопки AddToCart
struct AddToCartFeature: Reducer {
	
	// MARK: - State
	struct State: Equatable {
		var count = 0
	}
	
	// MARK: - Action
	enum Action: Equatable {
		case didTapPlusButton
		case didTapMinusButton
	}
	
	// MARK: - Environment
	struct Environment {}
	
	/// Обработка состояний по action
	/// - Parameters:
	///   - state: состояние
	///   - action: пришедшее действие
	/// - Returns: Эффект
	func reduce(into state: inout State, action: Action) -> Effect<Action> {
		switch action {
		case .didTapPlusButton:
			state.count += 1
		case .didTapMinusButton:
			state.count = max(0, state.count - 1)
		}
		return .none
	}
}
