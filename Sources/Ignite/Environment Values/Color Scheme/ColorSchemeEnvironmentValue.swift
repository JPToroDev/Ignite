//
// ColorScheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct ColorSchemeEnvironmentValue: EnvironmentValue {
    public enum Value {
        case light, dark
    }
    
    public var key: String { "colorScheme" }
    public var eventName: String { "environment-\(key.lowercased())-change" }
    
    public var detectionScript: String {
        """
        function updateColorScheme() {
            const isDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
            const colorScheme = isDark ? 'dark' : 'light';
            updateEnvironmentValue('colorScheme', colorScheme);
            dispatchEnvironmentChange('colorScheme', colorScheme);
            document.documentElement.classList.toggle('dark', isDark);
        }
        
        updateColorScheme();
        window.matchMedia('(prefers-color-scheme: dark)')
            .addEventListener('change', updateColorScheme);
        """
    }
}
