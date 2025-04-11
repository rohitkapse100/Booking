import { LightningElement, track } from 'lwc';
import getPendingBookings from '@salesforce/apex/MoverControllers.getPendingBookings';
import updateBookingStatus from '@salesforce/apex/MoverControllers.updateBookingStatus';
import getLoggedInUserId from '@salesforce/apex/MoverControllers.getLoggedInUserId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

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
    userEmail;

    connectedCallback() {
        this.loadBookings();
    }

    async loadBookings() {
        try {
            this.userEmail = await getLoggedInUserId();
            const result = await getPendingBookings({ userEmail: this.userEmail });

            this.bookings = result.map(booking => this.formatBooking(booking));
        } catch (error) {
            this.showToast('Error', 'Failed to load booking requests', 'error');
        }
    }

    formatBooking(booking) {
        return {
            ...booking,
            disableApprove: booking.Status__c === 'Confirmed' || booking.Status__c === 'Approved',
            disablePending: booking.Status__c === 'In Progress' || booking.Status__c === 'Pending',
            disableReject: booking.Status__c === 'Rejected'
        };
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const bookingId = event.detail.row.Id;
        let newStatus = '';

        if (actionName === 'approve') {
            newStatus = 'Approved';
        } else if (actionName === 'pending') {
            newStatus = 'Pending';
        } else if (actionName === 'reject') {
            newStatus = 'Rejected';
        }

        updateBookingStatus({ bookingId, status: newStatus })
            .then(() => {
                // ✅ Update local row without full refresh
                this.bookings = this.bookings.map(booking => {
                    if (booking.Id === bookingId) {
                        const updated = { ...booking, Status__c: newStatus };
                        return this.formatBooking(updated); // Update disable flags
                    }
                    return booking;
                });

                this.showToast('Success', `Booking marked as ${newStatus}`, 'success');
            })
            .catch(error => {
                console.error(error);
                this.showToast('Error', 'Failed to update status', 'error');
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}