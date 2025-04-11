import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class AdminHome extends NavigationMixin(LightningElement) {
    navigateToBookings() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: { url: '/bookings' }
        });
    }

    navigateToMovers() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: { url: '/movers' }
        });
    }

    navigateToReports() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: { url: '/reports' }
        });
    }
}