//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace NPSSOnlineRecruitmentPortal.DBModel
{
    using System;
    using System.Collections.Generic;
    
    public partial class ApplicantQualificationDetail
    {
        public int ApplicantQDID { get; set; }
        public int ApplicantID { get; set; }
        public int QualificationTypeID { get; set; }
        public int QualificationHeaderID { get; set; }
        public string Value { get; set; }
        public string OtherQualificationName { get; set; }
    }
}