//
//  StikJITApp.swift
//  StikJIT
//
//  Created by Stephen on 3/26/25.
//

import SwiftUI
import Network
import em_proxy
import UniformTypeIdentifiers

@main
struct HeartbeatApp: App {
    @State private var isLoading = true
    @State private var isPairing = false
    @State private var heartBeat = false
    @State private var error: Int32? = nil
    @State private var show_error = false
    @State private var error_string = ""
    @StateObject private var mount = MountingProgress.shared
    
    let urls: [String] = [
        "https://github.com/doronz88/DeveloperDiskImage/raw/refs/heads/main/PersonalizedImages/Xcode_iOS_DDI_Personalized/BuildManifest.plist",
        "https://github.com/doronz88/DeveloperDiskImage/raw/refs/heads/main/PersonalizedImages/Xcode_iOS_DDI_Personalized/Image.dmg",
        "https://github.com/doronz88/DeveloperDiskImage/raw/refs/heads/main/PersonalizedImages/Xcode_iOS_DDI_Personalized/Image.dmg.trustcache"
    ]

    let outputDir: String = "DDI"

    let outputFiles: [String] = [
        "DDI/BuildManifest.plist",
        "DDI/Image.dmg",
        "DDI/Image.dmg.trustcache"
    ]
    
    init() {
        let fixMethod = class_getInstanceMethod(UIDocumentPickerViewController.self, #selector(UIDocumentPickerViewController.fix_init(forOpeningContentTypes:asCopy:)))!
        let origMethod = class_getInstanceMethod(UIDocumentPickerViewController.self, #selector(UIDocumentPickerViewController.init(forOpeningContentTypes:asCopy:)))!
        method_exchangeImplementations(origMethod, fixMethod)
    }

    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingView()
                    .onAppear {
                        // Removed WiFi check
                        startProxy() { result, error in
                            if result {
                                checkVPNConnection() { result, vpn_error in
                                    if result {
                                        if FileManager.default.fileExists(atPath: URL.documentsDirectory.appendingPathComponent("pairingFile.plist").path) {
                                            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                                                if pubHeartBeat {
                                                    isLoading = false
                                                    timer.invalidate()
                                                } else {
                                                    if let error {
                                                        if error == InvalidHostID.rawValue {
                                                            isPairing = true
                                                        } else {
                                                            startHeartbeatInBackground()
                                                        }
                                                        self.error = nil
                                                    }
                                                }
                                            }
                                            
                                            startHeartbeatInBackground()
                                        } else {
                                            isLoading = false
                                        }
                                    } else if let vpn_error {
                                        showAlert(title: "Error", message: "EM Proxy failed to connect: \(vpn_error)", showOk: true) { _ in
                                            exit(0)
                                        }
                                    }
                                }
                            } else if let error {
                                showAlert(title: "Error", message: "EM Proxy Failed to start \(error)", showOk: true) { _ in }
                            }
                        }
                    }
                    .fileImporter(isPresented: $isPairing, allowedContentTypes: [UTType(filenameExtension: "mobiledevicepairing", conformingTo: .data)!, .propertyList]) { result in
                        switch result {
                        case .success(let url):
                            let fileManager = FileManager.default
                            let accessing = url.startAccessingSecurityScopedResource()
                            
                            if fileManager.fileExists(atPath: url.path) {
                                do {
                                    if fileManager.fileExists(atPath: URL.documentsDirectory.appendingPathComponent("pairingFile.plist").path) {
                                        try fileManager.removeItem(at: URL.documentsDirectory.appendingPathComponent("pairingFile.plist"))
                                    }
                                    
                                    try fileManager.copyItem(at: url, to: URL.documentsDirectory.appendingPathComponent("pairingFile.plist"))
                                    print("File copied successfully!")
                                    startHeartbeatInBackground()
                                } catch {
                                    print("Error copying file: \(error)")
                                }
                            } else {
                                print("Source file does not exist.")
                            }
                            
                            if accessing {
                                url.stopAccessingSecurityScopedResource()
                            }
                        case .failure(_):
                            print("Failed")
                        }
                    }
            } else {
                MainTabView()
                    .onAppear {
                        let fileManager = FileManager.default
                        for (index, urlString) in urls.enumerated() {
                            let destinationURL = URL.documentsDirectory.appendingPathComponent(outputFiles[index])
                            if !fileManager.fileExists(atPath: destinationURL.path) {
                                downloadFile(from: urlString, to: destinationURL){ result in
                                    if result != "" {
                                        error_string = "[Download DDI Error]: " + result
                                        show_error = true
                                    }
                                }
                            }
                        }
                    }
                    .alert("An Error Occurred", isPresented: $show_error) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(error_string)
                    }
            }
        }
    }
    
    func startProxy(callback: @escaping (Bool, Int?) -> Void) {
        let port = 51820
        let bindAddr = "127.0.0.1:\(port)"
        
        DispatchQueue.global(qos: .background).async {
            let result = start_emotional_damage(bindAddr)
            DispatchQueue.main.async {
                if result == 0 {
                    print("DEBUG: em_proxy started successfully on port \(port)")
                    callback(true, nil)
                } else {
                    print("DEBUG: Failed to start em_proxy")
                    callback(false, Int(result))
                }
            }
        }
    }
    
    private func checkVPNConnection(callback: @escaping (Bool, String?) -> Void) {
        let host = NWEndpoint.Host("10.7.0.1")
        let port = NWEndpoint.Port(rawValue: 62078)!
        let connection = NWConnection(host: host, port: port, using: .tcp)
        
        // Create a variable to hold the timeout work item
        var timeoutWorkItem: DispatchWorkItem?
        
        timeoutWorkItem = DispatchWorkItem { [weak connection] in
            if connection?.state != .ready {
                connection?.cancel()
                DispatchQueue.main.async {
                    if timeoutWorkItem?.isCancelled == false {
                        callback(false, "[TIMEOUT] Wireguard is not connected. Try closing this app, turn Wireguard off and back on.")
                    }
                }
            }
        }
        
        connection.stateUpdateHandler = { [weak connection] state in
            switch state {
            case .ready:
                timeoutWorkItem?.cancel()
                connection?.cancel()
                DispatchQueue.main.async {
                    callback(true, nil)
                }
            case .failed(let error):
                timeoutWorkItem?.cancel()
                connection?.cancel()
                DispatchQueue.main.async {
                    if error == NWError.posix(.ETIMEDOUT) || error == NWError.posix(.ECONNREFUSED) {
                        callback(false, "Wireguard is not connected. Try closing the app and restarting Wireguard.")
                    } else {
                        callback(false, "em proxy check error: \(error.localizedDescription)")
                    }
                }
            default:
                break
            }
        }
        
        connection.start(queue: .global())
        
        if let workItem = timeoutWorkItem {
            DispatchQueue.global().asyncAfter(deadline: .now() + 20, execute: workItem)
        }
    }
    
    // Removed isConnectedToWifi() function as it is no longer needed.
}

