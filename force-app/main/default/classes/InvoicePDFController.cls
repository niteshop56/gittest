public with sharing class InvoicePDFController {
    
    public Invoice__c inv { get; set; }

    public InvoicePDFController() {
        String idParam = ApexPages.currentPage().getParameters().get('id');
        //Hii Sir
        if(String.isBlank(idParam)) {
            inv = new Invoice__c();
            return;
        }

        try {
            inv = [
                SELECT Id, Invoice_No__c, Date__c, Client_Name__c, Disbursement_Amount_Requested__c,Particulars_Rendered__c,Invoice_Number__c,
                       Initials_and_Current_Date__c,Name,Invoiced_Amount__c, Invoiced_Amount_VAT_16__c, Total_of_Invoice__c,Include_Logo__c,
                       Matter__r.Name, Matter__r.Job_No__c, Matter__r.Our_Ref_2__c,Matter__r.Hisa_Job_No__c,Type__c,Matter__r.Unit_Description__c,
                       Matter__r.Client__r.Physical_Address__c,Select_Address_On_Invoice__c,Postal_Address__c,Adverse_Party_Invoice_Postal_Address__c,
                       Matter__r.Client__r.Postal_Address__c,Bank_Account_Name__c,Hisa_Secretarial_Number__c,Disbursement_Invoice_Number__c
                FROM Invoice__c
                WHERE Id = :idParam
                LIMIT 1
            ];
        } catch (Exception e) {
            inv = new Invoice__c();
        }
    }
}