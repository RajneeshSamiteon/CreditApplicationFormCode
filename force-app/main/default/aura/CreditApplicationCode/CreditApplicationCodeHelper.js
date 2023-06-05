({
    // if the OTP already exists on the Credit Application Form by ContactID, it will load it
    loadCreditApplicationFormOTP : function(component, event, helper) {
        var action = component.get("c.generateCreditApplicationFormOTP");
        action.setParams({
            contactId : component.get("v.recordId"),
            methodUsed : 'doInit'
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.otp",response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let errorReferemce = {'className' : "CreditApplicationCode - Aura",
                                              'apexTrace' : "helper.loadCreditApplicationFormOTP",
                                              'exceptionMsg' : errors[0].message};
                        helper.CreateExceptionLog(component, event, helper, errorReferemce);
                    }
                } else {
                    console.log("\n--Unknown error--");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    // it will create a fresh OTP for the Credit Application Form and replace the old one
    generateOTP : function(component, event, helper) {
        var action = component.get("c.generateCreditApplicationFormOTP");
        action.setParams({
            contactId : component.get("v.recordId"),
            methodUsed : 'normal'
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.otp",response.getReturnValue());
                helper.successToast('OTP was successfully generated');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let errorReferemce = {'className' : "CreditApplicationCode - Aura",
                                              'apexTrace' : "helper.generateOTP",
                                              'exceptionMsg' : errors[0].message};
                        helper.CreateExceptionLog(component, event, helper, errorReferemce);
                    }
                } else {
                    console.log("\n--Unknown error--");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    successToast : function(message) {
        try {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":'Success',
                "message": message,
                "type":'success'
            });
            toastEvent.fire();
        }
        catch(e) {
            alert(message);
        }
    },
    
    errorToast : function(message) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":'Error',
                "message": message,
                "type":'error'
            });
            toastEvent.fire();
        }
        catch(e){
            alert("Error :: "+message);
        }
    }
})