var pubHeartBeat = false

actor FunctionGuard<T> {
    private var runningTask: Task<T, Never>?

    func execute(_ work: @escaping @Sendable () -> T) async -> T {
        if let task = runningTask {
            return await task.value
        }
        let task = Task.detached { work() }
        runningTask = task
        let result = await task.value
        runningTask = nil
        return result
    }
}

class MountingProgress: ObservableObject {
    static var shared = MountingProgress()
    @Published var mountProgress: Double = 0.0
    @Published var mountingThread: Thread?
    @Published var coolisMounted: Bool = false
    
    func checkforMounted() {
        DispatchQueue.main.async {
            self.coolisMounted = isMounted()
        }
    }
    
    func progressCallback(progress: size_t, total: size_t, context: UnsafeMutableRawPointer?) {
        let percentage = Double(progress) / Double(total) * 100.0
        print("Mounting progress: \(percentage)%")
        
        DispatchQueue.main.async {
            self.mountProgress = percentage
        }
    }
    
    func pubMount() { mount() }
    
    private func mount() {
        self.coolisMounted = isMounted()
        let fileManager = FileManager.default
        let pairingpath = URL.documentsDirectory.appendingPathComponent("pairingFile.plist").path
        
        if isPairing(), !isMounted() {
            if let mountingThread {
                mountingThread.cancel()
                self.mountingThread = nil
            }
            
            mountingThread = Thread {
                let mount = mountPersonalDDI(imagePath: URL.documentsDirectory.appendingPathComponent("DDI/Image.dmg").path,
                                             trustcachePath: URL.documentsDirectory.appendingPathComponent("DDI/Image.dmg.trustcache").path,
                                             manifestPath: URL.documentsDirectory.appendingPathComponent("DDI/BuildManifest.plist").path,
                                             pairingFilePath: pairingpath)
                
                if mount != 0 {
                    showAlert(title: "Error", message: "An Error Occured when Mounting the DDI\nError Code: \(mount)", showOk: true, showTryAgain: true) { cool in
                        if cool {
                            self.mount()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.coolisMounted = isMounted()
                    }
                }
            }
            
            mountingThread!.qualityOfService = .background
            mountingThread!.name = "mounting"
            mountingThread!.start()
        }
    }
}

func isPairing() -> Bool {
    let pairingpath = URL.documentsDirectory.appendingPathComponent("pairingFile.plist").path
    var pairingFile: IdevicePairingFile?
    let err = idevice_pairing_file_read(pairingpath, &pairingFile)
    if err != IdeviceSuccess {
        print("Failed to read pairing file: \(err)")
        return false
    }
    return true
}

func startHeartbeatInBackground() {
    let heartBeat = Thread {
        let completionHandler: @convention(block) (Int32, String?) -> Void = { result, message in
            if result == 0 {
                print("Heartbeat started successfully: \(message ?? "")")
                pubHeartBeat = true
                if FileManager.default.fileExists(atPath: URL.documentsDirectory.appendingPathComponent("DDI/Image.dmg.trustcache").path) {
                    MountingProgress.shared.pubMount()
                }
            } else {
                print("Error: \(message ?? "") (Code: \(result))")
                DispatchQueue.main.async {
                    if let mainWindow = UIApplication.shared.windows.last {
                        let alert = UIAlertController(title: "Heartbeat Error", message: "\(message ?? "") (\(result))", preferredStyle: .alert)
                        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { _ in
                            startHeartbeatInBackground()
                        }
                        alert.addAction(tryAgainAction)
                        mainWindow.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
        JITEnableContext.shared.startHeartbeat(completionHandler: completionHandler, logger: nil)
    }
    
    heartBeat.qualityOfService = .background
    heartBeat.name = "Heartbeat"
    heartBeat.start()
}

struct LoadingView: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 8)
                        .foregroundColor(Color.white.opacity(0.3))
                        .frame(width: 80, height: 80)

                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(AngularGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white.opacity(0.3)]),
                            center: .center
                        ), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .rotationEffect(.degrees(animate ? 360 : 0))
                        .frame(width: 80, height: 80)
                        .animation(Animation.linear(duration: 1.2).repeatForever(autoreverses: false), value: animate)
                }
                .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
                .onAppear {
                    animate = true
                }

