import { LightningElement, api, track } from 'lwc';
import getProductDetails from '@salesforce/apex/ProductApprovalController.getProductDetails';
import approveOrRejectProduct from '@salesforce/apex/ProductApprovalController.approveOrRejectProduct';

export default class ProductApprovalComponent extends LightningElement {
    @api recordId; // This is the product ID passed from the parent component or page
    @track product;
    @track comment = '';
    @track error;
    @track isLoading = false;

    connectedCallback() {
        this.fetchProductDetails();
    }

    // Fetch product details
    fetchProductDetails() {
        this.isLoading = true;
        getProductDetails({ productId: this.recordId })
            .then((result) => {
                this.product = result;
                this.error = undefined; // Clear previous errors if successful
            })
            .catch((error) => {
                this.error = error.body.message;
                this.product = undefined; // Ensure product is undefined on error
                console.error('Error fetching product details', error);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    // Handle comment change
    handleCommentChange(event) {
        this.comment = event.target.value;
    }

    // Approve the product
    handleApprove() {
        this.updateProductStatus('Approve');
    }

    // Reject the product
    handleReject() {
        this.updateProductStatus('Reject');
    }

    // Update product status (Approve/Reject)
    updateProductStatus(action) {
        this.isLoading = true;
        approveOrRejectProduct({
            productId: this.recordId,
            action: action,
            comment: this.comment
        })
            .then((result) => {
                console.log(result);
                this.fetchProductDetails(); // Refresh product details
            })
            .catch((error) => {
                console.error('Error updating product status', error);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    // Get error message for display
    get hasError() {
        return this.error && this.error.length > 0;
    }
}