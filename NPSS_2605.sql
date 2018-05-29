USE [NPSS]
GO
/****** Object:  Table [dbo].[QualificationType]    Script Date: 26-May-18 11:08:15 PM ******/
DROP TABLE [dbo].[QualificationType]
GO
/****** Object:  Table [dbo].[QualificationHeader]    Script Date: 26-May-18 11:08:15 PM ******/
DROP TABLE [dbo].[QualificationHeader]
GO
/****** Object:  Table [dbo].[ApplicantQualificationDetails]    Script Date: 26-May-18 11:08:15 PM ******/
DROP TABLE [dbo].[ApplicantQualificationDetails]
GO
/****** Object:  Table [dbo].[ApplicantMaster]    Script Date: 26-May-18 11:08:15 PM ******/
DROP TABLE [dbo].[ApplicantMaster]
GO
/****** Object:  Table [dbo].[ApplicantExperienceDetails]    Script Date: 26-May-18 11:08:15 PM ******/
DROP TABLE [dbo].[ApplicantExperienceDetails]
GO
/****** Object:  Table [dbo].[ApplicantExperienceDetails]    Script Date: 26-May-18 11:08:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantExperienceDetails](
	[ApplicantEDID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantID] [int] NOT NULL,
	[OrganizationName] [nvarchar](250) NOT NULL,
	[Designation] [nvarchar](100) NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[Sequence] [int] NOT NULL,
 CONSTRAINT [PK_ApplicantExperienceDetails] PRIMARY KEY CLUSTERED 
(
	[ApplicantEDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApplicantMaster]    Script Date: 26-May-18 11:08:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantMaster](
	[ApplicantID] [int] IDENTITY(1,1) NOT NULL,
	[Surname] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[AgeOnApplicationDate] [date] NOT NULL,
	[BirthPlaceVillage] [nvarchar](50) NOT NULL,
	[BirthPlaceCity] [nvarchar](50) NOT NULL,
	[BirthPlaceState] [nvarchar](50) NOT NULL,
	[Address1] [nvarchar](250) NOT NULL,
	[Address2] [nvarchar](250) NOT NULL,
	[Address3] [nvarchar](250) NOT NULL,
	[MobileNumber] [bigint] NOT NULL,
	[EmailId] [nvarchar](100) NULL,
	[Cast] [nvarchar](50) NULL,
	[SubCast] [nvarchar](50) NULL,
	[Category] [nvarchar](50) NOT NULL,
	[MaritalStaus] [nvarchar](50) NOT NULL,
	[ImagePath] [nvarchar](250) NULL,
	[IsAppliedForSupervisor] [bit] NOT NULL,
	[SupervisorSeatNumber] [nvarchar](100) NULL,
	[ISAppliedForAsstAO] [bit] NOT NULL,
	[AsstAOSeatNumber] [nvarchar](100) NULL,
	[Title] [nvarchar](10) NOT NULL,
	[Gender] [nvarchar](10) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[State] [nvarchar](50) NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[District] [nvarchar](100) NOT NULL,
	[Taluka] [nvarchar](100) NOT NULL,
	[PinCode] [int] NOT NULL,
 CONSTRAINT [PK_ApplicantMaster] PRIMARY KEY CLUSTERED 
(
	[ApplicantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApplicantQualificationDetails]    Script Date: 26-May-18 11:08:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantQualificationDetails](
	[ApplicantQDID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantID] [int] NOT NULL,
	[QualificationTypeID] [int] NOT NULL,
	[QualificationHeaderID] [int] NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[OtherQualificationName] [nvarchar](250) NULL,
 CONSTRAINT [PK_ApplicantQualificationDetails] PRIMARY KEY CLUSTERED 
(
	[ApplicantQDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QualificationHeader]    Script Date: 26-May-18 11:08:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QualificationHeader](
	[QualificationHeaderID] [int] IDENTITY(1,1) NOT NULL,
	[QualificationHeader] [nvarchar](100) NOT NULL,
	[FIELDTYPE] [bit] NOT NULL,
 CONSTRAINT [PK_QualificationHeader] PRIMARY KEY CLUSTERED 
(
	[QualificationHeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QualificationType]    Script Date: 26-May-18 11:08:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QualificationType](
	[QualificationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[QualificationType] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_QualificationType] PRIMARY KEY CLUSTERED 
(
	[QualificationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[ApplicantExperienceDetails] ON 

GO
INSERT [dbo].[ApplicantExperienceDetails] ([ApplicantEDID], [ApplicantID], [OrganizationName], [Designation], [StartDate], [EndDate], [Sequence]) VALUES (1, 8, N'CD', N'SD', CAST(0xFC330B00 AS Date), CAST(0xC9350B00 AS Date), 1)
GO
SET IDENTITY_INSERT [dbo].[ApplicantExperienceDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[ApplicantMaster] ON 

GO
INSERT [dbo].[ApplicantMaster] ([ApplicantID], [Surname], [FirstName], [LastName], [BirthDate], [AgeOnApplicationDate], [BirthPlaceVillage], [BirthPlaceCity], [BirthPlaceState], [Address1], [Address2], [Address3], [MobileNumber], [EmailId], [Cast], [SubCast], [Category], [MaritalStaus], [ImagePath], [IsAppliedForSupervisor], [SupervisorSeatNumber], [ISAppliedForAsstAO], [AsstAOSeatNumber], [Title], [Gender], [City], [State], [Country], [District], [Taluka], [PinCode]) VALUES (8, N'SONI', N'JAY', N'D', CAST(0xDA3D0B00 AS Date), CAST(0x00000000 AS Date), N'ABAD', N'ABAD', N'ABAD', N'ABAD', N'ABAD', N'ABAD', 1234567890, N'ABAD@AA.COM', NULL, NULL, N'General', N'Married', NULL, 1, NULL, 1, NULL, N'Mr.', N'Male', N'ABAD', N'GUJARAT', N'INDIA', N'ABAD', N'ABAD', 0)
GO
INSERT [dbo].[ApplicantMaster] ([ApplicantID], [Surname], [FirstName], [LastName], [BirthDate], [AgeOnApplicationDate], [BirthPlaceVillage], [BirthPlaceCity], [BirthPlaceState], [Address1], [Address2], [Address3], [MobileNumber], [EmailId], [Cast], [SubCast], [Category], [MaritalStaus], [ImagePath], [IsAppliedForSupervisor], [SupervisorSeatNumber], [ISAppliedForAsstAO], [AsstAOSeatNumber], [Title], [Gender], [City], [State], [Country], [District], [Taluka], [PinCode]) VALUES (9, N'SONI', N'JAY', N'D', CAST(0xDA3D0B00 AS Date), CAST(0x00000000 AS Date), N'ABAD', N'ABAD', N'ABAD', N'ABAD', N'ABAD', N'ABAD', 1234567890, N'AA@AA.COM', NULL, NULL, N'General', N'Married', NULL, 1, NULL, 0, NULL, N'Mr.', N'Male', N'ABAD', N'GUJARAT', N'INDIA', N'ABAD', N'ABAD', 0)
GO
SET IDENTITY_INSERT [dbo].[ApplicantMaster] OFF
GO
SET IDENTITY_INSERT [dbo].[ApplicantQualificationDetails] ON 

GO
INSERT [dbo].[ApplicantQualificationDetails] ([ApplicantQDID], [ApplicantID], [QualificationTypeID], [QualificationHeaderID], [Value], [OtherQualificationName]) VALUES (8, 8, 1, 1, N'2014', NULL)
GO
INSERT [dbo].[ApplicantQualificationDetails] ([ApplicantQDID], [ApplicantID], [QualificationTypeID], [QualificationHeaderID], [Value], [OtherQualificationName]) VALUES (9, 8, 1, 2, N'GECG', NULL)
GO
INSERT [dbo].[ApplicantQualificationDetails] ([ApplicantQDID], [ApplicantID], [QualificationTypeID], [QualificationHeaderID], [Value], [OtherQualificationName]) VALUES (10, 8, 1, 3, N'1', NULL)
GO
INSERT [dbo].[ApplicantQualificationDetails] ([ApplicantQDID], [ApplicantID], [QualificationTypeID], [QualificationHeaderID], [Value], [OtherQualificationName]) VALUES (11, 8, 1, 4, N'100', NULL)
GO
INSERT [dbo].[ApplicantQualificationDetails] ([ApplicantQDID], [ApplicantID], [QualificationTypeID], [QualificationHeaderID], [Value], [OtherQualificationName]) VALUES (12, 8, 1, 5, N'100', NULL)
GO
INSERT [dbo].[ApplicantQualificationDetails] ([ApplicantQDID], [ApplicantID], [QualificationTypeID], [QualificationHeaderID], [Value], [OtherQualificationName]) VALUES (13, 8, 1, 6, N'100', NULL)
GO
INSERT [dbo].[ApplicantQualificationDetails] ([ApplicantQDID], [ApplicantID], [QualificationTypeID], [QualificationHeaderID], [Value], [OtherQualificationName]) VALUES (14, 8, 1, 7, N'PASS', NULL)
GO
SET IDENTITY_INSERT [dbo].[ApplicantQualificationDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[QualificationHeader] ON 

GO
INSERT [dbo].[QualificationHeader] ([QualificationHeaderID], [QualificationHeader], [FIELDTYPE]) VALUES (1, N'PASSING YEAR', 1)
GO
INSERT [dbo].[QualificationHeader] ([QualificationHeaderID], [QualificationHeader], [FIELDTYPE]) VALUES (2, N'INSTITUTE NAME', 0)
GO
INSERT [dbo].[QualificationHeader] ([QualificationHeaderID], [QualificationHeader], [FIELDTYPE]) VALUES (3, N'NOOFTRIALS', 1)
GO
INSERT [dbo].[QualificationHeader] ([QualificationHeaderID], [QualificationHeader], [FIELDTYPE]) VALUES (4, N'TOTALMARKS', 1)
GO
INSERT [dbo].[QualificationHeader] ([QualificationHeaderID], [QualificationHeader], [FIELDTYPE]) VALUES (5, N'MARKS', 1)
GO
INSERT [dbo].[QualificationHeader] ([QualificationHeaderID], [QualificationHeader], [FIELDTYPE]) VALUES (6, N'PERCENTAGE', 1)
GO
INSERT [dbo].[QualificationHeader] ([QualificationHeaderID], [QualificationHeader], [FIELDTYPE]) VALUES (7, N'REMARKS', 0)
GO
SET IDENTITY_INSERT [dbo].[QualificationHeader] OFF
GO
SET IDENTITY_INSERT [dbo].[QualificationType] ON 

GO
INSERT [dbo].[QualificationType] ([QualificationTypeID], [QualificationType]) VALUES (1, N'H.S.C/S.S.C')
GO
INSERT [dbo].[QualificationType] ([QualificationTypeID], [QualificationType]) VALUES (2, N'Graduation')
GO
INSERT [dbo].[QualificationType] ([QualificationTypeID], [QualificationType]) VALUES (3, N'Post Graduation')
GO
INSERT [dbo].[QualificationType] ([QualificationTypeID], [QualificationType]) VALUES (4, N'B.ED/B.T/S.C.T/D.T')
GO
INSERT [dbo].[QualificationType] ([QualificationTypeID], [QualificationType]) VALUES (5, N'CCC+ AND CCC')
GO
INSERT [dbo].[QualificationType] ([QualificationTypeID], [QualificationType]) VALUES (6, N'OTHER')
GO
SET IDENTITY_INSERT [dbo].[QualificationType] OFF
GO
