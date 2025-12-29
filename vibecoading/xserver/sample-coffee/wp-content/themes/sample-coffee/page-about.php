<?php
/**
 * Template Name: About Page
 * Template Post Type: page
 *
 * @package Sample_Coffee
 */

get_header();
?>

<main id="primary" class="site-main about-page">

    <!-- Hero Text Section -->
    <section class="hero-text-section">
        <div class="hero-text-content">
            <h1 class="page-title">私たちについて</h1>
            <p class="page-description">
                沖縄の豊かな自然と、コーヒーへの深い情熱が織りなす、ここでしか味わえない一杯。土壌から育み、心を込めて焙煎する、私たちのこだわりの物語です。
            </p>
        </div>
    </section>

    <!-- Founder Section -->
    <section class="founder-section">
        <!-- Left Content - Our Initiatives -->
        <div class="founder-content">
            <h2 class="initiatives-title">私たちの取り組み</h2>
            <div class="initiatives-content">
                <div class="initiative-item">
                    <span class="initiative-year">2025</span>
                    <span class="initiative-text">持続可能なコーヒー栽培の実践</span>
                </div>
                <div class="initiative-item">
                    <span class="initiative-year">2025</span>
                    <span class="initiative-text">地域社会との連携、活性化への貢献</span>
                </div>
                <div class="initiative-item">
                    <span class="initiative-year">2024</span>
                    <span class="initiative-text">伝統的な手法と最新技術の融合</span>
                </div>
                <div class="initiative-item">
                    <span class="initiative-year">2024</span>
                    <span class="initiative-text">沖縄の風土を活かした独自ブレンド開発</span>
                </div>
                <div class="initiative-item">
                    <span class="initiative-year">2023</span>
                    <span class="initiative-text">厳格な品質管理と鮮度へのこだわり</span>
                </div>
                <div class="initiative-item">
                    <span class="initiative-year">2023</span>
                    <span class="initiative-text">コーヒー文化の普及と教育活動</span>
                </div>
            </div>
        </div>

        <!-- Right Content - Founder Image -->
        <div class="founder-image" style="background-image: url('<?php echo get_template_directory_uri(); ?>/assets/images/founder.jpg'); background-size: cover; background-position: center;">
            <div class="founder-name-card">
                <div class="circular-tag">
                    <span>生産者</span>
                </div>
                <h3 class="founder-name">屋良 健太</h3>
            </div>
        </div>
    </section>

    <!-- Contact Info Section -->
    <section class="contact-info-section">
        <div class="contact-image" style="background-image: url('<?php echo get_template_directory_uri(); ?>/assets/images/contact-image.jpg'); background-size: cover; background-position: center;">
        </div>
        <div class="contact-text-block">
            <div class="contact-details">
                <h2>コンタクト</h2>
                <div class="contact-list">
                    <div class="contact-item">
                        <span class="contact-label">Phone</span>
                        <span class="contact-value">000-0000-0000</span>
                    </div>
                    <div class="contact-item">
                        <span class="contact-label">email</span>
                        <span class="contact-value">hello@name.com</span>
                    </div>
                    <div class="contact-item">
                        <span class="contact-label">social</span>
                        <span class="contact-value">@sosial</span>
                    </div>
                </div>
            </div>
            <div class="year-info">
                <p>創業 2018年</p>
            </div>
        </div>
    </section>

</main><!-- #main -->

<?php
get_footer();

