# 🍽️ Recipe Application

## Summary

This SwiftUI-based app allows users to browse a categorized list of recipes fetched from a remote API. Recipes are grouped by cuisine, and each item includes name, cuisine type, and actionable buttons for YouTube(to see the video for the recipe) and website sources(to read about the recipe) when available.

- Fully built with **SwiftUI**
- Uses **Swift Concurrency (`async/await`)** for all async work
- Implements **manual image caching** to memory and disk
- Handles **empty and malformed** data scenarios with user-friendly messages
- Supports **pull-to-refresh** using `.refreshable`
- Includes **unit tests** for core logic (API handling, error states, caching)

📸 **Screenshots**: 

| Video
|---------------------------------|

[RecipeAppVideo 2.mov.zip](https://github.com/user-attachments/files/20544864/RecipeAppVideo.2.mov.zip)


![NoRecipes](https://github.com/user-attachments/assets/2a237c93-1e9a-45b0-80dd-5df8c53ded0a)
![MalformedResponse](https://github.com/user-attachments/assets/3c47afd4-5343-459c-997f-e836c20c9a92)


---


## Focus Areas

| Area | Description |
|------|-------------|
| Swift Concurrency | All networking and image loading uses `async/await` for clarity and safety. |![MalformedResponse](https://github.com/user-attachments/assets/8d602083-2722-4343-a925-045769400dec)

| Custom Image Caching | Implemented memory (NSCache) and manual disk caching using SHA256 filenames. |
| Error Handling | Clear UX for malformed JSON, empty results, and invalid image URLs. |
| Testing | Covered key logic in `ViewModel`, `NetworkManager`, `LinkType`, and `ImageLoader`. |
| Clean Architecture | MVVM design with composable SwiftUI views and testable business logic. |

---

## Time Spent

**~8–9 hours total**, allocated as follows:

| Task | Time |
|------|------|
| UI + SwiftUI Layout | 2.5 hours |
| Networking + Error handling | 3 hours |
| Caching Implementation | 1.5 hour |
| Unit Testing | 1 hour |
| Documentation + Polish | ~1 hour |

---

## Trade-offs and Decisions

-  **Manual Disk Caching**: Simple SHA256-based storage without eviction/LRU logic. It works efficiently for small-scale caching.
-  **Focused Tests**: Prioritized core logic over UI tests, per the project’s guidance.
-  **Minimal Custom UI Components**: Leveraged standard SwiftUI controls for simplicity and maintainability.
-  **Sync Cleanups in `Task {}`**: A trade-off made to simplify the flow of error handling and ensure main thread execution without overcomplicating the state machine.

---

## Weakest Part of the Project

- **Disk Cache Eviction**: Lacks LRU or size-based eviction. In a production app, this would need improvement.
- **Limited UI Testing**: While not required, a more robust app would benefit from snapshot or UI automation tests.
- No persistent cache expiry or cleanup mechanism for disk images.
---

## Additional Information

- Target: **iOS 16+**
- Tested with all 3 endpoint scenarios
- Uses `WKWebView` inside SwiftUI via `UIViewRepresentable` for embedded browsing.
- Disk caching uses `FileManager` with safe filenames derived via `CryptoKit.SHA256`.

---

## 🧪 Test Coverage Summary

- ** `LinkTypeTests`**: Embed URL conversion + ID generation
- ** `NetworkManagerTests`**: Mocked endpoint responses, image caching and download logic
- ** `RecipeViewModelTests`**: State handling and cuisine grouping
- ** `ImageLoaderTests`**: Asynchronous image loading with fallback behavior

## 🚀 Thank You!

This project was an enjoyable challenge to build and demonstrates how I approach clean, efficient, and user-focused mobile development. I look forward to the opportunity to contribute to Fetch’s iOS team!
