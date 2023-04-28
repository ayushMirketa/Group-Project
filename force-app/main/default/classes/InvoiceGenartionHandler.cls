public class InvoiceGenartionHandler {
    public static void sendInvoiceEmail(List<Custom_Invoice__c> newRecordList){
        Set<Id> OpportunityIdsSet = new Set<Id>();
        Set<Id> AccountIdsSet = new Set<Id>();
        for (Custom_Invoice__c customInvoice : newRecordList) {
            OpportunityIdsSet.add(customInvoice.Opportunity__c);
            AccountIdsSet.add(customInvoice.Account_Name__c);
        }
        List<Account> accountList = [SELECT Id, Primary_Contact__c FROM Account WHERE Id IN :AccountIdsSet AND Primary_Contact__c != null];
        Map<Id, Account> contactMap = new Map<Id, Account>([SELECT Id, Primary_Contact__r.Email FROM Account WHERE Id IN :AccountIdsSet]);
        List<OpportunityLineItem> OpportunityList = [SELECT Name,Product2.Name, Quantity, UnitPrice, TotalPrice FROM OpportunityLineItem WHERE opportunityId IN :OpportunityIdsSet];
        // Map<Id,Contact> contactMap=new Map<Id,Contact>([Select Id,Email from Contact where Id IN: ContactIdsSet]);
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for(Custom_Invoice__c customInvoice: newRecordList){
            Account con = contactMap.get(customInvoice.Account_Name__c);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Invoice Generated ');
            List<String> toAddress = new List<String>();
            toAddress.add(con.Primary_Contact__r.Email);
            mail.setToAddresses( toAddress );
            String table = '<table style="border: 1px solid black; border-collapse: collapse;"><thead style="border: 1px solid black;"><tr><th style="border: 1px solid black;">Product Name</th><th style="border: 1px solid black;">Price</th><th style="border: 1px solid black; ">Quantity</th><th style="border: 1px solid black;">Total Price</th></tr></thead ><tbody style="border: 1px solid black;">';
            for(OpportunityLineItem opp:OpportunityList){   
                table+='<tr><td style="border: 1px solid black;">' + opp.Product2.Name + '</td><td style="border: 1px solid black;">' + opp.UnitPrice + '</td><td style="border: 1px solid black;">' + opp.Quantity + '</td><td style="border: 1px solid black; ">' + opp.TotalPrice + '</td></tr>';
            }
            table+='</tbody></table>';
            mail.setHtmlBody(table);
            emailList.add(mail);
        }
        List<Messaging.SendEmailResult> results=Messaging.sendEmail(emailList,false);
        for(Messaging.SendEmailResult email:results){
            System.debug(email.isSuccess());
        }
    }
    
}