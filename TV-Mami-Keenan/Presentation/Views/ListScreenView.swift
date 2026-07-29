// MARK: - ShowListView.swift
// TV-Mami-Keenan
//
// Purpose: Presentation layer view for the show list screen.
// Purely declarative — reflects the ViewModel's state with no business logic.

import SwiftUI

// MARK: - ListScreenView

struct ListScreenView: View {

    // MARK: - Dependencies

    @State private var viewModel = ListScreenViewModel()

    // MARK: - Body

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("TV Shows")
                .task { await viewModel.loadShows() }
        }
    }

    // MARK: - State Views

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .success(let shows):
            successView(shows: shows)
        case .error(let message):
            errorView(message: message)
        }
    }
}

// MARK: - Subviews

private extension ListScreenView {

    var loadingView: some View {
        ProgressView("Loading Shows…")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    func successView(shows: [Show]) -> some View {
        if shows.isEmpty {
            ContentUnavailableView(
                "No Shows Available",
                systemImage: "tv.slash",
                description: Text("There are no shows to display right now.")
            )
        } else {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(shows) { show in
                        NavigationLink(destination: DetailScreenView(showID: show.id)) {
                            TVShowCard(show: show)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)

                        Divider()
                            .padding(.leading, 16)
                    }
                    if !viewModel.hasReachedEnd {
                        HStack {
                            Spacer()
                            if viewModel.isLoadingMore {
                                ProgressView()
                                    .padding(.vertical, 16)
                            }
                            Spacer()
                        }
                        .onAppear {
                            Task { await viewModel.loadMoreShows() }
                        }
                    }
                }
            }
        }
    }

    func errorView(message: String) -> some View {
        ContentUnavailableView(
            "Something Went Wrong",
            systemImage: "wifi.exclamationmark",
            description: Text(message)
        )
    }
}

// MARK: - Preview

#Preview {
    ListScreenView()
}
