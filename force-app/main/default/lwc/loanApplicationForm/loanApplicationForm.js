import { LightningElement, track, wire } from 'lwc';
import getInterestRate from '@salesforce/apex/LoanProcessor.getInterestRate';
import createLoanApplication from '@salesforce/apex/LoanProcessor.createLoanApplication';
import getCityStateByPin from '@salesforce/apex/LoanProcessor.getCityStateByPin';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class loanApplicationForm extends LightningElement {
    @track loanName = '';
    @track loanAmount = '';
    @track interestRate = '';
    @track tenure = '';
    @track panNo = '';
    @track fullName = '';
    @track Address = '';
    @track city = '';
    @track state = '';
    @track sscDetails = '';
    @track hscDetails = '';
    @track uploadedFiles = [];
    @track isApplicationDisabled = true;
    @track isPersonalDetailsOpen = false;
    @track isEducationDetailsOpen = false;
    @track isAttachDocumentsOpen = false;
    @track isCibilPopupOpen = false;
    @track cibilScore = '';
    @track cibilMessage = '';
    wiredData;

    handleNameChange(event) { this.loanName = event.target.value; }
    handleAmountChange(event) {
        this.loanAmount = event.target.value;
        getInterestRate({ loanAmount: this.loanAmount })
            .then(result => { this.interestRate = result; })
            .catch(error => { console.error(error); });
    }
    handleTenureChange(event) { this.tenure = event.target.value; }
    handleFullName(event) { this.fullName = event.target.value; }
    handlePan(event) { this.panNo = event.target.value; }
    handleAddress(event) {
        this.Address = event.target.value;
        this.fetchAddress(this.Address);
    }
    handleCity(event) { this.city = event.target.value; }
    handleState(event) { this.state = event.target.value; }
    handle10th(event) { this.sscDetails = event.target.value; }
    handle12th(event) { this.hscDetails = event.target.value; }
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        if (uploadedFiles.length > 0) {
            this.uploadedFiles = uploadedFiles.map(file => file.documentId);
            this.showToast('Success', 'Document uploaded successfully!', 'success');
        }
    }
    openPersonalDetails() { this.isPersonalDetailsOpen = true; }
    closePersonalDetails() { this.isPersonalDetailsOpen = false; }
    savePersonalDetails() { this.isPersonalDetailsOpen = false; this.checkFormCompletion(); }
    openEducationDetails() { this.isEducationDetailsOpen = true; }
    closeEducationDetails() { this.isEducationDetailsOpen = false; }
    saveEducationDetails() { this.isEducationDetailsOpen = false; this.checkFormCompletion(); }
    openAttachDocuments() { this.isAttachDocumentsOpen = true; }
    closeAttachDocuments() { this.isAttachDocumentsOpen = false; }
    saveAttachDocuments() { this.isAttachDocumentsOpen = false; }
    verifyPan() {
        this.cibilScore = Math.floor(Math.random() * 200) + 650;
        this.cibilMessage = this.cibilScore >= 750 ? 'Eligible for Loan' : 'Low Score, High Interest Rate';
        this.isCibilPopupOpen = true;
    }
    closeCibilPopup() { this.isCibilPopupOpen = false; }
    checkFormCompletion() {
        if (this.fullName && this.panNo && this.sscDetails && this.hscDetails) {
            this.isApplicationDisabled = false;
        }
    }
    // Submission of Loan Application
    handleSubmit() {
        createLoanApplication({ loanAmount: this.loanAmount, tenure: this.tenure , loanName: this.loanName, fileIds: this.uploadedFiles })
        .then(result => {
            this.showToast('Success', 'Loan Application Submitted Successfully', 'success');
            return refreshApex(this.wiredData);
        })
        .then(() => {
            this.resetForm();
        })
        .catch(error => {
            this.showToast('Error', 'Failed to submit loan application', 'error');
        });
    }
    fetchAddress(pinCode) {
        if (!pinCode) {
            this.showToast('Error', 'Pincode cannot be empty', 'error');
            return;
        }
        getCityStateByPin({ pinCode })
            .then(result => {
                if (result) {
                    this.city = result.Name;
                    this.state = result.State__c;
                }
            })
            .catch(error => {
                console.error(error);
                this.showToast('Error', error.body.message || 'Invalid Pincode', 'error');
            });
    }
    resetForm() {
        this.loanName = '';
        this.loanAmount = '';
        this.interestRate = '';
        this.tenure = '';
        this.panNo = '';
        this.fullName = '';
        this.Address = '';
        this.city = '';
        this.state = '';
        this.sscDetails = '';
        this.hscDetails = '';
        this.uploadedFiles = [];
        this.isApplicationDisabled = true;
        this.isPersonalDetailsOpen = false;
        this.isEducationDetailsOpen = false;
        this.isAttachDocumentsOpen = false;
        this.isCibilPopupOpen = false;
    }
    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}