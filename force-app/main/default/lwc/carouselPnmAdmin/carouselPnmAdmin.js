import { LightningElement, track } from 'lwc';

export default class carouselPnmAdmin extends LightningElement {
    @track slides = [
        { 
            id: 0, 
            name: 'Packers & Movers Truck', 
            image: 'https://cdn.pixabay.com/photo/2017/10/24/10/52/truck-2883963_1280.jpg', 
            isActive: true, 
            dotClass: 'dot active' 
        },
        { 
            id: 1, 
            name: 'Loading Moving Boxes', 
            image: 'https://cdn.pixabay.com/photo/2016/02/13/16/55/moving-boxes-1193127_1280.jpg', 
            isActive: false, 
            dotClass: 'dot' 
        },
        { 
            id: 2, 
            name: 'Workers Moving Furniture', 
            image: 'https://cdn.pixabay.com/photo/2017/07/06/13/54/packing-2487509_1280.jpg', 
            isActive: false, 
            dotClass: 'dot' 
        },
        { 
            id: 3, 
            name: 'Home Relocation Team', 
            image: 'https://cdn.pixabay.com/photo/2016/11/29/02/02/moving-truck-1866417_1280.jpg', 
            isActive: false, 
            dotClass: 'dot' 
        },
        { 
            id: 4, 
            name: 'Family Packing Luggage', 
            image: 'https://cdn.pixabay.com/photo/2018/02/24/20/39/moving-3177615_1280.jpg', 
            isActive: false, 
            dotClass: 'dot' 
        }
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
        this.toggleSlide(this.currentIndex, (this.currentIndex + 1) % this.slides.length);
    }

    prevSlide() {
        this.toggleSlide(this.currentIndex, (this.currentIndex - 1 + this.slides.length) % this.slides.length);
    }

    goToSlide(event) {
        const newIndex = parseInt(event.target.dataset.id, 10);
        this.toggleSlide(this.currentIndex, newIndex);
    }

    toggleSlide(oldIndex, newIndex) {
        if (oldIndex === newIndex) return;

        this.slides[oldIndex].isActive = false;
        this.slides[oldIndex].dotClass = 'dot';

        this.slides[newIndex].isActive = true;
        this.slides[newIndex].dotClass = 'dot active';

        this.currentIndex = newIndex;
    }
}