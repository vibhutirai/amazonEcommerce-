import { LightningElement, wire, api } from 'lwc';
import getUser from '@salesforce/apex/contoller.getUser';
import getlistOfUsers from '@salesforce/apex/contoller.getlistOfUsers';
import Profile_Pic from '@salesforce/resourceUrl/MyImage';


export default class ProfilePage extends LightningElement {
    isModalOpen = false;
    @wire (getUser) users;
    @wire (getlistOfUsers) userlist;
    pic = Profile_Pic;
    

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    
}