//
//  AwardsView.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 22/03/22.
//

import SwiftUI

struct AwardsView: View {
    
    static let tag: String? = "Awards"
    private var columns: [GridItem] = [GridItem(.adaptive(minimum: 100, maximum: 100))]

    @EnvironmentObject var dataController: DataController
    
    @State private var selectedAward = Award.example
    @State private var showingAwardDetails = false

    var body: some View {
        NavigationView {
            Group {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(Award.allAwards) { award in
                            Button {
                                selectedAward = award
                                showingAwardDetails = true
                            } label: {
                                Image(systemName: award.image)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(color(for: award))
                            }
                            .accessibilityLabel(label(for: award))
                            .accessibilityHint(Text(award.description))
                        }
                    }
                }
                SelectSomethingView()
            }
            .navigationTitle("Awards")
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .alert(isPresented: $showingAwardDetails) { generateAlert(for: dataController) }
        }
    }
    
}
    
extension AwardsView {
    
    private func color(for award: Award) -> Color {
        dataController.hasEarnedAward(award) ? Color(award.color) : Color.secondary.opacity(0.5)
    }
    
    private func label(for award: Award) -> Text {
        Text(dataController.hasEarnedAward(award) ? "\(award.name)" : "Locked")
    }
    
    private func generateAlert(for dataController: DataController) -> Alert {
        if dataController.hasEarnedAward(selectedAward!) {
            return Alert(
                title: Text(selectedAward!.name),
                message: Text(selectedAward!.description),
                dismissButton: .default(Text("OK"))
            )
        } else {
            return Alert(
                title: Text("Locked"),
                message: Text(selectedAward!.description),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
    }
}
