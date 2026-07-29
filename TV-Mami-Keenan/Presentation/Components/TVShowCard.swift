// MARK: - TVShowCard.swift
// TV-Mami-Keenan
//
// Purpose: A single row in the show list.
// Displays the show poster (medium size via AsyncImage), title, and average rating.
// Purely presentational — receives a fully-formed Show domain model, no logic inside.

import SwiftUI

// MARK: - TVShowCard

struct TVShowCard: View {

    let show: Show

    // MARK: - Layout Constants

    private enum Layout {
        static let posterWidth: CGFloat = 56
        static let posterHeight: CGFloat = 80
        static let cornerRadius: CGFloat = 6
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            posterImage
            VStack(alignment: .leading,) {
                showInfo
                    .padding(.top, 4)
                Spacer()
            }
        }
    }
}

// MARK: - Subviews

private extension TVShowCard {
    var posterImage: some View {
        AsyncImage(url: show.posterURL) { phase in
            switch phase {
            case .empty:
                posterPlaceholder(systemImage: nil)
                    .overlay { ProgressView().scaleEffect(0.6) }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                posterPlaceholder(systemImage: "photo")
            @unknown default:
                posterPlaceholder(systemImage: "photo")
            }
        }
        .frame(width: Layout.posterWidth, height: Layout.posterHeight)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
    }

    func posterPlaceholder(systemImage: String?) -> some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius)
            .fill(Color(.systemGray5))
            .overlay {
                if let systemImage {
                    Image(systemName: systemImage)
                        .foregroundStyle(.secondary)
                }
            }
    }

    var showInfo: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(show.name)
                .font(.headline)
                .lineLimit(2)
            Label(show.ratingDisplayString, systemImage: "star.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.orange)
                .labelStyle(.titleAndIcon)
                .monospacedDigit()
        }
    }
}

// MARK: - Preview

#Preview {
    TVShowCard(show: Show(
        id: 1,
        name: "Peaky Blinders",
        posterURL: URL(string: "https://static.tvmaze.com/uploads/images/medium_portrait/48/122213.jpg"),
        rating: 8.5
    ))
    .padding()
    .previewLayout(.sizeThatFits)
}
