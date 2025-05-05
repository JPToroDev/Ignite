// SECTION: Theme Switching -----------------------------------------------------------------

/*
 Manual Theme Switching Implementation (ThemeSwitchAction)
 Automatic theme switching is handled in HTMLHead.swift using the code in theme-switching.js.

 Bootstrap's theming system only understands explicit themes (light/dark/custom)
 through data-bs-theme. For "auto" theme support, our JavaScript code must
 actively switch data-bs-theme between "light" and "dark" based on the system
 preference (see lines 31-33, 39-44, and 51-54).

 This creates a problem: we lose track of the fact that we're in "auto" mode
 since data-bs-theme can only be "light" or "dark". To solve this, we use:

 1. data-bs-theme: Bootstrap's visual theming (always explicit: light/dark)
 2. data-theme-state: User's actual theme selection (light/dark/auto/custom)

 This separation lets us track the true theme state while still working within
 Bootstrap's theming constraints.
 */

function igniteSwitchTheme(themeID) {
    igniteApplyTheme(themeID);
}

function igniteApplyTheme(themeID) {
    if (themeID === 'auto') {
        localStorage.removeItem('custom-theme');
    } else {
        localStorage.setItem('custom-theme', themeID);
    }

    const lightThemeID = document.documentElement.getAttribute('data-light-theme') || 'light';
    const darkThemeID = document.documentElement.getAttribute('data-dark-theme') || 'dark';

    if (themeID === 'auto') {
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        const actualThemeID = prefersDark ? darkThemeID : lightThemeID;
        document.documentElement.setAttribute('data-bs-theme', actualThemeID);
        document.documentElement.setAttribute('data-theme-state', themeID);
    } else {
        document.documentElement.setAttribute('data-bs-theme', themeID);
        document.documentElement.setAttribute('data-theme-state', themeID);
    }

    igniteApplySyntaxTheme();
}

function igniteApplySyntaxTheme() {
    const syntaxTheme = getComputedStyle(document.documentElement)
        .getPropertyValue('--syntax-highlight-theme').trim().replace(/"/g, '');

    if (!syntaxTheme) return;

    // Check if theme has actually changed
    const currentActiveLink = document.querySelector('link[data-highlight-theme]:not([disabled])');
    if (currentActiveLink?.getAttribute('data-highlight-theme') === syntaxTheme) {
        return; // Theme hasn't changed, no need to update
    }

    // Disable all themes first
    document.querySelectorAll('link[data-highlight-theme]').forEach(link => {
        link.setAttribute('disabled', 'disabled');
    });

    // Enable the selected theme
    const themeLink = document.querySelector(`link[data-highlight-theme="${syntaxTheme}"]`);
    if (themeLink) {
        themeLink.removeAttribute('disabled');
    }
}

// SECTION: Email Protection ------------------------------------------------------------------

function encodeEmail(email) {
    return btoa(email);
}

function decode(encoded) {
    return atob(encoded);
}

// Decodes the display text when the page loads
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.protected-link').forEach(link => {
        const encodedDisplay = link.textContent;
        try {
            const decodedDisplay = decode(encodedDisplay);
            link.textContent = decodedDisplay;
        } catch {
            // If decoding fails, the display text wasn't encoded
        }
    });
});

// Handle clicks on protected links
document.addEventListener('click', (e) => {
    // Find closest parent link with protected-link class
    const protectedLink = e.target.closest('.protected-link');
    if (protectedLink) {
        e.preventDefault();
        const encodedUrl = protectedLink.getAttribute('data-encoded-url');
        const url = decode(encodedUrl);
        window.location.href = url;
    }
});

// SECTION: Animations ------------------------------------------------------------------------

document.addEventListener('DOMContentLoaded', () => {
    const appearElements = document.querySelectorAll('[class*="animation-"]');

    setTimeout(() => {
        appearElements.forEach(element => {
            element.classList.add('appeared');
        });
    }, 100);
});

function igniteToggleClickAnimation(element) {
    if (element.classList.contains('clicked')) {
        element.classList.remove('clicked');
        element.classList.add('unclicked');
    } else {
        element.classList.remove('unclicked');
        element.classList.add('clicked');
    }
    return false;
}

