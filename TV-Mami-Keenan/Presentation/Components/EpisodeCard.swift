// MARK: - EpisodeCard.swift
// TV-Mami-Keenan
//
// Purpose: A card displaying an episode's thumbnail and title in a horizontal list.
// Purely presentational — receives a fully-formed Episode domain model.

import SwiftUI

// MARK: - EpisodeCard

struct EpisodeCard: View {

    let episode: Episode

    private enum Layout {
        static let thumbnailWidth: CGFloat = 140
        static let thumbnailHeight: CGFloat = 80
        static let cornerRadius: CGFloat = 8
        static let cardWidth: CGFloat = 140
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            thumbnailImage
            episodeInfo
        }
        .frame(width: Layout.cardWidth)
    }
}

// MARK: - Subviews

private extension EpisodeCard {

    var thumbnailImage: some View {
        AsyncImage(url: episode.thumbnailURL) { phase in
            switch phase {
            case .empty:
                RoundedRectangle(cornerRadius: Layout.cornerRadius)
                    .fill(Color(.systemGray5))
                    .overlay { ProgressView().scaleEffect(0.7) }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                RoundedRectangle(cornerRadius: Layout.cornerRadius)
                    .fill(Color(.systemGray5))
                    .overlay {
                        Image(systemName: "film")
                            .foregroundStyle(.secondary)
                    }
            @unknown default:
                RoundedRectangle(cornerRadius: Layout.cornerRadius)
                    .fill(Color(.systemGray5))
            }
        }
        .frame(width: Layout.thumbnailWidth, height: Layout.thumbnailHeight)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
    }

    var episodeInfo: some View {
        Text(episode.displayTitle)
            .font(.caption.weight(.medium))
            .foregroundStyle(.primary)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
    }
}

// MARK: - Preview

#Preview {
    EpisodeCard(episode: Episode(
        id: 1,
        url: nil,
        name: "Episode 1",
        season: 1,
        number: 1,
        airdate: "2013-09-12",
        airtime: "21:00",
        runtime: 60,
        rating: 7.6,
        thumbnailURL: URL(string: "https://static.tvmaze.com/uploads/images/medium_landscape/399/999232.jpg"),
        summary: nil
    ))
    .padding()
    .previewLayout(.sizeThatFits)
}
