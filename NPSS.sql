USE [NPSS]
GO
/****** Object:  Table [dbo].[SupervisorQualificationDetails]    Script Date: 05/26/2018 14:17:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupervisorQualificationDetails](
	[SupervisorQDID] [int] NOT NULL,
	[SApplicantID] [int] NOT NULL,
	[QualificationTypeID] [int] NOT NULL,
	[QualificationHeaderID] [int] NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_SupervisorQualificationDetails] PRIMARY KEY CLUSTERED 
(
	[SupervisorQDID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SupervisorExperienceDetails]    Script Date: 05/26/2018 14:17:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupervisorExperienceDetails](
	[SupervisorEDID] [int] IDENTITY(1,1) NOT NULL,
	[SApplicantID] [int] NOT NULL,
	[OrganizationName] [nvarchar](250) NOT NULL,
	[Designation] [nvarchar](100) NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[Sequence] [int] NOT NULL,
 CONSTRAINT [PK_SupervisorExperienceDetails] PRIMARY KEY CLUSTERED 
(
	[SupervisorEDID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SupervisorApplicantMaster]    Script Date: 05/26/2018 14:17:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupervisorApplicantMaster](
	[SApplicantID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantSeatNumber] [nvarchar](50) NULL,
	[Surname] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[AgeOnApplicationDate] [date] NOT NULL,
	[BirthPlaceVillage] [nvarchar](50) NOT NULL,
	[BirthPlaceCity] [nvarchar](50) NOT NULL,
	[BirthPlaceState] [nvarchar](50) NOT NULL,
	[BirthPlaceCountry] [nvarchar](50) NOT NULL,
	[Address1] [nvarchar](250) NOT NULL,
	[Address2] [nvarchar](250) NOT NULL,
	[Address3] [nvarchar](250) NOT NULL,
	[MobileNumber] [int] NOT NULL,
	[EmailId] [nvarchar](100) NULL,
	[Cast] [nvarchar](50) NOT NULL,
	[SubCast] [nvarchar](50) NOT NULL,
	[ImagePath] [nvarchar](250) NULL,
 CONSTRAINT [PK_SupervisorApplicantMaster] PRIMARY KEY CLUSTERED 
(
	[SApplicantID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Supervisor]    Script Date: 05/26/2018 14:17:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supervisor](
	[NO_G] [float] NULL,
	[DATE_G] [datetime] NULL,
	[SURNAME_G] [nvarchar](255) NULL,
	[NAME_G] [nvarchar](255) NULL,
	[FNAME_G] [nvarchar](255) NULL,
	[ADDRESS_G] [nvarchar](255) NULL,
	[FULLNAME_G] [nvarchar](255) NULL,
	[NO_E] [float] NULL,
	[DATE_E] [datetime] NULL,
	[SURNAME_E] [nvarchar](255) NULL,
	[NAME_E] [nvarchar](255) NULL,
	[FNAME_E] [nvarchar](255) NULL,
	[BIRTHDATE] [datetime] NULL,
	[MBL_NO] [float] NULL,
	[EMAIL_ID] [nvarchar](255) NULL,
	[SEAT_NO] [nvarchar](50) NOT NULL,
	[TYPEOFPOST] [nvarchar](15) NULL,
	[NEWMBL_NO] [float] NULL,
	[NEWEMAIL_ID] [nvarchar](255) NULL,
 CONSTRAINT [PK_Supervisor] PRIMARY KEY CLUSTERED 
(
	[SEAT_NO] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (1, CAST(0x0000A51000000000 AS DateTime), N'ò™e', N'nu‚÷', N'rfþtuhfw{th', N'÷û{e¼wð™ BÞwr™.Mfq÷ Ët{u, ¾tu¾ht Ëfo÷,¾tu¾ht', N'ò™e  nu‚÷  rfþtuhfw{th', 1, CAST(0x0000A51000000000 AS DateTime), N'JANI', N'HETAL', N'KISHORKUMAR', CAST(0x000078C400000000 AS DateTime), 8141299292, NULL, N'S0001', N'સુપરવાઇઝર', 9865328956, N'test@gmail.com')
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (2, CAST(0x0000A51000000000 AS DateTime), N'þ{to', N'ÏÞtr‚', N'htsw÷fw{th', N'4/ r{÷t… V÷ux, yuË.ƒe.xÙMxðtze™e …tËu, ™ðtðtzs-13', N'þ{to  ÏÞtr‚  htsw÷fw{th', 2, CAST(0x0000A51000000000 AS DateTime), N'SHARMA', N'KHYATI', N'RAJULKUMAR', CAST(0x0000821B00000000 AS DateTime), 8347949437, N'khyatirsharma45@gmail.com', N'S0002', N'સુપરવાઇઝર', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (3, CAST(0x0000A51000000000 AS DateTime), N'…xu÷', N'«¿tuþfw{th', N'Œðt¼tE', N'„t{ {t™…wht …tu. Œþtu‚‚h …e™ 383230', N'…xu÷  «¿tuþfw{th  Œðt¼tE', 3, CAST(0x0000A51000000000 AS DateTime), N'PATEL', N'PRAGNESHKUMAR', N'DAVABHAI', CAST(0x00007F8200000000 AS DateTime), 8238737604, N'pragnesh06997@gmail.com', N'S0003', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (4, CAST(0x0000A51000000000 AS DateTime), N'Ëtu÷kfe', N'™huþfw{th', N'sÞkr‚÷t÷', N'80, fi÷tþÄt{ ËtuËtÞxe, òu„uïhe htuz, y{htEðtze,y{ŒtðtŒ-26', N'Ëtu÷kfe  ™huþfw{th  sÞkr‚÷t÷', 4, CAST(0x0000A51000000000 AS DateTime), N'SOLANKI', N'NARESHKUMAR', N'JAYANTILAL', CAST(0x00007A3000000000 AS DateTime), 7383912894, N'narsolanki.12@gmail.com', N'S0004', N'Supervisor', 9865328956, N'test2@gmail.com')
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (5, CAST(0x0000A51000000000 AS DateTime), N'«ò…r‚', N'yŠs‚t', N'÷e÷tÄh', N'105/871 r™{o÷ yu…txo{uLx, sÞ{k„÷ ƒeythxeyuË ƒË MxuLz, ™thý…wht', N'«ò…r‚  yŠs‚t  ÷e÷tÄh', 5, CAST(0x0000A51000000000 AS DateTime), N'PRAJAPATI', N'ARJITA', N'LILADHAR', CAST(0x00007A0900000000 AS DateTime), 9898989898, N'amitvadukar@gmail.com', N'S0005', N'Supervisor', 9865328956, N'test@gmail.com')
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (6, CAST(0x0000A51000000000 AS DateTime), N'rºtðuŒe', N'r«Þkffw{th', N'htsuLÿfw{th', N'{w.…tu.ðŒhtz, ‚t.«tkr‚s, S.ËtƒhftkXt …e™.383205', N'rºtðuŒe  r«Þkffw{th  htsuLÿfw{th', 6, CAST(0x0000A51000000000 AS DateTime), N'TRIVEDI', N'PRIYANKKUMAR', N'RAJENDRAKUMAR', CAST(0x00007E1C00000000 AS DateTime), 9429386050, N'priyanktrivedi23@gmail.com', N'S0006', N'Supervisor', 9865328956, N'test2@gmail.com')
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (7, CAST(0x0000A51000000000 AS DateTime), N'{eh', N'Ëçƒehfw{th ', N'„„t¼tE', N'yu/25 htuÞ÷ huËezuLËe rðò…wh htuz, Ë{e™w÷ fwht™e ƒtsw{tk yuz.…tuMx, Ëð„Z ‚t. ®n{‚™„h ËtƒhftkXt', N'{eh  Ëçƒehfw{th   „„t¼tE', 7, CAST(0x0000A51000000000 AS DateTime), N'MIR', N'SABBIRKUMAR', N'GAGABHAI', CAST(0x00007B6900000000 AS DateTime), 9726056486, NULL, N'S0007', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (8, CAST(0x0000A51000000000 AS DateTime), N'[tðzt', N'¼tðuþfw{th', N'ftkr‚¼tE', N'ƒe-129 ËhMð‚e™„h ËtuËtÞxe, ytE.ytu.Ëe.htuz, [tkŒ¾uzt', N'[tðzt  ¼tðuþfw{th  ftkr‚¼tE', 8, CAST(0x0000A51000000000 AS DateTime), N'CHAVDA', N'BHAVESH', N'KANTIBHAI', CAST(0x000082D600000000 AS DateTime), 9558464398, N'tobhaveshchavdaamca@gmail.com', N'S0008', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (9, CAST(0x0000A51000000000 AS DateTime), N'…xu÷', N'yþtuffw{th', N'…wY»ttu¥t{ŒtË', N'{w.…tu.fhý…wh, ‚t.®n{‚™„h, S. ËtƒhftkXt-383030', N'…xu÷  yþtuffw{th  …wY»ttu¥t{ŒtË', 9, CAST(0x0000A51000000000 AS DateTime), N'PATEL', N'ASHOKKUMAR', N'PURUSHOTTAMDAS', CAST(0x0000701900000000 AS DateTime), NULL, N'ashokpatel37287@gmail.com', N'S0009', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (10, CAST(0x0000A51300000000 AS DateTime), N'frzÞt', N'Ëus÷ƒu™', N'¼tE÷t÷¼tE', N'15/ƒe „tÞºte ËtuËtÞxe, Ënfthe S™ htuz, ®n{‚™„h', N'frzÞt  Ëus÷ƒu™  ¼tE÷t÷¼tE', 10, CAST(0x0000A51300000000 AS DateTime), N'KADIYA', N'SEJALBEN', N'BHAILALBHAI', NULL, 9624019165, N'sejal.kadiya@yahoo.com', N'S0010', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (11, CAST(0x0000A51300000000 AS DateTime), N'…h{th', N'f]ýt÷e', N'nh„tuð™¼tE', N'34,™u{e™tÚt …tfo,Ëe.yu{.Ëe.™e Ët{u, ytuZð, y{ŒtðtŒ-15', N'…h{th  f]ýt÷e  nh„tuð™¼tE', 11, CAST(0x0000A51300000000 AS DateTime), N'PARMAR', N'KRUNALIBEN', N'HARGOVANBHAI', CAST(0x00007FA000000000 AS DateTime), 7383642760, NULL, N'S0011', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (12, CAST(0x0000A51300000000 AS DateTime), N'òu»te', N'fts÷', N'ELÿðŒ™', N'ƒe-12 S™uïh™„h xu™t{uLx rð.1 Ë{…oý xtðh …tA¤, «¼t‚[tuf,hÒtt…tfo, ½tx÷tuzeÞt y{ŒtðtŒ-380061', N'òu»te  fts÷  ELÿðŒ™', 12, CAST(0x0000A51300000000 AS DateTime), N'JOSHI', N'KAJAL', N'INDRAVADAN', CAST(0x000078B500000000 AS DateTime), 8511191024, N'kajaljoshi101@gmail.com', N'S0012', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (13, CAST(0x0000A51300000000 AS DateTime), N'…kzÞt ', N'htsuLÿfw{th', N'ƒxwf¼tE', N'{w.…e…h¤t ‚t. ‚¤tò, S. ¼tð™„h …e™.364150', N'…kzÞt   htsuLÿfw{th  ƒxwf¼tE', 13, CAST(0x0000A51300000000 AS DateTime), N'PANDYA', N'RAJENDRAKUMAR', N'BATUKBHAI', CAST(0x00007B5A00000000 AS DateTime), 9428981872, N'rpandya9999@gmail.com', N'S0013', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (14, CAST(0x0000A51300000000 AS DateTime), N'Ëtu÷kfe', N'rn‚uþfw{th', N'{tun™÷t÷', N'¼e{htð™„h, {tuhƒe huÕðu Mxuþ™ …tA¤, {tuhƒe-363641', N'Ëtu÷kfe  rn‚uþfw{th  {tun™÷t÷', 14, CAST(0x0000A51300000000 AS DateTime), N'SOLANKI', N'HITESHKUMAR', N'MOHANLAL', CAST(0x00007CD200000000 AS DateTime), 9712028349, NULL, N'S0014', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (15, CAST(0x0000A51300000000 AS DateTime), N'f¼tu¤', N'S¿tuþfw{th', N'{„™¼tE', N'11, s÷tht{ ËtuËtÞxe {wðtzt {w.…tu. Ít÷tuŒ, S.ŒtntuŒ', N'f¼tu¤  S¿tuþfw{th  {„™¼tE', 15, CAST(0x0000A51300000000 AS DateTime), N'KAMOL', N'JIGNESHKUMAR', N'MAGANABHAI', CAST(0x0000714D00000000 AS DateTime), 9825533903, N'jigneshkamol@yahoo.in', N'S0015', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (16, CAST(0x0000A51300000000 AS DateTime), N'ztì.…h{th', N'{nuþfw{th', N' huðt¼tE', N'{w.…tu. z¼tz, ‚t. ¾uht÷w, S. {nuËtýt', N'ztì.…h{th  {nuþfw{th   huðt¼tE', 16, CAST(0x0000A51300000000 AS DateTime), N'DR. PARMAR', N'MAHESHKUMAR', N'REVABHAI', CAST(0x0000742800000000 AS DateTime), 9428717430, NULL, N'S0016', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (17, CAST(0x0000A51300000000 AS DateTime), N'þtn', N'Äht', N'{nuLÿfw{th', N'{w.…tu.[tuheðtzt, ‚t.Ezh S. ËtƒhftkXt …e™. 383440', N'þtn  Äht  {nuLÿfw{th', 17, CAST(0x0000A51300000000 AS DateTime), N'SHAH', N'DHARA', N'MAHENDRAKUMAR', CAST(0x00007E2600000000 AS DateTime), 9974816851, NULL, N'S0017', N'Supervisor', 8956238956, N'test2@gmail.com')
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (18, CAST(0x0000A51300000000 AS DateTime), N'„turn÷', N'[u‚™fw{th', N'h{uþ¼tE', N'62/1 ©e [t{wkzt r™ðtË, ykrƒftr™fu‚™ Ëtu. rŒðthtuz, ykf÷uïh …e™.393001', N'„turn÷  [u‚™fw{th  h{uþ¼tE', 18, CAST(0x0000A51300000000 AS DateTime), N'MOHIL', N'CHETANKUMAR', N'RAMESHBHAI', CAST(0x00007D5300000000 AS DateTime), 8141361194, N'psyrg@gmail.com', N'S0018', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (19, CAST(0x0000A51300000000 AS DateTime), N'htXtuz', N'htfuþfw{th', N'{nuþ¼tE', N'ze-9, yks™e ËtuËtÞxe, s™‚t™„h™e ƒtsw{t [tkŒ¾uzt, y{ŒtðtŒ 382424', N'htXtuz  htfuþfw{th  {nuþ¼tE', 19, CAST(0x0000A51300000000 AS DateTime), N'RATHOD', N'RAKESHKUMAR', N'MAHESHBHAI', CAST(0x0000765700000000 AS DateTime), 9510945482, N'rakesh.rathod4832@gmaiil.com', N'S0019', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (20, CAST(0x0000A51300000000 AS DateTime), N'htXtuz', N'sÞtuíË™tƒu™ ', N'rºt¼tuð™¼tE', N'{w.{tuZuht, ‚t. ƒu[htS, S.{nuËtýt, Xu.ytkƒuzfh™„h,(hturn‚ðtË) …e™.384212', N'htXtuz  sÞtuíË™tƒu™   rºt¼tuð™¼tE', 20, CAST(0x0000A51300000000 AS DateTime), N'RATHOD', N'JYOTSNABEN', N'TRIBHOVANBHAI', CAST(0x0000770300000000 AS DateTime), 8487980549, NULL, N'S0020', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (21, CAST(0x0000A51300000000 AS DateTime), N'þu¾', N'yçŒq÷hne{', N'yçŒq÷hnu{t™', N'42/yu, E{ŒtŒ™„h, ËiÞŒðtzek …tA¤ {¾Œq{™„h …tËu,ðxðt, y{ŒtðtŒ-382440 ', N'þu¾  yçŒq÷hne{  yçŒq÷hnu{t™', 21, CAST(0x0000A51300000000 AS DateTime), N'SHAIKH', N'ABDULRAHIM', N'ABDULRAHEMAN', CAST(0x0000630900000000 AS DateTime), 9725500750, N'a.rahim5700@gmail.com', N'S0021', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (22, CAST(0x0000A51300000000 AS DateTime), N'…xu÷', N'r™{o÷fw{th', N'{nuLÿ¼tE', N'{w.…tu.™ðt[thý„t{, ‚t.÷wýtðtzt, S.{rnËt„h …™e.389270', N'…xu÷  r™{o÷fw{th  {nuLÿ¼tE', 22, CAST(0x0000A51300000000 AS DateTime), N'PATEL', N'NIRMALKUMAR', N'MAHENDRAKUMAR', CAST(0x0000815600000000 AS DateTime), 7874175791, NULL, N'S0022', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (23, CAST(0x0000A51300000000 AS DateTime), N'«ò…r‚', N'™huLÿfw{th', N'Ä™S¼tE', N'{w.…ttu.„tuh÷, ‚t. Ezh, S. ËtƒhftkXt …e™.383410', N'«ò…r‚  ™huLÿfw{th  Ä™S¼tE', 23, CAST(0x0000A51300000000 AS DateTime), N'PRAJAPATI', N'NARENDRKUMAR', N'DHANAJIBHAI', CAST(0x00007DB700000000 AS DateTime), NULL, N'narendraprajapti75@gmail.com', N'S0023', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (24, CAST(0x0000A51300000000 AS DateTime), N'ðt½u÷t', N'hu¾tƒu™', N'÷t÷S¼tE', N'Äe rð™tÞf huËezuLËe htsÄt™e xu™t{uLx™e Ët{u, ç÷tuf ƒe.-203, y…oý Mfq÷ …tËu,  ð†t÷, y{ŒtðtŒ-382418', N'ðt½u÷t  hu¾tƒu™  ÷t÷S¼tE', 24, CAST(0x0000A51300000000 AS DateTime), N'VAGHELA', N'REKHABEN', N'LALJIBHAI', CAST(0x00006E9300000000 AS DateTime), 9974056218, NULL, N'S0024', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (25, CAST(0x0000A51300000000 AS DateTime), N'…xu÷', N'rn{uþfw{th', N'rð™tuŒ¼tE', N'Ëe-203, rËÂØ rð™tÞf huËezuLËe, Ëux{uhe Mfq÷™e …tËu, ™ðt™htuzt, y{ŒtðtŒ 382330', N'…xu÷  rn{uþfw{th  rð™tuŒ¼tE', 25, CAST(0x0000A51300000000 AS DateTime), N'PATEL', N'HIMESHKUMAR', N'VINODKUMAR', CAST(0x000078C200000000 AS DateTime), NULL, NULL, N'S0025', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (26, CAST(0x0000A51300000000 AS DateTime), N'…xu÷', N'rŒ™uþfw{th', N'ht{¼tE', N'{ww.yuhðtzt ‚t.…txze, S. ËwhuLÿ™„h …e™.382750', N'…xu÷  rŒ™uþfw{th  ht{¼tE', 26, CAST(0x0000A51300000000 AS DateTime), N'PATEL', N'DINESHKUMAR', N'RAMBHAI', CAST(0x000075FF00000000 AS DateTime), 9723550757, N'dpatel15@gmail.com', N'S0026', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (27, CAST(0x0000A51300000000 AS DateTime), N'Ëw‚heÞt', N'™er‚™fw{th ', N'ftÂL‚÷t÷', N'Ã÷tux ™k.3, ythËturzÞt htuz, f÷tu÷-382721', N'Ëw‚heÞt  ™er‚™fw{th   ftÂL‚÷t÷', 27, CAST(0x0000A51300000000 AS DateTime), N'SUTARIYA', N'NITINKUMR', N'KANTILAL', CAST(0x000074DA00000000 AS DateTime), 9428018325, N'nitinsutariya81@gmail.com', N'S0027', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (28, CAST(0x0000A51300000000 AS DateTime), N'[tiÄhe', N'rŒ™uþfw{th', N'ft¤w¼tE', N'©e yth.yu[.ò™e ®n„ðt÷t ntE..ƒztu÷e ‚t. Ezh S.ËtƒhftkXt …e™.383410', N'[tiÄhe  rŒ™uþfw{th  ft¤w¼tE', 28, CAST(0x0000A51300000000 AS DateTime), N'CHAUDHARY', N'DINESHKUMAR', N'KALUBHAI', CAST(0x00006D0600000000 AS DateTime), 9909589593, N'dkc13121975@gmail.com', N'S0028', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (29, CAST(0x0000A51300000000 AS DateTime), N'ŒuËtE', N'ò{t¼tE', N'ys{÷¼tE', N'7,r„hefwks Ëtu.rð¼t„-1 hðu[e [uBƒËo™e Ët{u, htsuLÿ…tfo htuz, ytuZð, y{ŒtðtŒ, …e™.382415', N'ŒuËtE  ò{t¼tE  ys{÷¼tE', 29, CAST(0x0000A51300000000 AS DateTime), N'DESAI', N'JAMABHAI', N'AJMALBHAI', CAST(0x0000730C00000000 AS DateTime), 9428474648, N'jamasir49@gmail.com', N'S0029', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (30, CAST(0x0000A51300000000 AS DateTime), N'ŒuËtE', N'ËkrŒ…fw{th ', N'ðt½S¼tE', N'ze.5/7 yðtË V÷ux, …tðt…whe [thhM‚t ½tx÷tuzeÞt, y{ŒtðtŒ-380061', N'ŒuËtE  ËkrŒ…fw{th   ðt½S¼tE', 30, CAST(0x0000A51300000000 AS DateTime), N'DESAI', N'SANDIPKUMAR', N'VAGHJIBHAI', CAST(0x00007F7300000000 AS DateTime), 9998150286, N'sandipshekha05@gmail.com', N'S0030', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (31, CAST(0x0000A51300000000 AS DateTime), N'ðt½u÷t', N'Þtu„uLÿ', N'y{]‚÷t÷', N'Ëe-246, ËhMð‚e™„h ËtuËtÞxe, ytE.ytu.Ëe. htuz, [tkŒ¾uzt, y{ŒtðtŒ-382424', N'ðt½u÷t  Þtu„uLÿ  y{]‚÷t÷', 31, CAST(0x0000A51300000000 AS DateTime), N'VAGHELA', N'YOGENDRA', N'AMRUTLAL', CAST(0x00007D1300000000 AS DateTime), 9016250251, N'drims_yash@yahoo.com', N'S0031', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (32, CAST(0x0000A51300000000 AS DateTime), N'{uzt', N'Ëwhuþ¼tE', N'nhËª„¼tE', N'{w.…tuu.¼tXeðtzt ‚t.S.ŒtntuŒ', N'{uzt  Ëwhuþ¼tE  nhËª„¼tE', 32, CAST(0x0000A51300000000 AS DateTime), N'MEDA', N'SURESHBHAI', N'HARSINGHBHAI', CAST(0x0000715B00000000 AS DateTime), 9662480480, NULL, N'S0032', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (33, CAST(0x0000A51300000000 AS DateTime), N'…xu÷', N'ò„]r‚ ', N'nhS¼tE', N'Ëe-96, ftiþÕÞ ƒkø÷tuÍ,y™{tu÷ ntix÷ Ët{u, fze fÕÞtý…wht htuz,™t™efze …e™.382715', N'…xu÷  ò„]r‚   nhS¼tE', 33, CAST(0x0000A51300000000 AS DateTime), N'PATEL', N'JAGRUTI', N'HARJIBHAI', CAST(0x00006FA500000000 AS DateTime), 9737372475, NULL, N'S0033', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (34, CAST(0x0000A51300000000 AS DateTime), N'[tintý', N'[u‚™fw{th', N'„ý…‚¼tE', N'yuV.04, ©e™kŒ™„h rð-4, Ëtu™÷ rË™u{t htuz, ðus÷…wh, y{ŒtðtŒ-51', N'[tintý  [u‚™fw{th  „ý…‚¼tE', 34, CAST(0x0000A51300000000 AS DateTime), N'CHAUHAN', N'CHETANKUMAR', N'GANPATBHAI', CAST(0x0000769900000000 AS DateTime), 9898466762, N'chetanchauhan16283@gmail.com', N'S0034', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (35, CAST(0x0000A51300000000 AS DateTime), N'…xu÷', N'Vw÷[kŒ¼tE', N'Eïh¼tE', N'{w.…tu. ËŒqÚt÷t. ‚t.rðË™„h, S. {nuËtýt Xu.™ðt…ht{t …e™.384315', N'…xu÷  Vw÷[kŒ¼tE  Eïh¼tE', 35, CAST(0x0000A51300000000 AS DateTime), N'PATEL', N'PHULCHANDBHAI', N'ISHWARBHAI', CAST(0x000070B700000000 AS DateTime), 9409134640, N'pfulchand@yahoo.com', N'S0035', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (36, CAST(0x0000A51300000000 AS DateTime), N'{fðtýt', N'rð…w÷fw{th', N'sÞuþ¼tE', N'11, {ntðeh™„h ËtuËt. AeË™„h ÷ªf htuz, {nuËtýt 384001', N'{fðtýt  rð…w÷fw{th  sÞuþ¼tE', 36, CAST(0x0000A51300000000 AS DateTime), N'MAKWANA', N'VIPULKUMAR', N'JAYESHBHAI', CAST(0x0000794800000000 AS DateTime), 8866568557, N'vipuranavat@gmail.com', N'S0036', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (37, CAST(0x0000A51300000000 AS DateTime), N'Ëtu™e', N'S‚uLÿfw{th', N'ht{÷t÷', N'{w.…tu.…wkËhe, ‚t. ‚÷tuŒ S. ËtƒhftkXt …e™.383307', N'Ëtu™e  S‚uLÿfw{th  ht{÷t÷', 37, CAST(0x0000A51300000000 AS DateTime), N'SONI', N'JITENDAKUMAR', N'RAMLAL', CAST(0x0000764300000000 AS DateTime), 9998765962, N'jitendra982@yahoo.com', N'S0037', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (38, CAST(0x0000A51300000000 AS DateTime), N'¼è', N'nrhrËØ', N'Þtu„uþ¼tE', N'¼è ƒk„÷tu, ðis™tÚt {ntŒuð …tËu,{nwÄt-387335', N'¼è  nrhrËØ  Þtu„uþ¼tE', 38, CAST(0x0000A51300000000 AS DateTime), N'BHATT', N'HARISIDDH', N'YOGESHBHAI', CAST(0x00007F7D00000000 AS DateTime), 8980329697, NULL, N'S0038', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (39, CAST(0x0000A51300000000 AS DateTime), N'…xu÷', N'®fs÷ƒu™ ', N'hrËf¼tE', N'13, …xu÷ðtË, „uhe…wht „t{, ‚t. ŒM¢tuE, S. y{ŒtðtŒ …e™.382435', N'…xu÷  ®fs÷ƒu™   hrËf¼tE', 39, CAST(0x0000A51300000000 AS DateTime), N'PATEL', N'KINJALBEN', N'RASIKBHAI', CAST(0x0000801F00000000 AS DateTime), 9909917002, N'dhaval290688@gmail.com', N'S0039', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (40, CAST(0x0000A51300000000 AS DateTime), N'ŒuËtE', N'rðsÞfw{th', N'ht{S¼tE', N'8 Ërð™Þ ËtuËtÞxe rðË™„h ÷ªf htuz, {nuËtýt …e™.384001', N'ŒuËtE  rðsÞfw{th  ht{S¼tE', 40, CAST(0x0000A51300000000 AS DateTime), N'DESAI', N'VIJAYKUMAR', N'RAMAJIBHAI', CAST(0x00007B1000000000 AS DateTime), 9427682376, N'vijaydesai4798@gmail.com', N'S0040', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (41, CAST(0x0000A51300000000 AS DateTime), N'ÔÞtË', N'{Þkffw{th', N'{wfuþ¼tE', N'E-10 Þtu„uïh yu…txo{uLx ðus÷…wh, y{ŒtðtŒ-51', N'ÔÞtË  {Þkffw{th  {wfuþ¼tE', 41, CAST(0x0000A51300000000 AS DateTime), N'VYAS', N'MAYANKKUMAR', N'MUKESHBHI', CAST(0x00007A1B00000000 AS DateTime), 9429029902, N'vyasmayank93@yahoo.co.in', N'S0041', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (42, CAST(0x0000A51300000000 AS DateTime), N'…h{th', N'fwËw{ƒu™ ', N'ftÂL‚÷t÷', N'21,yþtuf™„h ËtuËtÞxe, hts…wh, „tu{‚e…wh, y{ŒtðtŒ-21', N'…h{th  fwËw{ƒu™   ftÂL‚÷t÷', 42, CAST(0x0000A51300000000 AS DateTime), N'PARMAR', N'KUSUMEN', N'KANTILAL', CAST(0x000070F700000000 AS DateTime), 9904663957, NULL, N'S0042', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (43, CAST(0x0000A51300000000 AS DateTime), N'òu»te', N'[tkŒ™e', N'htsuLÿfw{th', N'™{oŒt™„h S.yu™.yuV.Ëe. MxÙex-25, Äh ™k 10 ¼Y[', N'òu»te  [tkŒ™e  htsuLÿfw{th', 43, CAST(0x0000A51300000000 AS DateTime), N'JOSHI', N'CHANDANIBEN', N'RAJENDRAKUMAR', CAST(0x00007C4300000000 AS DateTime), 8128409287, NULL, N'S0043', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (44, CAST(0x0000A51300000000 AS DateTime), N'{uhò', N'þþeftk‚', N'ƒtƒw÷t÷', N'ykƒtr{fu™ef …tA¤, ŒqÄhus htuz, frzÞt ËtuËtÞxe™e ƒtsw{tk ËwhuLÿ™„h-363001', N'{uhò  þþeftk‚  ƒtƒw÷t÷', 44, CAST(0x0000A51300000000 AS DateTime), N'MERJA', N'SHASHIKANT', N'BABULAL', CAST(0x00007AD400000000 AS DateTime), 9913439459, N'veermerja.189@gmail.com', N'S0044', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (45, CAST(0x0000A51300000000 AS DateTime), N'®Ën', N'htsuïhe', N'ƒúúñ[the', N'yu[.10,rfhexÄt{ ËtuËtÞxe, ðtðtu÷, „tkÄe™„h,382016', N'®Ën  htsuïhe  ƒúúñ[the', 45, CAST(0x0000A51300000000 AS DateTime), N'SINGH', N'RAJESHWARI', N'BRAMHACHARI', CAST(0x00007ED000000000 AS DateTime), 9825345636, N'rajeshwari.singh193@gmail.com', N'S0045', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (46, CAST(0x0000A51300000000 AS DateTime), N'…xu÷', N'nhuþfw{th', N'{tðS¼tE', N'ƒe.123, ™t÷kŒt-h xtW™þe… {t÷…wh htuz, {tuztËt', N'…xu÷  nhuþfw{th  {tðS¼tE', 46, CAST(0x0000A51300000000 AS DateTime), N'PATEL', N'HARESHUKUMAR', N'MAVJIBHAI', CAST(0x00006F9C00000000 AS DateTime), 9925076579, N'h.m.patel1978@gmail.com', N'S0046', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (47, CAST(0x0000A51300000000 AS DateTime), N'ŒuËtE', N'rðsÞfw{th', N'ÄehS¼tE', N'ze-8-yu, ytðtË V÷ux …tðt…whe [th hM‚t ½tx÷tuzeÞt, y{ŒtðtŒ', N'ŒuËtE  rðsÞfw{th  ÄehS¼tE', 47, CAST(0x0000A51300000000 AS DateTime), N'DESAI', N'VIJAYKUMAR', N'DHIRJIBHAI', CAST(0x0000806800000000 AS DateTime), 9978279921, N'vijayrbr@gmail.com', N'S0047', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (48, CAST(0x0000A51300000000 AS DateTime), N'…xu÷', N'{tir÷ffw{th ', N'yþtuf¼tE', N'{w.…tu. fwfhðtzt, „ý…r‚™„h, ‚t. rðò…wh, S. {nuËtýt …e™.382830', N'…xu÷  {tir÷ffw{th   yþtuf¼tE', 48, CAST(0x0000A51300000000 AS DateTime), N'PATEL', N'MAULIKKUMAR', N'ASHOKBHAI', CAST(0x00007FED00000000 AS DateTime), 9427681089, N'maulikpatel310889@gmaili.com', N'S0048', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (49, CAST(0x0000A51300000000 AS DateTime), N'…he¾', N'r™¾e÷fw{th ', N'ztÌtt÷t÷', N'Ã÷tux ™k.1271/yu.h Ëufxh-3 yu, „tkÄe™„h 382006', N'…he¾  r™¾e÷fw{th   ztÌtt÷t÷', 49, CAST(0x0000A51300000000 AS DateTime), N'PARIKH', N'NIKHILKUMAR', N'DAHYALAL', CAST(0x00007B7900000000 AS DateTime), 9428420935, N'nikhil.1986@yahoo.com', N'S0049', N'Supervisor', NULL, NULL)
INSERT [dbo].[Supervisor] ([NO_G], [DATE_G], [SURNAME_G], [NAME_G], [FNAME_G], [ADDRESS_G], [FULLNAME_G], [NO_E], [DATE_E], [SURNAME_E], [NAME_E], [FNAME_E], [BIRTHDATE], [MBL_NO], [EMAIL_ID], [SEAT_NO], [TYPEOFPOST], [NEWMBL_NO], [NEWEMAIL_ID]) VALUES (50, CAST(0x0000A51300000000 AS DateTime), N'…xu÷', N'Äð÷', N'[kÿftL‚', N'59, r[ºtfwx ËtuËtÞxe, {ntðeh™„h, ®n{‚™„h, ËtƒhftkXt 383001', N'…xu÷  Äð÷  [kÿftL‚', 50, CAST(0x0000A51300000000 AS DateTime), N'PATEL', N'DHAVAL', N'CHANDRAKANT', CAST(0x00007CFC00000000 AS DateTime), 9428768359, N'patel.dhaval59@gmail.com', N'S0050', N'Supervisor', NULL, NULL)
/****** Object:  Table [dbo].[QualificationType]    Script Date: 05/26/2018 14:17:07 ******/
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QualificationHeader]    Script Date: 05/26/2018 14:17:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QualificationHeader](
	[QualificationHeaderID] [int] IDENTITY(1,1) NOT NULL,
	[QualificationHeader] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_QualificationHeader] PRIMARY KEY CLUSTERED 
