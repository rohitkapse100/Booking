import { LightningElement, wire, track } from 'lwc';
import getPendingBookings from '@salesforce/apex/MoverControllers.getPendingBookings';
import updateBookingStatus from '@salesforce/apex/MoverControllers.updateBookingStatus';
import getLoggedInUserId from '@salesforce/apex/MoverControllers.getLoggedInUserId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const columns = [
    { label: 'Booking ID', fieldName: 'Name', type: 'text' },
    { label: 'Pickup Location', fieldName: 'Pickup_Location__c', type: 'text' },
    { label: 'Drop Location', fieldName: 'Drop_Location__c', type: 'text' },
    { label: 'Amount', fieldName: 'Amount__c', type: 'currency' },
    { label: 'Booking Date', fieldName: 'Booking_Date__c', type: 'date' },
    { label: 'Status', fieldName: 'Status__c', type: 'text' },
    {
        type: 'button',
        typeAttributes: {
            label: 'Approve',
            name: 'approve',
            title: 'Approve Booking',
            variant: 'success',
            disabled: { fieldName: 'disableApprove' }
        }
    },
    {
        type: 'button',
        typeAttributes: {
            label: 'Pending',
            name: 'pending',
            title: 'Mark as Pending',
            variant: 'brand',
            disabled: { fieldName: 'disablePending' }
        }
    },
    {
        type: 'button',
        typeAttributes: {
            label: 'Reject',
            name: 'reject',
            title: 'Reject Booking',
            variant: 'destructive',
            disabled: { fieldName: 'disableReject' }
        }
    }
];

export default class MoverComp extends LightningElement {
    @track bookings = [];
    columns = columns;
    wiredData;

    connectedCallback() {
        this.loadBookings();
    }

    async loadBookings() {
        this.isLoading = true;
        try {
            // Get logged-in mover's email
            this.userEmail = await getLoggedInUserId();
            console.log('Logged-in Mover Email:', this.userEmail);

            // Fetch bookings associated with this mover
            const result = await getPendingBookings({ userEmail: this.userEmail });
            console.log('Fetched Bookings:', JSON.stringify(result));

            // Format data for UI display
            this.bookings = result.map(booking => ({
                ...booking,
                disableApprove: booking.Status__c === 'Confirmed',
                disablePending: booking.Status__c === 'In Progress',
                disableReject: booking.Status__c === 'Rejected'
            }));
        } catch (error) {
            console.error('Error loading bookings:', error);
            this.showToast('Error', 'Failed to load booking requests', 'error');
        } finally {
            this.isLoading = false;
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const bookingId = event.detail.row.Id;
        let newStatus = '';

        if (actionName === 'approve') {
            newStatus = 'Approved'; // Maps to "Confirmed" in Apex
        } else if (actionName === 'pending') {
            newStatus = 'Pending'; // Maps to "In Progress" in Apex
        } else if (actionName === 'reject') {
            newStatus = 'Rejected'; // Maps to "Rejected" in Apex
        }

        updateBookingStatus({ bookingId, status: newStatus })
            .then(() => {
                this.showToast('Success', `Booking marked as ${newStatus}`, 'success');
                return refreshApex(this.wiredData);
            })
            .catch(error => {
                console.error('Error updating booking status:', error);
                this.showToast('Error', 'Failed to update status', 'error');
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}