using Elmah;
using NPSSOnlineRecruitmentPortal.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace NPSSOnlineRecruitmentPortal
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
        protected void Application_Error(object sender, EventArgs e)
        {
            var httpContext = ((MvcApplication)sender).Context;
            var ex = Server.GetLastError();
            ErrorSignal.FromCurrentContext().Raise(ex);
            if (ex is HttpException)
            {
                var httpEx = ex as HttpException;
            }
            var controller = new ErrorController();
            httpContext.ClearError();
            httpContext.Response.Clear();
            httpContext.Response.ContentType = "text/html";
            httpContext.Response.StatusCode = 500;
            httpContext.Response.TrySkipIisCustomErrors = true;

            var routeData = new RouteData();
            routeData.Values["controller"] = "Error";
            routeData.Values["action"] = "Index";
            ((IController)controller).Execute(new RequestContext(new HttpContextWrapper(httpContext), routeData));
        }
    }
}
