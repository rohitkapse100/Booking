import { LightningElement, track } from 'lwc';
import searchAccounts from '@salesforce/apex/AccountSearchController.searchAccounts';

export default class AccountSearchComponent extends LightningElement {
    @track wrapper = {
        accountName: '',
        accountEmail: '',
        searchResults: []
    };

    handleNameChange(event) {
        this.wrapper.accountName = event.target.value;
    }

    handleEmailChange(event) {
        this.wrapper.accountEmail = event.target.value;
    }

    searchAccounts() {
        searchAccounts({ wrapper: this.wrapper })
            .then(result => {
                this.wrapper = result;
            })
            .catch(error => {
                // Handle error
            });
    }
}