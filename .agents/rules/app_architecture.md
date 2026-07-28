---
trigger: always_on
---

# TV App Architecture & Guardrails

- Architecture: Implement the MVVM pattern. Ensure a strict separation between the Presentation Layer (SwiftUI Views), ViewModel (Business Logic), and Data Layer (API Client & Repository).
- API Integration: Use the TVMaze API for data fetching. Create dedicated service classes to handle URLSession requests and JSON decoding.
- Data Layer: Map API responses to internal Domain Models. Do not expose API-specific DTOs (Data Transfer Objects) directly to the ViewModels or Views.
- State Management: Every screen must explicitly handle 3 primary states: Loading, Success, and Error/Empty State. Use an enum-based approach in the ViewModel to represent these states.
- Declarative UI: The user interface must be written entirely declaratively using SwiftUI. Views should observe a ViewModel and reflect its current state.
- Dependency Injection & Testing: Use Protocol-Based Initializer Injection. Pass API services into ViewModels through their initializers using protocol abstractions (e.g., TVMazeServiceProtocol). Avoid third-party DI frameworks to keep the project lightweight, ensure compile-time safety, and simplify unit testing with mock services.
- Concurrency: Perform all network requests asynchronously using Swift's async/await. Ensure all ViewModel updates are pushed to the Main Thread using @MainActor to safely update UI state.