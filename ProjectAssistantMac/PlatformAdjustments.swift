//
//  PlatformAdjustments.swift
//  ProjectAssistantMac
//
//  Created by Juan Diego Ocampo on 9/04/22.
//

import SwiftUI

typealias InsetGroupedListStyle = SidebarListStyle
typealias ImageButtonStyle = BorderlessButtonStyle

extension Notification.Name {
    static let willResignActive = NSApplication.willResignActiveNotification
}

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(spacing: 0, content: content)
    }
}
