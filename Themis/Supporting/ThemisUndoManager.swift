//
//  ThemisUndoManager.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 24.05.23.
//

import Foundation

/// A wrapper class intended to perform UndoManager actions and publish notifications to update views
class ThemisUndoManager {
    static let shared = ThemisUndoManager()
    
    let stateChangeNotification = Notification.Name("undoStateChange")
    private let undoManager = UndoManager()
    
    private init() {}
    
    var canUndo: Bool {
        undoManager.canUndo
    }
    
    var canRedo: Bool {
        undoManager.canRedo
    }
    
    func removeAllActions() {
        undoManager.removeAllActions()
        NotificationCenter.default.post(name: stateChangeNotification, object: nil)
    }
    
    func beginUndoGrouping() {
        undoManager.beginUndoGrouping()
        NotificationCenter.default.post(name: stateChangeNotification, object: nil)
    }
    
    func endUndoGrouping() {
        undoManager.endUndoGrouping()
        NotificationCenter.default.post(name: stateChangeNotification, object: nil)
    }
    
    func registerUndo<TargetType>(withTarget target: TargetType, handler: @escaping (TargetType) -> Void) where TargetType: AnyObject {
        undoManager.registerUndo(withTarget: target, handler: handler)
        NotificationCenter.default.post(name: stateChangeNotification, object: nil)
    }
    
    func undo() {
        undoManager.undo()
        NotificationCenter.default.post(name: stateChangeNotification, object: nil)
    }
    
    func redo() {
        undoManager.redo()
        NotificationCenter.default.post(name: stateChangeNotification, object: nil)
    }
}
