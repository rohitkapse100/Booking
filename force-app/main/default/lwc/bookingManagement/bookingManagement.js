import { LightningElement, wire, track } from 'lwc';
import getAllBookings from '@salesforce/apex/AdminController.getAllBookings';

export default class BookingManagement extends LightningElement {
    @track bookings = [];

    @wire(getAllBookings)
    wiredBookings({ error, data }) {
        if (data) {
            this.bookings = data.map(booking => ({
                Id: booking.Id,
                CustomerName: booking.Customer__r?.Name || 'N/A',
                CustomerEmail: booking.Customer__r?.Email || 'N/A',
                MoverName: booking.Mover__r?.Name || 'N/A',
                MoverContact: booking.Mover__r?.Phone__c || 'N/A',
                Pickup_Location__c: booking.Pickup_Location__c || 'N/A',
                Drop_Location__c: booking.Drop_Location__c || 'N/A',
                Amount__c: booking.Amount__c ? `${booking.Amount__c.toFixed(2)}` : '$0.00',
                Booking_Date__c: booking.Booking_Date__c || 'N/A',
                Status__c: booking.Status__c || 'N/A',
                statusClass: this.getStatusClass(booking.Status__c)
            }));
        } else if (error) {
            console.error('Error fetching bookings:', error);
        }
    }

    getStatusClass(status) {
        switch (status) {
            case 'Confirmed': return 'status-confirmed';
            case 'In Progress': return 'status-inprogress';
            case 'Rejected': return 'status-rejected';
            default: return 'status-pending';
        }
    }
}