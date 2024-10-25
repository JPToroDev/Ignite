//
// ColorScheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct ColorSchemeEnvironmentValue: EnvironmentValue {
    public enum Value: String {
        case light, dark
        
        public var description: String { rawValue }
    }
    
    public var key: String { "colorScheme" }
    public var eventName: String { "environment-\(key.lowercased())-change" }
    
    public var detectionScript: String {
        """
        function detectColorScheme() {
            const isDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
            const value = isDark ? 'dark' : 'light';
            
            window.igniteEnvironment.setValue('colorScheme', value);
            document.documentElement.classList.toggle('dark', isDark);
        }
        
        detectColorScheme();
        
        window.matchMedia('(prefers-color-scheme: dark)')
            .addEventListener('change', detectColorScheme);
        """
    }
}
