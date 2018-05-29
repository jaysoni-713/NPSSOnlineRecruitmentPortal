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
            $("#modal-center").modal({
                backdrop: 'static',
                keyboard: false,
                show: false
            })
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
        if (Application.validateApplicant(enumeration.requiredFields, true) && Application.validateExperienceDetail(ExperienceDetail)) {
            if (Application.options.ApplicantAge >= 25 && Application.options.ApplicantAge <= 45) {
                $("#modal-center").modal("show");
            }
            else {
                alert("You are not eligible to apply for this post.");
            }
        }
    },
    addBasicDetails: function () {
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
            Surname: $("#txtSurname").val(),
            FirstName: $("#txtFirstName").val(),
            LastName: $("#txtLastName").val(),
            BirthDate: $("#txtBirthDt").val(),
            AgeOnApplicationDate: Application.calculateAge(),
            BirthPlaceVillage: $("#txtBirthVillage").val(),
            BirthPlaceCity: $("#txtBirthCity").val(),
            BirthPlaceState: $("#txtBirthState").val(),
            AadharCardNo: $("#txtAadharCard").val(),
            Address1: $("#txtAddress1").val(),
            Address2: $("#txtAddress2").val(),
            Address3: $("#txtAddress3").val(),
            MobileNumber: $("#txtMobileNo").val(),
            EmailId: $("#txtEmail").val(),
            Cast: "",
            SubCast: "",
            ImagePath: "",
            IsAppliedForSupervisor: isAppliedforSupervisor,
            ISAppliedForAsstAO: isAppliedForAsstAO,
            Category: $("#ddlCategory").val(),
            MaritalStaus: $("#ddlMaritalStaus").val(),
            Title: $("#ddlSalute").val(),
            Gender: $("#ddlGender").val(),
            City: $("#ddlAddressCity").val(),
            District: $("#txtdistrict").val(),
            Taluka: $("#txttaluka").val(),
            PinCode: $("#txtPIN").val(),
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
            async: false,
            dataType: "json",
            type: "POST",
            success: function (result) {
                if (result.IsSuccess) {
                    if (result.IsDuplicate) {
                        alert("You are already applied for the selected post. Your application number is " + result.ApplicationID.replace("@_@", " & ") + ".");
                    }
                    else {
                        location.href = Application.options.applicationsuccessful + "?applicantID=" + result.ApplicantID;
                    }
                }
                else {
                    location.href = Application.options.errorPageurl;
                }
            },
            error: function (result) {
                location.href = Application.options.errorPageurl;
            }
        });
        //    }
        //    else {
        //        alert("You are not eligible to apply for this post.");
        //    }
        //}
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
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization1").val(), Designation: $("#txtDesignation1").val(), StartDate: $("#txtStartDate1").val(), EndDate: $("#txtEndDate1").val(), Sequence: 1 })
            });
        }
        if ($("#txtOrganization2").val() != undefined && $("#txtOrganization2").val() != "") {
            array.push({
                Key: "2",
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization2").val(), Designation: $("#txtDesignation2").val(), StartDate: $("#txtStartDate2").val(), EndDate: $("#txtEndDate2").val(), Sequence: 2 })
            });
        }
        if ($("#txtOrganization3").val() != undefined && $("#txtOrganization3").val() != "") {
            array.push({
                Key: "3",
                Value: JSON.stringify({ OrganizationName: $("#txtOrganization3").val(), Designation: $("#txtDesignation3").val(), StartDate: $("#txtStartDate3").val(), EndDate: $("#txtEndDate3").val(), Sequence: 3 })
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

        //var yearNow = now.getFullYear();
        //var monthNow = now.getMonth();
        //var dateNow = now.getDate();
        var yearNow = "2018";
        var monthNow = "06";
        var dateNow = "01";
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
    }
}
