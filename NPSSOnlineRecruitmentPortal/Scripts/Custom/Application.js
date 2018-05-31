var Application = {
    options: {
        postSelection: "",
        ApplicantAge: 0,
        saveapplicationdormurl: "",
        errorPageurl: "",
        homepageurl: "",
        applicationsuccessful: "",
        uploadImagesurl: ""
    },
    init: function () {
        $(document).ready(function () {
            $("#Step_1").text("Personal Details");
            $("#Step_2").text("Communication Details");
            $("#Step_3").text("Qualification Details");
            $("#Step_4").text("Experience Details");

            for (var field in enumeration.requiredFields) {
                $("#" + enumeration.requiredFields[field]["id"]).on("focusout", function (e) {
                    Application.validateField($(this).attr("id"));
                });
            }

            $('#txtBirthDt').mask('99/99/9999', { placeholder: "DD/MM/YYYY" });

            $('#txtAadharCard').mask('9999-9999-9999', { placeholder: "XXXX-XXXX-XXXX" });

            $('.expdatepicker').mask('99/99/9999', { placeholder: "DD/MM/YYYY" });

            $('#chkIsMSBEmp').change(function () {
                if (this.checked) {
                    $("#chkIsAMCEmp").prop('checked', false);
                }
            });

            $('#chkIsAMCEmp').change(function () {
                if (this.checked) {
                    $("#chkIsMSBEmp").prop('checked', false);
                }
            });

            $("#txtAadharCard").on("focusout", function (e) {
                if ($("#txtAadharCard").val() != "" && $("#txtAadharCard").val().length < 12) {
                    $("#txtAadharCard").addClass("error");
                    $("#msgAadharCard").show();
                    $("#msgAadharCard").text("Aadhar Card Number cannot be less than 12 characters");
                }
                else {
                    $("#msgAadharCard").hide();
                    $("#msgAadharCard").text("");
                    $("#txtAadharCard").removeClass("error");
                }
            });

            $("input[type='file']").change(function () {
                var fileExtension = ['jpeg', 'jpg', 'jpe'];
                var file_size = $(this)[0].files[0].size;
                if (file_size > 15000) {
                    alert("Allowed file size is 15KB.");
                    $("#lbl" + $(this).attr("id")).text('No File Chosen');
                    $(this).val(null);
                    return false;
                }
                if ($.inArray($(this).val().split('.').pop().toLowerCase(), fileExtension) == -1) {
                    alert("Only format is allowed : " + fileExtension.join(', '));
                    $("#lbl" + $(this).attr("id")).text('No File Chosen');
                    $(this).val(null);
                    return false;
                }
                $("#lbl" + $(this).attr("id")).text($(this).val().replace("C:\\fakepath\\", ""));
            });

            $('.retype').on("cut copy paste", function (e) {
                e.preventDefault();
            });

            $('.QualificationInt').keydown(function (e) {
                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
                    (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                    (e.keyCode >= 35 && e.keyCode <= 40)) {
                    return;
                }
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            });

            $('.QualificationString').keydown(function (e) {
                var key = e.keyCode;
                if (!((key == 8) || (key == 9) || (key == 32) || (key == 16) || (key == 46) || (key == 190) || (key >= 35 && key <= 40) || (key >= 65 && key <= 90))) {
                    e.preventDefault();
                }
            });

            $('.OnlyStringTextbox').keydown(function (e) {
                var key = e.keyCode;
                if (!((key == 8) || (key == 9) || (key == 16) || (key == 32) || (key == 46) || (key >= 35 && key <= 40) || (key >= 65 && key <= 90))) {
                    e.preventDefault();
                }
            });

            $('.QualificationRequired').on("focusout", function (e) {
                //$("#" + this).on("focusout", function (e) {
                Application.validateField(this.id);
                //});
            });

            $('#txtBirthDt').focusout(function (e) {
                if ($('#txtBirthDt').val() != null && $('#txtBirthDt').val() != "" && $('#txtBirthDt').val() != undefined) {
                    //$("#lblAgeAsOnToday").text(Application.getAge($("#txtBirthDt").val()));
                    $("#btnAgeAsOnToday").text(Application.getAge($("#txtBirthDt").val()));
                    $("#btnAgeAsOnToday").css("display", "block");
                }
                else {
                    //$("#lblAgeAsOnToday").text('');
                    $("#btnAgeAsOnToday").text('');
                    $("#btnAgeAsOnToday").css("display", "none");
                    Application.options.ApplicantAge = 0;
                }
            });

            $("input[type='text']").bind('keyup', function (e) {
                if (e.which >= 97 && e.which <= 122) {
                    var newKey = e.which - 32;
                    // I have tried setting those
                    e.keyCode = newKey;
                    e.charCode = newKey;
                }
                $(this).val(($(this).val()).toUpperCase());
            });
        });
    },
    confirmSubmit: function () {
        if (Application.validateDateFields()) {
            if (Application.validateApplicant(enumeration.requiredFields, true) && Application.validateExperienceDetail(Application.ExperienceDetailsList())) {
                if ($("#ddlPhysicalDisability option:selected").val() == "false" || ($("#ddlPhysicalDisability option:selected").val() == "true" && $("#txtDisabilityPercentage").val() != null && $("#txtDisabilityPercentage").val() != "" && $("#txtDisabilityPercentage").val() >= 0 && $("#txtDisabilityPercentage").val() <= 100)) {
                    if (Application.validateQualificationDetail()) {
                        if (Application.QualificationMarkValidation()) {
                            if (Application.QualificationPercentageValidation()) {
                                if (($("#chkIsMSBEmp").prop('checked') == true || $("#chkIsAMCEmp").prop('checked') == true) || ($("#chkIsMSBEmp").prop('checked') == false && $("#chkIsAMCEmp").prop('checked') == false && Application.options.ApplicantAge >= 25)) {
                                    $("#modal-center").modal("show");
                                }
                                else {
                                    alert("Your age is below 25 years. You are not qualifying to apply for this post.");
                                }
                            }
                            else {
                                alert("Any Qualification Percentage should be between 0 and 100.");
                            }
                        }
                        else {
                            alert("Any Qualification should not have Obtained marks greater then Total marks.");
                        }
                    }
                    else {
                        alert("Please fill all necessary qualification information.");
                    }
                }
                else {
                    alert("Disability Percentage should be between 0 and 100.");
                }
            }
        }
        else {
            alert("Please enter valid dates.");
        }
    },
    addBasicDetails: function () {
        $("#pageloader").css("display", "block");
        if (window.FormData !== undefined) {
            var fileData = new FormData();
            var form = $('#file1')[0];
            var sign = $('#file2')[0];
            fileData.append('uploadedFile', form.files[0]);
            fileData.append('signature', sign.files[0]);

        }
        $.ajax({
            url: Application.options.uploadImagesurl,
            contentType: false,
            processData: false,
            async: false,
            data: fileData,
            type: "POST",
            success: function (result) {
                if (result.IsSuccess) {
                    Application.saveApplicantDetail();
                }
                else {
                    $("#pageloader").css("display", "none");
                    location.href = Application.options.errorPageurl;
                }
            }
        });
    },
    saveApplicantDetail: function () {
        var model = {};
        var isAppliedforSupervisor = false;
        var isAppliedForAsstAO = false;
        var QualificationDetail = Application.QualificationDetailsList();
        var ExperienceDetail = Application.ExperienceDetailsList();
        //if (Application.validateApplicant(enumeration.requiredFields, true) && Application.validateExperienceDetail(ExperienceDetail)) {
        //    if (Application.options.ApplicantAge >= 25 && Application.options.ApplicantAge <= 45) {
        if (Application.options.postSelection == "1" || Application.options.postSelection == "3") {
            isAppliedforSupervisor = true;
        }
        if (Application.options.postSelection == "2" || Application.options.postSelection == "3") {
            isAppliedForAsstAO = true;
        }
        model = {
            postSelected: Application.options.postSelection,
            Surname: $("#txtSurname").val().trim(),
            FirstName: $("#txtFirstName").val().trim(),
            LastName: $("#txtLastName").val().trim(),
            BirthDate: Application.formatDate($("#txtBirthDt").val()),
            //AgeOnApplicationDate: Application.calculateAge(),
            BirthPlaceVillage: "", //$("#txtBirthVillage").val()
            BirthPlaceCity: "", //$("#txtBirthCity").val()
            BirthPlaceState: "", //$("#txtBirthState").val()
            AadharCardNo: $("#txtAadharCard").val(),
            PhysicalDisability: $("#ddlPhysicalDisability option:selected").val(),
            DisabilityPercentage: $("#txtDisabilityPercentage").val(),
            IsMSBEmp: $("#chkIsMSBEmp").prop('checked'),
            IsAMCEmp: $("#chkIsAMCEmp").prop('checked'),
            Address1: $("#txtAddress1").val().trim(),
            Address2: $("#txtAddress2").val().trim(),
            Address3: $("#txtAddress3").val().trim(),
            MobileNumber: $("#txtMobileNo").val(),
            EmailId: $("#txtEmail").val().trim(),
            Cast: "",
            SubCast: "",
            IsAppliedForSupervisor: isAppliedforSupervisor,
            ISAppliedForAsstAO: isAppliedForAsstAO,
            Category: $("#ddlCategory").val(),
            MaritalStaus: $("#ddlMaritalStaus").val(),
            Title: $("#ddlSalute").val(),
            Gender: $("#ddlGender").val(),
            City: $("#ddlAddressCity").val().trim(),
            District: $("#txtdistrict").val().trim(),
            Taluka: $("#txttaluka").val().trim(),
            PinCode: $("#txtPIN").val().trim(),
            State: $("#drpStateA option:selected").text(),
            QualificationDetails: QualificationDetail,
            ExperienceDetails: ExperienceDetail
        };
        var jsondata = JSON.stringify({
            'objApplication': model
        });
        $.ajax({
            url: Application.options.saveapplicationdormurl,
            contentType: "application/json; charset=utf-8",
            data: jsondata,
            //async: false,
            beforeSend: function () {
                $("#pageloader").css("display", "block");
            },
            dataType: "json",
            type: "POST",
            success: function (result) {
                if (result.IsSuccess) {
                    if (result.IsDuplicate) {
                        $("#pageloader").css("display", "none");
                        alert("You are already applied for the selected post. Your application number is " + result.ApplicationID.replace("@_@", " & ") + ".");
                    }
                    else {
                        $("#pageloader").css("display", "none");
                        location.href = Application.options.applicationsuccessful + "?applicantID=" + result.ApplicantID;
                    }
                }
                else {
                    $("#pageloader").css("display", "none");
                    location.href = Application.options.errorPageurl;
                }
            },
        });
    },
    validateApplicant: function (fields, isFromSave) {
        var strVal = "";
        var isValid = true;
        for (var field in fields) {
            if (field.toString().toLowerCase() != "email" && field.toString().toLowerCase() != "retypeemail") {
                if ($("#" + fields[field]["id"]).val() == null || $("#" + fields[field]["id"]).val() == "") {
                    if (isValid) {
                        $("#" + fields[field]["id"]).focus();
                        isValid = false;
                    }
                    $("#" + fields[field]["id"]).addClass("error");
                    strVal += enumeration.validationMessages.requiredVal.format(fields[field]["DisplayName"]) + "\n\n";
                }
                else {
                    $("#" + fields[field]["id"]).removeClass("error");
                }
            }
            
            if (isValid) {
                if ($("#" + fields[field]["id"]).val().length > Number(fields[field]["length"])) {
                    if (isValid) {
                        $("#" + fields[field]["id"]).focus();
                        isValid = false;
                    }
                    $("#" + fields[field]["id"]).addClass("error");
                    strVal += enumeration.validationMessages.maxlength.format(fields[field]["DisplayName"], fields[field]["length"]) + "\n\n";
                }
                else {
                    $("#" + fields[field]["id"]).removeClass("error");
                }

                if (isValid && field.toString().toLowerCase() == "email") {
                    if (!common.validateEmail($("#" + fields[field]["id"]).val())) {
                        isValid = false;
                        $("#" + fields[field]["id"]).addClass("error");
                        strVal += enumeration.validationMessages.emailReg.toString();
                    }
                    else {
                        $("#" + fields[field]["id"]).removeClass("error");
                    }
                }
                if (isValid && field.toString().toLowerCase() == "mobileno") {
                    if ($("#" + fields[field]["id"]).val().length < 10) {
                        isValid = false;
                        $("#" + fields[field]["id"]).addClass("error");
                        strVal += enumeration.validationMessages.minlength.toString().format(fields[field]["DisplayName"], 10);
                    }
                    else {
                        $("#" + fields[field]["id"]).removeClass("error");
                    }
                }
                if (isValid && field.toString().toLowerCase() == "pin") {
                    if ($("#" + fields[field]["id"]).val().length < 6) {
                        isValid = false;
                        $("#" + fields[field]["id"]).addClass("error");
                        strVal += enumeration.validationMessages.minlength.toString().format(fields[field]["DisplayName"], 6);
                    }
                    else {
                        $("#" + fields[field]["id"]).removeClass("error");
                    }
                }
                if (field.toString().toLowerCase() == "retypemobileno") {
                    if ($("#txtMobileNo").val() !== $("#txtretypeMobileNo").val()) {
                        isValid = false;
                        strVal += enumeration.validationMessages.comparemobile.toString();
                        $("#" + field).addClass("error");
                    }
                    else {
                        $("#" + field).removeClass("error");
                    }
                }
                if (field.toString().toLowerCase() == "retypeemail") {
                    if ($("#txtEmail").val() !== $("#txtretypeEmail").val()) {
                        isValid = false;
                        strVal += enumeration.validationMessages.compareemail.toString();
                        $("#" + field).addClass("error");
                    }
                    else {
                        $("#" + field).removeClass("error");
                    }
                }
            }
        }
        if ($("#txtAadharCard").val() != "" && $("#txtAadharCard").val().length < 12) {
            isValid = false;
            $("#txtAadharCard").addClass("error");
            $("#msgAadharCard").show();
            $("#msgAadharCard").text("Aadhar Card Number cannot be less than 12 characters");
            strVal += enumeration.validationMessages.minlength.toString().format("Aadhar Card Number", 12);
        }
        else {
            $("#msgAadharCard").hide();
            $("#msgAadharCard").text("");
            $("#txtAadharCard").removeClass("error");
        }
        if (strVal != "") { //isFromSave && 
            alert(strVal);
        }
        return isValid;
    },
    validateField: function (field) {
        var ismobvalid = true;
        var isemailvalid = true;
        if ($("#" + field).val() == null || $("#" + field).val() == "") {
            $("#" + field).addClass("error");
        }
        else {
            $("#" + field).removeClass("error");
        }
        if (field.toString().toLowerCase() == "txtemail" || field.toString().toLowerCase() == "txtretypeemail") {
            if (!common.validateEmail($("#" + field).val())) {
                isemailvalid = false;
                $("#" + field.toString().replace("txt", "msg")).show();
                $("#" + field.toString().replace("txt", "msg")).text(enumeration.validationMessages.emailReg.toString());
                $("#" + field).addClass("error");
            }
            else {
                $("#" + field.toString().replace("txt", "msg")).hide();
                $("#" + field.toString().replace("txt", "msg")).text('');
                $("#" + field).removeClass("error");
            }
        }
        if (field.toString().toLowerCase() == "txtmobileno" || field.toString().toLowerCase() == "txtretypemobileno") {
            if ($("#" + field).val().length < 10) {
                ismobvalid = false;
                $("#" + field.toString().replace("txt", "msg")).show();
                $("#" + field.toString().replace("txt", "msg")).text(enumeration.validationMessages.minlength.toString().format("Mobile No", 10));
                $("#" + field).addClass("error");
            }
            else {
                $("#" + field.toString().replace("txt", "msg")).hide();
                $("#" + field.toString().replace("txt", "msg")).text('');
                $("#" + field).removeClass("error");
            }
        }
        if (field.toString().toLowerCase() == "txtpin") {
            if ($("#" + field).val().length < 6) {
                $("#msgPIN").show();
                $("#msgPIN").text(enumeration.validationMessages.minlength.toString().format("Pin Code", 6));
                $("#" + field).addClass("error");
            }
            else {
                $("#msgPIN").hide();
                $("#msgPIN").text('');
                $("#" + field).removeClass("error");
            }
        }
        if (ismobvalid && field.toString().toLowerCase() == "txtretypemobileno") {
            if ($("#txtMobileNo").val() !== $("#txtretypeMobileNo").val()) {
                $("#msgretypeMobileNo").show();
                $("#msgretypeMobileNo").text(enumeration.validationMessages.comparemobile.toString());
                $("#" + field).addClass("error");
            }
            else {
                $("#msgretypeMobileNo").hide();
                $("#msgretypeMobileNo").text('');
                $("#" + field).removeClass("error");
            }
        }
        if (isemailvalid && field.toString().toLowerCase() == "txtretypeemail") {
            if ($("#txtEmail").val() !== $("#txtretypeEmail").val()) {
                $("#msgretypeEmail").show();
                $("#msgretypeEmail").text(enumeration.validationMessages.compareemail.toString());
                $("#" + field).addClass("error");
            }
            else {
                $("#msgretypeEmail").hide();
                $("#msgretypeEmail").text('');
                $("#" + field).removeClass("error");
            }
        }
    },
    QualificationPercentageValidation: function () {
        var isValid = true;
        var PercentageValidationCounter = 0;
        $(".percentagevalidation").each(function () {
            var percentage = $('#' + this.id).val().trim();
            if (percentage != "" && percentage != null && percentage != undefined) {
                if (parseInt(percentage) >= 0 && parseInt(percentage) <= 100) {
                    $('#' + this.id).removeClass("error");
                }
                else {
                    PercentageValidationCounter = PercentageValidationCounter + 1;
                    $('#' + this.id).addClass("error");
                }
            }
        })
        if (PercentageValidationCounter > 0) {
            isValid = false;
        }
        return isValid;
    },
    QualificationMarkValidation: function () {
        var isValid = true;
        var QualificationValidationCounter = 0;
        $(".markvalidationclass").each(function () {
            var totalmarks = $('.TTM_' + this.id.split("_")[0]).val().trim();
            var obtainedmarks = $('.OBTM_' + this.id.split("_")[0]).val().trim();

            if (totalmarks != "" && totalmarks != null && totalmarks != undefined && obtainedmarks != "" && obtainedmarks != null && obtainedmarks != undefined) {
                if (parseInt(obtainedmarks) > parseInt(totalmarks)) {
                    QualificationValidationCounter = QualificationValidationCounter + 1;
                    $('.TTM_' + this.id.split("_")[0]).addClass("error");
                    $('.OBTM_' + this.id.split("_")[0]).addClass("error");
                }
                else {
                    $('.TTM_' + this.id.split("_")[0]).removeClass("error");
                    $('.OBTM_' + this.id.split("_")[0]).removeClass("error");
                }
            }
        })
        if (QualificationValidationCounter > 0) {
            isValid = false;
        }
        return isValid;
    },
    QualificationDetailsList: function () {
        var array = [];
        $(".ApplicantQualificationDetails").each(function () {
            if ($('#' + this.id).val().trim() != "" && $('#' + this.id).val().trim() != null && $('#' + this.id).val().trim() != undefined) {
                array.push({
                    Key: this.id,
                    Value: $("#" + this.id).val()
                });
            }
        })
        return array;
    },
    ExperienceDetailsList: function () {
        var days = 0;
        var array = [];
        if ($("#txtOrganization1").val() != undefined && $("#txtOrganization1").val() != "") {
            var startyear = $("#txtStartDate1").val().substring(6, 10);
            var startmonth = $("#txtStartDate1").val().substring(3, 5);
            var endyear = $("#txtEndDate1").val().substring(6, 10);
            var endmonth = $("#txtEndDate1").val().substring(3, 5);
            days = days + Math.round(((new Date(endyear, endmonth - 1)) - (new Date(startyear, startmonth - 1))) / 86400000);

            array.push({
                Key: "1",
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization1").val(), Designation: $("#txtDesignation1").val(), StartDate: Application.formatDate($("#txtStartDate1").val()), EndDate: Application.formatDate($("#txtEndDate1").val()), Sequence: 1 })
            });
        }
        if ($("#txtOrganization2").val() != undefined && $("#txtOrganization2").val() != "") {
            var startyear = $("#txtStartDate2").val().substring(6, 10);
            var startmonth = $("#txtStartDate2").val().substring(3, 5);
            var endyear = $("#txtEndDate2").val().substring(6, 10);
            var endmonth = $("#txtEndDate2").val().substring(3, 5);
            days = days + Math.round(((new Date(endyear, endmonth - 1)) - (new Date(startyear, startmonth - 1))) / 86400000);
            array.push({
                Key: "2",
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization2").val(), Designation: $("#txtDesignation2").val(), StartDate: Application.formatDate($("#txtStartDate2").val()), EndDate: Application.formatDate($("#txtEndDate2").val()), Sequence: 2 })
            });
        }
        if ($("#txtOrganization3").val() != undefined && $("#txtOrganization3").val() != "") {
            var startyear = $("#txtStartDate3").val().substring(6, 10);
            var startmonth = $("#txtStartDate3").val().substring(3, 5);
            var endyear = $("#txtEndDate3").val().substring(6, 10);
            var endmonth = $("#txtEndDate3").val().substring(3, 5);
            days = days + Math.round(((new Date(endyear, endmonth - 1)) - (new Date(startyear, startmonth - 1))) / 86400000);
            array.push({
                Key: "3",
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization3").val(), Designation: $("#txtDesignation3").val(), StartDate: Application.formatDate($("#txtStartDate3").val()), EndDate: Application.formatDate($("#txtEndDate3").val()), Sequence: 3 })
            });
        }
        if ($("#txtOrganization4").val() != undefined && $("#txtOrganization4").val() != "") {
            var startyear = $("#txtStartDate4").val().substring(6, 10);
            var startmonth = $("#txtStartDate4").val().substring(3, 5);
            var endyear = $("#txtEndDate4").val().substring(6, 10);
            var endmonth = $("#txtEndDate4").val().substring(3, 5);
            days = days + Math.round(((new Date(endyear, endmonth - 1)) - (new Date(startyear, startmonth - 1))) / 86400000);
            array.push({
                Key: "4",
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization4").val(), Designation: $("#txtDesignation4").val(), StartDate: Application.formatDate($("#txtStartDate4").val()), EndDate: Application.formatDate($("#txtEndDate4").val()), Sequence: 4 })
            });
        }
        if ($("#txtOrganization5").val() != undefined && $("#txtOrganization5").val() != "") {
            var startyear = $("#txtStartDate5").val().substring(6, 10);
            var startmonth = $("#txtStartDate5").val().substring(3, 5);
            var endyear = $("#txtEndDate5").val().substring(6, 10);
            var endmonth = $("#txtEndDate5").val().substring(3, 5);
            days = days + Math.round(((new Date(endyear, endmonth - 1)) - (new Date(startyear, startmonth - 1))) / 86400000);
            array.push({
                Key: "5",
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization5").val(), Designation: $("#txtDesignation5").val(), StartDate: Application.formatDate($("#txtStartDate5").val()), EndDate: Application.formatDate($("#txtEndDate5").val()), Sequence: 5 })
            });
        }
        if ($("#txtOrganization6").val() != undefined && $("#txtOrganization6").val() != "") {
            var startyear = $("#txtStartDate6").val().substring(6, 10);
            var startmonth = $("#txtStartDate6").val().substring(3, 5);
            var endyear = $("#txtEndDate6").val().substring(6, 10);
            var endmonth = $("#txtEndDate6").val().substring(3, 5);
            days = days + Math.round(((new Date(endyear, endmonth - 1)) - (new Date(startyear, startmonth - 1))) / 86400000);
            array.push({
                Key: "6",
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization6").val(), Designation: $("#txtDesignation6").val(), StartDate: Application.formatDate($("#txtStartDate6").val()), EndDate: Application.formatDate($("#txtEndDate6").val()), Sequence: 6 })
            });
        }

        return array;
    },
    validateExperienceDetail: function (list) {
        var isValid = true;
        //if (list.length == 0) {
        //    isValid = false;
        //    alert("At least one expierience detail required.");
        //}
        var days = 0;
        if ($("#txtOrganization1").val() != undefined && $("#txtOrganization1").val() != "") {
            var startyear = $("#txtStartDate1").val().substring(6, 10);
            var startmonth = $("#txtStartDate1").val().substring(3, 5);
            var endyear = $("#txtEndDate1").val().substring(6, 10);
            var endmonth = $("#txtEndDate1").val().substring(3, 5);
            days = days + Math.round(((new Date(endyear, endmonth - 1)) - (new Date(startyear, startmonth - 1))) / 86400000);
        }
        if ($("#txtOrganization2").val() != undefined && $("#txtOrganization2").val() != "") {
            var startyear = $("#txtStartDate2").val().substring(6, 10);
            var startmonth = $("#txtStartDate2").val().substring(3, 5);
            var endyear = $("#txtEndDate2").val().substring(6, 10);
            var endmonth = $("#txtEndDate2").val().substring(3, 5);
            days = days + Math.round(((new Date(endyear, endmonth - 1)) - (new Date(startyear, startmonth - 1))) / 86400000);
        }
        if ($("#txtOrganization3").val() != undefined && $("#txtOrganization3").val() != "") {
            var startyear = $("#txtStartDate3").val().substring(6, 10);
            var startmonth = $("#txtStartDate3").val().substring(3, 5);
            var endyear = $("#txtEndDate3").val().substring(6, 10);
            var endmonth = $("#txtEndDate3").val().substring(3, 5);
            days = days + Math.round(((new Date(endyear, endmonth - 1)) - (new Date(startyear, startmonth - 1))) / 86400000);
        }
        if ($("#txtOrganization4").val() != undefined && $("#txtOrganization4").val() != "") {
            var startyear = $("#txtStartDate4").val().substring(6, 10);
            var startmonth = $("#txtStartDate4").val().substring(3, 5);
            var endyear = $("#txtEndDate4").val().substring(6, 10);
            var endmonth = $("#txtEndDate4").val().substring(3, 5);
            days = days + Math.round(((new Date(endyear, endmonth - 1)) - (new Date(startyear, startmonth - 1))) / 86400000);
        }
        if ($("#txtOrganization5").val() != undefined && $("#txtOrganization5").val() != "") {
            var startyear = $("#txtStartDate5").val().substring(6, 10);
            var startmonth = $("#txtStartDate5").val().substring(3, 5);
            var endyear = $("#txtEndDate5").val().substring(6, 10);
            var endmonth = $("#txtEndDate5").val().substring(3, 5);
            days = days + Math.round(((new Date(endyear, endmonth - 1)) - (new Date(startyear, startmonth - 1))) / 86400000);
        }
        if ($("#txtOrganization6").val() != undefined && $("#txtOrganization6").val() != "") {
            var startyear = $("#txtStartDate6").val().substring(6, 10);
            var startmonth = $("#txtStartDate6").val().substring(3, 5);
            var endyear = $("#txtEndDate6").val().substring(6, 10);
            var endmonth = $("#txtEndDate6").val().substring(3, 5);
            days = days + Math.round(((new Date(endyear, endmonth - 1)) - (new Date(startyear, startmonth - 1))) / 86400000);
        }

        if (days < 731) {
            isValid = false;
            alert("At least two years of experience is required for applying this post.");
        }

        return isValid;
    },
    validateQualificationDetail: function () {
        var isValid = true;
        $('.QualificationRequired').each(function (e) {
            if ($("#" + this.id).val() == null || $("#" + this.id).val() == "") {
                $("#" + this.id).addClass("error");
            }
            else {
                $("#" + this.id).removeClass("error");
            }
        });
        if ($('.QualificationRequired.error').length > 0) {
            isValid = false;
        }

        return isValid;
    },
    validateDateFields: function () {
        var isValid = true;
        $('.DateValidation').each(function (e) {
            if ($("#" + this.id).val() != null && $("#" + this.id).val() != "" && !Application.isValidDate($("#" + this.id).val())) {
                $("#" + this.id).addClass("error");
            }
            else {
                $("#" + this.id).removeClass("error");
            }
        });
        if ($('.DateValidation.error').length > 0) {
            isValid = false;
        }
        return isValid;
    },
    getAge: function (dateString) {
        var now = new Date();
        var today = new Date(now.getFullYear(), now.getMonth(), now.getDate());

        var yearNow = now.getFullYear();
        var monthNow = now.getMonth();
        var dateNow = now.getDate();
        //date must be mm/dd/yyyy
        var dob = new Date(parseInt(dateString.substring(6, 10)),
                            parseInt(dateString.substring(3, 5)) - 1,
                           parseInt(dateString.substring(0, 2))
                           );

        var yearDob = dob.getFullYear();
        var monthDob = dob.getMonth();
        var dateDob = dob.getDate();
        var age = {};
        var ageString = "";
        var yearString = "";
        var monthString = "";
        var dayString = "";


        yearAge = yearNow - yearDob;

        if (monthNow >= monthDob)
            var monthAge = monthNow - monthDob;
        else {
            yearAge--;
            var monthAge = 12 + monthNow - monthDob;
        }

        if (dateNow >= dateDob)
            var dateAge = dateNow - dateDob;
        else {
            monthAge--;
            var dateAge = 31 + dateNow - dateDob;

            if (monthAge < 0) {
                monthAge = 11;
                yearAge--;
            }
        }

        age = {
            years: yearAge,
            months: monthAge,
            days: dateAge
        };
        Application.options.ApplicantAge = age.years;
        if (age.years > 1) yearString = " years";
        else yearString = " year";
        if (age.months > 1) monthString = " months";
        else monthString = " month";
        if (age.days > 1) dayString = " days";
        else dayString = " day";


        if ((age.years > 0) && (age.months > 0) && (age.days > 0))
            ageString = age.years + yearString + ", " + age.months + monthString + ", " + age.days + dayString;
        else if ((age.years == 0) && (age.months == 0) && (age.days > 0))
            ageString = "Only " + age.days + dayString + " old!";
        else if ((age.years > 0) && (age.months == 0) && (age.days == 0))
            ageString = age.years + yearString + " . Happy Birthday!!";
        else if ((age.years > 0) && (age.months > 0) && (age.days == 0))
            ageString = age.years + yearString + " " + age.months + monthString;
        else if ((age.years == 0) && (age.months > 0) && (age.days > 0))
            ageString = age.months + monthString + " " + age.days + dayString;
        else if ((age.years > 0) && (age.months == 0) && (age.days > 0))
            ageString = age.years + yearString + " " + age.days + dayString;
        else if ((age.years == 0) && (age.months > 0) && (age.days == 0))
            ageString = age.months + monthString;
        else ageString = "Oops! Could not calculate age!";

        return ageString;
    },
    formatDate: function (date) {
        var formatedDate;
        if (date != null && date != "" && date != undefined) {
            formatedDate = date.substring(3, 5) + "/" + date.substring(0, 2) + "/" + date.substring(6, 10);
        }
        else {
            formatedDate = "";
        }
        return formatedDate;
    },
    isValidDate: function (dateString) {
        //var currVal = dateString;
        var currVal = dateString.substring(6, 10) + "/" + dateString.substring(3, 5) + "/" + dateString.substring(0, 2);
        if (currVal == '')
            return false;

        var rxDatePattern = /^(\d{4})(\/|-)(\d{1,2})(\/|-)(\d{1,2})$/; //Declare Regex
        var dtArray = currVal.match(rxDatePattern); // is format OK?

        if (dtArray == null)
            return false;

        //Checks for mm/dd/yyyy format.
        dtMonth = dtArray[3];
        dtDay = dtArray[5];
        dtYear = dtArray[1];

        if (dtMonth < 1 || dtMonth > 12)
            return false;
        else if (dtDay < 1 || dtDay > 31)
            return false;
        else if ((dtMonth == 4 || dtMonth == 6 || dtMonth == 9 || dtMonth == 11) && dtDay == 31)
            return false;
        else if (dtMonth == 2) {
            var isleap = (dtYear % 4 == 0 && (dtYear % 100 != 0 || dtYear % 400 == 0));
            if (dtDay > 29 || (dtDay == 29 && !isleap))
                return false;
        }
        return true;
    }
}
