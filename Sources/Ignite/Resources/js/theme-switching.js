(function() {
    function getThemePreference() {
        return localStorage.getItem('current-theme') || 'auto';
    }

    function applyTheme(themeID) {
        const lightThemeID = getComputedStyle(document.documentElement)
            .getPropertyValue('light-theme-ID')
            .trim() || 'light';
        const darkThemeID = getComputedStyle(document.documentElement)
            .getPropertyValue('dark-theme-ID')
            .trim() || 'dark';

        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        const actualThemeID = themeID === 'auto' ? (prefersDark ? darkThemeID : lightThemeID) : themeID;
        document.documentElement.setAttribute('data-ig-theme', actualThemeID);
        const isDarkTheme = actualThemeID.endsWith('dark');
        document.documentElement.setAttribute('data-bs-theme', isDarkTheme ? 'dark' : 'light');
        document.documentElement.setAttribute('data-ig-auto-theme-enabled', themeID === 'auto' ? 'true' : 'false');
    }

    function applySyntaxTheme() {
        const syntaxTheme = getComputedStyle(document.documentElement)
            .getPropertyValue('--syntax-highlight-theme').trim().replace(/"/g, '');

        if (!syntaxTheme) return;

        document.querySelectorAll('link[data-highlight-theme]').forEach(link => {
            link.setAttribute('disabled', 'disabled');
        });

        const themeLink = document.querySelector(`link[data-highlight-theme="${syntaxTheme}"]`);
        if (themeLink) {
            themeLink.removeAttribute('disabled');
        }
    }

    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
        const currentTheme = getThemePreference();
        if (currentTheme === 'auto') {
            applyTheme('auto');
            applySyntaxTheme();
        }
    });

    const savedTheme = getThemePreference();
    applyTheme(savedTheme);
    applySyntaxTheme();
})();
