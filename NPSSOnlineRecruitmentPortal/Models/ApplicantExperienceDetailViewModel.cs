using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NPSSOnlineRecruitmentPortal.Models
{
    public class ApplicantExperienceDetailViewModel
    {
        public int ApplicantEDID { get; set; }
        public int ApplicantID { get; set; }
        public string OrganizationName { get; set; }
        public string Designation { get; set; }
        public System.DateTime StartDate { get; set; }
        public System.DateTime EndDate { get; set; }
        public int Sequence { get; set; }
        public string Duration { get; set; }
    }
}