//
//  main.swift
//  Extension
//
//  Created by Csaba Szigeti on 17.10.22.
//

import Foundation
import CoreMediaIO

let providerSource = ExtensionProviderSource(clientQueue: nil)
CMIOExtensionProvider.startService(provider: providerSource.provider)

CFRunLoopRun()
