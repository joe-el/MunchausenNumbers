//
//  ContentView.swift
//  Shared
//
//  Created by Kenneth Gutierrez on 12/23/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var munchausenNum = MunchausenNum()
    @State private var selectedCode = "Swift"
    @State private var codes = ["Rust", "Swift"]
    @State private var executionTime: Double = 0.00
    @State private var convertUnit: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        Form {
            Section {
                Picker("", selection: $selectedCode) {
                    ForEach(codes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("// Select Language to Use //")
                    .macOS { $0.padding(.top) }
            } footer: {
                Text("Note: This may take a while.")
                    .macOS { $0.padding(.bottom) }
                    .font(.system(.caption))
            }
            
            Section(header: Text("// Münchhausen Numbers //")) {
                HStack {
                    Text(munchausenNum.wholeNumbers.map(String.init).joined(separator: ", "))
                        .macOS { $0.padding(.bottom) }
                    
                    Spacer()
                
                    if #available(macOS 12.0, *) {
                        Button("Erase", role: .destructive, action: { munchausenNum.wholeNumbers.removeAll()
                        })
                    } else {
                        // Fallback on earlier versions
                        Button("Erase", action: {
                            munchausenNum.wholeNumbers.removeAll()
                        })
                    }
                }
            }
            
            Section(header: Text("// Elapsed Time //")) {
                Text("\(executionTime, specifier: "%.2f") seconds")
            }
            
            Section {
                HStack {
                    Spacer()
                    
                    Button("Run Code", action: {
                        if selectedCode == "Swift" {
                            measureExecutionTime(of: munchausenNum.swiftMunchausenNumbers)
                        } else {
                            measureExecutionTime(of: munchausenNum.rustMunchausenNumbers)
                        }
                    })
                    
                    Spacer()
                }
            }
            .macOS { $0.padding([.top, .bottom, .trailing]) }
        }
        .disabled(isLoading)
        .macOS { $0.padding() }
    }
    
    // Measure how long it takes for a piece of code to execute.
    func measureExecutionTime(of code: (() -> Void)) {
        isLoading.toggle()
        
        let start = CFAbsoluteTimeGetCurrent()
        code()
        let diff = CFAbsoluteTimeGetCurrent() - start
        executionTime = diff
        
        isLoading.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    // platform customization-different layouts for a chosen os
    func iOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
        #if os(iOS)
        return modifier(self)
        #else
        return self
        #endif
    }
    
    func macOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
        #if os(macOS)
        return modifier(self)
        #else
        return self
        #endif
    }
}
