//
// environment.js
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// environment.js
class EnvironmentSystem {
    constructor() {
        this.values = new Map();
        this.setupDefaults();
        this.setupListeners();
    }

    setupDefaults() {
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        this.setValue('colorscheme', prefersDark ? 'dark' : 'light');
    }

    setupListeners() {
        const colorSchemeMedia = window.matchMedia('(prefers-color-scheme: dark)');
        colorSchemeMedia.addEventListener('change', e => {
            this.setValue('colorscheme', e.matches ? 'dark' : 'light');
        });
    }

    setValue(key, value) {
        this.values.set(key, value);
        this.updateElements(key, value);
    }

    updateElements(key, value) {
        const elements = document.querySelectorAll(`[data-ignite-env-${key}]`);
        elements.forEach(element => {
            const envCondition = element.getAttribute(`data-ignite-env-${key}`);
            const matches = envCondition === value;
            
            if (matches) {
                element.style.removeProperty('display');
            } else {
                element.style.display = 'none';
            }
            
            // Dispatch custom event for other handlers
            element.dispatchEvent(new CustomEvent('igniteEnvChange', {
                detail: { key, value, matches },
                bubbles: true
            }));
        });
    }

    getValue(key) {
        return this.values.get(key);
    }
}

// Initialize once DOM is ready
window.addEventListener('DOMContentLoaded', () => {
    window.igniteEnv = new EnvironmentSystem();
});
