//
//  ProductDomain.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 19.10.2023.
//

import ComposableArchitecture
import SwiftUI

/// Слой ячейки продукта
struct ProductDomain: Reducer {
	
	// MARK: - State
	struct State: Equatable, Identifiable {
		let id: UUID
		let product: Product
		
		var addToCartState = AddToCartFeature.State()
		
		var count: Int {
			get { addToCartState.count }
			set { addToCartState.count = newValue }
		}
	}
	
	// MARK: - Action
	enum Action: Equatable {
		case addToCart(AddToCartFeature.Action)
	}
	
	var body: some Reducer<State, Action> {
		Scope(state: \.addToCartState, action: /ProductDomain.Action.addToCart) {
			AddToCartFeature()
		}
		Reduce { state, action in
			switch action {
			case .addToCart(.didTapPlusButton):
				return .none
			case .addToCart(.didTapMinusButton):
				state.addToCartState.count = max(0, state.addToCartState.count)
				return .none
			}
		}
	}
}
