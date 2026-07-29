// MARK: - String+HTML.swift
// TV-Mami-Keenan
//
// Purpose: Utility extension to strip HTML tags from API-returned strings.
// TVMaze embeds HTML inside summary fields (e.g. <p>, <b>); this strips them
// to a plain-text representation suitable for display in SwiftUI.

import Foundation

extension String {
   /// Returns a new string with all HTML tags removed.
   ///
   /// Uses `NSAttributedString` with the `.html` document type, which correctly
   /// handles HTML entities (e.g. `&amp;`, `&nbsp;`) as well as block-level
   /// tags that produce line breaks.
   ///
   /// - Returns: Plain-text string, or the original string if parsing fails.
   func strippingHTML() -> String {
       guard
           let data = data(using: .utf8),
           let attributed = try? NSAttributedString(
               data: data,
               options: [
                   .documentType: NSAttributedString.DocumentType.html,
                   .characterEncoding: String.Encoding.utf8.rawValue
               ],
               documentAttributes: nil
           )
       else {
           // Fallback: strip tags with a simple regex if NSAttributedString fails.
           return self.replacingOccurrences(
               of: "<[^>]+>",
               with: "",
               options: .regularExpression
           ).trimmingCharacters(in: .whitespacesAndNewlines)
       }

       return attributed.string.trimmingCharacters(in: .whitespacesAndNewlines)
   }
}
