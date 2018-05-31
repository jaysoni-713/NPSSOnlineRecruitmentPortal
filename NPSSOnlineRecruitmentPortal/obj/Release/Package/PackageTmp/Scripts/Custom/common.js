var common = {
    options: {
        errorpageurl: ""
    },
    init: function () {
        $(document).ready(function () {
            $.ajaxSetup({
                cache: false,
                error: function (xhr, status, error) {
                    $("#pageloader").css("display", "none");
                    location.href = common.options.errorpageurl;
                }
            });

            $('.numberinput').keydown(function (e) {
                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
                    (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                    (e.keyCode >= 35 && e.keyCode <= 40)) {
                    return;
                }
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            });
        });
    },
    validateEmail: function ($email) {
        var emailReg = enumeration.regEx.email;
        return emailReg.test($email);
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