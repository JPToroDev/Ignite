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
        const elements = document.querySelectorAll('[data-ignite-env="true"]');
        elements.forEach(element => {
            const children = element.children;
            for (let child of children) {
                const condition = child.getAttribute('data-ignite-env-condition');
                const shouldShow = (value === 'dark' && condition === 'false') ||
                                 (value === 'light' && condition === 'true');
                child.style.display = shouldShow ? '' : 'none';
            }
        });
    }
}

window.addEventListener('DOMContentLoaded', () => {
    window.igniteEnv = new EnvironmentSystem();
});
