import { LightningElement, wire, track } from 'lwc';
import getPendingMovers from '@salesforce/apex/AdminControllersMover.getPendingMovers';
import updateMoverStatus from '@salesforce/apex/AdminControllersMover.updateMoverStatus';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MoverApprovalDashboard extends LightningElement {
    @track movers;
    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Email', fieldName: 'Email__c' },
        { label: 'Phone', fieldName: 'Phone__c' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Approve', type: 'button', typeAttributes: { label: 'Approve', name: 'approve', variant: 'success' } },
        { label: 'Reject', type: 'button', typeAttributes: { label: 'Reject', name: 'reject', variant: 'destructive' } }
    ];

    @wire(getPendingMovers)
    wiredMovers({ error, data }) {
        if (data) {
            this.movers = data;
        } else if (error) {
            console.error(error);
        }
    }

    async handleRowAction(event) {
        const moverId = event.detail.row.Id;
        const status = event.detail.action.name === 'approve' ? 'Approved' : 'Rejected';

        try {
            await updateMoverStatus({ moverId, status });
            this.showToast('Success', `Mover marked as ${status}`, 'success');
            this.refreshMovers(moverId, status);
        } catch (error) {
            this.showToast('Error', 'Failed to update status', 'error');
        }
    }

    refreshMovers(moverId, status) {
        this.movers = this.movers.map(mover => 
            mover.Id === moverId ? { ...mover, Status__c: status } : mover
        );
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
