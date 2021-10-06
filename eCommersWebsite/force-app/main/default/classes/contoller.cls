public with sharing class contoller {

   
   @AuraEnabled(Cacheable = true)
    public static list<Product2> getProduct() {
        try {
            return [SELECT Id, Name,Price__c, ProductCode, Display_Image__c,  Description FROM Product2 WHERE Family='SmartPhone'];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(Cacheable = true)
    public static list<User> getlistOfUsers() {
        try {
            return [SELECT Username, ProfileId, Title, Name, IsActive, CompanyName, Address, Alias FROM User WHERE Name='Vibhuti rai'];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(Cacheable = true)
    public static String getUser() {
        try {
            String name;
             for(User u: [SELECT ProfileId,Name, IsActive, CompanyName FROM User WHERE Name='Vibhuti rai']){
	        name = u.Name;
            }
            return name;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    
    @AuraEnabled(Cacheable = true)
    public static List<Product2> retriveProducts(String strProdName) {
        try{
        strProdName = '%' + strProdName + '%';
        System.debug('strProdName value is : ' +strProdName);
        List<Product2> lstProd = [SELECT Id, Name, ProductCode, Display_Image__c, Price__c,  Description FROM Product2 WHERE Name LIKE :strProdName AND Family='SmartPhone'];
        System.debug('return  value is : ' +lstProd);
        return lstProd;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(Cacheable = true)
    public static List<Product2> sortHightoLowPrice() {
        try{
        List<Product2> ascProd = [SELECT Id, Name, ProductCode, Display_Image__c, Price__c, Description FROM Product2 WHERE Family='SmartPhone' ORDER BY Price__c ASC];
        return ascProd;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(Cacheable = true)
    public static List<Product2> sortLowToHighPrice() {
        try {
        List<Product2> descPro = [SELECT Id, Name, ProductCode, Display_Image__c, Price__c, Description FROM Product2 WHERE Family='SmartPhone' ORDER BY Price__c DESC];
        return descPro;
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void checkOpportunityForAddToCart(Id proId){
        try{
            System.debug('Product Id : ' +proId);
            Id oppObjId ;
            OpportunityLineItem objLineItem = new OpportunityLineItem();
            List<Opportunity> op = [SELECT Id, Name, StageName FROM Opportunity ];
            System.debug('List of Opp : '+op);
            for(Opportunity oppObj : op){
                if(oppObj.StageName != 'Closed Won'){
                    oppObjId = oppObj.Id; 
            }
           }
           if(op == NULL){
            Opportunity objOpporunity = new Opportunity();
            objOpporunity.Name = 'Products Opporutnity';
            objOpporunity.StageName = 'Closed Won';
            objOpporunity.CloseDate = system.Today();
            System.debug('List of Opportunty : '+objOpporunity);
            Insert objOpporunity;
            oppObjId = objOpporunity.Id;
           }
            PricebookEntry PBobj= [SELECT Id, UnitPrice from PricebookEntry WHERE PriceBook2.isStandard=true AND Product2Id=:proId];
            objLineItem.PriceBookEntryId = PBobj.Id;
            objLineItem.Product2Id = proId;
            objLineItem.Quantity = 1;
            objLineItem.UnitPrice = PBobj.UnitPrice;
            objLineItem.OpportunityId = oppObjId;
            System.debug('List of OpportunityLineItem : '+objLineItem);
            Insert objLineItem;
        }catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
                throw new AuraHandledException(e.getMessage());
            }
        
    }

    @AuraEnabled(Cacheable = true)
    public static List<Opportunity> getOpportunityForCart() {
        try { 
        System.debug('Enter Cart Opportunity');
        List<Opportunity> getopp = [SELECT Id, Name,Amount,CloseDate, (SELECT Id, Name,PricebookEntryId ,Quantity, PricebookEntry.Product2Id,
         TotalPrice, UnitPrice, ListPrice from OpportunityLineItems) from Opportunity WHERE StageName !='Closed won' ORDER BY CloseDate 
         DESC LIMIT 1];
        sumAmount(getopp);
        System.debug('List of  Cart Opportunity :' +getopp);
        return getopp;
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled(Cacheable = true)
    public static void getOpportunityForCheckout() {
        try {
        Order neworder = new Order();
        OrderItem orderItemObj = new OrderItem();
        List<Opportunity> getop = [SELECT OwnerId, TotalOpportunityQuantity, StageName, Id, AccountId ,Name,Amount,CloseDate from Opportunity WHERE StageName !='Closed won'];
        for(Opportunity oppObj : getop){
            neworder.OpportunityId = oppObj.Id;
            neworder.Status='Delivered';
            neworder.EndDate = oppObj.CloseDate;
          //  neworder.Pricebook2Id = 
            neworder.OwnerId = oppObj.OwnerId;
            System.debug('New Orders : ' +neworder);
        }
            insert neworder;
            orderItemObj.OrderId=neworder.Id;
            System.debug('New OrdersLineItems : ' +orderItemObj);
            insert orderItemObj;
        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    
    @AuraEnabled(Cacheable = true)
    public static List<Order> getOpportunityForOrderHistory() {
        try {
            return [SELECT Id, Status,EndDate,EffectiveDate, TotalAmount, BillingAddress, BillingPostalCode, OrderNumber FROM Order];
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Double sumAmount(List<Opportunity> oppAmount){
        try {
            Double sum = 0;
            for(Opportunity opAmount : oppAmount){
            sum = sum + opAmount.Amount;
            }
            return sum;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}



