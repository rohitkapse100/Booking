import { LightningElement, wire, track } from 'lwc';
import getRecentBookings from '@salesforce/apex/BookingController.getRecentBookings';

export default class BookingStatusTracker extends LightningElement {
    @track bookings = [];
    @track errorMessage = '';

    @wire(getRecentBookings)
    wiredBookings({ error, data }) {
        console.log('📌 Booking Data:', JSON.stringify(data));
        
        if (data && data.length > 0) {
            this.bookings = data;
            this.errorMessage = '';  // Clear error if bookings exist
        } else {
            this.bookings = [];
            this.errorMessage = '⚠ No recent bookings found.';
        }

        if (error) {
            console.error('❌ Error fetching bookings:', error);
            this.errorMessage = '❌ Error fetching bookings. Please try again.';
        }
    }
}