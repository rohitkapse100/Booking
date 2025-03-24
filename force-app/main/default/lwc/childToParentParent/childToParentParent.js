import { LightningElement } from 'lwc';

export default class ChildToParentParent extends LightningElement {
    InputValue;
    hadnleInputValue(event){
        this.InputValue = event.detail;
    }
}