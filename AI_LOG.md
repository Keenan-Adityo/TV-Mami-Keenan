AI Tools used 
- Google Antigravity (IDE)
- Claude Sonnet 4.6
- Gemini 3.6 Flash (Medium)

Entry 1:
1. What I asked the AI / the problem I was solving
- Asked the AI to generate data models, and the API Service protocol and its implementation.

Prompt:
Generate the Data Models for the TVMaze shows list endpoint "https://api.tvmaze.com/shows?page=1" and create the API Service Protocol and its implementation. Ensure it follows our project rules.

2. What it gave me
- showDTO.swift -> Decodable struct for responses from the API.
- TVMazeService.swift -> Service to fetch the data from the API.
- TVMazeServiceProtocol.swift -> Protocol for the service.
- Show.swift -> Model for the show.

AI Log:
### Planner Response

Let me first explore the project structure and fetch the TVMaze API response to understand the data shape.

*Listed directory [TV-Mami-Keenan](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan) *

*Read URL content from /shows *

*Listed directory [TV-Mami-Keenan](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan) *

*Viewed [content.md](file:///Users/keenanadityo/.gemini/antigravity-ide/brain/fc709831-6979-4e03-af67-f545bbecd76e/.system_generated/steps/5/content.md) *

### Planner Response

I now have a clear picture of the API structure. Let me also check the existing project files before creating the new ones.

*Viewed [TV_Mami_KeenanApp.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/TV_Mami_KeenanApp.swift) *

*Viewed [Item.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Item.swift) *

### Planner Response

Good. Now I have a full picture. The project is a fresh Xcode app with SwiftData boilerplate. I'll now create a clean, well-structured MVVM-compliant file hierarchy. Let me plan the files I need to create:

1. **`Models/`** — Domain models (mapped from DTOs)
2. **`Data/DTOs/`** — API response DTOs (Codable)
3. **`Data/Services/`** — `TVMazeServiceProtocol` + `TVMazeService` implementation

### Planner Response

Now I'll create all the files. Let me start with the DTOs, then Domain Models, then the Service.

*Edited relevant file*

*Edited relevant file*

*Edited relevant file*

*Edited relevant file*

### Planner Response

All four files are created. Here's a summary of what was built:

---

## What was created

### 📂 `Models/`
- **[Show.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Models/Show.swift)** — Domain models exposed to ViewModels & Views. Includes:
  - `Show` — the main entity (`Identifiable`, `Hashable`) with computed helpers (`broadcastNetworkName`, `premieredYear`)
  - `ShowType` / `ShowStatus` — type-safe enums for `type` and `status` fields
  - `Schedule`, `Network`, `Country`, `Externals`, `ShowImage` — nested value types
  - `String.strippingHTML()` — strips TVMaze's HTML-wrapped `summary` strings

### 📂 `Data/DTOs/`
- **[ShowDTO.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Data/DTOs/ShowDTO.swift)** — `Decodable` structs that mirror the API JSON exactly. Contains `ShowDTO.toDomain()` which is the **only** crossing point from the Data layer to the domain.

### 📂 `Data/Services/`
- **[TVMazeServiceProtocol.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Data/Services/TVMazeServiceProtocol.swift)** — Protocol with `fetchShows(page:)` and a `TVMazeServiceError` enum with localized descriptions.
- **[TVMazeService.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Data/Services/TVMazeService.swift)** — Concrete implementation using `async/await` + `URLSession`. Validates HTTP status codes before decoding, maps DTOs to domain models internally.

### Architecture compliance
| Rule | Applied |
|---|---|
| DTOs never exposed to ViewModels/Views | ✅ Mapping happens inside `TVMazeService` |
| Protocol-based DI for testability | ✅ `TVMazeServiceProtocol` injected via init |
| `async/await` for all network calls | ✅ `fetchShows` is fully `async throws` |
| No third-party DI frameworks | ✅ Pure Swift protocols |

> **Next step:** Add `TVMazeService` to Xcode's target membership for all new files under `Data/` and `Models/`, since they were created outside Xcode's file dialog.

3. What I did: accepted as-is / modified (how?) / rejected (why?)
- modified, the AI give me a good and complete data from API, but i modified it and trim the data kept in the app as minimal as the task needs.

4. One thing the AI got wrong or that I verified myself
- I verified all the generated code and it looks good.



Entry 2:
1. What I asked the AI / the problem I was solving
- Asked the AI to generate a view model
Generate the DetailScreenViewModel. It must use the @Observable macro and @MainActor. Define a ViewState enum with three cases: .loading, .success([ShowDetail]), and .error(String). Use protocol-based initializer injection to require TVMazeServiceProtocol. Finally, add an asynchronous loadShow() method that fetches the data from the service and updates the view state accordingly.

2. What it gave me
- ShowDetailScreenViewModel.swift -> Have the show detail model data and enum for state management.

AI Log:
*Edited relevant file*

*Viewed [TVMazeServiceProtocol.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Domain/Protocols/TVMazeServiceProtocol.swift) *

*Edited relevant file*

### Planner Response

[DetailScreenViewModel.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Presentation/ViewModels/DetailScreenViewModel.swift) is ready. A couple of intentional decisions worth noting:

| Decision | Rationale |
|---|---|
| `DetailScreenViewState` (separate enum) | Avoids a name collision with `ViewState` from `ListScreenViewModel`. Each screen owns its own state type |
| `.success(ShowDetail)` singular, not `[ShowDetail]` | The `/shows/{id}` endpoint always returns exactly one object — an array would be a misleading type |
| `showID: Int` in the initializer | The ID is required context to even construct the ViewModel, not runtime input, so it belongs in `init` rather than `loadShow()` |

**Usage from a View:**
```swift
@State private var viewModel = DetailScreenViewModel(showID: show.id)
```

3. What I did: accepted as-is / modified (how?) / rejected (why?)
- accepted as-is because at the moment the code is already good and fulfill the requirements. But, I modified it later when i need to add more features.

4. One thing the AI got wrong or that I verified myself
- I verified the code myself and the code is already good and fulfill the requirements I need.


Entry 3:
1. What I asked the AI / the problem I was solving
- Generate a DetailScreenView in SwiftUI 

Prompt: 
Generate the DetailScreenView in SwiftUI. It must observe the DetailScreenViewModel we just created. Handle the ViewState enum explicitly (Loading, Success, Error). In the success state, display the shows. display its poster using AsyncImage (image.original size), the show title, premiere date, and the summary. Ensure no business logic or network calls exist in this View.

2. What it gave me
- DetailScreenView.swift -> With AsyncImage and the show detail data.

AI Log:
*Edited relevant file*

*Edited relevant file*

*Edited relevant file*

*Viewed [MockTVMazeService.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-KeenanTests/Mocks/MockTVMazeService.swift) *

### Planner Response

Let me quickly check the current `ShowDetail` model to confirm the exact field names before writing the View.

*Viewed [ShowDetail.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Domain/Models/ShowDetail.swift) *

*Edited relevant file*

### Planner Response

[DetailScreenView.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Presentation/Views/DetailScreenView.swift) is ready. Key design decisions:

| Decision | Rationale |
|---|---|
| `init(showID: Int)` | The View takes an ID, constructs the ViewModel internally — mirrors the same API as `TVShowCard(show:)` and keeps the call site clean |
| `backdropURL` (original size) | Uses the high-res `image.original` URL as requested, displayed as a full-bleed hero with `.ignoresSafeArea(edges: .top)` |
| All 3 `AsyncImage` phases handled | Empty → spinner placeholder, failure → `photo` icon, success → the image |
| `.navigationTitle` on the scroll view | Keeps the title in the nav bar (inline mode) without duplicating it in the scrollable content |
| `premiered` shown as full date string | Uses `showDetail.premiered` (e.g. `"2013-09-12"`) directly. You can swap for `premieredYear` if you want just the year |

**Wire it up from `ListScreenView`** by wrapping `TVShowCard` in a `NavigationLink`:
```swift
NavigationLink(destination: DetailScreenView(showID: show.id)) {
    TVShowCard(show: show)
}
```

3. What I did: accepted as-is / modified (how?) / rejected (why?)
- Modified, because the UI is not to my liking, i changed it to make it more appealing.
4. One thing the AI got wrong or that I verified myself
- As i verify all is good, but the UI styling just a bit off.


Entry 4:
1. What I asked the AI / the problem I was solving
- Updating viewmodel to fetch season, episode and cast data from the TVmaze API.

Prompt:
Update @[TV-Mami-Keenan/Presentation/ViewModels/DetailScreenViewModel.swift] 
to fetch and get the cast, episode, and season data.

2. What it gave me
- DetailScreenViewModel.swift -> With seasons, episodes, and cast data.

AI Log:
*Viewed [DetailScreenViewModel.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Presentation/ViewModels/DetailScreenViewModel.swift) *

*Viewed [DetailScreenViewModel.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Presentation/ViewModels/DetailScreenViewModel.swift) *

*Edited relevant file*

### Planner Response

[DetailScreenViewModel.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Presentation/ViewModels/DetailScreenViewModel.swift) is updated. Key design decisions:

### State layout

| Property | Type | When populated |
|---|---|---|
| `state` | `DetailScreenViewState` | `loadShow()` — primary screen state |
| `seasons` | `[Season]` | `loadShow()` — in parallel |
| `cast` | `[CastMember]` | `loadShow()` — in parallel |
| `episodesBySeason` | `[Int: [Episode]]` | `loadEpisodes(forSeasonID:)` — on demand |
| `loadingSeasonIDs` | `Set<Int>` | Guards against duplicate in-flight requests |

### Concurrency strategy
```
loadShow()
  ├── async let showDetailTask  ┐
  ├── async let seasonsTask     ├── all three fire simultaneously
  └── async let castTask        ┘
       └── try await (all three)
```
Episodes use a **lazy per-season** pattern — call `loadEpisodes(forSeasonID: season.id)` from the View's `.task` when the user taps/expands a season row. Fetching all episodes for all seasons upfront would mean N extra network calls on screen open.

3. What I did: accepted as-is / modified (how?) / rejected (why?)
- modified, because the generated code, need all data to be loaded before UI can show the data, so i changed the cast and season to be loaded after the show detail Succeeded .

4. One thing the AI got wrong or that I verified myself
- The fetching data priority.



Entry 5:
1. What I asked the AI / the problem I was solving
- Make the navigation title in detail screen invisible when the page is in the most top.

Prompt:
Update @[TV-Mami-Keenan/Presentation/Views/DetailScreenView.swift] , navigationtitle to be invisible when the page is in the most top.

2. What it gave me
- DetailScreenView.swift -> Geometry PreferencePreferenceKey to track scroll offset and toggle the navigation title based on scroll position.

AI Log:
*Viewed [DetailScreenView.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Presentation/Views/DetailScreenView.swift) *

*Grep searched codebase*

*Edited relevant file*

*Viewed [DetailScreenView.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Presentation/Views/DetailScreenView.swift) *

*Edited relevant file*

*User accepted the command `xcodebuild -project TV-Mami-Keenan.xcodeproj -scheme TV-Mami-Keenan -destination 'generic/platform=iOS' build`*

### Planner Response

I have updated [DetailScreenView.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Presentation/Views/DetailScreenView.swift#L55-L75) so that the navigation title remains invisible (`""`) when the page is scrolled to the top, and dynamically displays the show's title once scrolled down. 

### Summary of Changes:
- Added `@State private var showTitle: Bool = false` to manage title visibility.
- Implemented `ScrollOffsetPreferenceKey` and attached a coordinate space reader to track the `ScrollView` vertical offset.
- Configured `.navigationTitle(showTitle ? showDetail.name : "")` to show the title only when scrolled past the top threshold.

*User accepted the command `xcodebuild -project TV-Mami-Keenan.xcodeproj -scheme TV-Mami-Keenan -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build`*

### Planner Response

The simulator build is running to verify that [DetailScreenView.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Presentation/Views/DetailScreenView.swift) compiles cleanly. I will summarize the result as soon as it completes.

### Planner Response

The project build has succeeded (**BUILD SUCCEEDED**).

### Summary of Changes:
1. **[DetailScreenView.swift](file:///Users/keenanadityo/Documents/programming/work/TV-Mami-Keenan/TV-Mami-Keenan/Presentation/Views/DetailScreenView.swift#L18)**: Added `@State private var showTitle: Bool = false`.
2. **Scroll position tracking**: Configured `.coordinateSpace(name: "scroll")` and measured the header view's `minY` using `ScrollOffsetPreferenceKey`.
3. **Dynamic Navigation Title**: Updated `navigationTitle` to evaluate `showTitle ? showDetail.name : ""` so the navigation bar title remains hidden when the view is scrolled to the top and smoothly appears when scrolling down.

3. What I did: accepted as-is / modified (how?) / rejected (why?)
- Rejected, because it's not working, even after multiple tries to fix it

4. One thing the AI got wrong or that I verified myself
- The AI put the bussiness logic in the view.

