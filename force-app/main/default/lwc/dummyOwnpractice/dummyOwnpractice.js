import {
    LightningElement
} from 'lwc';

export default class DummyOwnpractice extends LightningElement {

    number;
    HandleNumber(e) {

        this.number = e.target.value;
    }


    text;
    HandleText(e) {
        this.text = e.target.value;
    }
}