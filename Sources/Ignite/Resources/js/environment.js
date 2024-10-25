//
// environment.js
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

class EnvironmentSystem {
    constructor() {
        this.values = new Map();
        this.setupDefaults();
        this.setupListeners();
    }

    setupDefaults() {
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        this.setValue('colorScheme', prefersDark ? 'dark' : 'light');
    }

    setupListeners() {
        const colorSchemeMedia = window.matchMedia('(prefers-color-scheme: dark)');
        colorSchemeMedia.addEventListener('change', e => {
            this.setValue('colorScheme', e.matches ? 'dark' : 'light');
        });
    }

    setValue(key, value) {
        this.values.set(key, value);
        this.updateElements(key, value);
    }

    updateElements(key, value) {
        const elements = document.querySelectorAll(`[data-ignite-env-${key}]`);
        elements.forEach(element => {
            const envValue = element.getAttribute(`data-ignite-env-${key}`);
            element.style.display = (envValue === value) ? '' : 'none';
        });
    }
}

window.addEventListener('DOMContentLoaded', () => {
    window.igniteEnv = new EnvironmentSystem();
});
