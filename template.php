<?php
/**
 * Block: Carousel Block
 */

// Block ID and classes
$block_id = 'carousel-block-' . $block['id'];
if( !empty($block['anchor']) ) {
    $block_id = $block['anchor'];
}

$className = 'carousel-block';
if( !empty($block['className']) ) {
    $className .= ' ' . $block['className'];
}
if( !empty($block['align']) ) {
    $className .= ' align' . $block['align'];
}

// Fields
$title = get_field('title') ?: '';
$content = get_field('content') ?: '';
$carousel = get_field('carousel') ?: [];
?>

<section id="<?php echo esc_attr($block_id); ?>" class="<?php echo esc_attr($className); ?>">
    <div class="carousel-block__header">
        <?php if ( $title ) : ?>
            <h2 class="carousel-block__title">
                <?php echo esc_html( $title ); ?>
            </h2>
        <?php endif; ?>

        <?php if ( $content ) : ?>
            <div class="carousel-block__content">
                <?php echo wp_kses_post( $content ); ?>
            </div>
        <?php endif; ?>
    </div>

    <?php if ( $carousel ) : ?>
        <div class="carousel-block__container">
            <div class="carousel-block__track" data-carousel-track>
                <?php foreach ( $carousel as $index => $item ) : 
                    $image_id = $item['carousel_image'] ?? '';
                    $caption = $item['carousel_caption'] ?? '';
                    $image_url = $image_id ? wp_get_attachment_url( $image_id ) : '';
                    ?>
                    <div class="carousel-block__slide" data-slide-index="<?php echo $index; ?>">
                        <?php if ( $image_url ) : ?>
                            <div class="carousel-block__image-container">
                                <img 
                                    src="<?php echo esc_url( $image_url ); ?>" 
                                    alt="<?php echo esc_attr( $caption ?: 'Carousel image' ); ?>" 
                                    class="carousel-block__image"
                                    loading="lazy"
                                />
                            </div>
                        <?php endif; ?>

                        <?php if ( $caption ) : ?>
                            <div class="carousel-block__caption">
                                <?php echo esc_html( $caption ); ?>
                            </div>
                        <?php endif; ?>
                    </div>
                <?php endforeach; ?>
            </div>

            <!-- Navigation -->
            <?php if ( count( $carousel ) > 1 ) : ?>
                <button class="carousel-block__nav carousel-block__nav--prev" data-carousel-prev aria-label="Previous slide">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                        <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </button>
                <button class="carousel-block__nav carousel-block__nav--next" data-carousel-next aria-label="Next slide">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                        <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </button>

                <!-- Indicators -->
                <div class="carousel-block__indicators">
                    <?php foreach ( $carousel as $index => $item ) : ?>
                        <button 
                            class="carousel-block__indicator <?php echo $index === 0 ? 'carousel-block__indicator--active' : ''; ?>" 
                            data-slide-to="<?php echo $index; ?>"
                            aria-label="Go to slide <?php echo $index + 1; ?>"
                        ></button>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>
        </div>
    <?php endif; ?>
</section>
