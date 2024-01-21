//
//  CartListDomain.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 01.11.2023.
//

import Foundation
import ComposableArchitecture

struct CartListDomain: Reducer {

	// MARK: - State
	struct State: Equatable {
		var cartItems: IdentifiedArrayOf<CartItemDomain.State> = []
		var totalPrice: Decimal = 0
		var isPayButtonDisable = false
		@PresentationState var confirmPurchaseAlertState: AlertState<Action.PurchaseAlert>?
		@PresentationState var resultPurchaseAlertState: AlertState<Action>?
	}

	// MARK: - Action
	enum Action: Equatable {
		case didPressCloseButton
		case cartItem(id: CartItemDomain.State.ID, action: CartItemDomain.Action)
		case setTotalPrice
		case didTapPayButton
		case didReceivePurchaseResponse(TaskResult<String>)
		case purchaseAlert(PresentationAction<PurchaseAlert>)
		case resultAlert
		case didTapResultAlertOKButton

		/// Алерт с вопросом об оплате
		enum PurchaseAlert: Equatable {
			case confirmPurchase
			case cancel
		}

		/// Алерт с результатом оплаты
		enum ResultPurchaseAlert: Equatable {
			case didTapResultAlertOKButton
		}
	}

	// MARK: - Dependencies
	@Dependency(\.productService) var productService


	// MARK: - Reducer
	var body: some Reducer<State, Action> {
		Reduce { state, action in

			switch action {

			case .cartItem(_, let action):

				switch action {

				case .deleteCartItem(let product):

					if let cartItemIndex = state.cartItems.map({ $0.cartItem }).firstIndex(where: {
						$0.product.id == product.id
					}) {
						state.cartItems.remove(at: cartItemIndex)
					}
				}

				return .send(.setTotalPrice)

			case .setTotalPrice:

				let items = state.cartItems.map { $0.cartItem }
				state.totalPrice = items.reduce(0, {
					$0 + Decimal($1.quantity) * $1.product.price
				})

				return setDisableForPayButton(state: &state)

			case .didTapPayButton:
				let totalPrice = state.totalPrice.formattedWithSeparator
				state.confirmPurchaseAlertState = AlertState {
					TextState("Confirm your purchase")
				} actions: {
					return [.default(TextState("Yes, pay!"), action: .send(.confirmPurchase)),
									.cancel(TextState("Cancel"), action: .send(.cancel))]
				} message: {
					TextState("Do you want to proceed with your purchase of $\(totalPrice)?")
				}
			case .purchaseAlert(.presented(.confirmPurchase)):
				let items = state.cartItems.map { $0.cartItem }

				return .run { send in
					let result = await TaskResult {
						try await self.productService.sendOrder(items)
					}
					await send(.didReceivePurchaseResponse(result))
				}
			case .purchaseAlert:
				state.confirmPurchaseAlertState = nil

			case .didReceivePurchaseResponse(let result):

				var title = ""
				var message = ""

				switch result {
				case .success(let string):
					title = "Success \(string)"
					message = "The order was successfully placed and paid"
				case .failure(let error):
					title = "Error: \(error.localizedDescription)"
					message = "Error when placing an order"
				}

				state.resultPurchaseAlertState =
				AlertState {
					TextState(title)
				} actions: {
					.default(TextState("OK"), action: .send(.didTapResultAlertOKButton))
				} message: {
					TextState(message)
				}

			case .resultAlert:
				state.resultPurchaseAlertState = nil
				return .send(.didTapResultAlertOKButton)

			case .didPressCloseButton, .didTapResultAlertOKButton:
				break
			}

			return .none
		}
		.forEach(\.cartItems, action: /Action.cartItem(id:action:)) {
			CartItemDomain()
		}
	}

	// MARK: - Private
	private func setDisableForPayButton(state: inout State) -> Effect<Action> {
		state.isPayButtonDisable = state.cartItems.isEmpty
		return .none
	}
}
