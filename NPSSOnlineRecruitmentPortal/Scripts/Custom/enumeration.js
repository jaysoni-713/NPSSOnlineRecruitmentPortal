var enumeration = {
    requiredFields: {
        Surname: { id: "txtSurname", length: 100, DisplayName: "Surname" },
        FirstName: { id: "txtFirstName", length: 100, DisplayName: "First Name" },
        LastName: { id: "txtLastName", length: 100, DisplayName: "Last Name" },
        BirthDt: { id: "txtBirthDt", length: 100, DisplayName: "Birth Date" },
        ddlCategory: { id: "ddlCategory", length: 100, DisplayName: "Category" },
        ddlMaritalStaus: { id: "ddlMaritalStaus", length: 100, DisplayName: "Marital Status" },
        ddlSalute: { id: "ddlSalute", length: 100, DisplayName: "Title" },
        ddlGender: { id: "ddlGender", length: 100, DisplayName: "Gender" },
        Photo: { id: "file1", length: 10000, DisplayName: "Photo" },
        Signature: { id: "file2", length: 10000, DisplayName: "Signature" },
        Address1: { id: "txtAddress1", length: 100, DisplayName: "Address1" },
        Address2: { id: "txtAddress2", length: 100, DisplayName: "Address2" },
        Address3: { id: "txtAddress3", length: 100, DisplayName: "Address3" },
        MobileNo: { id: "txtMobileNo", length: 10, DisplayName: "Mobile No" },
        Email: { id: "txtEmail", length: 100, DisplayName: "Email" },
        retypeEmail: { id: "txtretypeEmail", length: 100, DisplayName: "Re-Type Email" },
        retypeMobileNo: { id: "txtretypeMobileNo", length: 10, DisplayName: "Re-Type Mobile No" },
        ddlAddressCity: { id: "ddlAddressCity", length: 100, DisplayName: "City/Village" },
        txttaluka: { id: "txttaluka", length: 100, DisplayName: "Taluka" },
        txtdistrict: { id: "txtdistrict", length: 100, DisplayName: "District" },
        PIN: { id: "txtPIN", length: 6, DisplayName: "Pin Code" }
    },
    firstStepFields: {
        Surname: { id: "txtSurname", length: 100, DisplayName: "Surname" },
        FirstName: { id: "txtFirstName", length: 100, DisplayName: "First Name" },
        LastName: { id: "txtLastName", length: 100, DisplayName: "Last Name" },
        BirthDt: { id: "txtBirthDt", length: 100, DisplayName: "Birth Date" },
        Photo: { id: "file1", length: 10000, DisplayName: "Photo" },
        Signature: { id: "file2", length: 10000, DisplayName: "Signature" },
        ddlSalute: { id: "ddlSalute", length: 100, DisplayName: "Title" },
        ddlCategory: { id: "ddlCategory", length: 100, DisplayName: "Category" },
        ddlMaritalStaus: { id: "ddlMaritalStaus", length: 100, DisplayName: "Marital Status" },
        ddlGender: { id: "ddlGender", length: 100, DisplayName: "Gender" },
    },
    secondStepFields: {
        Address1: { id: "txtAddress1", length: 100, DisplayName: "Address1" },
        Address2: { id: "txtAddress2", length: 100, DisplayName: "Address2" },
        Address3: { id: "txtAddress3", length: 100, DisplayName: "Address3" },
        MobileNo: { id: "txtMobileNo", length: 10, DisplayName: "Mobile No" },
        Email: { id: "txtEmail", length: 100, DisplayName: "Email" },
        retypeEmail: { id: "txtretypeEmail", length: 100, DisplayName: "Re-Type Email" },
        retypeMobileNo: { id: "txtretypeMobileNo", length: 10, DisplayName: "Re-Type Mobile No" },
        ddlAddressCity: { id: "ddlAddressCity", length: 100, DisplayName: "City/Village" },
        txttaluka: { id: "txttaluka", length: 100, DisplayName: "Taluka" },
        txtdistrict: { id: "txtdistrict", length: 100, DisplayName: "District" },
        PIN: { id: "txtPIN", length: 6, DisplayName: "Pin Code" }
    },
    validationMessages: {
        requiredVal: "- {0} is required.",
        minlength: "- {0} cannot be less than {1} characters",
        emailReg: "Please enter valid email address.",
        maxlength: "{0} cannot be more than {1} characters.",
        compareemail: "Re-Type Email must match with Email.",
        comparemobile: "Re-Type Mobile No must match with Mobile No."
    },
    regEx: {
        email: /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/
    }
}