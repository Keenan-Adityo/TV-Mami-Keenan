// MARK: - DetailScreenView.swift
// TV-Mami-Keenan
//
// Purpose: Presentation layer view for the show detail screen.
// Purely declarative — reflects the ViewModel's state with no business logic.

import SwiftUI

// MARK: - DetailScreenView

struct DetailScreenView: View {

    // MARK: - Dependencies

    @State private var viewModel: DetailScreenViewModel

    // MARK: - Initializer

    init(showID: Int) {
        _viewModel = State(initialValue: DetailScreenViewModel(showID: showID))
    }

    // MARK: - Body

    var body: some View {
        content
            .task { await viewModel.loadShow() }
    }

    // MARK: - State Views

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .success(let showDetail):
            successView(showDetail: showDetail)
        case .error(let message):
            errorView(message: message)
        }
    }
}

// MARK: - Subviews

private extension DetailScreenView {

    var loadingView: some View {
        ProgressView("Loading…")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func successView(showDetail: ShowDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                backdropImage(url: showDetail.backdropURL)
                detailContent(showDetail: showDetail)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationTitle(showDetail.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let url = showDetail.url {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ShareLink(
                        item: url,
                        subject: Text(showDetail.name),
                        message: Text(showDetail.summary ?? "")
                    )
                }
            }
        }
    }

    func backdropImage(url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Rectangle()
                    .fill(Color(.systemGray5))
                    .overlay { ProgressView() }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Rectangle()
                    .fill(Color(.systemGray5))
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                    }
            @unknown default:
                Rectangle()
                    .fill(Color(.systemGray5))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 400)
        .clipped()
    }

    func detailContent(showDetail: ShowDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {

            // Title
            Text(showDetail.name)
                .font(.title2.bold())

            // Premiere date
            if let premiered = showDetail.premiered {
                Label(premiered, systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Divider()

            // Summary
            if let summary = showDetail.summary {
                Text(summary)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .lineSpacing(4)
            } else {
                Text("No description available.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .italic()
            }

            // Cast
            if !viewModel.cast.isEmpty {
                castSection
            }
        }
        .padding(20)
    }

    func errorView(message: String) -> some View {
        ContentUnavailableView(
            "Something Went Wrong",
            systemImage: "wifi.exclamationmark",
            description: Text(message)
        )
    }

    // MARK: - Cast Section

    var castSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()

            Text("Cast")
                .font(.title3.bold())

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.cast) { member in
                        CastMemberCard(member: member)
                    }
                }
            }
        }
    }
}

// MARK: - CastMemberCard

private struct CastMemberCard: View {

    let member: CastMember

    private enum Layout {
        static let photoSize: CGFloat = 72
        static let cardWidth: CGFloat = 88
        static let cornerRadius: CGFloat = 36
    }

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: member.person.photoURL) { phase in
                switch phase {
                case .empty:
                    Circle()
                        .fill(Color(.systemGray5))
                        .overlay { ProgressView().scaleEffect(0.6) }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                case .failure:
                    Circle()
                        .fill(Color(.systemGray5))
                        .overlay {
                            Image(systemName: "person.fill")
                                .foregroundStyle(.secondary)
                        }
                @unknown default:
                    Circle().fill(Color(.systemGray5))
                }
            }
            .frame(width: Layout.photoSize, height: Layout.photoSize)
            .clipShape(Circle())

            VStack(spacing: 2) {
                Text(member.person.name)
                    .font(.caption.bold())
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Text(member.character.name)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(width: Layout.cardWidth)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        DetailScreenView(showID: 269)
    }
}
