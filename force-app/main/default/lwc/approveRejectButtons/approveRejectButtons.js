import { LightningElement, api } from 'lwc';
import approveRecord from '@salesforce/apex/ApprovalProcessController.approveRecord';
import rejectRecord from '@salesforce/apex/ApprovalProcessController.rejectRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ApproveRejectButtons extends LightningElement {
    @api recordId; // Record Id passed from the record page

    // Handle Approve Button Click
    handleApprove() {
        approveRecord({ recordId: this.recordId })
            .then((result) => {
                this.showToast('Success', result, 'success');
                this.refreshView(); // Refresh the page to show updated record status
            })
            .catch((error) => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    // Handle Reject Button Click
    handleReject() {
        rejectRecord({ recordId: this.recordId })
            .then((result) => {
                this.showToast('Success', result, 'success');
                this.refreshView(); // Refresh the page to show updated record status
            })
            .catch((error) => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    // Show Toast Notification
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    // Refresh the page view
    refreshView() {
        eval("$A.get('e.force:refreshView').fire();");
    }
}