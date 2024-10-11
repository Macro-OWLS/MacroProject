//
//  SyncManager.swift
//  MacroProject
//
//  Created by Agfi on 11/10/24.
//

import Foundation

struct SyncManager {
    static let syncKey = "hasSynchronized"
    
    static func isFirstAppOpen() -> Bool {
        return !UserDefaults.standard.bool(forKey: syncKey)
    }
    
    static func markAsSynchronized() {
        UserDefaults.standard.set(true, forKey: syncKey)
    }
}
