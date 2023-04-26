@isTest
public with sharing class OpportunityAccountTriggerTest {
    
    @isTest
    static void testInsert(){
        // Create test account
        Test.startTest();
        Account testAccount = new Account(Name = 'Test Account 1');
        insert testAccount;
        
        // Create test opportunity associated with the test account
        Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', AccountId = testAccount.Id, CloseDate = Date.today()+1, StageName = 'Prospecting');
        insert testOpportunity;
        Opportunity testOpportunity1 = new Opportunity(Name = 'Test Opportunity 2', AccountId = testAccount.Id, CloseDate = Date.today()+8, StageName = 'Prospecting');
        try{
        insert testOpportunity1;}
        catch(DmlException e){
            System.debug(e);
        }
        Test.stopTest();
        List<Opportunity> opList = [Select Name, AccountId,CloseDate,StageName from Opportunity];
        System.assertEquals(1, opList.size());

    }

    @isTest
    static void testCloseInsert(){
        // Create test account
        Test.startTest();
        Account testAccount = new Account(Name = 'Test Account 1');
        insert testAccount;
        
        // Create test opportunity associated with the test account
        Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', AccountId = testAccount.Id, CloseDate = Date.today()+1, StageName = 'Closed Won');
        insert testOpportunity;
        Opportunity testOpportunity1 = new Opportunity(Name = 'Test Opportunity 2', AccountId = testAccount.Id, CloseDate = Date.today()+8, StageName = 'Prospecting');
        try{
        insert testOpportunity1;}
        catch(DmlException e){
            System.debug(e);
        }
        Test.stopTest();
        List<Opportunity> opList = [Select Name, AccountId,CloseDate,StageName from Opportunity];
        System.assertEquals(2, opList.size());

    }
}