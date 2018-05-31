using NPSSOnlineRecruitmentPortal.DBModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NPSSOnlineRecruitmentPortal.Models
{
    public class ApplicationViewModel
    {
        public int ApplicantID { get; set; }
        public int postSelected { get; set; }
        public string Surname { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public System.DateTime BirthDate { get; set; }
        public System.DateTime AgeOnApplicationDate { get; set; }
        public string BirthPlaceVillage { get; set; }
        public string BirthPlaceCity { get; set; }
        public string BirthPlaceState { get; set; }
        public string AadharCardNo { get; set; }
        public bool PhysicalDisability { get; set; }
        public int DisabilityPercentage { get; set; }
        public bool IsMSBEmp { get; set; }
        public bool IsAMCEmp { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Address3 { get; set; }
        public Int64 MobileNumber { get; set; }
        public string EmailId { get; set; }
        public string Cast { get; set; }
        public string SubCast { get; set; }
        public bool IsAppliedForSupervisor { get; set; }
        public string SupervisorSeatNumber { get; set; }
        public bool ISAppliedForAsstAO { get; set; }
        public string AsstAOSeatNumber { get; set; }
        public string Category { get; set; }
        public string MaritalStaus { get; set; }
        public string Title { get; set; }
        public string Gender { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Country { get; set; }
        public string District { get; set; }
        public string Taluka { get; set; }
        public int PinCode { get; set; }
        public byte[] photo { get; set; }
        public byte[] signature { get; set; }
        public List<QualificationType> QualificationTypeList { get; set; }
        public List<QualificationHeader> QualificationHeaderList { get; set; }
        public Dictionary<string, object> QualificationDetails { get; set; }
        public Dictionary<string, object> ExperienceDetails { get; set; }
    }
}