// This function removes rows from a table when some filter text is supplied.
// We need to actually remove the rows to ensure that any zebra striping is
// maintained correctly, but we need to a way to reinsert rows later on if
// the search text changes.
function igniteFilterTable(searchText, tableId) {
    let input = searchText.toLowerCase();
    let table = document.getElementById(tableId);
    let tbody = table.querySelector("tbody");

    // The very first time we filter this table, take a back-up copy of the
    // original rows. This uses Array.from() to make a deep copy of the rows.
    if (!("igniteFilterOriginalRows" in tbody)) {
        tbody.igniteFilterOriginalRows = Array.from(tbody.rows);
    }

    // Filter based on our original backup row data.
    let rows = tbody.igniteFilterOriginalRows;

    // Filter rows and detach them to force reflow, to ensure zebra striping is correct.
    let matchingRows = rows.filter(row => row.textContent.toLowerCase().includes(input));

    // Clear tbody and reappend only matching rows; Bootstrap will auto re-stripe.
    tbody.innerHTML = "";
    matchingRows.forEach(row => tbody.appendChild(row));
}

// SECTION: SplitView -------------------------------------------------------------------------

function initializeSplitView() {
    const dividerHitarea = document.getElementById('splitview-divider-hitarea');
    const container = document.querySelector('.splitview');
    const sidebar = document.querySelector('.splitview-sidebar');
    let isDragging = false;

    const MIN_WIDTH = parseInt(
        getComputedStyle(sidebar).getPropertyValue('--splitview-min-width')
    );

    const DEFAULT_WIDTH = parseInt(
        getComputedStyle(sidebar).getPropertyValue('--splitview-default-width')
    );

    const SHOULD_COLLAPSE = getComputedStyle(sidebar)
        .getPropertyValue('--splitview-collapse-on-min') === 'true';

    const COLLAPSED_WIDTH = 0;

    // Store the last non-collapsed width
    let lastWidth = DEFAULT_WIDTH;

    function collapsePanel() {
        sidebar.style.width = `${COLLAPSED_WIDTH}px`;
        sidebar.classList.add('collapsed');
        dividerHitarea.classList.add('collapsed');
    }

    function expandPanel() {
        sidebar.style.width = `${lastWidth}px`;
        sidebar.classList.remove('collapsed');
        dividerHitarea.classList.remove('collapsed');
    }

    function togglePanel() {
        if (sidebar.classList.contains('collapsed')) {
            expandPanel();
        } else {
            lastWidth = parseInt(sidebar.style.width) || DEFAULT_WIDTH;
            collapsePanel();
        }
    }

    function showPanel() {
        if (sidebar.classList.contains('collapsed')) {
            expandPanel();
        }
    }

    function hidePanel() {
        if (!sidebar.classList.contains('collapsed')) {
            lastWidth = parseInt(sidebar.style.width) || DEFAULT_WIDTH;
            collapsePanel();
        }
    }

    function handleDrag(e) {
        if (!isDragging) return;

        const containerRect = container.getBoundingClientRect();
        const clientX = e.touches ? e.touches[0].clientX : e.clientX;
        const leftWidth = clientX - containerRect.left;

        if (leftWidth < MIN_WIDTH) {
            if (SHOULD_COLLAPSE) {
                collapsePanel();
            } else {
                sidebar.style.width = `${MIN_WIDTH}px`;
                lastWidth = MIN_WIDTH;
            }
        } else if (leftWidth < containerRect.width - MIN_WIDTH) {
            sidebar.style.width = `${leftWidth}px`;
            lastWidth = leftWidth;
            sidebar.classList.remove('collapsed');
            dividerHitarea.classList.remove('collapsed');
        }
    }

    function handleDragEnd() {
        isDragging = false;
        dividerHitarea.classList.remove('active');
    }

    dividerHitarea.addEventListener('mousedown', (e) => {
        isDragging = true;
        dividerHitarea.classList.add('active');
        e.preventDefault();
    });

    dividerHitarea.addEventListener('touchstart', (e) => {
        isDragging = true;
        dividerHitarea.classList.add('active');
        e.preventDefault();
    });

    document.addEventListener('mousemove', handleDrag);
    document.addEventListener('touchmove', handleDrag);
    document.addEventListener('mouseup', handleDragEnd);
    document.addEventListener('touchend', handleDragEnd);

    // Make functions available globally
    window.igniteToggleSplitView = togglePanel;
    window.igniteShowSplitView = showPanel;
    window.igniteHideSplitView = hidePanel;
}

// Initialize everything when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    initializeSplitView();
    updateMainContentHeight();
});
