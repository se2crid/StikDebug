//
//  MainTabView.swift
//  StikJIT
//
//  Created by Stephen on 3/27/25.
//

import SwiftUI

struct MainTabView: View {
    @AppStorage("customAccentColor") private var customAccentColorHex: String = ""
    @AppStorage("enableAdvancedOptions") private var enableAdvancedOptions = false
    @AppStorage("enableTesting") private var enableTesting = false
    
    private var accentColor: Color {
        if customAccentColorHex.isEmpty {
            return .blue
        } else {
            return Color(hex: customAccentColorHex) ?? .blue
        }
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                ScriptListView()
                    .tabItem {
                        Label("Scripts", systemImage: "scroll")
                    }
                IPAAppManagerView()
                    .tabItem {
                        Label("Testing", systemImage: "square.grid.2x2")
                    }
            DeviceInfoView()
                .tabItem {
                    Label("Info", systemImage: "info.circle.fill")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(accentColor)
        .environment(\.accentColor, accentColor)
    }
}
