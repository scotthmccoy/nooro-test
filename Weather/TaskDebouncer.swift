//
//  TaskDebouncer.swift
//  Weather
//
//  Created by Scott McCoy on 1/27/25.
//

import Foundation


class TaskDebouncer {
    private var currentTask: Task<Void, Never>?
    
    func debounce(delay: TimeInterval, action: @escaping @Sendable () async -> Void) {
        // Cancel the current task if it exists
        currentTask?.cancel()
        
        // Create a new debounced task
        currentTask = Task {
            // Wait for the debounce delay
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            
            // Check if the task is still active before executing
            guard !Task.isCancelled else { return }
            
            await action()
        }
    }
}
