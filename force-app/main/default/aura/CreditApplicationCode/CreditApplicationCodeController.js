({
    // execute on load of component
	doInit : function(component, event, helper) {
		helper.loadCreditApplicationFormOTP(component, event, helper);
	},
    
    // it generate the OTP for Credit Application Form
    regenerateOTP : function(component, event, helper) {
		helper.generateOTP(component, event, helper);
	}
    
})