using Elmah;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace NPSSOnlineRecruitmentPortal.Controllers
{
    public class BaseController : Controller
    {
        protected override void OnException(ExceptionContext filterContext)
        {
            ErrorSignal.FromCurrentContext().Raise(filterContext.Exception);
        }
    }
}