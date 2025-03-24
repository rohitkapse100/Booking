import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchBankDetails from '@salesforce/apex/bankDetailController.fetchbankdetail';
import saveRecord from '@salesforce/apex/bankDetailController.CreateBankDetail';
export default class displayBankDetails extends LightningElement {
    IFSClength = 11;
    isButtondisabled = true;
    IFSC = '';
    bankDetails;
    handleinput(event) {
        this.IFSC = event.target.value;
        this.isButtondisabled = this.IFSC.length !== this.IFSClength;
    }
    handleClick() {
        fetchBankDetails({ IFSCCode: this.IFSC })
            .then(data => {
                this.bankDetails = data;
                console.log('Bank Details Fetched:', JSON.stringify(data));
            })
            .catch(error => {
                console.error('Error fetching bank details:', error);
            });
    }
    saveClick() {
        if (!this.bankDetails) {
            this.showToast('Error', 'No bank details available to save.', 'error');
            return;
        }
        saveRecord({
            ifsc: this.IFSC,
            BankName: this.bankDetails.BANK,
            branch: this.bankDetails.BRANCH,
            Address: this.bankDetails.ADDRESS,
            city: this.bankDetails.CITY,
            state: this.bankDetails.STATE
        })
            .then(result => {
                console.log('Record created successfully:', result);
                this.showToast('Success', 'Bank details saved successfully.', 'success');
            })
            .catch(error => {
                console.error('Error occurred while saving record:', error);
                this.showToast('Error', 'Error occurred while saving record.', 'error');
            });
    }
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}