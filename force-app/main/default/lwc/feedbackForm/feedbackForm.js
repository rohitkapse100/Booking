import { LightningElement, api, track, wire } from 'lwc';
import submitReview from '@salesforce/apex/ReviewController.submitReview';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class ReviewForm extends LightningElement {
    @api bookingId; // Passed from parent
    @track rating = 0;
    @track comments = '';
    wiredReviews;

    ratingOptions = [
        { value: 1, starClass: 'star' },
        { value: 2, starClass: 'star' },
        { value: 3, starClass: 'star' },
        { value: 4, starClass: 'star' },
        { value: 5, starClass: 'star' }
    ];

    handleStarClick(event) {
        this.rating = parseInt(event.currentTarget.dataset.value, 10);
        this.updateStarStyles();
    }

    updateStarStyles() {
        this.ratingOptions = this.ratingOptions.map(star => ({
            ...star,
            starClass: star.value <= this.rating ? 'selected' : 'star'
        }));
    }

    handleCommentChange(event) {
        this.comments = event.target.value;
    }

    handleSubmit() {
        if (!this.rating) {
            this.showToast('Error', 'Please select a rating.', 'error');
            return;
        }

        submitReview({ 
            bookingId: this.bookingId, 
            rating: this.rating, 
            comments: this.comments 
        })
        .then(result => {
            this.showToast('Success', result, 'success');
            this.rating = 0;
            this.comments = '';
            this.updateStarStyles();

            // Notify parent that review is submitted
            this.dispatchEvent(new CustomEvent('reviewsubmitted', {
                detail: { bookingId: this.bookingId }
            }));

            // Refresh data
            return refreshApex(this.wiredReviews);
        })
        .catch(error => {
            console.error('Error submitting review:', error);
            this.showToast('Error', 'Failed to submit review.', 'error');
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}