import { LightningElement, track } from 'lwc';
import registerMover from '@salesforce/apex/MoverRegistrationController.registerMover';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MoverRegistration extends LightningElement {
    @track moverName = '';
    @track email = '';
    @track phone = '';
    @track location = '';
    @track availability = '';

    // Picklist options for Availability
    availabilityOptions = [
        { label: 'Available', value: 'Available' },
        { label: 'Busy', value: 'Busy' },
        { label: 'Not Available', value: 'Not Available' }
    ];

    handleInputChange(event) {
        const field = event.target.dataset.field;
        this[field] = event.target.value;
    }

    handleRegister() {
        const inputs = this.template.querySelectorAll('lightning-input, lightning-combobox');
        let isValid = true;

        inputs.forEach(input => {
            if (!input.checkValidity()) {
                input.reportValidity();
                isValid = false;
            }
        });

        if (!isValid) {
            this.showToast('Error', 'Please fill in all required fields.', 'error');
            return;
        }

        registerMover({ 
            moverName: this.moverName, 
            email: this.email, 
            phone: this.phone, 
            location: this.location, 
            availability: this.availability
        })
        .then(() => {
            this.showToast('Success', 'Mover registered successfully!', 'success');
            this.resetForm();
        })
        .catch(error => {
            console.error('Error:', JSON.stringify(error)); // Log full error
            let message = 'Something went wrong.';

            if (error && error.body && error.body.message) {
                message = error.body.message;
            } else if (error && error.message) {
                message = error.message;
            }

            this.showToast('Error', message, 'error');
        });
    }

    resetForm() {
        this.moverName = '';
        this.email = '';
        this.phone = '';
        this.location = '';
        this.availability = '';
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}