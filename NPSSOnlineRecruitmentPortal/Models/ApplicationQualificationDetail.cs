using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NPSSOnlineRecruitmentPortal.Models
{
    public class ApplicationQualificationDetail
    {
        public string PASSINGYEAR { get; set; }
        public string INSTITUTENAME { get; set; }
        public string NOOFTRIALS { get; set; }
        public string TOTALMARKS { get; set; }
        public string MARKS { get; set; }
        public string PERCENTAGE { get; set; }
        public string EXAMNAME { get; set; }
        public string QualificationType { get; set; }
        public int ApplicantID { get; set; }
        public int QualificationTypeID { get; set; }
    }
}