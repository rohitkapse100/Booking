import { LightningElement, wire, track } from 'lwc';
import getBookingStats from '@salesforce/apex/AdminTotalBookings.getBookingStats';

export default class AdminDashboard extends LightningElement {
    @track totalBookings = 0;
    @track confirmedBookings = 0;
    @track rejectedBookings = 0;
    @track pendingBookings = 0;
    @track moversApproved = 0;
    @track moversRejected = 0;

    @wire(getBookingStats)
    wiredBookingStats({ error, data }) {
        if (data) {
            this.totalBookings = data.TotalBookings;
            this.confirmedBookings = data.ConfirmedBookings;
            this.rejectedBookings = data.RejectedBookings;
            this.pendingBookings = data.PendingBookings;
            this.moversApproved = data.MoversApproved;
            this.moversRejected = data.MoversRejected;
        } else if (error) {
            console.error('Error fetching booking stats:', error);
        }
    }
}