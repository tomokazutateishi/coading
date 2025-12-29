<?php
/**
 * Template Name: Find Us Page
 * Template Post Type: page
 *
 * @package Sample_Coffee
 */

get_header();
?>

<main id="primary" class="site-main find-us-page">

    <!-- Main Content with Stock Lists -->
    <section class="find-us-main" style="background-image: url('<?php echo get_template_directory_uri(); ?>/assets/images/stocklist-bg.jpg'); background-size: cover; background-position: center;">
        <div class="find-us-inner">
            <h1 class="section-title">Our Stock lists</h1>

            <div class="stock-list">
                <!-- Physical Store -->
                <div class="stock-item">
                    <h2 class="stock-title">実店舗</h2>
                    <div class="stock-details">
                        <p>Sample Coffee Okinawa</p>
                        <p>本店 / 沖縄県〇〇市〇〇</p>
                        <p>098-XXX-XXXX</p>
                    </div>
                </div>

                <!-- Online Store -->
                <div class="stock-item">
                    <h2 class="stock-title">オンラインストア</h2>
                    <div class="stock-details">
                        <p>公式サイトオンラインストア / info@samplecoffeeokinawa.jp</p>
                    </div>
                </div>

                <!-- Partner Stores -->
                <div class="stock-item">
                    <h2 class="stock-title">提携販売店 / カフェ</h2>
                    <div class="stock-details">
                        <p>那覇市〇〇カフェ / 宮古島物産店</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

</main><!-- #main -->

<?php
get_footer();

