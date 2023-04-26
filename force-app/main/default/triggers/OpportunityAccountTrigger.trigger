trigger OpportunityAccountTrigger on Opportunity (before insert) {
    Set<Id> accId = new Set<Id>();
    for(Opportunity opp: Trigger.new){
        accId.add(opp.AccountId);
    }
    List<Opportunity> oppList = [SELECT Id, Name, AccountId, StageName, IsClosed from Opportunity where AccountId IN :accId];
    for (Opportunity opp : Trigger.New) {
        for(Opportunity o:oppList){
            // ||(opp.AccountId == o.AccountId && o.StageName != 'Closed Lost')
            // if((opp.AccountId == o.AccountId && o.StageName != 'Closed Won') ){
            if((opp.AccountId == o.AccountId && o.IsClosed == false) ){
                opp.AccountId.addError('Already assigned trigger');
            }
        }
        
    }

}