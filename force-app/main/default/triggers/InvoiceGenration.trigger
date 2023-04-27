trigger InvoiceGenration on Opportunity (after insert,after update) {
    List<Opportunity> opps=[Select Id,Name from Opportunity where StageName='Closed Won'];
    for(Object opp:opps){
        Custom_Invoice__c Inv=new Custom_Invoice__c();
    }  
}