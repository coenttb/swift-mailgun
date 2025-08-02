import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import Events
import IssueReporting
import Shared

@Suite(
    "Events Client Tests",
    .dependency(\.calendar, .current)
)
struct EventsClientTests {
}
