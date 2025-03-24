import { LightningElement, track } from 'lwc';

export default class WatchCarousel extends LightningElement {
    @track watches = [
        { id: 0, name: 'Luxury Gold Watch', image: 'https://www.maximawatches.com/cdn/shop/files/Artboard_1_4f86e097-952f-4b32-b813-5ec8134aee5f.png?v=1740217058', isActive: true, dotClass: 'dot active' },
        { id: 1, name: 'Classic Silver Watch', image: 'https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/0bd0ac52415183.5a8acdbfdeb13.png', isActive: false, dotClass: 'dot' },
        { id: 2, name: 'Modern Black Watch', image: 'https://sylvi.in/cdn/shop/articles/Explore_Unique_Diwali_Gifts_for_Men_Online_-_Explore_Sylvi_Iconic_Imperial_Rig_One_O_One_Watches.webp?v=1697707030', isActive: false, dotClass: 'dot' }
    ];

    currentIndex = 0;
    intervalId;

    connectedCallback() {
        this.startAutoSlide();
    }

    disconnectedCallback() {
        clearInterval(this.intervalId);
    }

    startAutoSlide() {
        this.intervalId = setInterval(() => {
            this.nextSlide();
        }, 3000); // Change slide every 3 seconds
    }

    nextSlide() {
        this.toggleSlide(this.currentIndex, (this.currentIndex + 1) % this.watches.length);
    }

    prevSlide() {
        this.toggleSlide(this.currentIndex, (this.currentIndex - 1 + this.watches.length) % this.watches.length);
    }

    goToSlide(event) {
        const newIndex = parseInt(event.target.dataset.id, 10);
        this.toggleSlide(this.currentIndex, newIndex);
    }

    toggleSlide(oldIndex, newIndex) {
        if (oldIndex === newIndex) return;

        this.watches[oldIndex].isActive = false;
        this.watches[oldIndex].dotClass = 'dot';

        this.watches[newIndex].isActive = true;
        this.watches[newIndex].dotClass = 'dot active';

        this.currentIndex = newIndex;
    }
}