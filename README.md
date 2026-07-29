TV-Mami-Keenan

A TV show catalog application powered by the TVMaze API for Mamikos Internship Coding Test.

# How to Run

## Requirements:
- Xcode 15.0 or later.
- iOS 16.0 or later (adjust as needed).
- Swift 5.9+.

## Setup Instructions:
- Clone the repository to your local machine.
- Open TV-Mami-Keenan.xcodeproj in Xcode.
- Wait for Xcode to resolve any built-in dependencies (Note: No third-party package, the app relies on native frameworks and URLSession).
- Select your preferred iOS Simulator or a physical device.
- Build and run the app! :D

## Architecture Decisions:
- **MVVM (Model-View-ViewModel)**: SwiftUI handles the Presentation Layer, ViewModels handle Business Logic and State Management, and the Data Layer (API Client) fetches the data.
- **Declarative UI**: The entire user interface is built declaratively using SwiftUI. Views observe ViewModels and reactively update based on their current state.
- **Explicit State Management**: Every screen handles three primary states: Loading, Success, and Error/Empty. These are represented using enums in the ViewModels to guarantee predictable UI updates.
- **Protocol-Based Dependency Injection**: Dependencies are injected into ViewModels via initializers using abstractions.
- **Data Layer Isolation**: Network responses are parsed into internal Domain Models first. API-specific Data Transfer Objects (DTOs) are never exposed directly to the ViewModels or Views.
- **Async Await Concurrency**: All asynchronous operations utilize Swift's async/await.

## Improvements if have more time:
- Add more Unit Tests
- Add UI Test
- Make the UI to be more beautiful 

Link to the video:
https://drive.google.com/drive/folders/1ZSpboAi2uPPBx_qKjvyE_yHDxQVGYtS2?usp=sharing