import { LightningElement,api } from 'lwc';

export default class Pagination extends LightningElement {
    currentPage = 1;
    totalRecords;
    recordSize = 4;
    totalPage =0;

    get records(){
        return this.visibleRecods;
    }

    @api 
    set records(data){
        if(data){
            this.totalRecords=data;
            this.totalPage = Math.ceil(data.length/this.recordSize);
            this.updateRecords();
        }
    }
    previousHandler() {
        if(this.currentPage > 1 ){
            this.currentPage = this.currentPage-1;
            this.updateRecords();
        }
    }

    get disablePrevious(){
        return this.currentPage<=1;
    }

    get disableNext(){
        return this.currentPage>=this.totalPage;
    }
    nexrtHandler() {
        if(this.currentPage < this.totalPage ){
            this.currentPage = this.currentPage+1;
            this.updateRecords();
        }
    }

    updateRecords(){
        const start = (this.currentPage-1)*this.recordSize;
        const end = this.recordSize*this.currentPage;
        this.visibleRecods =  this.totalRecords.slice(start, end);
        this.dispatchEvent(new CustomEvent('update', {
            detail:{
                records : this.visibleRecods
            }
        }))
    }
}