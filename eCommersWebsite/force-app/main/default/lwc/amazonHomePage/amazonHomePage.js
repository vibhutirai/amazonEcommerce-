import {  api, LightningElement, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getProduct from '@salesforce/apex/contoller.getProduct';
import Amazon_Logo from '@salesforce/resourceUrl/amazonLogo';
import serachProds from '@salesforce/apex/contoller.retriveProducts';
import sortHightoLowPrice from '@salesforce/apex/contoller.sortHightoLowPrice';
import sortLowToHighPrice from '@salesforce/apex/contoller.sortLowToHighPrice';
import checkOpportunityForAddToCart from '@salesforce/apex/contoller.checkOpportunityForAddToCart';

export default class AmazonHomePage extends LightningElement {
    @wire (getProduct) product;
    @wire (sortHightoLowPrice) hightolow;
    @wire (sortLowToHighPrice) lowtohigh;
    @api searchData;
    @api strSearchProdName;
    logo = Amazon_Logo ;
    @api visibleData;
     clickOrderHistory = 'Go To OrderHistory';  
     clickGoToCart = 'Go To CartSummary';
     clickCart = 'Go To Cart';
    @api OrderVisible = false;
    @api cartVisible = false;

    handleSearch(event) {
        this.strSearchProdName = event.detail.value;
        if(this.strSearchProdName != "" && this.strSearchProdName != null && this.strSearchProdName != undefined){
        serachProds({strProdName : this.strSearchProdName})
        .then(result => {
            this.searchData = result;
    }) 
    }
    else{
        this.searchData = null;
    }
}


    handleOrderHistoryClick(event) {  
        const lab = event.target.label;  
        if ( lab === 'Go To OrderHistory') {  
            this.clickOrderHistory = 'Back To HomePage';  
            this.OrderVisible = true;  
        } else if  ( lab === 'Back To HomePage') {  
            this.clickOrderHistory = 'Go To OrderHistory';  
            this.OrderVisible = false;  
  
        } 
    } 

    handleCartClick(event){
        const val = event.target.label;
        if(val === 'Go To Cart'){
            this.cartVisible = true;
            this.clickCart = 'Go To Cart';
            this.clickGoToCart = 'Back To HomePage';
        }
         else if ( val === 'Go To CartSummary' ) {
            this.clickGoToCart = 'Back To HomePage';
            this.cartVisible = true;

        } else if(val === 'Back To HomePage'){
            this.clickGoToCart = 'Go To CartSummary';
            this.cartVisible = false;
        }
     }


    updateHandler(event){
    this.visibleData = [...event.detail.records];
    console.log(event.detail.records);
    }
   
    handlesorting(event){
        if(event.target.value !="" && event.target.value !=null && event.target.value !=undefined)
        {
            if(event.target.value == 'High'){
            this.visibleData = this.hightolow.data; 
            }
            else if(event.target.value == 'Low'){
            this.visibleData = this.lowtohigh.data;
            }
        }
        else{
            this.visibleData =  [...event.detail.records];
            }
        }
           

        handleAddToCart(event){
             const productId= event.currentTarget.dataset.index;
            console.log('Product List :'+productId);
            checkOpportunityForAddToCart({proId : productId})
            .then(getresult => {
                    const evt = new ShowToastEvent({
                        title: 'Successfully!!!',
                        message: 'Product Added Sucessfully',
                        variant: 'success',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                   
        })
        .catch(error => {
        console.log('Error: ', error);
        }) 
    }

    
    
}