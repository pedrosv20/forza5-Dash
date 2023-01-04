// TODO: - Temporary View and udpConnection calling

import SwiftUI
import NetworkProviders

struct ContentView: View {
    let udpConnection = UDPConnectionProvider()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
