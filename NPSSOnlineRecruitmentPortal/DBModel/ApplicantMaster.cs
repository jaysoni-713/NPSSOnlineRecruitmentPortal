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
    
    public partial class ApplicantMaster
    {
        public int ApplicantID { get; set; }
        public string Surname { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public System.DateTime BirthDate { get; set; }
        public System.DateTime AgeOnApplicationDate { get; set; }
        public string BirthPlaceVillage { get; set; }
        public string BirthPlaceCity { get; set; }
        public string BirthPlaceState { get; set; }
        public string AadharCardNo { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Address3 { get; set; }
        public long MobileNumber { get; set; }
        public string EmailId { get; set; }
        public string Cast { get; set; }
        public string SubCast { get; set; }
        public string Category { get; set; }
        public string MaritalStaus { get; set; }
        public string ImagePath { get; set; }
        public bool IsAppliedForSupervisor { get; set; }
        public string SupervisotApplicationID { get; set; }
        public string SupervisorSeatNumber { get; set; }
        public bool ISAppliedForAsstAO { get; set; }
        public string AsstAOApplicationID { get; set; }
        public string AsstAOSeatNumber { get; set; }
        public string Title { get; set; }
        public string Gender { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Country { get; set; }
        public string District { get; set; }
        public string Taluka { get; set; }
        public int PinCode { get; set; }
        public Nullable<System.DateTime> CreatedDateTime { get; set; }
    }
}
