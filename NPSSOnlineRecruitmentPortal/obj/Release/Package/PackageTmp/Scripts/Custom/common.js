﻿var common = {
    options: {
        errorpageurl: ""
    },
    init: function () {
        $(document).ready(function () {
            $.ajaxSetup({
                cache: false,
                error: function (xhr, status, error) {
                    location.href = common.options.errorpageurl;
                }
            });
        });
    },
    validateEmail: function ($email) {
        var emailReg = enumeration.regEx.email;
        return emailReg.test($email);
    }
}