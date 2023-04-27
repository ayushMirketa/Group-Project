trigger InvoiceGenrationEmail on Custom_Invoice__c (after insert) {
    
    InvoiceGenartionHandler.sendInvoiceEmail(trigger.new);
}