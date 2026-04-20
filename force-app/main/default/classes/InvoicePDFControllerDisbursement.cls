public with sharing class InvoicePDFControllerDisbursement {
    
    public Invoice__c inv { get; set; }
    public List<Matter_Item__c> matterItems { get; set; }
    public Decimal totalAmount { get; set; }
    
    public List<Matter_Item__c> particularsItems { get; set; }
    public List<Matter_Item__c> disbursementItems { get; set; }
    
    //hiiiiiiiiiyyy
    public Decimal particularsTotal { get; set; }
    public Decimal particularsTotalWithVAT { get; set; }
    public Decimal disbursementTotal { get; set; }
    public Decimal disbursementTotalWithVAT { get; set; }
    public Decimal grandTotal { get; set; }

    public InvoicePDFControllerDisbursement() {

        String idParam = ApexPages.currentPage().getParameters().get('id');

        if (String.isBlank(idParam)) {
            inv = new Invoice__c();
            matterItems = new List<Matter_Item__c>();
            totalAmount = 0;
            return;
        }

        try {
            inv = [
                SELECT Id, Invoice_No__c, Date__c, Client_Name__c,Name, Disbursement_Amount_Requested__c,Particulars_Rendered__c,Include_Logo__c,
                       Initials_and_Current_Date__c,Invoiced_Amount__c, Invoiced_Amount_VAT_16__c, Total_of_Invoice__c,Invoice_Number__c,
                       Matter__r.Id, Matter__r.Name, Matter__r.Job_No__c, Matter__r.Our_Ref_2__c,
                	   Matter__r.Amount__c, Matter__r.VAT_16__c, Matter__r.Sub_Total__c,Type__c,
                       Matter__r.Client__r.Physical_Address__c,Select_Address_On_Invoice__c,Postal_Address__c,Adverse_Party_Invoice_Postal_Address__c,
                       Matter__r.Client__r.Postal_Address__c,Bank_Account_Name__c,Disbursement_Invoice_Number__c
                FROM Invoice__c
                WHERE Id = :idParam
                LIMIT 1
            ];

            // Fetch Matter Item records
            matterItems = [
                SELECT Id, Description__c, Amount__c, Appear_on_Invoice__c, Line_Type__c, Quantity__c, Unit_Price__c, Grand_Total__c
                FROM Matter_Item__c
                WHERE Matter__c = :inv.Matter__r.Id AND Appear_on_Invoice__c = True
                ORDER BY CreatedDate ASC
            ];

            // Calculate Total Amount
            totalAmount = 0;
            for (Matter_Item__c mi : matterItems) {
                if (mi.Amount__c != null)
                    totalAmount += mi.Amount__c;
            }
            
        particularsItems = new List<Matter_Item__c>();
        disbursementItems = new List<Matter_Item__c>();

        particularsTotal = 0;
        disbursementTotal = 0;

        for (Matter_Item__c mi : matterItems) {

            if (mi.Line_Type__c == 'Particulars Rendered') {
                particularsItems.add(mi);
                if (mi.Grand_Total__c != null)
                    particularsTotal += mi.Grand_Total__c;
            }

            else if (mi.Line_Type__c == 'Disbursement') {
                disbursementItems.add(mi);
                if (mi.Grand_Total__c != null)
                    disbursementTotal += mi.Grand_Total__c;
            }
        }
         
		particularsTotalWithVAT = particularsTotal + particularsTotal * 0.16;
        disbursementTotalWithVAT = disbursementTotal + disbursementTotal * 0.16;
        grandTotal = particularsTotalWithVAT + disbursementTotalWithVAT;

        } catch (Exception e) {
            inv = new Invoice__c();
            matterItems = new List<Matter_Item__c>();
            totalAmount = 0;
        }
    }
    
    
}