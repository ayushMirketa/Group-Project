trigger InvoiceGenrationEmail on Custom_Invoice__c (before insert) {
    InvoiceGenartionHandler.sendInvoiceEmail(trigger.new);
}