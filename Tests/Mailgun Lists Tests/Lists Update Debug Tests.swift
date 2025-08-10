import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Lists
import Testing

@Suite(
    "Lists Update Debug Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct ListsUpdateDebugTests {

    }
