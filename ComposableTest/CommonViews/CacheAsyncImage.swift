//
//  CacheAsyncImage.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 24.01.2024.
//

import SwiftUI

/// AsyncImage + Simple Cache
struct CacheAsyncImage<Content>: View where Content: View {

	private let url: URL?
	private let placeholder: () -> any View
	private let content: (Image) -> Content

	init(
		url: URL?,
		@ViewBuilder content: @escaping (Image) -> Content,
		placeholder: @escaping () -> any View
	) {
		self.url = url
		self.placeholder = placeholder
		self.content = content
	}

	var body: some View {

		if let cached = ImageCache[url] {
			content(cached)
		} else {
			AsyncImage(
				url: url
			) { image in
				cacheAndRender(image: image)
			} placeholder: {
				ProgressView()
					.frame(height: 300)
			}
		}
	}

	private func cacheAndRender(image: Image) -> some View {
		ImageCache[url] = image
		return content(image)
	}
}

/// Кэшер
fileprivate struct ImageCache {
	static private var cache: [URL: Image] = [:]

	static subscript(url: URL?) -> Image? {

		get {
			guard let url else { return nil }
				return ImageCache.cache[url]
		}
		set {
			guard let url else { return }
			ImageCache.cache[url] = newValue
		}
	}
}
