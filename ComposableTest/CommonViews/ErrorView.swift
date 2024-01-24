//
//  ErrorView.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 21.01.2024.
//

import SwiftUI

struct ErrorView: View {

	let title: String
	let subtitle: String
	let retryAction: () -> Void

	var body: some View {
		VStack {
			Text(":(")
				.font(.custom("AmericanTypewriter", size: 72))
				.fontWeight(.bold)
				.rotationEffect(.radians(.pi/2))
				.padding(.bottom, 20)

			Text(title)
				.font(.custom("AmericanTypewriter", size: 28))
				.fontWeight(.bold)
				.padding()

			Text(subtitle)
				.font(.custom("AmericanTypewriter", size: 20))

			Button {

			} label: {
				Text("Retry")
					.font(.custom("AmericanTypewriter", size: 25))
					.foregroundStyle(.white)
			}
			.frame(width: 100, height: 60)
			.background(.blue)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.padding()
		}
	}
}

#Preview {
	ErrorView(title: "Title",
						subtitle: "Subtitle",
						retryAction: { print("Retry") }
	)
}
