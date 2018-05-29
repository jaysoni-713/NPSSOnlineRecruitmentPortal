var enumeration = {
    requiredFields: {
        Surname: { id: "txtSurname", length: 100 },
        FirstName: { id: "txtFirstName", length: 100 },
        LastName: { id: "txtLastName", length: 100 },
        BirthDt: { id: "txtBirthDt", length: 100 },
        BirthVillage: { id: "txtBirthVillage", length: 100 },
        BirthCity: { id: "txtBirthCity", length: 100 },
        BirthState: { id: "txtBirthState", length: 100 },
        Address1: { id: "txtAddress1", length: 100 },
        Address2: { id: "txtAddress2", length: 100 },
        Address3: { id: "txtAddress3", length: 100 },
        MobileNo: { id: "txtMobileNo", length: 10 },
        Email: { id: "txtEmail", length: 100 },
        ddlAddressCity: { id: "ddlAddressCity", length: 100 },
        txttaluka: { id: "txttaluka", length: 100 },
        txtdistrict: { id: "txtdistrict", length: 100 },
        ddlCategory: { id: "ddlCategory", length: 100 },
        ddlMaritalStaus: { id: "ddlMaritalStaus", length: 100 },
        ddlSalute: { id: "ddlSalute", length: 100 },
        ddlGender: { id: "ddlGender", length: 100 },
        PIN: { id: "txtPIN", length: 6 }
    },
    firstStepFields: {
        Surname: { id: "txtSurname", length: 100 },
        FirstName: { id: "txtFirstName", length: 100 },
        LastName: { id: "txtLastName", length: 100 },
        BirthDt: { id: "txtBirthDt", length: 100 },
        BirthVillage: { id: "txtBirthVillage", length: 100 },
        BirthCity: { id: "txtBirthCity", length: 100 },
        BirthState: { id: "txtBirthState", length: 100 },
    },
    secondStepFields: {
        Address1: { id: "txtAddress1", length: 100 },
        Address2: { id: "txtAddress2", length: 100 },
        Address3: { id: "txtAddress3", length: 100 },
        MobileNo: { id: "txtMobileNo", length: 10 },
        Email: { id: "txtEmail", length: 100 },
        ddlAddressCity: { id: "ddlAddressCity", length: 100 },
        txttaluka: { id: "txttaluka", length: 100 },
        txtdistrict: { id: "txtdistrict", length: 100 },
        ddlCategory: { id: "ddlCategory", length: 100 },
        ddlMaritalStaus: { id: "ddlMaritalStaus", length: 100 },
        ddlSalute: { id: "ddlSalute", length: 100 },
        ddlGender: { id: "ddlGender", length: 100 },
        PIN: { id: "txtPIN", length: 6 }
    },
    validationMessages: {
        requiredVal: "- {0} is required.",
        emailReg: "Please enter valid email address.",
        maxlength: "{0} cannot be more than {1} characters",
    },
    regEx: {
        email: /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/
    }
}