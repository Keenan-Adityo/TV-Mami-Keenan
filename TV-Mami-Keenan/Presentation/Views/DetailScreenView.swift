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
    @State private var selectedSeasonID: Int?

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
            
            // Seasons & Episodes
            if !viewModel.seasons.isEmpty {
                seasonsSection
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

 // MARK: - Seasons & Episodes Section

    var seasonsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()

            Text("Seasons")
                .font(.title3.bold())

            // Season picker — horizontal pill switcher
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.seasons) { season in
                        let isSelected = selectedSeasonID == season.id
                        Button(season.displayTitle) {
                            selectedSeasonID = season.id
                        }
                        .font(.subheadline.weight(isSelected ? .semibold : .regular))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(isSelected ? Color.accentColor : Color(.systemGray5))
                        .foregroundStyle(isSelected ? .white : .primary)
                        .clipShape(Capsule())
                        .task(id: season.id) {
                            await viewModel.loadEpisodes(forSeasonID: season.id)
                        }
                    }
                }
            }

            // Episode list for the selected season
            if let seasonID = selectedSeasonID {
                episodeList(for: seasonID)
            }
        }
        .onAppear {
            // Auto-select the first season when the section appears
            if selectedSeasonID == nil {
                selectedSeasonID = viewModel.seasons.first?.id
            }
        }
    }

    @ViewBuilder
    func episodeList(for seasonID: Int) -> some View {
        let isLoading = viewModel.loadingSeasonIDs.contains(seasonID)
        let episodes = viewModel.episodesBySeason[seasonID] ?? []

        if isLoading && episodes.isEmpty {
            ProgressView()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        } else if episodes.isEmpty {
            Text("No episodes available.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.vertical, 8)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(episodes) { episode in
                        EpisodeCard(episode: episode)
                    }
                }
            }
        }
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


// MARK: - Preview

#Preview {
    NavigationStack {
        DetailScreenView(showID: 269)
    }
}
