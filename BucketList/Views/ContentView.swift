//
//  ContentView.swift
//  BucketList
//
//  Created by Jacob LeCoq on 2/25/21.
//

import LocalAuthentication
import SwiftUI

struct ContentView: View {
    @State private var isUnlocked = false

    @State private var errorTitle = "Unlock Failed"
    @State private var errorMessage = ""
    @State private var showErrorAlert = false

    var body: some View {
        if isUnlocked {
            MapContentView()
        } else {
            Button("Unlock Places") {
                self.authenticate()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        
    }

    private func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in

                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.errorMessage = "Face ID Auth failed"
                        self.showErrorAlert.toggle();
                    }
                }
            }
        } else {
            self.errorMessage = "Your device doesn't support authentication with biometrics."
            self.showErrorAlert.toggle();
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
