@isTest
public class CreditApplicationCodeControllerTest {
	
    @testSetup
    public static void createTestRecord() {
        Account account = new Account();
        account.Name = 'Dummy Account';
        account.Account_Category__c = 'Dealer';
        insert account;
        
        Contact contact = new Contact();
        contact.LastName = 'Dummy Contact';
        contact.AccountId = account.Id;
        contact.Email = 'dummy@nonemail.com';
        contact.Roles__c = 'Architect';
        insert contact;
        
        Credit_Application_Form__c creditForm = new Credit_Application_Form__c();
        creditForm.Contact__c = contact.Id;
        creditForm.Application_Status__c = 'In Progress';
        creditForm.Credit_Application_Code__c = '123456';
        insert creditForm;
    }
    
    @isTest
    public static void validateOTPGenerationOfCreditApplicationForm() {
        Contact contact = [SELECT Id FROM Contact WHERE LastName =: 'Dummy Contact' LIMIT 1];
        
        System.test.startTest();
        String otp1 = CreditApplicationCodeController.generateCreditApplicationFormOTP(contact.Id, 'doInit');
        String otp2 = CreditApplicationCodeController.generateCreditApplicationFormOTP(contact.Id, 'normal');
        System.test.stopTest();
        
        System.assert(otp1 != null, 'No OTP is found.');
        System.assertEquals('123456', otp1, 'OTP generated failed to match.');
        System.assert(otp2 != null, 'OTP is not generated.');
    }

}