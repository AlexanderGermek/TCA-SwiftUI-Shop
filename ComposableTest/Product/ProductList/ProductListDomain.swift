//
//  ProductListDomain.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 19.10.2023.
//

import ComposableArchitecture
import SwiftUI

struct ProductListDomain: Reducer {

	// MARK: - State
	struct State: Equatable {
		var productListState: IdentifiedArrayOf<ProductDomain.State> = []
		@PresentationState var cartOpenedState: CartListDomain.State? //    var cartState: CartListDomain.State?
	}

	// MARK: - Action
	enum Action: Equatable {
		case loadProducts
		case loadProductsSuccess(TaskResult<[Product]>)
		case product(id: ProductDomain.State.ID, action: ProductDomain.Action)
		case goToCartButtonTapped // setCartView(isPresented)
		case cartOpenedAction(PresentationAction<CartListDomain.Action>)
	}

	// MARK: - Dependencies
	@Dependency(\.productService) var productService
//	var fetchProducts: @Sendable () async throws -> [Product]
	var uuid: @Sendable () -> UUID

	// MARK: - Reducer
	var body: some Reducer<State, Action> {
		Reduce { state, action in
			switch action {

			case .loadProducts:
				return .run { send in
					let result = await TaskResult { try await self.productService.fetchProducts() }
					await send(.loadProductsSuccess(result))
				}

			case .loadProductsSuccess(let result):
				switch result {
				case .success(let products):
					state.productListState = IdentifiedArrayOf(
						uniqueElements: products.map
						{
					ProductDomain.State(
						id: uuid(),
						product: $0)
						}
					)

				case .failure(let error):
					print("Error getting products = \(error)")
				}

				return .none
			case .product:
				return .none
			case .goToCartButtonTapped:
				state.cartOpenedState =
				CartListDomain.State(
					cartItems: IdentifiedArrayOf(
						uniqueElements: state.productListState.compactMap {
							$0.count > 0 ?
							CartItemDomain.State(
								id: uuid(),
								cartItem: CartItem(product: $0.product, quantity: $0.count)
							) : nil
						}))
				return .none
			case .cartOpenedAction(.dismiss): break

			case .cartOpenedAction(.presented(let action)):

				switch action {
				case .didPressCloseButton:
					state.cartOpenedState = nil

				case .cartItem(_, action: let action):
					switch action {
					case .deleteCartItem(let deletedProduct):
						print("PLD LOL")
						guard let index = state.productListState.firstIndex(where: {
							$0.product.id == deletedProduct.id
						}) else { return .none }

						let productStateID = state.productListState[index].id
						state.productListState[id: productStateID]?.count = 0
					}

				case .didTapResultAlertOKButton:
					state.cartOpenedState = nil
					resetProductsCount(state: &state)

				default: break
				}
			}
			return .none
		}
		.forEach(\.productListState, action: /ProductListDomain.Action.product(id:action:)) {
			ProductDomain()
		}
		.ifLet(\.$cartOpenedState, action: /ProductListDomain.Action.cartOpenedAction) {
			CartListDomain()
		}
	}

	private func resetProductsCount(state: inout State) {
		state.productListState.ids.forEach {
			state.productListState[id: $0]?.count = 0
		}
	}
}

struct MyError : Error {}
