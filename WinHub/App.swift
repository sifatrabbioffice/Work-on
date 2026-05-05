import SwiftUI
import UniformTypeIdentifiers

@main
struct WinHubApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

struct HomeView: View {
    @State private var isRunning = false
    @State private var fileName = "No Environment"
    @State private var pickerOpen = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if isRunning {
                EmulatorUI(envName: fileName) { isRunning = false }
            } else {
                VStack(spacing: 20) {
                    Text("WINHUB PRO MAX").font(.largeTitle.bold()).foregroundColor(.blue)
                    Text("File: \(fileName)").foregroundColor(.white.opacity(0.6))
                    
                    HStack {
                        Button("Import .exe / .iso") { pickerOpen = true }
                            .padding().background(Color.blue).cornerRadius(10)
                        
                        if fileName != "No Environment" {
                            Button("Start") { isRunning = true }
                                .padding().background(Color.green).cornerRadius(10)
                        }
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .fileImporter(isPresented: $pickerOpen, allowedContentTypes: [.item]) { res in
            if let url = try? res.get() { fileName = url.lastPathComponent }
        }
    }
}

struct EmulatorUI: View {
    let envName: String
    var exitAction: () -> Void
    
    var body: some View {
        ZStack {
            Color(white: 0.1).ignoresSafeArea()
            
            VStack {
                HStack {
                    Button("Exit", action: exitAction).padding().background(Color.red).cornerRadius(8)
                    Spacer()
                    Text("Running: \(envName)").foregroundColor(.white.opacity(0.5))
                }.padding()
                
                Spacer()
                
                // গেমপ্যাড কন্ট্রোল
                HStack {
                    Joystick()
                    Spacer()
                    ActionPad()
                }
                .padding(.horizontal, 50).padding(.bottom, 30)
            }
        }
    }
}

struct Joystick: View {
    @State private var offset = CGSize.zero
    var body: some View {
        Circle().fill(.white.opacity(0.1)).frame(width: 140, height: 140)
            .overlay(
                Circle().fill(.white.opacity(0.7)).frame(width: 60, height: 60)
                    .offset(offset)
                    .gesture(DragGesture().onChanged { v in
                        let lim: CGFloat = 40
                        offset = CGSize(width: min(max(v.translation.width, -lim), lim), height: min(max(v.translation.height, -lim), lim))
                    }.onEnded { _ in withAnimation { offset = .zero } })
            )
    }
}

struct ActionPad: View {
    var body: some View {
        VStack(spacing: 15) {
            Btn(n: "Y", c: .yellow)
            HStack(spacing: 15) { Btn(n: "X", c: .blue); Btn(n: "B", c: .red) }
            Btn(n: "A", c: .green)
        }
    }
}

struct Btn: View {
    let n: String; let c: Color
    var body: some View {
        Circle().fill(c.opacity(0.8)).frame(width: 70, height: 70).overlay(Text(n).bold().foregroundColor(.white))
    }
}
