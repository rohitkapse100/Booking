import { LightningElement, track, wire } from 'lwc';
import getApprovedMovers from '@salesforce/apex/MoverController.getApprovedMovers';
import createBooking from '@salesforce/apex/MoverController.createBooking';
import USER_ID from '@salesforce/user/Id';
import CONTACT_ID from '@salesforce/schema/user.ContactId';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BookingForm extends LightningElement {
    @track pickupLocation = '';
    @track dropLocation = '';
    @track bookingDate = '';
    @track selectedMover = '';
    @track movers = [];
    @track items = [];
    @track showItems = false;
    @track estimatedPrice = 0;
    @track contactId ;
    moverPrice = 0; // Stores the price per weight unit of the selected mover

    @wire(getRecord, { recordId: USER_ID, fields: [CONTACT_ID] })
    wiredUser({ error, data }) {
        if (data) {
            this.contactId = data.fields.ContactId.value;
        } else if (error) {
            console.error('Error fetching user email:', error);
        }
    }
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

    handleMoverChange(event) {
        this.selectedMover = event.target.value;
        let selectedMoverObj = this.movers.find(mover => mover.Id === this.selectedMover);
        this.moverPrice = selectedMoverObj ? selectedMoverObj.Price__c : 0;
        this.calculateEstimatedPrice();
    }

    handleItemChange(event) {
        let id = event.target.dataset.id;
        this.items = this.items.map(item => 
            item.id == id ? { ...item, name: event.target.value } : item
        );
    }

    handleWeightChange(event) {
        let id = event.target.dataset.id;
        let weightValue = parseFloat(event.target.value) || 0;
        this.items = this.items.map(item => 
            item.id == id ? { ...item, weight: weightValue } : item
        );
        this.calculateEstimatedPrice();
    }

    handleQuantityChange(event) {
        let id = event.target.dataset.id;
        let quantityValue = parseInt(event.target.value) || 1;
        this.items = this.items.map(item => 
            item.id == id ? { ...item, quantity: quantityValue } : item
        );
        this.calculateEstimatedPrice();
    }

    handleDescriptionChange(event) {
        let id = event.target.dataset.id;
        this.items = this.items.map(item => 
            item.id == id ? { ...item, description: event.target.value } : item
        );
    }

    addItem() {
        if (!this.showItems) {
            this.showItems = true;
        }
        let newItem = { id: Date.now(), name: '', weight: 0, quantity: 1, description: '' };
        this.items = [...this.items, newItem];
        this.calculateEstimatedPrice();
    }

    removeItem(event) {
        let id = event.target.dataset.id;
        this.items = this.items.filter(item => item.id != id);
        if (this.items.length === 0) {
            this.showItems = false;
        }
        this.calculateEstimatedPrice();
    }

    calculateEstimatedPrice() {
        this.estimatedPrice = this.items.reduce((acc, item) => 
            acc + (item.weight * this.moverPrice), 0
        );
    }

    createBooking() {
        if (!this.pickupLocation || !this.dropLocation || !this.bookingDate || !this.selectedMover || this.items.length === 0) {
            this.showToast('Error', 'All fields are required.', 'error');
            return;
        }

        let formattedItems = this.items.map(item => ({
            Name: item.name,
            Quantity__c: item.quantity,
            Weight__c: item.weight,
            Description__c: item.description
        }));

        createBooking({ 
            moverId: this.selectedMover, 
            pickup: this.pickupLocation, 
            drop: this.dropLocation, 
            bookingDate: this.bookingDate, 
            items: formattedItems,
            customerId: this.contactId
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
        this.items = [];
        this.showItems = false;
        this.estimatedPrice = 0;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}