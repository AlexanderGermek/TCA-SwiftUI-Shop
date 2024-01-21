//
//  ProductListView.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 25.10.2023.
//

import SwiftUI
import ComposableArchitecture

struct ProductListView: View {

	let store: StoreOf<ProductListDomain>

	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			NavigationStack {
				Group {
					if viewStore.isLoading {
						ProgressView().frame(width: 200, height: 200, alignment: .center)
					} else if viewStore.isShouldShowError {
						ProductListErrorView(retryAction: {
							viewStore.send(.loadProducts)
						})
					} else {
						List {
							ForEachStore(
								self.store.scope(
									state: \.productListState,
									action: ProductListDomain.Action.product(id: action:)
								)
							) {
								ProductCellView(store: $0)
							}
						}
					}
				}

				.task {
					viewStore.send(.loadProducts)
				}
				.navigationTitle("Products")
				.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						Button {
							viewStore.send(.goToCartButtonTapped)
						} label: {
							Text("Go To Cart")
						}
					}
				}
				.sheet(
					store: self.store.scope(
						state: \.$cartOpenedState,
						action: { .cartOpenedAction($0) }
					)
				) { store in
					CartListView(store: store)
				}
			}
		}
	}
}

// MARK: - Preview
#Preview {
	ProductListView(store: .init(
		initialState: ProductListDomain.State()
	) {
		ProductListDomain(uuid: { UUID() })
	})
}
