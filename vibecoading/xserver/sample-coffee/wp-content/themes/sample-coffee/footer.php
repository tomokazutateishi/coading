    </div><!-- #content -->

    <footer id="colophon" class="site-footer">
        <div class="footer-container">
            <!-- Footer Navigation & Contact -->
            <div class="footer-content">
                <!-- Links Section -->
                <div class="footer-links">
                    <nav class="footer-nav">
                        <?php
                        wp_nav_menu( array(
                            'theme_location' => 'footer',
                            'menu_id'        => 'footer-menu',
                            'container'      => false,
                            'menu_class'     => 'footer-menu',
                            'depth'          => 1,
                            'fallback_cb'    => 'sample_coffee_footer_default_menu',
                        ) );
                        ?>
                    </nav>
                </div>

                <!-- Contact Info -->
                <div class="footer-contact">
                    <p><a href="tel:000-0000-0000">(000) 0000-0000</a></p>
                    <p><a href="mailto:hello@name.com">hello@name.com</a></p>
                </div>
            </div>

            <!-- Wordmark & Copyright -->
            <div class="footer-bottom">
                <div class="footer-branding">
                    <p class="footer-site-title"><?php echo esc_html( get_bloginfo( 'name' ) ); ?></p>
                    <p class="footer-copyright">
                        <?php echo esc_html( get_bloginfo( 'name' ) ); ?>© <?php echo date( 'Y' ); ?> All Rights Reserved
                    </p>
                </div>
            </div>

            <!-- Decorative Border -->
            <div class="footer-divider"></div>
        </div>
    </footer>
</div><!-- #page -->

<?php wp_footer(); ?>

</body>
</html>

