Flag and the fix:

PR Review:
// FLAG -> missing @MainActor
class MovieViewModel: ObservableObject {
    var movies: [Movie] = [] // FLAG -> other view can't use it.
    func loadMovies() {
        let data = try! Data(contentsOf: URL(string: // FLAG -> try! might crash the app if fail to get the data
        "https://api.example.com/movies")!) // FLAG -> the URL maybe not valid

        movies = try! JSONDecoder().decode([Movie].self, from:data) // FLAG -> try! might crash the app if fail to get the data
    }
}

The Fix:
@MainActor // FLAG -> adding @MainActor to observableobject to make sure the UI updates correctly
class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = [] // FLAG -> need to add @Published if other view want to use it using ObservableObject 

    func loadMovies() async {
        // FLAG -> Need to check if the URL is valid.
        guard let url = URL(string: "https://api.example.com/movies") else {
            print("Invalid URL")
            return
        }
        // FLAG -> use try and catch instead of try!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
        
            let decodedMovies = try JSONDecoder().decode([Movie].self, from: data)
            self.movies = decodedMovies
        } catch {
            print("Failed to load movies")
        }
    }
}

There is modern approach by using @Observable macro (introduced in iOS 17) instead of the older ObservableObject protocol.

The code should be like this:

import Foundation
import Observation

@Observable 
@MainActor 
class MovieViewModel {
    var movies: [Movie] = []
    
    func loadMovies() async {
        guard let url = URL(string: "https://api.example.com/movies") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.movies = try JSONDecoder().decode([Movie].self, from: data)
        } catch {
            print("Failed to load movies")
        }
    }
}