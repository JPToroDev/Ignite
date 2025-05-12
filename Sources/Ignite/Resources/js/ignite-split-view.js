function initializeSplitView() {
    const dividerHitarea = document.getElementById('splitview-divider-hitarea');
    const container = document.querySelector('.splitview');
    const sidebar = document.querySelector('.splitview-sidebar');
    const content = document.querySelector('.splitview-sidebar-content');

    let isDragging = false;

    const MIN_WIDTH = parseInt(
        getComputedStyle(content).getPropertyValue('--splitview-min-width') || '100'
    );

    const DEFAULT_WIDTH = parseInt(
        getComputedStyle(content).getPropertyValue('--splitview-default-width') || '250'
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
