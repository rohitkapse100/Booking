import { LightningElement, wire, track } from 'lwc';
import getApprovedMovers from '@salesforce/apex/MoverController.getApprovedMovers';

export default class MoverList extends LightningElement {
    @track movers;

    @wire(getApprovedMovers)
    wiredMovers({ error, data }) {
        if (data) {
            this.movers = data;
        } else if (error) {
            console.error('Error fetching movers:', error);
        }
    }
}