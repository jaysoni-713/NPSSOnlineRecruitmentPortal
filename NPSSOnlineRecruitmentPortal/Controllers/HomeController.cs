using NPSSOnlineRecruitmentPortal.Models;
using NPSSOnlineRecruitmentPortal.DBModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Elmah;
using Newtonsoft.Json;
using System.Data.SqlClient;
using System.Configuration;
using System.Net.Mail;
using System.IO;
using Microsoft.Reporting.WebForms;
using System.Threading.Tasks;

namespace NPSSOnlineRecruitmentPortal.Controllers
{
    public class HomeController : BaseController
    {
        NPSSOnlineRecruitmentPortal.DBModel.NPSSEntities context;
        List<ApplicantExperienceDetail> expdetail;
        List<ApplicationQualificationDetail> qualificationdetail;
        public ActionResult Index()
        {
            return View();
        }
        [HttpGet]
        public ActionResult Application(int postSelection = 0)
        {
            if (postSelection == 0)
            {
                return RedirectToAction("Index", "Home");
            }
            ViewBag.postSelection = Convert.ToString(postSelection);
            ApplicationViewModel applicationViewModel = new ApplicationViewModel();
            using (context = new DBModel.NPSSEntities())
            {
                applicationViewModel.QualificationTypeList = context.QualificationTypes.ToList();
                applicationViewModel.QualificationHeaderList = context.QualificationHeaders.ToList();
            }
            return View(applicationViewModel);
        }
        [HttpPost, ValidateInput(false)]
        public JsonResult Application(ApplicationViewModel objApplication)
        {
            int ApplicantID = 0;
            bool IsDuplicateFlag = false;
            string ApplicationNumber = string.Empty;
            try
            {
                using (context = new DBModel.NPSSEntities())
                {
                    if (objApplication != null)
                    {
                        var isDuplicated = context.ApplicantMasters.Where(x => x.Surname == objApplication.Surname && x.FirstName == objApplication.FirstName && x.LastName == objApplication.LastName
                                            && x.BirthDate == objApplication.BirthDate && x.MobileNumber == objApplication.MobileNumber && x.EmailId == objApplication.EmailId
                                            && (objApplication.postSelected == 1 ? x.IsAppliedForSupervisor : true)
                                            && (objApplication.postSelected == 2 ? x.ISAppliedForAsstAO : true)).FirstOrDefault();

                        if (isDuplicated == null)
                        {
                            #region "Save Basic details"

                            ApplicantMaster dbApplication = new ApplicantMaster()
                            {
                                Surname = objApplication.Surname.Trim(),
                                FirstName = objApplication.FirstName.Trim(),
                                LastName = objApplication.LastName.Trim(),
                                BirthDate = objApplication.BirthDate,
                                AgeOnApplicationDate = objApplication.AgeOnApplicationDate,
                                BirthPlaceVillage = objApplication.BirthPlaceVillage,
                                BirthPlaceCity = objApplication.BirthPlaceCity,
                                BirthPlaceState = objApplication.BirthPlaceState,
                                AadharCardNo = objApplication.AadharCardNo,
                                Address1 = objApplication.Address1,
                                Address2 = objApplication.Address2,
                                Address3 = objApplication.Address3,
                                MobileNumber = objApplication.MobileNumber,
                                EmailId = objApplication.EmailId,
                                Cast = objApplication.Cast,
                                SubCast = objApplication.SubCast,
                                ImagePath = objApplication.ImagePath,
                                IsAppliedForSupervisor = objApplication.IsAppliedForSupervisor,
                                SupervisorSeatNumber = objApplication.SupervisorSeatNumber,
                                ISAppliedForAsstAO = objApplication.ISAppliedForAsstAO,
                                AsstAOSeatNumber = objApplication.AsstAOSeatNumber,
                                Category = objApplication.Category,
                                MaritalStaus = objApplication.MaritalStaus,
                                Title = objApplication.Title,
                                Gender = objApplication.Gender,
                                City = objApplication.City.Trim(),
                                State = objApplication.State.Trim(),
                                PinCode = objApplication.PinCode,
                                District = objApplication.District.Trim(),
                                Taluka = objApplication.Taluka.Trim(),
                                Country = "INDIA",
                                CreatedDateTime = DateTime.Now
                            };
                            context.ApplicantMasters.Add(dbApplication);
                            context.SaveChanges();
                            ApplicantID = dbApplication.ApplicantID;
                            #endregion

                            #region "Save Qualification details"

                            if (dbApplication.ApplicantID > 0 && objApplication.QualificationDetails != null && objApplication.QualificationDetails.Count > 0)
                            {
                                foreach (var item in objApplication.QualificationDetails)
                                {
                                    ApplicantQualificationDetail dbQualification = new ApplicantQualificationDetail()
                                    {
                                        ApplicantID = dbApplication.ApplicantID,
                                        QualificationTypeID = Convert.ToInt32(item.Key.Split('_')[0]),
                                        QualificationHeaderID = Convert.ToInt32(item.Key.Split('_')[1]),
                                        Value = item.Value.ToString()
                                    };
                                    context.ApplicantQualificationDetails.Add(dbQualification);
                                    context.SaveChanges();
                                }
                            }

                            #endregion

                            #region "Save Experience details"

                            if (dbApplication.ApplicantID > 0 && objApplication.ExperienceDetails != null && objApplication.ExperienceDetails.Count > 0)
                            {
                                foreach (var item in objApplication.ExperienceDetails)
                                {
                                    var objval = JsonConvert.DeserializeObject<ApplicantExperienceDetail>(Convert.ToString(item.Value));
                                    ApplicantExperienceDetail dbExperience = new ApplicantExperienceDetail()
                                    {
                                        ApplicantID = dbApplication.ApplicantID,
                                        OrganizationName = objval.OrganizationName,
                                        Designation = objval.Designation,
                                        StartDate = objval.StartDate,
                                        EndDate = objval.EndDate,
                                        Sequence = Convert.ToInt32(objval.Sequence)
                                    };
                                    context.ApplicantExperienceDetails.Add(dbExperience);
                                    context.SaveChanges();
                                }
                            }

                            #endregion

                            context.UpdateApplicationIDByPost(dbApplication.ApplicantID, objApplication.postSelected);
                            Report("Application Form", dbApplication.ApplicantID, dbApplication.EmailId, objApplication.postSelected, dbApplication);
                        }
                        else
                        {
                            IsDuplicateFlag = true;
                            if (objApplication.postSelected == 1)
                            {
                                ApplicationNumber = isDuplicated.SupervisotApplicationID;
                            }
                            else if (objApplication.postSelected == 2)
                            {
                                ApplicationNumber = isDuplicated.AsstAOApplicationID;
                            }
                            else if (objApplication.postSelected == 3)
                            {
                                ApplicationNumber = isDuplicated.SupervisotApplicationID + "@_@" + isDuplicated.AsstAOApplicationID;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ErrorSignal.FromCurrentContext().Raise(ex);
                if (ApplicantID > 0)
                {
                    using (context = new DBModel.NPSSEntities())
                    {
                        context.DeleteApplicantDetails(ApplicantID);
                    }
                }
                return Json(new { IsSuccess = false, ApplicantID = ApplicantID, IsDuplicate = IsDuplicateFlag, ApplicationID = ApplicationNumber }, JsonRequestBehavior.AllowGet);
            }
            return Json(new { IsSuccess = true, ApplicantID = ApplicantID, IsDuplicate = IsDuplicateFlag, ApplicationID = ApplicationNumber }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Instructions()
        {
            return View();
        }

        public FileStreamResult GetInstructionsPDF()
        {
            FileStream fs = new FileStream(Server.MapPath("~/Content/PDF/AgatyaNiSuchna.pdf"), FileMode.Open, FileAccess.Read);
            return File(fs, "application/pdf");
        }

        public ActionResult PostSelection()
        {
            return View();
        }

        public ActionResult ApplicationSuccessful(int applicantID = 0)
        {
            ApplicantMaster applicantMaster = new ApplicantMaster();
            if (applicantID == 0)
            {
                return RedirectToAction("Index", "Home");
            }
            else if (applicantID > 0)
            {
                using (context = new DBModel.NPSSEntities())
                {
                    applicantMaster = context.ApplicantMasters.Where(x => x.ApplicantID == applicantID).FirstOrDefault();
                    if (applicantMaster == null)
                    {
                        return RedirectToAction("Index", "Error");
                    }
                }
            }
            return View(applicantMaster);
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        public ActionResult ThemeSamplePage()
        {
            return View();
        }

        public void Report(string fileName, int applicantID, string toMail, int postSelection, ApplicantMaster dbApplication)
        {
            List<ApplicantMaster> lstappmaster = new List<ApplicantMaster>();
            expdetail = new List<ApplicantExperienceDetail>();
            qualificationdetail = new List<ApplicationQualificationDetail>();

            using (context = new NPSSEntities())
            {
                lstappmaster = context.Database.SqlQuery<ApplicantMaster>("SP_GetApplicationDetail " + applicantID).ToList<ApplicantMaster>();
                expdetail = context.Database.SqlQuery<ApplicantExperienceDetail>("SP_ExpierienceDetail " + applicantID).ToList<ApplicantExperienceDetail>();
                qualificationdetail = context.Database.SqlQuery<ApplicationQualificationDetail>("SP_QualificationDetail " + applicantID).ToList<ApplicationQualificationDetail>();
            }

            if (postSelection == 1)
            {
                CreatePDF(fileName, lstappmaster, Server.MapPath("~/Report/ApplicantDetail.rdlc"), applicantID, toMail, "true", dbApplication, lstappmaster.FirstOrDefault().SupervisotApplicationID);
            }
            else if (postSelection == 2)
            {
                CreatePDF(fileName, lstappmaster, Server.MapPath("~/Report/ApplicantDetail.rdlc"), applicantID, toMail, "false", dbApplication, lstappmaster.FirstOrDefault().AsstAOApplicationID);
            }
            else if (postSelection == 3)
            {
                CreatePDF(fileName, lstappmaster, Server.MapPath("~/Report/ApplicantDetail.rdlc"), applicantID, toMail, "true", dbApplication, lstappmaster.FirstOrDefault().SupervisotApplicationID);
                CreatePDF(fileName, lstappmaster, Server.MapPath("~/Report/ApplicantDetail.rdlc"), applicantID, toMail, "false", dbApplication, lstappmaster.FirstOrDefault().AsstAOApplicationID);
            }

        }

        public void ReportDetail()
        {
            List<ApplicantMaster> lstappmaster = new List<ApplicantMaster>();
            ApplicantMaster dbApplication;
            using (context = new NPSSEntities())
            {
                lstappmaster = context.Database.SqlQuery<ApplicantMaster>("SP_GetApplicationDetail " + 6).ToList<ApplicantMaster>();
                expdetail = context.Database.SqlQuery<ApplicantExperienceDetail>("SP_ExpierienceDetail " + 6).ToList<ApplicantExperienceDetail>();
                qualificationdetail = context.Database.SqlQuery<ApplicationQualificationDetail>("SP_QualificationDetail " + 6).ToList<ApplicationQualificationDetail>();
                dbApplication = context.ApplicantMasters.Where(x => x.ApplicantID == 6).FirstOrDefault();
            }
            CreatePDF("Form", lstappmaster, Server.MapPath("~/Report/ApplicantDetail.rdlc"), 6, "", "true", dbApplication, dbApplication.SupervisotApplicationID);
        }

        private void CreatePDF(string fileName, List<ApplicantMaster> ds, string reportFileName, int applicantID, string toMail, string isSuperVisor, ApplicantMaster dbApplication, string ApplicationId)
        {
            // Create Report DataSource
            ReportDataSource rds = new ReportDataSource("DataSet1", ds);

            // Variables
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;


            // Setup the report viewer object and get the array of bytes
            ReportViewer viewer = new ReportViewer();
            viewer.ProcessingMode = ProcessingMode.Local;
            viewer.LocalReport.ReportPath = reportFileName;
            viewer.LocalReport.SetParameters(new ReportParameter("IsSupervisor", isSuperVisor));
            viewer.LocalReport.DataSources.Add(rds); // Add datasource here
            viewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SetSubDataSource);

            byte[] bytes = viewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
            //SendMailToMultipleUser(toMail, fileName, bytes, dbApplication, isSuperVisor, ApplicationId);

            Response.Buffer = true;
            Response.Clear();
            Response.ContentType = mimeType;
            Response.AddHeader("content-disposition", "attachment; filename=" + fileName + "." + extension);
            Response.BinaryWrite(bytes); // create the file
            Response.Flush(); // send it to the client to download
        }

        public void SetSubDataSource(object sender, SubreportProcessingEventArgs e)
        {
            e.DataSources.Add(new ReportDataSource("DataSet1", expdetail));
            e.DataSources.Add(new ReportDataSource("Qualification", qualificationdetail));
        }

        public static void SendMailToMultipleUser(string toemailid, string attachmentFileName, byte[] bytes, ApplicantMaster dbApplication, string isSuperVisor, string ApplicationId)
        {
            string UserName = ConfigurationManager.AppSettings["NetworkCredentialUserName"].ToString();
            string Password = ConfigurationManager.AppSettings["NetworkCredentialPassword"].ToString();
            string FromMail = ConfigurationManager.AppSettings["FromMail"].ToString();
            string subject = ConfigurationManager.AppSettings["Subject"].ToString();
            string body = ConfigurationManager.AppSettings["Body"].ToString();
            string message = body.Replace("@@NewLine", "<br />")
                .Replace("@@Name", dbApplication.Surname + " " + dbApplication.FirstName + " " + dbApplication.LastName)
                .Replace("@@Position", isSuperVisor == "true" ? "Supervisor (સુપરવાઇઝર)" : "Assistant Administration Officer (મદદનિશ શાસનાઅધિકારી)")
                .Replace("@@ApplicationNo", ApplicationId);
            string Host = ConfigurationManager.AppSettings["Host"].ToString();
            int Port = Convert.ToInt32(ConfigurationManager.AppSettings["Port"].ToString());

            MailMessage objEmail = new MailMessage();
            try
            {
                objEmail.From = new MailAddress(FromMail, UserName);

                objEmail.To.Add(toemailid);
                objEmail.Subject = subject;
                objEmail.Body = message;

                objEmail.IsBodyHtml = true;

                objEmail.Priority = MailPriority.Normal;

                Attachment att = new Attachment(new MemoryStream(bytes), attachmentFileName + ".pdf");
                objEmail.Attachments.Add(att);

                //Get appropriate SmtpSection for mail sending
                //SmtpSection smtpSection = GetSmtpSection(isSupportMail);
                SmtpClient smtpClient = new SmtpClient(Host, Port);
                smtpClient.Credentials = new System.Net.NetworkCredential(FromMail, Password);
                smtpClient.EnableSsl = true;
                smtpClient.Send(objEmail);
            }
            catch (Exception ex)
            {
                using (NPSSOnlineRecruitmentPortal.DBModel.NPSSEntities context = new NPSSEntities())
                {
                    EmailFailureBacklog logFailure = new EmailFailureBacklog();
                    logFailure.ApplicantID = dbApplication.ApplicantID;
                    logFailure.FailureReason = ex.Message;
                    context.EmailFailureBacklogs.Add(logFailure);
                    context.SaveChanges();
                }
            }
            finally
            {
                objEmail.Dispose();
            }
        }
    }
}