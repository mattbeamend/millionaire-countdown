//
//  SettingsView.swift
//  Millionaire Countdown
//
//  Created by Matthew Smith on 23/07/2021.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var target = UserDefaults.standard.object(forKey: "Target") as? String ?? ""
    @State private var interestRate = UserDefaults.standard.object(forKey: "Interest Rate") as? String ?? ""
    @State private var targetYear = UserDefaults.standard.object(forKey: "Target Year") as? String ?? ""
    
    @State private var total = UserDefaults.standard.object(forKey: "Total") as? String ?? ""
    @State private var deposits = UserDefaults.standard.object(forKey: "Deposits") as? String ?? ""
    @State private var interest = UserDefaults.standard.object(forKey: "Interest") as? String ?? ""
    
    @State private var showingAlert = false

    var body: some View {
        GeometryReader { geometry in
            
            VStack(alignment: .leading) {
                
                // Settings Title
                Text("Settings")
                    .font(.system(size: 40, weight: .semibold))
                    .padding()
                    .padding(.bottom, -20)
                
                Form {
                    
                    // Target Settings Form
                    Section(header: Text("Target Settings")) {
                        HStack {
                            Text("Financial Target")
                            Spacer()
                            TextField("$1,000,000", text: $target)
                                .modifier(SettingsTextField())
                        }
                        HStack {
                            Text("Interest Rate %")
                            Spacer()
                            TextField("7%", text: $interestRate)
                                .modifier(SettingsTextField())
                        }
                        HStack {
                            Text("Target Year")
                            Spacer()
                            TextField("2035" ,text: $targetYear)
                                .modifier(SettingsTextField())
                        }
                    }
                    
                    // Current Progress Settings Form
                    Section(header: Text("Current Progress")) {
                        HStack {
                            Text("Investment Total")
                            Spacer()
                            TextField("$0.00", text: $total)
                                .modifier(SettingsTextField())
                        }
                        HStack {
                            Text("Deposits")
                            Spacer()
                            TextField("$0.00", text: $deposits)
                                .modifier(SettingsTextField())
                        }
                        HStack {
                            Text("Interest Earned")
                            Spacer()
                            TextField("$0.00", text: $interest)
                                .modifier(SettingsTextField())
                        }
                        
                        // Save Button
                        Button(
                            action: {
                                UserDefaults.standard.setValue(self.target, forKey: "Target")
                                UserDefaults.standard.setValue(self.interestRate, forKey: "Interest Rate")
                                UserDefaults.standard.setValue(self.targetYear, forKey: "Target Year")
                                
                                UserDefaults.standard.setValue(self.total, forKey: "Total")
                                UserDefaults.standard.setValue(self.deposits, forKey: "Deposits")
                                UserDefaults.standard.setValue(self.interest, forKey: "Interest")
                                self.showingAlert = true
                            },
                            label: {Text("Save").modifier(SaveButton())}
                        )
                        .buttonStyle(PlainButtonStyle())
                        .padding(.top, 10)
                        .padding(.bottom, 5)
                        
                        // Save Alert
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Saved"),
                            message: Text("Your settings have been saved"),
                            dismissButton: .default(Text("Dismiss")))
                        }
                    }
                }
                .frame(maxHeight: 500)
                
            }
            
        }
        .background(Color("Background2").edgesIgnoringSafeArea(.top))
        .onTapGesture {self.endEditing(true)}
    }
}

// Settings Text Field View Modifier
struct SettingsTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(Color.black)
            .padding(.leading, 5)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
    }
}

// Settings Save Button View Modifier
struct SaveButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue)
                    .shadow(color: Color("ContainerShadow"), radius: 5, x: 1, y: 1)
            )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


