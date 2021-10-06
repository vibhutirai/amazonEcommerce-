import { LightningElement,track,wire } from 'lwc';
import CartData from '@salesforce/apex/contoller.getOpportunityForCart';
import checkoutData from '@salesforce/apex/contoller.getOpportunityForCheckout';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CartSummary extends LightningElement {

    @wire (CartData) oppCart;
   

         handleCheckout(){
            checkoutData()                
            .then(result=>{
                const evt = new ShowToastEvent({
                    title: 'Successfully!!!',
                    message: 'Products Executed Sucessfully',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            }) 
             .catch(error =>{
                console.log('Error: ', error);
            })
            
        }

}