(
	[QualificationHeaderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AsstAOQualificationDetails]    Script Date: 05/26/2018 14:17:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AsstAOQualificationDetails](
	[AsstAOQDID] [int] IDENTITY(1,1) NOT NULL,
	[AAOApplicantID] [int] NOT NULL,
	[QualificationTypeID] [int] NOT NULL,
	[QualificationHeaderID] [int] NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_AsstAOQualificationDetails] PRIMARY KEY CLUSTERED 
(
	[AsstAOQDID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AsstAOExperienceDetails]    Script Date: 05/26/2018 14:17:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AsstAOExperienceDetails](
	[AsstAOEDID] [int] IDENTITY(1,1) NOT NULL,
	[AAOApplicantID] [int] NOT NULL,
	[OrganizationName] [nvarchar](250) NOT NULL,
	[Designation] [nvarchar](100) NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[Sequence] [int] NOT NULL,
 CONSTRAINT [PK_AsstAOExperienceDetails] PRIMARY KEY CLUSTERED 
(
	[AsstAOEDID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AsstAOApplicantMaster]    Script Date: 05/26/2018 14:17:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AsstAOApplicantMaster](
	[AAOApplicantID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantSeatNumber] [nvarchar](50) NULL,
	[Surname] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[AgeOnApplicationDate] [date] NOT NULL,
	[BirthPlaceVillage] [nvarchar](50) NOT NULL,
	[BirthPlaceCity] [nvarchar](50) NOT NULL,
	[BirthPlaceState] [nvarchar](50) NOT NULL,
	[BirthPlaceCountry] [nvarchar](50) NOT NULL,
	[Address1] [nvarchar](250) NOT NULL,
	[Address2] [nvarchar](250) NOT NULL,
	[Address3] [nvarchar](250) NOT NULL,
	[MobileNumber] [int] NOT NULL,
	[EmailId] [nvarchar](100) NULL,
	[Cast] [nvarchar](50) NOT NULL,
	[SubCast] [nvarchar](50) NOT NULL,
	[ImagePath] [nvarchar](250) NULL,
 CONSTRAINT [PK_AsstAOApplicantMaster] PRIMARY KEY CLUSTERED 
(
	[AAOApplicantID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantQualificationDetails]    Script Date: 05/26/2018 14:17:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantQualificationDetails](
	[ApplicantQDID] [int] NOT NULL,
	[ApplicantID] [int] NOT NULL,
	[QualificationTypeID] [int] NOT NULL,
	[QualificationHeaderID] [int] NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ApplicantQualificationDetails] PRIMARY KEY CLUSTERED 
(
	[ApplicantQDID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantMaster]    Script Date: 05/26/2018 14:17:07 ******/
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
	[BirthPlaceCountry] [nvarchar](50) NOT NULL,
	[Address1] [nvarchar](250) NOT NULL,
	[Address2] [nvarchar](250) NOT NULL,
	[Address3] [nvarchar](250) NOT NULL,
	[MobileNumber] [int] NOT NULL,
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
 CONSTRAINT [PK_ApplicantMaster] PRIMARY KEY CLUSTERED 
(
	[ApplicantID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantExperienceDetails]    Script Date: 05/26/2018 14:17:07 ******/
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
