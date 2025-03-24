import { LightningElement, track} from 'lwc';
import getInterest from '@salesforce/apex/InterestRateCalculator.getInterestRate';
import GenerateEMI from '@salesforce/apex/generateEMI.calculateEMI';
import ApplyLoan from '@salesforce/apex/generateEMI.createLoanRecord';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {subscribe} from 'lightning/empApi';
import getCibilScore from '@salesforce/apex/CibilScoreController.getCibilScore';
export default class loanApplicationComp1 extends LightningElement {
    show = false;
    loanAmount;
    tenure;
    Title;
    applicantName = '';
    ModalOpen1 = false;
    ModalOpen2 = false;
    ModalOpen3=false;
    interestRate;
    channelName = '/event/Loan_Status_Event__e';
    isButtondisabled=false;//make it true to make it disabled
    applicantPAN;
    PanValidation=true;
    cibilScore;
    riskCategory;
    errorMessage;
    Degree;
    Institue;
    Occupation;
    AnnualIncome;
    handlePermanantDisable=false;
    checkBoxValue;
    permanentStreet;
    permanentCity;
    permanentPostalCode;
    permanentState;
    permanentCountry;
    currentStreet;
    currentCity;
    currentPostalCode;
    currentState;
    currentCountry;
    fileId;
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        if (uploadedFiles.length > 0) {
            this.uploadedFiles = uploadedFiles.map(file => file.documentId);
            this.fileId = this.uploadedFiles[0]; // Storing only the first file's ID for now
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Document uploaded successfully!',
                    variant: 'success'
                })
            );
        }
    }
    HandleLoanAmount(e) {
        this.loanAmount = e.target.value;
    }
    HandleTenure(e) {
        this.tenure = e.target.value;
    }
    // Handle Name Change
    handleNameChange(event) {
        this.applicantName = event.target.value;
    }
    disable1=true;
    handlePANchange(e){
        this.applicantPAN=e.target.value;
        if(this.applicantPAN.length==10){
            this.PanValidation=false;
        }
        if(this.applicantName!=null && this.applicantPAN.length==10){
            this.disable1=false;
        }
    }
    openModal1(){
        this.ModalOpen1=true;
        this.ModalOpen2=false;
        this.ModalOpen3=false;
    }
    previous1(){
        this.ModalOpen1=true;
        this.ModalOpen2=false;
        this.ModalOpen3=false;
    }
    previous2(){
        this.ModalOpen1=false;
        this.ModalOpen2=true;
        this.ModalOpen3=false;
    }
    OpenModal2(){
        this.ModalOpen1=false;
        this.ModalOpen2=true;
        this.ModalOpen3=false;
    }
    OpenModal3(){
        this.ModalOpen1=false;
        this.ModalOpen2=false;
        this.ModalOpen3=true;
    }
    //Address:
    address = {
        street: 'Manish Nagar',
        city: 'Nagpur',
        province: 'MH',
        postalCode: '440015',
        country: 'IN',
    };
    _country = 'IN';
    countryProvinceMap = {
        US: [
            { label: 'California', value: 'CA' },
            { label: 'Texas', value: 'TX' },
            { label: 'Washington', value: 'WA' },
        ],
        CN: [
            { label: 'GuangDong', value: 'GD' },
            { label: 'GuangXi', value: 'GX' },
            { label: 'Sichuan', value: 'SC' },
        ],
        VA: [],
        IN:[
            { label: 'Maharashtra', value: 'MH' },
            { label: 'Andra Pradesh', value: 'AP' },
            { label: 'Goa', value: 'GOA' },
            { label: 'Gujrat', value: 'GA' },
            { label: 'Rajasthan', value: 'RJ' },
            { label: 'Utter Pradesh', value: 'UP' },
            { label: 'Delhi', value: 'DL' },
            { label: 'Kerala', value: 'KL' },
            { label: 'Jammu & Kashmir', value: 'JK' },
        ]
    };
    countryOptions = [
        { label: 'United States', value: 'US' },
        { label: 'China', value: 'CN' },
        { label: 'Vatican', value: 'VA' },
        { label: 'India', value: 'IN' },
    ];
    get getProvinceOptions() {
        return this.countryProvinceMap[this._country];
    }
    get getCountryOptions() {
        return this.countryOptions;
    }
    //cibil score
    handleGenerateScore() {
        getCibilScore()
            .then(result => {
                this.cibilScore = result.cibilScore;
                this.riskCategory = result.riskCategory;
                this.errorMessage = null;
            })
            .catch(error => {
                this.errorMessage = 'Error fetching CIBIL Score';
                console.error('Error:', error);
            });
    }
        //address Handle
    handleCurrentAddress(event) {
        this._country = event.detail.country;
        this.currentStreet = event.detail.street;
        this.currentCity = event.detail.city;
        this.currentPostalCode = event.detail.postalCode;  // Fixed typo
        this.currentState = event.detail.province;         // Fixed typo
        this.currentCountry = event.detail.country;
    }
    handlePermanentAddress(event) {
        this._country = event.detail.country;
        this.permanentStreet = event.detail.street;
        this.permanentCity = event.detail.city;
        this.permanentPostalCode = event.detail.postalCode;
        this.permanentState = event.detail.province;
        this.permanentCountry = event.detail.country;
    }
     //checkbox for same current and permant address
     HandleCheckBox(e) {
        this.checkBoxValue = e.target.checked;
        if (this.checkBoxValue) {
            this.permanentStreet = this.currentStreet;
            this.permanentCity = this.currentCity;
            this.permanentPostalCode = this.currentPostalCode;
            this.permanentState = this.currentState;
            this.permanentCountry = this.currentCountry;
            this.handlePermanantDisable = true;
        } else {
            this.permanentStreet = '';
            this.permanentCity = '';
            this.permanentPostalCode = '';
            this.permanentState = '';
            this.permanentCountry = '';
            this.handlePermanantDisable = false;
        }
    }
