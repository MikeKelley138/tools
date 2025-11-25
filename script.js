class CarouselBlock {
    constructor(container) {
        this.container = container;
        this.track = container.querySelector('[data-carousel-track]');
        this.prevBtn = container.querySelector('[data-carousel-prev]');
        this.nextBtn = container.querySelector('[data-carousel-next]');
        this.indicators = container.querySelectorAll('.carousel-block__indicator');
        this.slides = container.querySelectorAll('.carousel-block__slide');
        
        this.currentSlide = 0;
        this.slideCount = this.slides.length;
        
        this.init();
    }
    
    init() {
        // Add event listeners
        if (this.prevBtn) {
            this.prevBtn.addEventListener('click', () => this.prev());
        }
        
        if (this.nextBtn) {
            this.nextBtn.addEventListener('click', () => this.next());
        }
        
        // Indicator clicks
        this.indicators.forEach((indicator, index) => {
            indicator.addEventListener('click', () => this.goToSlide(index));
        });
        
        // Keyboard navigation
        this.container.addEventListener('keydown', (e) => this.handleKeydown(e));
        
        // Swipe support for touch devices
        this.setupSwipe();
        
        // Auto-play (optional - uncomment if needed)
        // this.setupAutoplay();
    }
    
    goToSlide(index) {
        this.currentSlide = index;
        this.updateCarousel();
    }
    
    next() {
        this.currentSlide = (this.currentSlide + 1) % this.slideCount;
        this.updateCarousel();
    }
    
    prev() {
        this.currentSlide = (this.currentSlide - 1 + this.slideCount) % this.slideCount;
        this.updateCarousel();
    }
    
    updateCarousel() {
        // Scroll to current slide
        if (this.track) {
            const slideWidth = this.slides[0].offsetWidth;
            this.track.scrollTo({
                left: slideWidth * this.currentSlide,
                behavior: 'smooth'
            });
        }
        
        // Update indicators
        this.indicators.forEach((indicator, index) => {
            if (index === this.currentSlide) {
                indicator.classList.add('carousel-block__indicator--active');
                indicator.setAttribute('aria-current', 'true');
            } else {
                indicator.classList.remove('carousel-block__indicator--active');
                indicator.removeAttribute('aria-current');
            }
        });
        
        // Update ARIA live region for screen readers
        this.updateAriaLive();
    }
    
    updateAriaLive() {
        // Create or update ARIA live region for screen readers
        let liveRegion = this.container.querySelector('[aria-live="polite"]');
        if (!liveRegion) {
            liveRegion = document.createElement('div');
            liveRegion.setAttribute('aria-live', 'polite');
            liveRegion.setAttribute('aria-atomic', 'true');
            liveRegion.className = 'sr-only';
            this.container.appendChild(liveRegion);
        }
        liveRegion.textContent = `Slide ${this.currentSlide + 1} of ${this.slideCount}`;
    }
    
    handleKeydown(e) {
        switch(e.key) {
            case 'ArrowLeft':
                e.preventDefault();
                this.prev();
                break;
            case 'ArrowRight':
                e.preventDefault();
                this.next();
                break;
            case 'Home':
                e.preventDefault();
                this.goToSlide(0);
                break;
            case 'End':
                e.preventDefault();
                this.goToSlide(this.slideCount - 1);
                break;
        }
    }
    
    setupSwipe() {
        let startX = 0;
        let endX = 0;
        
        const handleStart = (e) => {
            startX = e.type.includes('mouse') ? e.pageX : e.touches[0].pageX;
        };
        
        const handleEnd = (e) => {
            endX = e.type.includes('mouse') ? e.pageX : e.changedTouches[0].pageX;
            this.handleSwipe(startX, endX);
        };
        
        // Mouse events
        this.track.addEventListener('mousedown', handleStart);
        this.track.addEventListener('mouseup', handleEnd);
        
        // Touch events
        this.track.addEventListener('touchstart', handleStart, { passive: true });
        this.track.addEventListener('touchend', handleEnd, { passive: true });
    }
    
    handleSwipe(startX, endX) {
        const swipeThreshold = 50;
        const diff = startX - endX;
        
        if (Math.abs(diff) > swipeThreshold) {
            if (diff > 0) {
                this.next();
            } else {
                this.prev();
            }
        }
    }
    
    setupAutoplay() {
        // Auto-play every 5 seconds (optional)
        setInterval(() => {
            this.next();
        }, 5000);
    }
}

// Initialize all carousel blocks on the page
document.addEventListener('DOMContentLoaded', () => {
    const carouselBlocks = document.querySelectorAll('.carousel-block');
    carouselBlocks.forEach(block => {
        new CarouselBlock(block);
    });
});

// Fallback for no JavaScript
document.documentElement.classList.remove('no-js');
