import Dependencies
import Dependencies_Test_Support
import Mailgun_Lists
import Testing

@Suite(
    "Lists Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct ListsClientTests {
}
