public class InvoiceGenartionHandler {
    public static void sendInvoiceEmail(List<Custom_Invoice__c> newRecordList){
        Set<Id> OpportunityIdsSet = new Set<Id>();
        Set<Id> ContactIdsSet=new Set<Id>();
        for(Custom_Invoice__c customInvoice: newRecordList){
            OpportunityIdsSet.add(customInvoice.Opportunity__c);
            ContactIdsSet.add(customInvoice.Contact_Person__c);
        }
        List<OpportunityLineItem> OpportunityList = [SELECT Product2.Name, Quantity, UnitPrice,TotalPrice FROM OpportunityLineItem WHERE 
                                                     opportunityId IN :OpportunityIdsSet];
        Map<Id,Contact> contactMap=new Map<Id,Contact>([Select Id,Email from Contact where Id IN: ContactIdsSet]);
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for(Custom_Invoice__c customInvoice: newRecordList){
            Contact con = contactMap.get(customInvoice.Contact_Person__c);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Invoice Generated ');
            List<String> toAddress = new List<String>();
            toAddress.add(con.Email);
            mail.setToAddresses( toAddress );
            String table = '<table><thead><tr><th>Product Name</th><th>Unit Price</th><th>Quantity</th><th>Total Price</tr></thead><tbody>';
            for(OpportunityLineItem opp:OpportunityList){
                table+='<tr><td>' + opp.Product2.Name + '</td><td>' + opp.UnitPrice + '</td><td>' + opp.Quantity + '</td><td>'+opp.TotalPrice + '</td></tr>';
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