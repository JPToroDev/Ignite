//
// environment.js
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

class EnvironmentSystem {
    constructor() {
        this.values = new Map();
        this.listeners = new Map();
        this.setupDefaults();
        this.setupListeners();
    }
    
    setupDefaults() {
        // Color scheme
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        this.setValue('colorscheme', prefersDark ? 'dark' : 'light');
        
        // Orientation
        const isPortrait = window.matchMedia('(orientation: portrait)').matches;
        this.setValue('orientation', isPortrait ? 'portrait' : 'landscape');
    }
    
    setupListeners() {
        // Color scheme changes
        const darkModeMedia = window.matchMedia('(prefers-color-scheme: dark)');
        darkModeMedia.addEventListener('change', e => {
            this.setValue('colorscheme', e.matches ? 'dark' : 'light');
        });
        
        // Orientation changes
        const orientationMedia = window.matchMedia('(orientation: portrait)');
        orientationMedia.addEventListener('change', e => {
            this.setValue('orientation', e.matches ? 'portrait' : 'landscape');
        });
    }
    
    setValue(key, value) {
        this.values.set(key, value);
        this.updateElements(key, value);
    }
    
    updateElements(key, value) {
        const elements = document.querySelectorAll(`[data-ignite-env-${key}]`);
        
        elements.forEach(element => {
            const conditions = JSON.parse(element.getAttribute(`data-ignite-env-${key}`));
            
            // Remove existing environment classes
            element.classList.forEach(cls => {
                if (cls.startsWith(`env-${key}-`)) {
                    element.classList.remove(cls);
                }
            });
            
            // Add new environment class
            element.classList.add(`env-${key}-${value}`);
            
            // Update content visibility
            const trueContent = element.querySelector('.env-true');
            const falseContent = element.querySelector('.env-false');
            
            if (conditions[value]) {
                trueContent.style.display = '';
                falseContent.style.display = 'none';
            } else {
                trueContent.style.display = 'none';
                falseContent.style.display = '';
            }
        });
    }
}

window.addEventListener('DOMContentLoaded', () => {
    window.igniteEnv = new EnvironmentSystem();
});
