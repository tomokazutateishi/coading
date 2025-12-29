/**
 * Navigation Scripts
 * Handle mobile menu toggle
 */

(function() {
    'use strict';

    // Mobile Menu Toggle
    const menuToggle = document.querySelector('.menu-toggle');
    const navLinks = document.querySelector('.nav-links');
    const navLinksTablet = document.querySelector('.nav-links-tablet');

    // Function to handle responsive navigation
    function handleResponsiveNavigation() {
        const siteLockup = document.querySelector('.site-lockup');
        const siteBranding = document.querySelector('.site-branding');
        
        if (window.innerWidth <= 375) {
            // Mobile: Always show navigation links, title with 3 lines, hide tagline
            if (navLinksTablet) {
                navLinksTablet.style.display = 'none';
            }
            if (siteLockup) {
                siteLockup.style.display = 'flex';
                siteLockup.style.flexDirection = 'row';
                siteLockup.style.justifyContent = 'space-between';
                siteLockup.style.alignItems = 'center';
                siteLockup.style.width = 'auto';
                siteLockup.style.height = 'auto';
                siteLockup.style.overflow = 'visible';
                siteLockup.style.padding = '0';
                siteLockup.style.gap = '40px';
                siteLockup.style.visibility = 'visible';
                siteLockup.style.opacity = '1';
            }
            if (navLinks) {
                navLinks.style.display = 'flex';
                navLinks.style.visibility = 'visible';
                navLinks.style.opacity = '1';
            }
            if (siteBranding) {
                // Mobile: 3行表示（br表示）
                const titleBr = siteBranding.querySelectorAll('.site-title br');
                titleBr.forEach(br => {
                    br.style.display = 'block';
                });
                const siteTitle = siteBranding.querySelector('.site-title');
                if (siteTitle) {
                    siteTitle.style.whiteSpace = 'normal';
                }
            }
            // Hide tagline on mobile
            const siteTagline = document.querySelector('.site-tagline');
            if (siteTagline) {
                siteTagline.style.display = 'none';
                siteTagline.style.visibility = 'hidden';
                siteTagline.style.opacity = '0';
                siteTagline.style.position = 'absolute';
                siteTagline.style.left = '-9999px';
            }
        } else if (window.innerWidth <= 799) {
            // Tablet: Show site-lockup with tagline and nav-links, title with 1 line
            if (navLinksTablet) {
                navLinksTablet.style.display = 'none';
            }
            if (siteLockup) {
                siteLockup.style.display = 'flex';
                siteLockup.style.visibility = 'visible';
                siteLockup.style.opacity = '1';
            }
            if (siteBranding) {
                // Tablet: 1行表示（br非表示）
                const titleBr = siteBranding.querySelectorAll('.site-title br');
                titleBr.forEach(br => {
                    br.style.display = 'none';
                });
                const siteTitle = siteBranding.querySelector('.site-title');
                if (siteTitle) {
                    siteTitle.style.whiteSpace = 'nowrap';
                }
            }
        } else {
            // Desktop: Show site-lockup normally, title with 3 lines
            if (navLinksTablet) {
                navLinksTablet.style.display = 'none';
            }
            if (siteLockup) {
                siteLockup.style.display = 'flex';
                siteLockup.style.visibility = 'visible';
                siteLockup.style.opacity = '1';
            }
            if (siteBranding) {
                // Desktop: 3行表示（br表示）
                const titleBr = siteBranding.querySelectorAll('.site-title br');
                titleBr.forEach(br => {
                    br.style.display = 'block';
                });
                const siteTitle = siteBranding.querySelector('.site-title');
                if (siteTitle) {
                    siteTitle.style.whiteSpace = 'normal';
                }
            }
        }
    }

    // Initialize responsive navigation
    handleResponsiveNavigation();

    // Handle window resize
    let resizeTimer;
    window.addEventListener('resize', function() {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(function() {
            // Handle responsive navigation
            handleResponsiveNavigation();
        }, 250);
    });

})();

