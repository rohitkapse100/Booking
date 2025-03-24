import { LightningElement, track, wire } from 'lwc';
import getApprovedMovers from '@salesforce/apex/MoverController.getApprovedMovers';
import createBooking from '@salesforce/apex/MoverController.createBooking';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BookingForm extends LightningElement {
    @track pickupLocation = '';
    @track dropLocation = '';
    @track bookingDate = '';
    @track selectedMover = '';
    @track movers = [];
    @track items = [{ id: 1, name: '', quantity: 1, description: '' }];
    
    @wire(getApprovedMovers)
    wiredMovers({ error, data }) {
        if (data) {
            this.movers = data;
        } else if (error) {
            this.showToast('Error', 'Failed to load movers.', 'error');
        }
    }

    get moverOptions() {
        return this.movers.map(mover => ({ label: mover.Name, value: mover.Id }));
    }

    handlePickupChange(event) { this.pickupLocation = event.target.value; }
    handleDropChange(event) { this.dropLocation = event.target.value; }
    handleDateChange(event) { this.bookingDate = event.target.value; }
    handleMoverChange(event) { this.selectedMover = event.target.value; }

    handleItemChange(event) {
        let id = event.target.dataset.id;
        let updatedItems = this.items.map(item => item.id == id ? { ...item, name: event.target.value } : item);
        this.items = updatedItems;
    }

    handleQuantityChange(event) {
        let id = event.target.dataset.id;
        let updatedItems = this.items.map(item => item.id == id ? { ...item, quantity: event.target.value } : item);
        this.items = updatedItems;
    }

    handleDescriptionChange(event) {
        let id = event.target.dataset.id;
        let updatedItems = this.items.map(item => item.id == id ? { ...item, description: event.target.value } : item);
        this.items = updatedItems;
    }

    addItem() {
        let newItem = { id: Date.now(), name: '', quantity: 1, description: '' };
        this.items = [...this.items, newItem];
    }

    removeItem(event) {
        let id = event.target.dataset.id;
        this.items = this.items.filter(item => item.id != id);
    }

    createBooking() {
        if (!this.pickupLocation || !this.dropLocation || !this.bookingDate || !this.selectedMover || this.items.length === 0) {
            this.showToast('Error', 'All fields are required.', 'error');
            return;
        }

        let formattedItems = this.items.map(item => ({
            Name: item.name,
            Quantity__c: item.quantity,
            Description__c: item.description
        }));

        createBooking({ 
            moverId: this.selectedMover, 
            pickup: this.pickupLocation, 
            drop: this.dropLocation, 
            bookingDate: this.bookingDate, 
            items: formattedItems
        })
        .then(result => {
            this.showToast('Success', 'Booking created successfully!', 'success');
            this.resetForm();
        })
        .catch(error => {
            this.showToast('Error', error.body.message || 'Failed to create booking.', 'error');
        });
    }

    resetForm() {
        this.pickupLocation = '';
        this.dropLocation = '';
        this.bookingDate = '';
        this.selectedMover = '';
        this.items = [{ id: 1, name: '', quantity: 1, description: '' }];
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
