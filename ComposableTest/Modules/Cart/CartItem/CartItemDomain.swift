//
//  CartItemDomain.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 01.11.2023.
//

import Foundation
import ComposableArchitecture

struct CartItemDomain: Reducer {

	struct State: Equatable, Identifiable {
		let id: UUID
		let cartItem: CartItem
	}

	enum Action: Equatable {
		case deleteCartItem(product: Product)
	}

	// MARK: - Reducer
	var body: some Reducer<State, Action> {
		Reduce { state, action in
			return .none
		}
	}
}
