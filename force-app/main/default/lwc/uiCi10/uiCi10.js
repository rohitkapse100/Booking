import { LightningElement,track } from 'lwc';

export default class UiCi10 extends LightningElement {
    @track valueOne;
@track valueTwo;
@track result;
    handleOnchangeNumberOne(event){
        console.log('data--'+event);
        console.log('data--'+event.target.value);
        console.log('data--'+event.target.type);
        console.log('data--'+event.target.label);
        this.valueOne= event.target.value;
        console.log('data--'+this.valueOne);
    }
    handleOnChangeNumberTwo(event){
        console.log('data--'+event);
        console.log('data--'+event.target.value);
        console.log('data--'+event.target.type);
        console.log('data--'+event.target.label);
        this.valueTwo= event.target.value;
    }
    handleAdd(){
        console.log('in Add');
        console.log('data--'+this.valueOne);
        console.log('data--'+this.valueTwo);
        this.result = parseInt(this.valueOne)+parseInt(this.valueTwo);
    }
    handlesub(){
        this.result = parseInt(this.valueOne)-parseInt(this.valueTwo);
    }
    }