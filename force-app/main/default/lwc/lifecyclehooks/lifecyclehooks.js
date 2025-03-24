import { LightningElement } from 'lwc';

export default class Lifecyclehooks extends LightningElement {

    isVisible= true
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
    errorCallback(){
        console.log("call Recieved From errorCallback");
    }
    handleClick(){
        if(this.isVisible== true){
            this.isVisible = false;
        }else{
            this.isVisible= true;
        }

    }
}