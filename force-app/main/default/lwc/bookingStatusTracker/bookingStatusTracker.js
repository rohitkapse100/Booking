import { LightningElement, wire, track } from 'lwc';
import getRecentBookings from '@salesforce/apex/BookingController.getRecentBookings';

export default class BookingStatusTracker extends LightningElement {
    @track bookings = [];
    @track errorMessage = '';
    @track isModalOpen = false;
    @track selectedBookingId;

    @wire(getRecentBookings)
    wiredBookings({ error, data }) {
        if (data) {
            console.log('📌 Booking Data:', JSON.stringify(data));

            this.bookings = data.map(booking => ({
                Id: booking.Id,
                Name: booking.Name || 'N/A',
                CustomerName: booking.Customer__r ? booking.Customer__r.Name : 'N/A',
                MoverName: booking.Mover__r ? booking.Mover__r.Name : 'N/A',
                PickupLocation: booking.Pickup_Location__c || 'N/A',
                DropLocation: booking.Drop_Location__c || 'N/A',
                BookingDate: booking.Booking_Date__c || 'N/A',
                Status: booking.Status__c || 'N/A',
                Amount: booking.Amount__c != null ? booking.Amount__c : 'N/A'
            }));

            this.errorMessage = '';
        } else if (error) {
            console.error('❌ Error fetching bookings:', error);
            this.errorMessage = '❌ Error fetching bookings. Please try again.';
            this.bookings = [];
        }
    }

    handleOpenModal(event) {
        this.selectedBookingId = event.target.dataset.id;
        this.isModalOpen = true;
    }

    handleCloseModal() {
        this.isModalOpen = false;
        this.selectedBookingId = null;
    }
}