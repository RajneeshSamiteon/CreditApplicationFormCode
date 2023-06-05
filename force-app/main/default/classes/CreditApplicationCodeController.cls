// Test-Class : CreditApplicationCodeControllerTest
public class CreditApplicationCodeController {
    
    /*
	 * Functionality : generation of OTP Code for Credit Application Form [ methodUsed('doInit' or 'normal')]
	 * In doInit -> It returns the OTP code after extracting the previously saved code.
	 * In normal -> It generates a fresh code, updates the Credit Application Form's Credit Application Code field, and then returns the updated code.
	*/
    @AuraEnabled
    public static String generateCreditApplicationFormOTP(Id contactId, String methodUsed){
        String vCode = '--None--';
        try {
            List<Contact> contacts = ContactSelector.getContacts(new Set<Id>{contactId});
            if(contacts.isEmpty()){
                throw new AuraHandledException('No Contact Found.');
            }
            if(String.isBlank(contacts[0].Email)){
                throw new AuraHandledException('Email address not found.');
            }
            
            Set<Id> contactIds = new Set<Id>();
            for(Contact contact : contacts) {
                contactIds.add(contact.Id);
            }
            String verificationCode = generateVerificationCode();
            if(methodUsed.equals('doInit')) {
                List<Credit_Application_Form__c> creditApplicationForms = new List<Credit_Application_Form__c>();
                creditApplicationForms = CreditApplicationFormSelector.getCreditApplicationFormByContactIds(contactIds);
                if(!creditApplicationForms.isEmpty() && creditApplicationForms.size()>0) {
                    String savedCode = String.valueOf(creditApplicationForms[0].Credit_Application_Code__c);
                    return String.isEmpty(savedCode) ? vCode : savedCode;
                }
                else {
                    return vCode;
                }
            }
            else if(methodUsed.equals('normal')) {
                updateCodeOnCreditApplicationForm(contacts[0].Id, verificationCode);
            }
            
            return verificationCode;
        }
        catch(Exception ex) {
            ExceptionUtils.createExceptionLog('CreditApplicationCodeController - generateCreditApplicationFormOTP', ex.getMessage(), ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    // this method generates the 6-digit verfication code (in numeric)
    private static String generateVerificationCode(){
        return String.valueOf(Math.round((Math.random() * (900000) + 100000)));
    }
    
    // this method update the verfication code on Credit Application Form on the basis Contact Id
    public static void updateCodeOnCreditApplicationForm(Id contactId, String verificationCode) {
        try {
            List<Credit_Application_Form__c> creditApplicationFormByContactId = CreditApplicationFormSelector.getCreditApplicationFormByContactIds(new Set<Id>{contactId}); 
            
            if(!creditApplicationFormByContactId.isEmpty()) {
                creditApplicationFormByContactId[0].Credit_Application_Code__c = verificationCode;
                
                update creditApplicationFormByContactId;
            }
        }
        catch(Exception ex) {
            ExceptionUtils.createExceptionLog('CreditApplicationCodeController - updateCodeOnCreditApplicationForm', ex.getMessage(), ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
}