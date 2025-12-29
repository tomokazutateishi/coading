<?php
/**
 * Front Page Template
 *
 * @package Sample_Coffee
 */

get_header();
?>

<main id="primary" class="site-main front-page">
    
    <!-- Hero/CTA Section -->
    <section class="hero-section">
        <div class="hero-image" style="background-image: url('<?php echo get_template_directory_uri(); ?>/assets/images/hero-bg.jpg'); background-size: cover; background-position: center;">
            <div class="hero-content">
                <div class="hero-text-block">
                    <h1 class="hero-title">焙煎から淹れ方まで。その一杯に、最高の「贅沢」と「やすらぎ」を込めて。</h1>
                    <a href="<?php echo esc_url( home_url( '/shop' ) ); ?>" class="btn btn-primary">Shop now</a>
                </div>
            </div>
        </div>
    </section>

    <!-- About Section -->
    <section class="about-section section">
        <div class="container">
            <div class="about-content">
                <p class="about-text">
                    Sample Coffee Okinawaは、沖縄の豊かな土壌で丁寧に栽培し、浅煎りで仕上げた特別なドリップコーヒーです。沖縄の風と光を感じる、澄んだ酸味とフルーティーな香りが特徴です。
                </p>
                <a href="<?php echo esc_url( home_url( '/about' ) ); ?>" class="btn btn-secondary">私たちについて</a>
            </div>
        </div>
    </section>

    <!-- Featured Product Section -->
    <section class="featured-product-section">
        <div class="featured-product-image" style="background-image: url('<?php echo get_template_directory_uri(); ?>/assets/images/featured-product.jpg'); background-size: cover; background-position: center;">
            <div class="featured-product-content">
                <div class="circular-tag"></div>
                <div class="product-info">
                    <h2 class="product-name">沖縄ブレンド</h2>
                    <p class="product-description">深いコクと島の恵みを感じる一杯。</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Product Grid Section -->
    <section class="product-grid-section section">
        <div class="container">
            <div class="product-grid">
                <?php
                // Query for products (custom post type or WooCommerce products)
                $products = new WP_Query( array(
                    'post_type'      => 'product',
                    'posts_per_page' => 3,
                ) );

                if ( $products->have_posts() ) :
                    while ( $products->have_posts() ) : $products->the_post();
                ?>
                    <div class="product-item">
                        <div class="product-image">
                            <?php if ( has_post_thumbnail() ) : ?>
                                <?php the_post_thumbnail( 'sample-coffee-featured' ); ?>
                            <?php endif; ?>
                            <div class="product-title-overlay">
                                <h3><?php the_title(); ?></h3>
                            </div>
                        </div>
                        <div class="product-text">
                            <p><?php echo wp_trim_words( get_the_excerpt(), 20 ); ?></p>
                        </div>
                    </div>
                <?php
                    endwhile;
                    wp_reset_postdata();
                else :
                ?>
                    <!-- Default Products if none exist -->
                    <div class="product-item">
                        <div class="product-image" style="background-image: url('<?php echo get_template_directory_uri(); ?>/assets/images/product-1.jpg'); background-size: cover; background-position: center;">
                            <div class="product-title-overlay">
                                <h3>【浅煎り】やんばるライト</h3>
                            </div>
                        </div>
                        <div class="product-text">
                            <p>フルーティーな酸味と軽やかな口当たり。沖縄北部の爽やかな風をイメージした一杯。</p>
                        </div>
                    </div>

                    <div class="product-item">
                        <div class="product-image" style="background-image: url('<?php echo get_template_directory_uri(); ?>/assets/images/product-2.jpg'); background-size: cover; background-position: center;">
                            <div class="product-title-overlay">
                                <h3>【中煎り】島のバランス</h3>
                            </div>
                        </div>
                        <div class="product-text">
                            <p>程よい酸味と苦味のバランスが取れた、毎日飲みたくなる万能ブレンド。</p>
                        </div>
                    </div>

                    <div class="product-item">
                        <div class="product-image" style="background-image: url('<?php echo get_template_directory_uri(); ?>/assets/images/product-3.jpg'); background-size: cover; background-position: center;">
                            <div class="product-title-overlay">
                                <h3>【深煎り】石垣ダーク</h3>
                            </div>
                        </div>
                        <div class="product-text">
                            <p>チョコレートのような濃厚なコクと香ばしさ。どっしりとした飲み応えのある一杯。</p>
                        </div>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </section>

    <!-- Flavors Section -->
    <section class="flavors-section">
        <div class="flavors-text-grid">
            <p class="flavor-text">Lavande</p>
            <p class="flavor-text">Spezia</p>
            <p class="flavor-text">Primavera</p>
            <p class="flavor-text">店舗情報 / 豆の購入</p>
        </div>
    </section>

    <!-- Stocklist Section -->
    <section class="stocklist-section">
        <div class="stocklist-content">
            <div class="stocklist-text">
                <p>沖縄の豊かな自然の中で、豆の栽培から焙煎、抽出まで、全ての工程にこだわった私たちのコーヒーをぜひご体験ください。</p>
            </div>
            <div class="stocklist-image">
                <img src="<?php echo get_template_directory_uri(); ?>/assets/images/stocklist.jpg" alt="Store Location" style="width: 100%; height: 100%; object-fit: cover;">
            </div>
        </div>
    </section>

</main><!-- #main -->

<?php
get_footer();

