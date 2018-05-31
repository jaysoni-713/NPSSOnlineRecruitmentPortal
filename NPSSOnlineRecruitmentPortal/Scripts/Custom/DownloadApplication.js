var DownloadApp = {
    option: {
        downloadUrl: "",
        checkApplicanturl: ""
    },
    init: function () {
        $(document).ready(function () {
            $("#txtBirthDate").on("focusout", function () {
                if (!common.isValidDate($("#txtBirthDate").val())) {
                    $("#txtBirthDate").addClass("error");
                    $("#msgBirthDate").show();
                    $("#msgBirthDate").text("Enter valid birth date.");
                }
                else {
                    $("#msgBirthDate").hide();
                    $("#msgBirthDate").text("");
                    $("#txtBirthDate").removeClass("error");
                }
            });

            $("#txtApplicationNumber").on("focusout", function () {
                if ($("#txtApplicationNumber").val() == "") {
                    $("#txtApplicationNumber").addClass("error");
                    $("#msgApplicationNumber").show();
                    $("#msgApplicationNumber").text("Enter Application Number.");
                }
                else {
                    if ($("#txtApplicationNumber").val() != "" && $("#txtApplicationNumber").val().length < 7) {
                        $("#txtApplicationNumber").addClass("error");
                        $("#msgApplicationNumber").show();
                        $("#msgApplicationNumber").text("Application Number cannot be less than 7 characters.");
                    }
                    else {
                        $("#msgApplicationNumber").hide();
                        $("#msgApplicationNumber").text("");
                        $("#txtApplicationNumber").removeClass("error");
                    }
                }
            });

            $("#txtMobileNo").on("focusout", function () {
                if ($("#txtMobileNo").val() == "") {
                    $("#txtMobileNo").addClass("error");
                    $("#msgMobileNo").show();
                    $("#msgMobileNo").text("Enter Mobile Number.");
                }
                else {
                    if ($("#txtMobileNo").val() != "" && $("#txtMobileNo").val().length < 10) {
                        $("#txtMobileNo").addClass("error");
                        $("#msgMobileNo").show();
                        $("#msgMobileNo").text("Mobile Number cannot be less than 10 characters.");
                    }
                    else {
                        $("#msgMobileNo").hide();
                        $("#msgMobileNo").text("");
                        $("#txtMobileNo").removeClass("error");
                    }
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

    downloadApplication: function () {
        if (DownloadApp.validateFields()) {
            var data = JSON.stringify({ "appId": $("#txtApplicationNumber").val(), "birthdate": common.formatDate($("#txtBirthDate").val()), "mobile": $("#txtMobileNo").val() });
            $.ajax({
                url: DownloadApp.option.checkApplicanturl,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: data,
                type: "POST",
                success: function (result) {
                    if (result.IsSuccess) {
                        window.location.href = DownloadApp.option.downloadUrl + "?applicantId=" + result.applicantId + "&isSupervisor=" + result.isSupervisor;
                    }
                    else {
                        alert("There is no application available for given details.");
                    }
                }
            });
        }

    },
    validateFields: function () {
        var strVal = "";
        var isValid = true;
        if (!common.isValidDate($("#txtBirthDate").val())) {
            strVal += "Enter valid birth date.";
            $("#txtBirthDate").addClass("error");
            $("#msgBirthDate").show();
            $("#msgBirthDate").text("Enter valid birth date.");
            isValid = false;
        }
        else {
            $("#msgBirthDate").hide();
            $("#msgBirthDate").text("");
            $("#txtBirthDate").removeClass("error");
        }
        if ($("#txtApplicationNumber").val() == "") {
            strVal += "Enter Application Number.";
            $("#txtApplicationNumber").addClass("error");
            isValid = false;
        }
        else {
            if ($("#txtApplicationNumber").val() != "" && $("#txtApplicationNumber").val().length < 7) {
                strVal += "Application Number cannot be less than 7 characters";
                $("#txtApplicationNumber").addClass("error");
                isValid = false;
            }
            else {
                $("#txtApplicationNumber").removeClass("error");
            }
        }
        if ($("#txtMobileNo").val() == "") {
            strVal += "Enter Mobile Number.";
            $("#txtMobileNo").addClass("error");
            isValid = false;
        }
        else {
            if ($("#txtMobileNo").val() != "" && $("#txtMobileNo").val().length < 10) {
                strVal += "Mobile Number cannot be less than 10 characters";
                $("#txtMobileNo").addClass("error");
                isValid = false;
            }
            else {
                $("#txtMobileNo").removeClass("error");
            }
        }
        return isValid;
    }
}