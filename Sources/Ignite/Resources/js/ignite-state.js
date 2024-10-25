// Ignite State Management
const ignite = {
    state: {
        // Get a value from a DOM element's data attributes
        get(element, key) {
            return element.dataset[key];
        },
        
        // Set a value in a DOM element's data attributes
        set(element, key, value) {
            element.dataset[key] = value;
            // Dispatch a custom event for state changes
            element.dispatchEvent(new CustomEvent('ignite:stateChange', {
                detail: { key, value },
                bubbles: true
            }));
        },
        
        // Watch for changes to a particular state key
        watch(element, key, callback) {
            element.addEventListener('ignite:stateChange', (event) => {
                if (event.detail.key === key) {
                    callback(event.detail.value);
                }
            });
        },
        
        // Initialize state for an element
        init(element, initialState = {}) {
            Object.entries(initialState).forEach(([key, value]) => {
                this.set(element, key, value);
            });
        }
    },
    
    // Environment value management
    env: {
        // Set an environment value that affects child elements
        set(element, key, value) {
            element.dataset[`env_${key}`] = value;
            // Propagate to children that don't have their own value set
            element.querySelectorAll(`[data-env-inherits="${key}"]`).forEach(child => {
                if (!child.dataset[`env_${key}`]) {
                    child.dataset[`env_${key}`] = value;
                }
            });
        },
        
        // Get the nearest environment value from the DOM hierarchy
        get(element, key) {
            const ownValue = element.dataset[`env_${key}`];
            if (ownValue !== undefined) return ownValue;
            
            // Mark this element as inheriting this environment value
            element.dataset.envInherits = key;
            
            // Look for the nearest ancestor with this environment value
            const ancestor = element.closest(`[data-env_${key}]`);
            return ancestor ? ancestor.dataset[`env_${key}`] : null;
        }
    }
};

// Initialize Ignite on page load
document.addEventListener('DOMContentLoaded', () => {
    // Initialize any elements with data-ignite-init attributes
    document.querySelectorAll('[data-ignite-init]').forEach(element => {
        try {
            const initialState = JSON.parse(element.dataset.igniteInit);
            ignite.state.init(element, initialState);
        } catch (e) {
            console.error('Failed to initialize Ignite state:', e);
        }
    });
});
```