//
//  ViewController.swift
//  VirtualCamera
//
//  Created by Csaba Szigeti on 17.10.22.
//

import Cocoa
import SystemExtensions

class ViewController: NSViewController, OSSystemExtensionRequestDelegate {
    
    @IBOutlet weak var logText: NSTextField!
    
    func request(_ request: OSSystemExtensionRequest, actionForReplacingExtension existing: OSSystemExtensionProperties, withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {
        logText.stringValue = "Replacing extension version \(existing.bundleShortVersion) with \(ext.bundleShortVersion)"
        return .replace
    }
    
    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
        logText.stringValue = "Extension needs user approval"
    }
    
    func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {
        logText.stringValue = "Request finished with result : \(result.rawValue)"
    }
    
    func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {
        logText.stringValue = "Request failed with error : \(error)"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func installButtonPressed(_ sender: Any) {
        NSLog("Install pressed")
        
        guard let extensionIdentifier = ViewController._extensionBundle() .bundleIdentifier else {
            return
        }
        // Activate the System Extension
        let activationRequest = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: extensionIdentifier, queue: .main)
        activationRequest.delegate = self
        OSSystemExtensionManager.shared.submitRequest(activationRequest)
    }
    
    @IBAction func uninstallButtonPressed(_ sender: Any) {
        NSLog("Uninstall pressed")
        
        guard let extensionIdentifier = ViewController._extensionBundle() .bundleIdentifier else {
            return
        }
        // Deactivate the System Extension
        let deactivationRequest = OSSystemExtensionRequest.deactivationRequest(forExtensionWithIdentifier: extensionIdentifier, queue: .main)
        deactivationRequest.delegate = self
        OSSystemExtensionManager.shared.submitRequest(deactivationRequest)
    }
    
    private class func _extensionBundle() -> Bundle {
        let extensionsDirectoryUrl = URL(fileURLWithPath: "Contents/Library/SystemExtensions", relativeTo: Bundle.main.bundleURL)
        let extensionURLs: [URL]
        
        do {
            extensionURLs = try FileManager.default.contentsOfDirectory(at: extensionsDirectoryUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        } catch let error {
            fatalError("eee \(error)")
        }
        
        guard let extensionURL = extensionURLs.first else {
            fatalError("eee")
        }
        
        guard let extensionBundle = Bundle(url: extensionURL) else {
            fatalError("eee")
        }
        
        return extensionBundle
    }
}

