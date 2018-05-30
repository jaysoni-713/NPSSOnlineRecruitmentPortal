var Application = {
    options: {
        postSelection: "",
        ApplicantAge: 0,
        saveapplicationdormurl: "",
        errorPageurl: "",
        homepageurl: "",
        applicationsuccessful: ""
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

            //$('#txtBirthDt').datepicker({
            //    format: 'mm/dd/yyyy',
            //    endDate: new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate() - 1)
            //});

            //$('.expdatepicker').datepicker({
            //    format: 'mm/dd/yyyy',
            //    endDate: new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate() - 1)
            //});

            //$("#btncontractDateContainer").on("click", function () {
            //    $("#txtBirthDt").datepicker('show');
            //});

            //$(".expGroupaddon").on("click", function () {
            //    $(this).siblings(".expdatepicker").datepicker('show');
            //});

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
        if (Application.validateApplicant(enumeration.requiredFields, true) && Application.validateExperienceDetail(Application.ExperienceDetailsList())) {
            if (Application.options.ApplicantAge >= 25 && Application.options.ApplicantAge <= 40) {
                $("#modal-center").modal("show");
            }
            else {
                alert("You are not eligible to apply for this post.");
            }
        }
    },
    addBasicDetails: function () {
        debugger;
        $("#pageloader").css("display", "block");
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
            AgeOnApplicationDate: Application.calculateAge(),
            BirthPlaceVillage: "", //$("#txtBirthVillage").val()
            BirthPlaceCity: "", //$("#txtBirthCity").val()
            BirthPlaceState: "", //$("#txtBirthState").val()
            AadharCardNo: $("#txtAadharCard").val(),
            Address1: $("#txtAddress1").val().trim(),
            Address2: $("#txtAddress2").val().trim(),
            Address3: $("#txtAddress3").val().trim(),
            MobileNumber: $("#txtMobileNo").val(),
            EmailId: $("#txtEmail").val().trim(),
            Cast: "",
            SubCast: "",
            ImagePath: "",
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
                debugger;
                if (result.IsSuccess) {
                    if (result.IsDuplicate) {
                        alert("You are already applied for the selected post. Your application number is " + result.ApplicationID.replace("@_@", " & ") + ".");
                    }
                    else {
                        location.href = Application.options.applicationsuccessful + "?applicantID=" + result.ApplicantID;
                    }
                }
                else {
                    $("#pageloader").css("display", "none");
                    location.href = Application.options.errorPageurl;
                }
            },
            error: function (result) {
                $("#pageloader").css("display", "none");
                location.href = Application.options.errorPageurl;
            }
        });
        //}
        //else {
        //    $("#pageloader").css("display", "none");
        //    alert("You are not eligible to apply for this post.");
        //}
        //}
        $("#pageloader").css("display", "none");
    },
    calculateAge: function () {
        return 25;
    },
    validateApplicant: function (fields, isFromSave) {
        var strVal = "";
        var isValid = true;
        for (var field in fields) {
            if ($("#" + fields[field]["id"]).val() == null || $("#" + fields[field]["id"]).val() == "") {
                if (isValid) {
                    $("#" + fields[field]["id"]).focus();
                    isValid = false;
                }
                $("#" + fields[field]["id"]).addClass("error");
                strVal += enumeration.validationMessages.requiredVal.format(field) + "\n\n";
            }
            else {
                $("#" + fields[field]["id"]).removeClass("error");
            }
            if (isValid) {
                if ($("#" + fields[field]["id"]).val().length > Number(fields[field]["length"])) {
                    if (isValid) {
                        $("#" + fields[field]["id"]).focus();
                        isValid = false;
                    }
                    $("#" + fields[field]["id"]).addClass("error");
                    strVal += enumeration.validationMessages.maxlength.format(field, fields[field]["length"]) + "\n\n";
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
            }
        }
        if (strVal != "") { //isFromSave && 
            alert(strVal);
        }
        return isValid;
    },
    validateField: function (field) {
        if ($("#" + field).val() == null || $("#" + field).val() == "") {
            $("#" + field).addClass("error");
        }
        else {
            $("#" + field).removeClass("error");
        }
        if (field.toString().toLowerCase() == "txtemail") {
            if (!common.validateEmail($("#" + field).val())) {
                $("#" + field).addClass("error");
            }
            else {
                $("#" + field).removeClass("error");
            }
        }
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
        var array = [];
        if ($("#txtOrganization1").val() != undefined && $("#txtOrganization1").val() != "") {
            array.push({
                Key: "1",
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization1").val(), Designation: $("#txtDesignation1").val(), StartDate: Application.formatDate($("#txtStartDate1").val()), EndDate: Application.formatDate($("#txtEndDate1").val()), Sequence: 1 })
            });
        }
        if ($("#txtOrganization2").val() != undefined && $("#txtOrganization2").val() != "") {
            array.push({
                Key: "2",
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization2").val(), Designation: $("#txtDesignation2").val(), StartDate: Application.formatDate($("#txtStartDate2").val()), EndDate: Application.formatDate($("#txtEndDate2").val()), Sequence: 2 })
            });
        }
        if ($("#txtOrganization3").val() != undefined && $("#txtOrganization3").val() != "") {
            array.push({
                Key: "3",
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization3").val(), Designation: $("#txtDesignation3").val(), StartDate: Application.formatDate($("#txtStartDate3").val()), EndDate: Application.formatDate($("#txtEndDate3").val()), Sequence: 3 })
            });
        }
        if ($("#txtOrganization4").val() != undefined && $("#txtOrganization4").val() != "") {
            array.push({
                Key: "4",
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization4").val(), Designation: $("#txtDesignation4").val(), StartDate: Application.formatDate($("#txtStartDate4").val()), EndDate: Application.formatDate($("#txtEndDate4").val()), Sequence: 4 })
            });
        }
        if ($("#txtOrganization5").val() != undefined && $("#txtOrganization5").val() != "") {
            array.push({
                Key: "5",
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization5").val(), Designation: $("#txtDesignation5").val(), StartDate: Application.formatDate($("#txtStartDate5").val()), EndDate: Application.formatDate($("#txtEndDate5").val()), Sequence: 5 })
            });
        }
        if ($("#txtOrganization6").val() != undefined && $("#txtOrganization6").val() != "") {
            array.push({
                Key: "6",
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization6").val(), Designation: $("#txtDesignation6").val(), StartDate: Application.formatDate($("#txtStartDate6").val()), EndDate: Application.formatDate($("#txtEndDate6").val()), Sequence: 6 })
            });
        }
        return array;
    },
    validateExperienceDetail: function (list) {
        var isValid = true;
        if (list.length == 0) {
            isValid = false;
            alert("At least one expierience detail required.");
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
    }
}
