import { LightningElement } from 'lwc';

export default class LifeCycleChildComponent extends LightningElement {
    constructor(){

        super();

        console.log("call From child Constructor");
    }
    connectedCallback(){

        console.log("call Recieved From child connectedCallback");
    }
    renderedCallback(){

        console.log("call Recieved From child renderedCallback");
    }
    disconnectedCallback(){

        console.log("call Recieved From child disconnectedCallback");
    }
    }