@isTest
public class InvoiceGenrationEmailTest {

    @isTest
    static void testInvoiceGeneration(){
        Contact con  = new Contact(FirstName = 'Pragam', LastName = 'Kaistha', Email = 'kaisthapragam@gmail.com');
        insert con;
        Account acc = new Account(Name = 'Test Account Invoice', Primary_Contact__c = con.Id, AccountNumber = '987');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Test Opp Invoice', AccountId= acc.Id, StageName = 'Closed Won', CloseDate = Date.today());
        insert opp;
        String priceBookName = 'Pk-pricebook';
        PriceBook2 priceBk = new PriceBook2(
            Name = priceBookName, 
            IsActive = true);
        insert priceBk;

        List<PricebookEntry> priceBkEntry = new List<PricebookEntry>();
        Id standardPribookId;
        // if(Test.isRunningTest()) {
            standardPribookId = Test.getStandardPricebookId();
        // } else {
            // Pricebook2 standardPribook = [SELECT Id, Name 
            //                                 FROM Pricebook2 
            //                                 WHERE IsStandard = true 
            //                                 LIMIT 1];
            // standardPribookId = standardPribook.Id;
        // }
            Product2 prod1 = new Product2(
                ProductCode = '123', 
                Name = 'Test prod 1', 
                Description = 'prodDescription 1');
            insert prod1;

            Product2 prod2 = new Product2(
                ProductCode = '1234', 
                Name = 'Test prod 2', 
                Description = 'prodDescription 2');
            insert prod2;

            PricebookEntry priceBE1 = new PricebookEntry(
                Pricebook2Id = standardPribookId, 
                Product2Id = prod1.Id, 
                UnitPrice = 2000, 
                IsActive = true);
            insert priceBE1;

            PricebookEntry priceBE2 = new PricebookEntry(
                Pricebook2Id = standardPribookId, 
                Product2Id = prod2.Id, 
                UnitPrice = 2000, 
                IsActive = true);
            insert priceBE2;

            PricebookEntry pbe1 = new PricebookEntry(
                Pricebook2Id = priceBk.Id, 
                Product2Id = prod1.Id, 
                UnitPrice = 30000, 
                IsActive = true);
            insert pbe1;
            
            PricebookEntry pbe2 = new PricebookEntry(
                Pricebook2Id = priceBk.Id, 
                Product2Id = prod2.Id, 
                UnitPrice = 30000, 
                IsActive = true);
            insert pbe2;
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe1.Id, Product2Id = prod1.Id, Quantity = 2, UnitPrice = 2000);
        insert oli1;
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe2.Id, Product2Id = prod2.Id, Quantity = 5, UnitPrice = 30000);
        insert oli2;
        Custom_Invoice__c custInvoice = new Custom_Invoice__c(Account_Name__c= acc.Id, Invoice_Date__c = Date.today()+3, Opportunity__c = opp.Id, Payment_Due_date__c = Date.today()+10, Status_Of_Payment__c = 'Not Paid');
        insert custInvoice;
        Test.startTest();
        // Call the sendInvoiceEmail method with the test custom invoice
        InvoiceGenartionHandler.sendInvoiceEmail(new List<Custom_Invoice__c>{custInvoice});
        Test.stopTest();
        System.assertEquals(1, Limits.getEmailInvocations());
        // List<Messaging.SingleEmailMessage> sentEmails = [SELECT Id, ToAddress, Subject, HtmlBody FROM Messaging.SingleEmailMessage];
        // System.assertEquals(1, sentEmails.size(), 'One email should have been sent');
        // Messaging.SingleEmailMessage sentEmail = sentEmails[0];
        // System.assertEquals(con.Email, sentEmail.getToAddresses()[0], 'The email should have been sent to the contact email address');
        // System.assertEquals('Invoice Generated ', sentEmail.getSubject(), 'The email subject should be "Invoice Generated"');
        // System.assert(sentEmail.getHtmlBody().contains(testProduct.Name), 'The email body should contain the product name');
    }
}