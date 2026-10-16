//
//  SwiftUIView.swift
//  SVGParser
//
//  Created by Mike Muszynski on 5/23/25.
//

import SwiftUI
import SVGParser

@main
struct SVGParserExampleApp: App {
    init() {
      DispatchQueue.main.async {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        NSApp.windows.first?.makeKeyAndOrderFront(nil)
      }
    }
        
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

extension URL {
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}

struct ExampleCategory {
    var name: String
    var urls: [URL]
}

class ExampleGrabber {
    var categories: [String: [URL]] = [:]
    var categoryObjects: [ExampleCategory] = []
    
    init() throws {
        let examplesURL = Bundle.module.url(forResource: "Example Images", withExtension: "")!
        
        func processDirectory(at directoryURL: URL) throws {
            //get the files
            let contents = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            
            for url in contents {
                if url.isDirectory {
                    categories[url.lastPathComponent] = []
                    try processDirectory(at: url)
                } else {
                    categories[directoryURL.lastPathComponent]?.append(url)
                }
            }
        }
        
        try processDirectory(at: examplesURL)
        categoryObjects = categories.map { (key, val) in
            ExampleCategory(name: key, urls: val)
        }
    }
}

struct MainView: View {
    let exampleGrabber = try! ExampleGrabber()
    @AppStorage("com.mmuszynski.SVGParserExamples.selectionKey") var selection: String = ""
    var image: SVGImage? {
        guard let url = exampleGrabber.categories.values.reduce(+).first { $0.path.contains(selection) }
        try? .svg(named: url)
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(Array(exampleGrabber.categories.keys).sorted(), id: \.self) { key in
                    Section(key) {
                        ForEach(exampleGrabber.categories[key] ?? [], id: \.lastPathComponent) { url in
                            Text(url.lastPathComponent)
                        }
                    }
                }
            }
        } detail: {
            if let image {
                SVGImageView(image: image)
            } else {
                Text("No selection")
            }
        }
    }
}

#Preview {
    MainView()
}
