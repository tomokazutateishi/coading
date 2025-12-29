<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo( 'charset' ); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="profile" href="https://gmpg.org/xfn/11">
    <?php wp_head(); ?>
</head>

<body <?php body_class(); ?>>
<?php wp_body_open(); ?>

<div id="page" class="site">
    <header id="masthead" class="site-header">
        <nav class="main-navigation" role="navigation">
            <div class="nav-container">
                <!-- Wordmark -->
                <div class="site-branding">
                    <a href="<?php echo esc_url( home_url( '/' ) ); ?>" class="site-title">
                        Sample<br>Coffee<br>Okinawa
                    </a>
                </div>

                <!-- Lockup (Tagline + Navigation) -->
                <div class="site-lockup">
                    <!-- Tagline -->
                    <p class="site-tagline">沖縄の太陽と恵みが育む、特別な一杯。</p>
                    
                    <!-- Navigation Links -->
                    <div class="nav-links">
                        <a href="<?php echo esc_url( home_url( '/about' ) ); ?>">私たちについて</a>
                        <a href="<?php echo esc_url( home_url( '/find-us' ) ); ?>">店舗情報 / 豆の購入</a>
                        <a href="<?php echo esc_url( home_url( '/contact' ) ); ?>">コンタクト</a>
                    </div>
                </div>

                <!-- Tablet Navigation Links (duplicate for tablet view) -->
                <div class="nav-links-tablet">
                    <a href="<?php echo esc_url( home_url( '/about' ) ); ?>">私たちについて</a>
                    <a href="<?php echo esc_url( home_url( '/find-us' ) ); ?>">店舗情報 / 豆の購入</a>
                    <a href="<?php echo esc_url( home_url( '/contact' ) ); ?>">コンタクト</a>
                </div>

                <!-- Mobile Menu Toggle -->
                <button class="menu-toggle" aria-controls="primary-menu" aria-expanded="false">
                    <span class="menu-toggle-icon"></span>
                </button>
            </div>
        </nav>

        <?php if ( ! is_front_page() ) : ?>
            <div class="page-header-divider"></div>
        <?php endif; ?>
    </header>

    <div id="content" class="site-content">