//Professional Details Handle
    handleDegree(e){
        this.Degree=e.target.value;
      //  console.log('degree',this.degree);
    }
    handleInstitue(e){
        this.Institue=e.target.value;
       // console.log('Institue',this.Institue);
    }
    handleOccupation(e){
        this.Occupation=e.target.value;
    }
    handleAnnualIncome(e){
        this.AnnualIncome=e.target.value;
    }
    // InterestValue;
    subscription = null;
    loanStatusMessage = '';
    //Platform Event Popup
    connectedCallback() {
        subscribe(this.channelName, -1, (event) => {
            console.log('Received event:', JSON.stringify(event));
            const edata = event.data.payload;
            this.loanStatusMessage = edata.Message__c;
            this.showToast('Loan Status Updated', edata.Message__c, 'info');
        }).then(res => {
            this.subscription = res;
            console.log('Subscribed to:', res.channel);
        });
    }
    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        }));
    }
    Value;
    handleGenrateEMI() {
        getInterest({
                loanAmount: this.loanAmount
            })
            .then(result => {
                this.interestRate = result;
                console.log('Result get Interest ==>' + result);
                // this.InterestValue=this.interestRate + '%';
                //Calculate EMI
                return GenerateEMI({
                        amount: this.loanAmount,
                        tenure: this.tenure,
                        interestRate: this.interestRate
                    })
                    .then(result => {
                        this.Value = result;
                        this.Title = "Genrated EMI is " + result + " Rs/Month";
                        console.log('Result Imaparative ==>' + result);
                    })
                    .catch(error => {
                        console.log('Errorured in imparative==> ' + error.body.message);
                    });
            })
            .catch(error => {
                console.log('Errorured in getting Interest Rate  ==> ' + error.body.message);
            });
        this.show = true;
    }
    loanRefresh;
// Apply Loan
    handleApplyLoan() {
        if (!this.fileId) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please upload a document before applying for the loan.',
                    variant: 'error'
                })
            );
            return;
        }
        const loanData = {
            name: this.applicantName,
            amount: parseFloat(this.loanAmount),
            tenure: parseInt(this.tenure, 10),
            interestRate: parseFloat(this.interestRate),
            EMI: parseFloat(this.Value),
            panNumber: this.applicantPAN,
            degree: this.Degree,
            instituteName: this.Institue,
            occupation: this.Occupation,
            annualIncome: parseFloat(this.AnnualIncome),
            fileId: this.fileId,  // Passing fileId
            currentAddress: {
                street: this.currentStreet,
                city: this.currentCity,
                province: this.currentState,
                postalCode: this.currentPostalCode,
                country: this.currentCountry
            },
            permanentAddress: {
                street: this.permanentStreet,
                city: this.permanentCity,
                province: this.permanentState,
                postalCode: this.permanentPostalCode,
                country: this.permanentCountry
            }
        };
        console.log('Sending loan data:', JSON.stringify(loanData));
        ApplyLoan({ loanDataJson: JSON.stringify(loanData) })
            .then((result) => {
                this.loanRefresh = result;
                console.log('Result==>', result);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success!',
                        message: 'Your Loan Application is submitted successfully.',
                        variant: 'success'
                    })
                );
                window.location.reload();
            })
            .catch(error => {
                console.error('Error while applying for loan:', error);
            });
    }
    // Open Modal
    openModal() {
        this.isModalOpen1 = true;
        this.isModalOpen2 = true;
        this.isModalOpen3 = true;
    }
    // Close Modal
    closeModal() {
        this.ModalOpen1 = false;
        this.ModalOpen2 = false;
        this.ModalOpen3 = false;
    }
}