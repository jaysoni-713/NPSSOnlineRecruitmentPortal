using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(NPSSOnlineRecruitmentPortal.Startup))]
namespace NPSSOnlineRecruitmentPortal
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
