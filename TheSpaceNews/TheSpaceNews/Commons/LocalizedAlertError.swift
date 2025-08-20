//
//  LocalizedAlertError.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//

import SwiftUI

extension View {
    /// Presents an alert for a given error, providing a retry button and optional completion handler.
    /// - Parameters:
    ///   - error: A binding to an optional `Error` to display.
    ///   - buttonTitle: The title for the retry button (default is "Retry").
    ///   - completion: A closure called when the retry button is tapped.
    /// - Returns: A view that presents an error alert when needed.
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "Retry", completion: @escaping () -> Void) -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
                completion()
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}

/// A wrapper for presenting localized errors in SwiftUI alerts.
struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }

    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}