                Text("Loading...")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 20)
                    .opacity(animate ? 1.0 : 0.5)
                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animate)
            }
        }
    }
}

public func showAlert(title: String, message: String, showOk: Bool, showTryAgain: Bool = false, completion: @escaping (Bool) -> Void) {
    DispatchQueue.main.async {
        if let mainWindow = UIApplication.shared.windows.last {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if showOk, !showTryAgain {
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    completion(true)
                }
                alert.addAction(okAction)
            } else if !showTryAgain {
                completion(false)
            }
            if showTryAgain {
                let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { _ in
                    completion(true)
                }
                alert.addAction(tryAgainAction)
                let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                    completion(false)
                }
                alert.addAction(okAction)
            }
            mainWindow.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}

func downloadFile(from urlString: String, to destinationURL: URL, completion: @escaping (String) -> Void) {
    let fileManager = FileManager.default
    let documentsDirectory = URL.documentsDirectory
    guard let url = URL(string: urlString) else {
        print("Invalid URL: \(urlString)")
        completion("[Internal Invalid URL error]")
        return
    }
    let task = URLSession.shared.downloadTask(with: url) { (tempLocalUrl, response, error) in
        guard let tempLocalUrl = tempLocalUrl, error == nil else {
            print("Error downloading file from \(urlString): \(String(describing: error))")
            completion("Are you connected to the internet? [Download Failed]")
            return
        }
        do {
            try fileManager.createDirectory(at: destinationURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            try fileManager.moveItem(at: tempLocalUrl, to: destinationURL)
            print("Downloaded \(urlString) to \(destinationURL.path)")
        } catch {
            print("Error saving file: \(error)")
        }
    }
    task.resume()
    completion("")
}
