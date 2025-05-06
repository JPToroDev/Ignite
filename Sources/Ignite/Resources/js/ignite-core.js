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
    const content = document.querySelector('.splitview-sidebar-content');
    let isDragging = false;

    const MIN_WIDTH = parseInt(
        getComputedStyle(sidebar).getPropertyValue('--splitview-min-width') || '100'
    );

    const DEFAULT_WIDTH = parseInt(
        getComputedStyle(sidebar).getPropertyValue('--splitview-default-width') || '250'
    );

    const SHOULD_COLLAPSE = sidebar.dataset.collapseOnMin === 'true';

    // Store the original width before collapse
    let sidebarWidth = DEFAULT_WIDTH;

    function collapsePanel() {
        // Store current width before collapsing
        // (only if it's not already collapsed)
        if (!sidebar.classList.contains('collapsed')) {
            sidebarWidth = sidebar.offsetWidth || DEFAULT_WIDTH;
        }

        // First animate the width to 0
        sidebar.style.width = '0px';
        sidebar.classList.add('collapsed');
        dividerHitarea.classList.add('collapsed');

        // Synchronize with Bootstrap's state
        sidebar.classList.remove('show');

        // Wait for the animation to complete before hiding
        // Default transition duration is 0.35s in Bootstrap
        setTimeout(() => {
            // Only hide if still collapsed (user might have expanded during animation)
            if (sidebar.classList.contains('collapsed')) {
                sidebar.style.display = 'none';
            }

            // Trigger a resize event for any components that need to adjust
            window.dispatchEvent(new Event('resize'));
        }, 350); // Match this to your CSS transition duration
    }

    function expandPanel() {
        // Make the sidebar visible but with width 0
        sidebar.style.display = 'block'; // Use block instead of flex initially
        sidebar.style.width = '0px'; // Start from 0

        // Force a reflow before changing width to ensure transition works
        sidebar.offsetHeight;

        // Set the target width to trigger the animation
        sidebar.style.width = `${sidebarWidth}px`;

        // Remove collapsed class for other styling
        sidebar.classList.remove('collapsed');
        dividerHitarea.classList.remove('collapsed');

        // Wait for animation to complete before applying flex
        setTimeout(() => {
            // Apply flex styling after width animation completes
            sidebar.style.display = 'flex';

            // Trigger a resize event for any components that need to adjust
            window.dispatchEvent(new Event('resize'));
        }, 350); // Match this to your CSS transition duration
    }

    function togglePanel() {
        if (sidebar.classList.contains('collapsed')) {
            expandPanel();
        } else {
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
            collapsePanel();
        }
    }

    function handleDrag(e) {
        if (!isDragging) return;

        const containerRect = container.getBoundingClientRect();
        const clientX = e.touches ? e.touches[0].clientX : e.clientX;
        const leftWidth = clientX - containerRect.left;

        const MAX_WIDTH = parseInt(
            getComputedStyle(content).getPropertyValue('--splitview-max-width')
        );

        if (leftWidth < MIN_WIDTH) {
            if (SHOULD_COLLAPSE) {
                collapsePanel();
            } else {
                sidebar.style.width = `${MIN_WIDTH}px`;
            }
        } else if (MAX_WIDTH && leftWidth > MAX_WIDTH) {
            // If we're exceeding max width, cap it
            sidebar.style.width = `${MAX_WIDTH}px`;
        } else if (leftWidth < containerRect.width - MIN_WIDTH) {
            // Ensure sidebar is visible when dragging
            if (sidebar.classList.contains('collapsed')) {
                sidebar.style.display = 'flex';
                sidebar.classList.remove('collapsed');
                dividerHitarea.classList.remove('collapsed');
            }

            sidebar.style.width = `${leftWidth}px`;
        }
    }

    function handleDragEnd() {
        isDragging = false;
        dividerHitarea.classList.remove('active');

        if (sidebar.offsetWidth <= MIN_WIDTH) {
            sidebar.classList.add('collapsed');
            sidebar.classList.remove('show');
            dividerHitarea.classList.add('collapsed');
        } else {
            sidebar.classList.remove('collapsed');
            sidebar.classList.add('show');
            dividerHitarea.classList.remove('collapsed');
        }
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

    // Connect to Bootstrap collapse events if they exist
    if (sidebar.classList.contains('collapse')) {
        // For Bootstrap collapse, we need a different approach
        // since Bootstrap handles the animation itself

        // On hide.bs.collapse (triggered at the start of hiding)
        sidebar.addEventListener('hide.bs.collapse', () => {
            // Store width before Bootstrap collapses it
            if (!sidebar.classList.contains('collapsed')) {
                sidebarWidth = sidebar.offsetWidth || DEFAULT_WIDTH;
            }
            sidebar.classList.add('collapsed');
            dividerHitarea.classList.add('collapsed');
        });

        // On hidden.bs.collapse (triggered after animation complete)
        sidebar.addEventListener('hidden.bs.collapse', () => {
            // Now we can safely hide it completely
            sidebar.style.display = 'none';
            window.dispatchEvent(new Event('resize'));
        });

        // On show.bs.collapse (triggered at the start of showing)
        sidebar.addEventListener('show.bs.collapse', () => {
            // Make visible first before Bootstrap shows it
            sidebar.style.display = 'flex';
            expandPanel();
        });
    }

    // Make functions available globally
    window.igniteToggleSplitView = togglePanel;
    window.igniteShowSplitView = showPanel;
    window.igniteHideSplitView = hidePanel;
}

// Initialize everything when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    initializeSplitView();
});

// Resets sidebar width when crossing mobile breakpoint
(function() {
  // Track if we're in mobile mode
  let isMobile = window.innerWidth <= 767.98;

  // Listen for viewport size changes
  window.addEventListener('resize', () => {
    const wasMobile = isMobile;
    isMobile = window.innerWidth <= 767.98;

    // Only act when crossing the breakpoint
    if (wasMobile !== isMobile) {
      const sidebar = document.querySelector('.splitview-sidebar');
      const content = document.querySelector('.splitview-sidebar-content');

      if (!sidebar || sidebar.classList.contains('collapsed')) return;

      if (isMobile) {
        sidebar.style.width = '';
      } else {
        const defaultWidth = parseInt(
          getComputedStyle(content).getPropertyValue('--splitview-default-width') || '250'
        );
        sidebar.style.width = defaultWidth + 'px';
      }
    }
  });
})();
