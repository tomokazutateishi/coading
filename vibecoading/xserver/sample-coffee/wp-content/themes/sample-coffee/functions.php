<?php
/**
 * Sample Coffee Okinawa Theme Functions
 *
 * @package Sample_Coffee
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

/**
 * Theme Setup
 */
function sample_coffee_setup() {
    // Add default posts and comments RSS feed links to head
    add_theme_support( 'automatic-feed-links' );

    // Let WordPress manage the document title
    add_theme_support( 'title-tag' );

    // Enable support for Post Thumbnails
    add_theme_support( 'post-thumbnails' );

    // Register navigation menus
    register_nav_menus( array(
        'primary' => __( 'Primary Menu', 'sample-coffee' ),
        'footer'  => __( 'Footer Menu', 'sample-coffee' ),
    ) );

    // Switch default core markup to output valid HTML5
    add_theme_support( 'html5', array(
        'search-form',
        'comment-form',
        'comment-list',
        'gallery',
        'caption',
        'style',
        'script',
    ) );

    // Add theme support for custom logo
    add_theme_support( 'custom-logo', array(
        'height'      => 100,
        'width'       => 400,
        'flex-height' => true,
        'flex-width'  => true,
    ) );

    // Add support for editor styles
    add_theme_support( 'editor-styles' );
}
add_action( 'after_setup_theme', 'sample_coffee_setup' );

/**
 * Enqueue scripts and styles
 */
function sample_coffee_scripts() {
    // Enqueue Google Fonts - Noto Serif JP
    wp_enqueue_style( 
        'sample-coffee-fonts', 
        'https://fonts.googleapis.com/css2?family=Noto+Serif+JP:wght@400;700&display=swap', 
        array(), 
        null 
    );

    // Enqueue main stylesheet
    wp_enqueue_style( 
        'sample-coffee-style', 
        get_stylesheet_uri(), 
        array(), 
        wp_get_theme()->get( 'Version' ) 
    );

    // Enqueue custom CSS
    wp_enqueue_style( 
        'sample-coffee-custom', 
        get_template_directory_uri() . '/assets/css/custom.css', 
        array( 'sample-coffee-style' ), 
        wp_get_theme()->get( 'Version' ) 
    );

    // Enqueue front page specific CSS
    if ( is_front_page() ) {
        wp_enqueue_style( 
            'sample-coffee-front-page', 
            get_template_directory_uri() . '/assets/css/front-page.css', 
            array( 'sample-coffee-custom' ), 
            wp_get_theme()->get( 'Version' ) 
        );
    }

    // Enqueue about page specific CSS
    if ( is_page( 'about' ) ) {
        wp_enqueue_style( 
            'sample-coffee-page-about', 
            get_template_directory_uri() . '/assets/css/page-about.css', 
            array( 'sample-coffee-custom' ), 
            wp_get_theme()->get( 'Version' ) 
        );
    }

    // Enqueue navigation script
    wp_enqueue_script( 
        'sample-coffee-navigation', 
        get_template_directory_uri() . '/assets/js/navigation.js', 
        array(), 
        wp_get_theme()->get( 'Version' ), 
        true 
    );

    // Enqueue comment reply script
    if ( is_singular() && comments_open() && get_option( 'thread_comments' ) ) {
        wp_enqueue_script( 'comment-reply' );
    }
}
add_action( 'wp_enqueue_scripts', 'sample_coffee_scripts' );

/**
 * Register widget areas
 */
function sample_coffee_widgets_init() {
    register_sidebar( array(
        'name'          => __( 'Sidebar', 'sample-coffee' ),
        'id'            => 'sidebar-1',
        'description'   => __( 'Add widgets here to appear in your sidebar.', 'sample-coffee' ),
        'before_widget' => '<section id="%1$s" class="widget %2$s">',
        'after_widget'  => '</section>',
        'before_title'  => '<h2 class="widget-title">',
        'after_title'   => '</h2>',
    ) );
}
add_action( 'widgets_init', 'sample_coffee_widgets_init' );

/**
 * Custom Image Sizes
 */
add_image_size( 'sample-coffee-hero', 1280, 800, true );
add_image_size( 'sample-coffee-featured', 600, 600, true );
add_image_size( 'sample-coffee-thumbnail', 355, 355, true );

/**
 * Add custom body classes
 */
function sample_coffee_body_classes( $classes ) {
    if ( is_front_page() ) {
        $classes[] = 'home-page';
    }
    
    if ( is_page_template( 'page-about.php' ) ) {
        $classes[] = 'about-page';
    }
    
    if ( is_page_template( 'page-find-us.php' ) ) {
        $classes[] = 'find-us-page';
    }
    
    return $classes;
}
add_filter( 'body_class', 'sample_coffee_body_classes' );

/**
 * Custom excerpt length
 */
function sample_coffee_excerpt_length( $length ) {
    return 30;
}
add_filter( 'excerpt_length', 'sample_coffee_excerpt_length' );

/**
 * Custom excerpt more
 */
function sample_coffee_excerpt_more( $more ) {
    return '...';
}
add_filter( 'excerpt_more', 'sample_coffee_excerpt_more' );

/**
 * Default menu fallback for primary menu
 */
function sample_coffee_default_menu() {
    echo '<ul id="primary-menu" class="primary-menu">';
    echo '<li><a href="' . esc_url( home_url( '/about' ) ) . '">私たちについて</a></li>';
    echo '<li><a href="' . esc_url( home_url( '/find-us' ) ) . '">店舗情報 / 豆の購入</a></li>';
    echo '<li><a href="' . esc_url( home_url( '/contact' ) ) . '">コンタクト</a></li>';
    echo '</ul>';
}

/**
 * Default menu fallback for footer menu
 */
function sample_coffee_footer_default_menu() {
    echo '<ul id="footer-menu" class="footer-menu">';
    echo '<li><a href="' . esc_url( home_url( '/find-us' ) ) . '">店舗情報 / 豆の購入</a></li>';
    echo '<li><a href="' . esc_url( home_url( '/about' ) ) . '">私たちについて</a></li>';
    echo '</ul>';
}

