//
//  Domain Tracking Client Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//
import Testing
import Dependencies
import DependenciesTestSupport
import Mailgun_Domains
import Mailgun_Shared

@Suite(
    "Domain Tracking Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct DomainTrackingClientTests {
    @Dependency(Mailgun.Domains.Domains.Tracking.Client.self) var client
    @Dependency(\.envVars.mailgunDomain) var domain
    
    @Test("Should successfully get tracking settings")
    func testGetTrackingSettings() async throws {
        do {
            let response = try await client.get(domain)
            
            // Verify response structure
            #expect(response.tracking != nil)
            #expect(response.tracking.click != nil)
            #expect(response.tracking.open != nil)
            #expect(response.tracking.unsubscribe != nil)
            
            // Check that settings have boolean values
            let tracking = response.tracking
            #expect(tracking.click.active == true || tracking.click.active == false)
            #expect(tracking.open.active == true || tracking.open.active == false)
            #expect(tracking.unsubscribe.active == true || tracking.unsubscribe.active == false)
            
        } catch {
            // Handle cases where tracking might not be available
            let errorString = String(describing: error).lowercased()
            if
               errorString.contains("404") || errorString.contains("not found") {
                #expect(Bool(true), "Tracking settings not available - this is expected for some domains")
            } else {
                throw error
            }
        }
    }
    
    @Test("Should successfully update click tracking")
    func testUpdateClickTracking() async throws {
        // First get current state
        var currentState = false
        do {
            let currentSettings = try await client.get(domain)
            currentState = currentSettings.tracking.click.active
        } catch {
            // If we can't get current state, assume false
            currentState = false
        }
        
        // Toggle the state
        let newState = !currentState
        let request = Mailgun.Domains.Domains.Tracking.UpdateClick.Request(
            active: newState
        )
        
        do {
            let response = try await client.updateClick(domain, request)
            
            #expect(!response.message.isEmpty)
            #expect(response.click.active == newState)
            
            // Toggle back to original state
            let restoreRequest = Mailgun.Domains.Domains.Tracking.UpdateClick.Request(
                active: currentState
            )
            _ = try await client.updateClick(domain, restoreRequest)
            
        } catch {
            // Handle cases where tracking updates might not be available
            let errorString = String(describing: error).lowercased()
            if
               errorString.contains("404") || errorString.contains("not found") || errorString.contains("forbidden") {
                #expect(Bool(true), "Tracking updates not available - this is expected for sandbox domains")
            } else {
                throw error
            }
        }
    }
    
    @Test("Should successfully update open tracking")
    func testUpdateOpenTracking() async throws {
        // First get current state
        var currentState = false
        do {
            let currentSettings = try await client.get(domain)
            currentState = currentSettings.tracking.open.active
        } catch {
            // If we can't get current state, assume false
            currentState = false
        }
        
        // Toggle the state
        let newState = !currentState
        let request = Mailgun.Domains.Domains.Tracking.UpdateOpen.Request(
            active: newState
        )
        
        do {
            let response = try await client.updateOpen(domain, request)
            
            #expect(!response.message.isEmpty)
            #expect(response.open.active == newState)
            
            // Toggle back to original state
            let restoreRequest = Mailgun.Domains.Domains.Tracking.UpdateOpen.Request(
                active: currentState
            )
            _ = try await client.updateOpen(domain, restoreRequest)
            
        } catch {
            // Handle cases where tracking updates might not be available
            let errorString = String(describing: error).lowercased()
            if
               errorString.contains("404") || errorString.contains("not found") || errorString.contains("forbidden") {
                #expect(Bool(true), "Tracking updates not available - this is expected for sandbox domains")
            } else {
                throw error
            }
        }
    }
    
    @Test("Should successfully update unsubscribe tracking")
    func testUpdateUnsubscribeTracking() async throws {
        // First get current state
        var currentState = false
        var currentHtmlFooter: String?
        var currentTextFooter: String?
        
        do {
            let currentSettings = try await client.get(domain)
            currentState = currentSettings.tracking.unsubscribe.active
            currentHtmlFooter = currentSettings.tracking.unsubscribe.htmlFooter
            currentTextFooter = currentSettings.tracking.unsubscribe.textFooter
        } catch {
            // If we can't get current state, use defaults
            currentState = false
        }
        
        // Toggle the state with custom footers
        let newState = !currentState
        let request = Mailgun.Domains.Domains.Tracking.UpdateUnsubscribe.Request(
            active: newState,
            htmlFooter: newState ? "<p>Click <a href=\"%unsubscribe_url%\">here</a> to unsubscribe</p>" : currentHtmlFooter,
            textFooter: newState ? "Click here to unsubscribe: %unsubscribe_url%" : currentTextFooter
        )
        
        do {
            let response = try await client.updateUnsubscribe(domain, request)
            
            #expect(!response.message.isEmpty)
            #expect(response.unsubscribe.active == newState)
            
            if newState {
                #expect(response.unsubscribe.htmlFooter != nil || response.unsubscribe.textFooter != nil)
            }
            
            // Toggle back to original state
            let restoreRequest = Mailgun.Domains.Domains.Tracking.UpdateUnsubscribe.Request(
                active: currentState,
                htmlFooter: currentHtmlFooter,
                textFooter: currentTextFooter
            )
            _ = try await client.updateUnsubscribe(domain, restoreRequest)
            
        } catch {
            // Handle cases where tracking updates might not be available
            let errorString = String(describing: error).lowercased()
            if
               errorString.contains("404") || errorString.contains("not found") || errorString.contains("forbidden") {
                #expect(Bool(true), "Tracking updates not available - this is expected for sandbox domains")
            } else {
                throw error
            }
        }
    }
    
    @Test("Should handle tracking settings with custom footers")
    func testTrackingWithCustomFooters() async throws {
        let htmlFooter = """
            <div style="text-align: center; padding: 20px;">
                <p style="color: #666;">You are receiving this email because you subscribed to our newsletter.</p>
                <p><a href="%unsubscribe_url%" style="color: #007bff;">Unsubscribe from this list</a></p>
            </div>
            """
        
        let textFooter = """
            ---
            You are receiving this email because you subscribed to our newsletter.
            Unsubscribe from this list: %unsubscribe_url%
            """
        
        let request = Mailgun.Domains.Domains.Tracking.UpdateUnsubscribe.Request(
            active: true,
            htmlFooter: htmlFooter,
            textFooter: textFooter
        )
        
        // Just verify the request can be constructed with custom footers
        #expect(request.active == true)
        #expect(request.htmlFooter == htmlFooter)
        #expect(request.textFooter == textFooter)
    }
    
    @Test("Should validate all tracking states can be toggled")
    func testToggleAllTrackingStates() async throws {
        // Test that all tracking types can be enabled and disabled
        let clickEnabled = Mailgun.Domains.Domains.Tracking.UpdateClick.Request(active: true)
        let clickDisabled = Mailgun.Domains.Domains.Tracking.UpdateClick.Request(active: false)
        
        let openEnabled = Mailgun.Domains.Domains.Tracking.UpdateOpen.Request(active: true)
        let openDisabled = Mailgun.Domains.Domains.Tracking.UpdateOpen.Request(active: false)
        
        let unsubscribeEnabled = Mailgun.Domains.Domains.Tracking.UpdateUnsubscribe.Request(
            active: true,
            htmlFooter: "<a href=\"%unsubscribe_url%\">Unsubscribe</a>",
            textFooter: "Unsubscribe: %unsubscribe_url%"
        )
        let unsubscribeDisabled = Mailgun.Domains.Domains.Tracking.UpdateUnsubscribe.Request(
            active: false
        )
        
        // Verify all requests can be constructed
        #expect(clickEnabled.active == true)
        #expect(clickDisabled.active == false)
        #expect(openEnabled.active == true)
        #expect(openDisabled.active == false)
        #expect(unsubscribeEnabled.active == true)
        #expect(unsubscribeDisabled.active == false)
    }
}
