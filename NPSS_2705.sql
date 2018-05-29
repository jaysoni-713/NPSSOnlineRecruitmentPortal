USE [NPSS]
GO
ALTER TABLE [dbo].[ELMAH_Error] DROP CONSTRAINT [DF_ELMAH_Error_ErrorId]
GO
/****** Object:  Index [PK_ELMAH_Error]    Script Date: 28-May-18 12:54:44 AM ******/
ALTER TABLE [dbo].[ELMAH_Error] DROP CONSTRAINT [PK_ELMAH_Error]
GO
/****** Object:  Table [dbo].[QualificationHeader]    Script Date: 28-May-18 12:54:44 AM ******/
DROP TABLE [dbo].[QualificationHeader]
GO
/****** Object:  Table [dbo].[ELMAH_Error]    Script Date: 28-May-18 12:54:44 AM ******/
DROP TABLE [dbo].[ELMAH_Error]
GO
/****** Object:  StoredProcedure [dbo].[SP_QualificationDetail]    Script Date: 28-May-18 12:54:44 AM ******/
DROP PROCEDURE [dbo].[SP_QualificationDetail]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetApplicationDetail]    Script Date: 28-May-18 12:54:44 AM ******/
DROP PROCEDURE [dbo].[SP_GetApplicationDetail]
GO
/****** Object:  StoredProcedure [dbo].[SP_ExpierienceDetail]    Script Date: 28-May-18 12:54:44 AM ******/
DROP PROCEDURE [dbo].[SP_ExpierienceDetail]
GO
/****** Object:  StoredProcedure [dbo].[ELMAH_LogError]    Script Date: 28-May-18 12:54:44 AM ******/
DROP PROCEDURE [dbo].[ELMAH_LogError]
GO
/****** Object:  StoredProcedure [dbo].[ELMAH_GetErrorXml]    Script Date: 28-May-18 12:54:44 AM ******/
DROP PROCEDURE [dbo].[ELMAH_GetErrorXml]
GO
/****** Object:  StoredProcedure [dbo].[ELMAH_GetErrorsXml]    Script Date: 28-May-18 12:54:44 AM ******/
DROP PROCEDURE [dbo].[ELMAH_GetErrorsXml]
GO
/****** Object:  StoredProcedure [dbo].[ELMAH_GetErrorsXml]    Script Date: 28-May-18 12:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ELMAH_GetErrorsXml]
(
    @Application NVARCHAR(60),
    @PageIndex INT = 0,
    @PageSize INT = 15,
    @TotalCount INT OUTPUT
)
AS 

    SET NOCOUNT ON

    DECLARE @FirstTimeUTC DATETIME
    DECLARE @FirstSequence INT
    DECLARE @StartRow INT
    DECLARE @StartRowIndex INT

    SELECT 
        @TotalCount = COUNT(1) 
    FROM 
        [ELMAH_Error]
    WHERE 
        [Application] = @Application

    -- Get the ID of the first error for the requested page

    SET @StartRowIndex = @PageIndex * @PageSize + 1

    IF @StartRowIndex <= @TotalCount
    BEGIN

        SET ROWCOUNT @StartRowIndex

        SELECT  
            @FirstTimeUTC = [TimeUtc],
            @FirstSequence = [Sequence]
        FROM 
            [ELMAH_Error]
        WHERE   
            [Application] = @Application
        ORDER BY 
            [TimeUtc] DESC, 
            [Sequence] DESC

    END
    ELSE
    BEGIN

        SET @PageSize = 0

    END

    -- Now set the row count to the requested page size and get
    -- all records below it for the pertaining application.

    SET ROWCOUNT @PageSize

    SELECT 
        errorId     = [ErrorId], 
        application = [Application],
        host        = [Host], 
        type        = [Type],
        source      = [Source],
        message     = [Message],
        [user]      = [User],
        statusCode  = [StatusCode], 
        time        = CONVERT(VARCHAR(50), [TimeUtc], 126) + 'Z'
    FROM 
        [ELMAH_Error] error
    WHERE
        [Application] = @Application
    AND
        [TimeUtc] <= @FirstTimeUTC
    AND 
        [Sequence] <= @FirstSequence
    ORDER BY
        [TimeUtc] DESC, 
        [Sequence] DESC
    FOR
        XML AUTO


GO
/****** Object:  StoredProcedure [dbo].[ELMAH_GetErrorXml]    Script Date: 28-May-18 12:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ELMAH_GetErrorXml]
(
    @Application NVARCHAR(60),
    @ErrorId UNIQUEIDENTIFIER
)
AS

    SET NOCOUNT ON

    SELECT 
        [AllXml]
    FROM 
        [ELMAH_Error]
    WHERE
        [ErrorId] = @ErrorId
    AND
        [Application] = @Application


GO
/****** Object:  StoredProcedure [dbo].[ELMAH_LogError]    Script Date: 28-May-18 12:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ELMAH_LogError]
(
    @ErrorId UNIQUEIDENTIFIER,
    @Application NVARCHAR(60),
    @Host NVARCHAR(30),
    @Type NVARCHAR(100),
    @Source NVARCHAR(60),
    @Message NVARCHAR(500),
    @User NVARCHAR(50),
    @AllXml NTEXT,
    @StatusCode INT,
    @TimeUtc DATETIME
)
AS

    SET NOCOUNT ON

    INSERT
    INTO
        [ELMAH_Error]
        (
            [ErrorId],
            [Application],
            [Host],
            [Type],
            [Source],
            [Message],
            [User],
            [AllXml],
            [StatusCode],
            [TimeUtc]
        )
    VALUES
        (
            @ErrorId,
            @Application,
            @Host,
            @Type,
            @Source,
            @Message,
            @User,
            @AllXml,
            @StatusCode,
            @TimeUtc
        )


GO
/****** Object:  StoredProcedure [dbo].[SP_ExpierienceDetail]    Script Date: 28-May-18 12:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_ExpierienceDetail]
	@ApplicantID INT
AS
BEGIN
	SELECT * FROM ApplicantExperienceDetails WHERE ApplicantID = @ApplicantID
	ORDER BY Sequence
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetApplicationDetail]    Script Date: 28-May-18 12:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetApplicationDetail]
	@ApplicantID int
AS
BEGIN
	SELECT 
	M.ApplicantID,
	M.Surname,
	M.FirstName,
	M.LastName,
	M.BirthDate,
	M.AgeOnApplicationDate,
	M.BirthPlaceVillage,
	M.BirthPlaceCity,
	M.BirthPlaceState,
	M.Address1,
	M.Address2,
	M.Address3,
	M.MobileNumber,
	M.EmailId,
	M.[Cast],
	M.SubCast,
	M.Category,
	M.MaritalStaus,
	M.ImagePath,
	M.IsAppliedForSupervisor,
	M.SupervisorSeatNumber,
	M.ISAppliedForAsstAO,
	M.AsstAOSeatNumber,
	M.Title,
	M.Gender,
	M.City,
	M.[State],
	M.Country,
	M.District,
	M.Taluka,
	M.PinCode
	 FROM ApplicantMaster M
	JOIN ApplicantQualificationDetails Q ON M.ApplicantID = Q.ApplicantID
	JOIN ApplicantExperienceDetails E ON M.ApplicantID = E.ApplicantID
	WHERE M.ApplicantID = @ApplicantID
END

GO
/****** Object:  StoredProcedure [dbo].[SP_QualificationDetail]    Script Date: 28-May-18 12:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- EXEC [SP_QualificationDetail] 8
-- =============================================
CREATE PROCEDURE [dbo].[SP_QualificationDetail]
	@ApplicantID int
AS
BEGIN
	DECLARE @ColumnName AS NVARCHAR(MAX),
@strQuery AS NVARCHAR(MAX) = ''


SELECT @ColumnName= ISNULL(@ColumnName + ',','') 
       + QUOTENAME(ReportName)
FROM (SELECT ReportName FROM QualificationHeader) AS QualificationHeader  

print @ColumnName

SET @strQuery = 'SELECT * FROM
(SELECT 
	Q.ApplicantID,
	--H.QualificationHeaderID,
	H.ReportName,
	T.QualificationTypeID,
	T.QualificationType,
	Q.Value
	--,Q.OtherQualificationName
	 FROM ApplicantQualificationDetails Q
	JOIN QualificationHeader H ON H.QualificationHeaderID = Q.QualificationHeaderID
	JOIN QualificationType T ON T.QualificationTypeID = Q.QualificationTypeID
	WHERE Q.ApplicantID = 8
	) AS T PIVOT(MAX(T.[Value]) FOR T.ReportName 
	IN (' + @ColumnName + ')) AS Pivottable'

EXEC sp_executesql @strQuery
END

GO
/****** Object:  Table [dbo].[ELMAH_Error]    Script Date: 28-May-18 12:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ELMAH_Error](
	[ErrorId] [uniqueidentifier] NOT NULL,
	[Application] [nvarchar](60) NOT NULL,
	[Host] [nvarchar](50) NOT NULL,
	[Type] [nvarchar](100) NOT NULL,
	[Source] [nvarchar](60) NOT NULL,
	[Message] [nvarchar](500) NOT NULL,
	[User] [nvarchar](50) NOT NULL,
	[StatusCode] [int] NOT NULL,
	[TimeUtc] [datetime] NOT NULL,
	[Sequence] [int] IDENTITY(1,1) NOT NULL,
	[AllXml] [ntext] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QualificationHeader]    Script Date: 28-May-18 12:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QualificationHeader](
	[QualificationHeaderID] [int] IDENTITY(1,1) NOT NULL,
	[QualificationHeader] [nvarchar](100) NOT NULL,
	[FIELDTYPE] [bit] NOT NULL,
	[ReportName] [nvarchar](100) NULL,
 CONSTRAINT [PK_QualificationHeader] PRIMARY KEY CLUSTERED 
(
	[QualificationHeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[ELMAH_Error] ON 

GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'b23978d1-a46b-452d-bef8-4ab008b23877', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC00C5CEB5 AS DateTime), 1, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)"
  time="2018-05-26T12:00:11.6982356Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application\2" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="62292" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'e0889823-d4f1-46c5-8787-7483954fb995', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC00C5CFC0 AS DateTime), 2, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-26T12:00:12.5854714Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application\2" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="62292" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'c3544a2f-c141-4d6d-85fc-f419dd0f52bc', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC00C5CFC6 AS DateTime), 3, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-26T12:00:12.6077760Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application\2" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="62292" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'5e6fd388-8d5a-4121-8664-bb63bce0f34b', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC00C667EC AS DateTime), 4, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)"
  time="2018-05-26T12:02:22.4414895Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CACHE_CONTROL:max-age=0&#xD;&#xA;HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Cache-Control: max-age=0&#xD;&#xA;Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application\2" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="62296" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="HTTP_CACHE_CONTROL">
      <value
        string="max-age=0" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'113e0331-e572-4aba-a55d-d292fddc0754', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC00C66802 AS DateTime), 5, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-26T12:02:22.5130657Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CACHE_CONTROL:max-age=0&#xD;&#xA;HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Cache-Control: max-age=0&#xD;&#xA;Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application\2" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="62296" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="HTTP_CACHE_CONTROL">
      <value
        string="max-age=0" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'2b9484f5-78bf-424f-a3fb-9f3d1c5d820c', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC00C6680B AS DateTime), 6, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-26T12:02:22.5419451Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CACHE_CONTROL:max-age=0&#xD;&#xA;HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Cache-Control: max-age=0&#xD;&#xA;Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application\2" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="62296" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="HTTP_CACHE_CONTROL">
      <value
        string="max-age=0" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'0e43418c-6165-4da5-9bcd-babc0c1895c6', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC00C6BF08 AS DateTime), 7, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)"
  time="2018-05-26T12:03:36.7730925Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CACHE_CONTROL:max-age=0&#xD;&#xA;HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Cache-Control: max-age=0&#xD;&#xA;Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application\2" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="62303" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="HTTP_CACHE_CONTROL">
      <value
        string="max-age=0" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'6d9aa802-a466-4b39-982f-35d39bffd2e8', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.ComponentModel.Win32Exception', N'', N'Access is denied', N'', 0, CAST(0x0000A8ED00AB3E8E AS DateTime), 23, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.ComponentModel.Win32Exception"
  message="Access is denied"
  detail="System.Data.Entity.Core.EntityException: The underlying provider failed on Open. ---&gt; System.Data.SqlClient.SqlException: A network-related or instance-specific error occurred while establishing a connection to SQL Server. The server was not found or was not accessible. Verify that the instance name is correct and that SQL Server is configured to allow remote connections. (provider: Named Pipes Provider, error: 40 - Could not open a connection to SQL Server) ---&gt; System.ComponentModel.Win32Exception: Access is denied&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at System.Data.SqlClient.SqlInternalConnectionTds..ctor(DbConnectionPoolIdentity identity, SqlConnectionString connectionOptions, SqlCredential credential, Object providerInfo, String newPassword, SecureString newSecurePassword, Boolean redirectedUserInstance, SqlConnectionString userConnectionOptions, SessionData reconnectSessionData, DbConnectionPool pool, String accessToken, Boolean applyTransientFaultHandling)&#xD;&#xA;   at System.Data.SqlClient.SqlConnectionFactory.CreateConnection(DbConnectionOptions options, DbConnectionPoolKey poolKey, Object poolGroupProviderInfo, DbConnectionPool pool, DbConnection owningConnection, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionFactory.CreatePooledConnection(DbConnectionPool pool, DbConnection owningObject, DbConnectionOptions options, DbConnectionPoolKey poolKey, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.CreateObject(DbConnection owningObject, DbConnectionOptions userOptions, DbConnectionInternal oldConnection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.UserCreateRequest(DbConnection owningObject, DbConnectionOptions userOptions, DbConnectionInternal oldConnection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.TryGetConnection(DbConnection owningObject, UInt32 waitForMultipleObjectsTimeout, Boolean allowCreate, Boolean onlyOneCheckConnection, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.TryGetConnection(DbConnection owningObject, TaskCompletionSource`1 retry, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionFactory.TryGetConnection(DbConnection owningConnection, TaskCompletionSource`1 retry, DbConnectionOptions userOptions, DbConnectionInternal oldConnection, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionInternal.TryOpenConnectionInternal(DbConnection outerConnection, DbConnectionFactory connectionFactory, TaskCompletionSource`1 retry, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.TryOpenInner(TaskCompletionSource`1 retry)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.TryOpen(TaskCompletionSource`1 retry)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.Open()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.&lt;&gt;c__DisplayClass1.&lt;Execute&gt;b__0()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.EntityClient.EntityConnection.Open()&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at System.Data.Entity.Core.EntityClient.EntityConnection.Open()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.EnsureConnection()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteInTransaction[T](Func`1 func, IDbExecutionStrategy executionStrategy, Boolean startLocalTransaction, Boolean releaseConnectionOnSuccess)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.&lt;&gt;c__DisplayClassb.&lt;GetResults&gt;b__9()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.GetResults(Nullable`1 forMergeOption)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.&lt;System.Collections.Generic.IEnumerable&lt;T&gt;.GetEnumerator&gt;b__0()&#xD;&#xA;   at System.Lazy`1.CreateValue()&#xD;&#xA;   at System.Lazy`1.LazyInitValue()&#xD;&#xA;   at System.Data.Entity.Internal.LazyEnumerator`1.MoveNext()&#xD;&#xA;   at System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)&#xD;&#xA;   at System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Application(Int32 postSelection) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 31&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)"
  time="2018-05-27T10:23:28.9001515Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CACHE_CONTROL:max-age=0&#xD;&#xA;HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Cache-Control: max-age=0&#xD;&#xA;Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="postSelection=2" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="50342" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="HTTP_CACHE_CONTROL">
      <value
        string="max-age=0" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
  <queryString>
    <item
      name="postSelection">
      <value
        string="2" />
    </item>
  </queryString>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'4f34620b-eaed-47bb-b71e-1c5d1d342f40', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.ComponentModel.Win32Exception', N'', N'Access is denied', N'', 0, CAST(0x0000A8ED00AB422E AS DateTime), 24, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.ComponentModel.Win32Exception"
  message="Access is denied"
  detail="System.Data.Entity.Core.EntityException: The underlying provider failed on Open. ---&gt; System.Data.SqlClient.SqlException: A network-related or instance-specific error occurred while establishing a connection to SQL Server. The server was not found or was not accessible. Verify that the instance name is correct and that SQL Server is configured to allow remote connections. (provider: Named Pipes Provider, error: 40 - Could not open a connection to SQL Server) ---&gt; System.ComponentModel.Win32Exception: Access is denied&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at System.Data.SqlClient.SqlInternalConnectionTds..ctor(DbConnectionPoolIdentity identity, SqlConnectionString connectionOptions, SqlCredential credential, Object providerInfo, String newPassword, SecureString newSecurePassword, Boolean redirectedUserInstance, SqlConnectionString userConnectionOptions, SessionData reconnectSessionData, DbConnectionPool pool, String accessToken, Boolean applyTransientFaultHandling)&#xD;&#xA;   at System.Data.SqlClient.SqlConnectionFactory.CreateConnection(DbConnectionOptions options, DbConnectionPoolKey poolKey, Object poolGroupProviderInfo, DbConnectionPool pool, DbConnection owningConnection, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionFactory.CreatePooledConnection(DbConnectionPool pool, DbConnection owningObject, DbConnectionOptions options, DbConnectionPoolKey poolKey, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.CreateObject(DbConnection owningObject, DbConnectionOptions userOptions, DbConnectionInternal oldConnection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.UserCreateRequest(DbConnection owningObject, DbConnectionOptions userOptions, DbConnectionInternal oldConnection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.TryGetConnection(DbConnection owningObject, UInt32 waitForMultipleObjectsTimeout, Boolean allowCreate, Boolean onlyOneCheckConnection, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.TryGetConnection(DbConnection owningObject, TaskCompletionSource`1 retry, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionFactory.TryGetConnection(DbConnection owningConnection, TaskCompletionSource`1 retry, DbConnectionOptions userOptions, DbConnectionInternal oldConnection, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionInternal.TryOpenConnectionInternal(DbConnection outerConnection, DbConnectionFactory connectionFactory, TaskCompletionSource`1 retry, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.TryOpenInner(TaskCompletionSource`1 retry)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.TryOpen(TaskCompletionSource`1 retry)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.Open()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.&lt;&gt;c__DisplayClass1.&lt;Execute&gt;b__0()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.EntityClient.EntityConnection.Open()&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at System.Data.Entity.Core.EntityClient.EntityConnection.Open()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.EnsureConnection()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteInTransaction[T](Func`1 func, IDbExecutionStrategy executionStrategy, Boolean startLocalTransaction, Boolean releaseConnectionOnSuccess)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.&lt;&gt;c__DisplayClassb.&lt;GetResults&gt;b__9()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.GetResults(Nullable`1 forMergeOption)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.&lt;System.Collections.Generic.IEnumerable&lt;T&gt;.GetEnumerator&gt;b__0()&#xD;&#xA;   at System.Lazy`1.CreateValue()&#xD;&#xA;   at System.Lazy`1.LazyInitValue()&#xD;&#xA;   at System.Data.Entity.Internal.LazyEnumerator`1.MoveNext()&#xD;&#xA;   at System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)&#xD;&#xA;   at System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Application(Int32 postSelection) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 31&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-27T10:23:31.9916887Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CACHE_CONTROL:max-age=0&#xD;&#xA;HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Cache-Control: max-age=0&#xD;&#xA;Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="postSelection=2" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="50342" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="HTTP_CACHE_CONTROL">
      <value
        string="max-age=0" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
  <queryString>
    <item
      name="postSelection">
      <value
        string="2" />
    </item>
  </queryString>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'3dcbfda2-96d8-41be-84c2-ca8349a028ba', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.ComponentModel.Win32Exception', N'', N'Access is denied', N'', 0, CAST(0x0000A8ED00AB4237 AS DateTime), 25, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.ComponentModel.Win32Exception"
  message="Access is denied"
  detail="System.Data.Entity.Core.EntityException: The underlying provider failed on Open. ---&gt; System.Data.SqlClient.SqlException: A network-related or instance-specific error occurred while establishing a connection to SQL Server. The server was not found or was not accessible. Verify that the instance name is correct and that SQL Server is configured to allow remote connections. (provider: Named Pipes Provider, error: 40 - Could not open a connection to SQL Server) ---&gt; System.ComponentModel.Win32Exception: Access is denied&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at System.Data.SqlClient.SqlInternalConnectionTds..ctor(DbConnectionPoolIdentity identity, SqlConnectionString connectionOptions, SqlCredential credential, Object providerInfo, String newPassword, SecureString newSecurePassword, Boolean redirectedUserInstance, SqlConnectionString userConnectionOptions, SessionData reconnectSessionData, DbConnectionPool pool, String accessToken, Boolean applyTransientFaultHandling)&#xD;&#xA;   at System.Data.SqlClient.SqlConnectionFactory.CreateConnection(DbConnectionOptions options, DbConnectionPoolKey poolKey, Object poolGroupProviderInfo, DbConnectionPool pool, DbConnection owningConnection, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionFactory.CreatePooledConnection(DbConnectionPool pool, DbConnection owningObject, DbConnectionOptions options, DbConnectionPoolKey poolKey, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.CreateObject(DbConnection owningObject, DbConnectionOptions userOptions, DbConnectionInternal oldConnection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.UserCreateRequest(DbConnection owningObject, DbConnectionOptions userOptions, DbConnectionInternal oldConnection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.TryGetConnection(DbConnection owningObject, UInt32 waitForMultipleObjectsTimeout, Boolean allowCreate, Boolean onlyOneCheckConnection, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.TryGetConnection(DbConnection owningObject, TaskCompletionSource`1 retry, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionFactory.TryGetConnection(DbConnection owningConnection, TaskCompletionSource`1 retry, DbConnectionOptions userOptions, DbConnectionInternal oldConnection, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionInternal.TryOpenConnectionInternal(DbConnection outerConnection, DbConnectionFactory connectionFactory, TaskCompletionSource`1 retry, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.TryOpenInner(TaskCompletionSource`1 retry)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.TryOpen(TaskCompletionSource`1 retry)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.Open()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.&lt;&gt;c__DisplayClass1.&lt;Execute&gt;b__0()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.EntityClient.EntityConnection.Open()&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at System.Data.Entity.Core.EntityClient.EntityConnection.Open()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.EnsureConnection()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteInTransaction[T](Func`1 func, IDbExecutionStrategy executionStrategy, Boolean startLocalTransaction, Boolean releaseConnectionOnSuccess)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.&lt;&gt;c__DisplayClassb.&lt;GetResults&gt;b__9()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.GetResults(Nullable`1 forMergeOption)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.&lt;System.Collections.Generic.IEnumerable&lt;T&gt;.GetEnumerator&gt;b__0()&#xD;&#xA;   at System.Lazy`1.CreateValue()&#xD;&#xA;   at System.Lazy`1.LazyInitValue()&#xD;&#xA;   at System.Data.Entity.Internal.LazyEnumerator`1.MoveNext()&#xD;&#xA;   at System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)&#xD;&#xA;   at System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Application(Int32 postSelection) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 31&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-27T10:23:32.0218420Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CACHE_CONTROL:max-age=0&#xD;&#xA;HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Cache-Control: max-age=0&#xD;&#xA;Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="postSelection=2" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="50342" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="HTTP_CACHE_CONTROL">
      <value
        string="max-age=0" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
  <queryString>
    <item
      name="postSelection">
      <value
        string="2" />
    </item>
  </queryString>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'94c6672d-d1b3-4948-81fa-5046d710f1f6', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.ComponentModel.Win32Exception', N'', N'Access is denied', N'', 0, CAST(0x0000A8ED00AB7757 AS DateTime), 26, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.ComponentModel.Win32Exception"
  message="Access is denied"
  detail="System.Data.Entity.Core.EntityException: The underlying provider failed on Open. ---&gt; System.Data.SqlClient.SqlException: A network-related or instance-specific error occurred while establishing a connection to SQL Server. The server was not found or was not accessible. Verify that the instance name is correct and that SQL Server is configured to allow remote connections. (provider: Named Pipes Provider, error: 40 - Could not open a connection to SQL Server) ---&gt; System.ComponentModel.Win32Exception: Access is denied&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at System.Data.SqlClient.SqlInternalConnectionTds..ctor(DbConnectionPoolIdentity identity, SqlConnectionString connectionOptions, SqlCredential credential, Object providerInfo, String newPassword, SecureString newSecurePassword, Boolean redirectedUserInstance, SqlConnectionString userConnectionOptions, SessionData reconnectSessionData, DbConnectionPool pool, String accessToken, Boolean applyTransientFaultHandling)&#xD;&#xA;   at System.Data.SqlClient.SqlConnectionFactory.CreateConnection(DbConnectionOptions options, DbConnectionPoolKey poolKey, Object poolGroupProviderInfo, DbConnectionPool pool, DbConnection owningConnection, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionFactory.CreatePooledConnection(DbConnectionPool pool, DbConnection owningObject, DbConnectionOptions options, DbConnectionPoolKey poolKey, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.CreateObject(DbConnection owningObject, DbConnectionOptions userOptions, DbConnectionInternal oldConnection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.UserCreateRequest(DbConnection owningObject, DbConnectionOptions userOptions, DbConnectionInternal oldConnection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.TryGetConnection(DbConnection owningObject, UInt32 waitForMultipleObjectsTimeout, Boolean allowCreate, Boolean onlyOneCheckConnection, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.TryGetConnection(DbConnection owningObject, TaskCompletionSource`1 retry, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionFactory.TryGetConnection(DbConnection owningConnection, TaskCompletionSource`1 retry, DbConnectionOptions userOptions, DbConnectionInternal oldConnection, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionInternal.TryOpenConnectionInternal(DbConnection outerConnection, DbConnectionFactory connectionFactory, TaskCompletionSource`1 retry, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.TryOpenInner(TaskCompletionSource`1 retry)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.TryOpen(TaskCompletionSource`1 retry)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.Open()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.&lt;&gt;c__DisplayClass1.&lt;Execute&gt;b__0()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.EntityClient.EntityConnection.Open()&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at System.Data.Entity.Core.EntityClient.EntityConnection.Open()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.EnsureConnection()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteInTransaction[T](Func`1 func, IDbExecutionStrategy executionStrategy, Boolean startLocalTransaction, Boolean releaseConnectionOnSuccess)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.&lt;&gt;c__DisplayClassb.&lt;GetResults&gt;b__9()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.GetResults(Nullable`1 forMergeOption)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.&lt;System.Collections.Generic.IEnumerable&lt;T&gt;.GetEnumerator&gt;b__0()&#xD;&#xA;   at System.Lazy`1.CreateValue()&#xD;&#xA;   at System.Lazy`1.LazyInitValue()&#xD;&#xA;   at System.Data.Entity.Internal.LazyEnumerator`1.MoveNext()&#xD;&#xA;   at System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)&#xD;&#xA;   at System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Application(Int32 postSelection) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 31&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)"
  time="2018-05-27T10:24:17.3557573Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CACHE_CONTROL:max-age=0&#xD;&#xA;HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Cache-Control: max-age=0&#xD;&#xA;Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="postSelection=2" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="50367" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="HTTP_CACHE_CONTROL">
      <value
        string="max-age=0" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
  <queryString>
    <item
      name="postSelection">
      <value
        string="2" />
    </item>
  </queryString>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'061647c2-27b0-4ad4-afa5-4af87d4b75e1', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.ComponentModel.Win32Exception', N'', N'Access is denied', N'', 0, CAST(0x0000A8ED00AB777D AS DateTime), 27, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.ComponentModel.Win32Exception"
  message="Access is denied"
  detail="System.Data.Entity.Core.EntityException: The underlying provider failed on Open. ---&gt; System.Data.SqlClient.SqlException: A network-related or instance-specific error occurred while establishing a connection to SQL Server. The server was not found or was not accessible. Verify that the instance name is correct and that SQL Server is configured to allow remote connections. (provider: Named Pipes Provider, error: 40 - Could not open a connection to SQL Server) ---&gt; System.ComponentModel.Win32Exception: Access is denied&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at System.Data.SqlClient.SqlInternalConnectionTds..ctor(DbConnectionPoolIdentity identity, SqlConnectionString connectionOptions, SqlCredential credential, Object providerInfo, String newPassword, SecureString newSecurePassword, Boolean redirectedUserInstance, SqlConnectionString userConnectionOptions, SessionData reconnectSessionData, DbConnectionPool pool, String accessToken, Boolean applyTransientFaultHandling)&#xD;&#xA;   at System.Data.SqlClient.SqlConnectionFactory.CreateConnection(DbConnectionOptions options, DbConnectionPoolKey poolKey, Object poolGroupProviderInfo, DbConnectionPool pool, DbConnection owningConnection, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionFactory.CreatePooledConnection(DbConnectionPool pool, DbConnection owningObject, DbConnectionOptions options, DbConnectionPoolKey poolKey, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.CreateObject(DbConnection owningObject, DbConnectionOptions userOptions, DbConnectionInternal oldConnection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.UserCreateRequest(DbConnection owningObject, DbConnectionOptions userOptions, DbConnectionInternal oldConnection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.TryGetConnection(DbConnection owningObject, UInt32 waitForMultipleObjectsTimeout, Boolean allowCreate, Boolean onlyOneCheckConnection, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.TryGetConnection(DbConnection owningObject, TaskCompletionSource`1 retry, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionFactory.TryGetConnection(DbConnection owningConnection, TaskCompletionSource`1 retry, DbConnectionOptions userOptions, DbConnectionInternal oldConnection, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionInternal.TryOpenConnectionInternal(DbConnection outerConnection, DbConnectionFactory connectionFactory, TaskCompletionSource`1 retry, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.TryOpenInner(TaskCompletionSource`1 retry)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.TryOpen(TaskCompletionSource`1 retry)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.Open()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.&lt;&gt;c__DisplayClass1.&lt;Execute&gt;b__0()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.EntityClient.EntityConnection.Open()&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at System.Data.Entity.Core.EntityClient.EntityConnection.Open()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.EnsureConnection()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteInTransaction[T](Func`1 func, IDbExecutionStrategy executionStrategy, Boolean startLocalTransaction, Boolean releaseConnectionOnSuccess)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.&lt;&gt;c__DisplayClassb.&lt;GetResults&gt;b__9()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.GetResults(Nullable`1 forMergeOption)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.&lt;System.Collections.Generic.IEnumerable&lt;T&gt;.GetEnumerator&gt;b__0()&#xD;&#xA;   at System.Lazy`1.CreateValue()&#xD;&#xA;   at System.Lazy`1.LazyInitValue()&#xD;&#xA;   at System.Data.Entity.Internal.LazyEnumerator`1.MoveNext()&#xD;&#xA;   at System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)&#xD;&#xA;   at System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Application(Int32 postSelection) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 31&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-27T10:24:17.4826123Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CACHE_CONTROL:max-age=0&#xD;&#xA;HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Cache-Control: max-age=0&#xD;&#xA;Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="postSelection=2" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="50367" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="HTTP_CACHE_CONTROL">
      <value
        string="max-age=0" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
  <queryString>
    <item
      name="postSelection">
      <value
        string="2" />
    </item>
  </queryString>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'907cfc64-15b5-4f4b-9448-0c794681f9de', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC00C6BF14 AS DateTime), 8, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-26T12:03:36.8142476Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CACHE_CONTROL:max-age=0&#xD;&#xA;HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Cache-Control: max-age=0&#xD;&#xA;Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application\2" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="62303" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="HTTP_CACHE_CONTROL">
      <value
        string="max-age=0" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'15e38a4d-67e8-4e62-a97c-062b95575f44', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC00C6BFC9 AS DateTime), 9, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-26T12:03:37.4158003Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CACHE_CONTROL:max-age=0&#xD;&#xA;HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Cache-Control: max-age=0&#xD;&#xA;Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application\2" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="62303" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application/2" />
    </item>
    <item
      name="HTTP_CACHE_CONTROL">
      <value
        string="max-age=0" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'a0682106-23f1-408e-b886-c49fe2645ef2', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC00C7A433 AS DateTime), 10, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)"
  time="2018-05-26T12:06:52.3315863Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="62351" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'8c9224d3-36db-4eb5-81a5-c6961c74c196', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC00C7A4BD AS DateTime), 11, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-26T12:06:52.7911088Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="62351" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'263f81c7-0ce4-48b8-8eb8-655a21e5ac60', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC00C7A4C2 AS DateTime), 12, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-26T12:06:52.8051202Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="62351" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'e398587e-c9bb-4225-b67b-d530baa4dd22', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC01037B35 AS DateTime), 17, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)"
  time="2018-05-26T15:44:44.5487758Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="54698" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'e423c620-e6a7-4d9f-8671-06dee9b02d5c', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC01037F51 AS DateTime), 18, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-26T15:44:48.0569900Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="54698" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'405bbab7-0714-40b5-89b0-0144b60ec5b2', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.Data.Entity.Core.MappingException', N'EntityFramework', N'The type ''Edm.Int32'' of the member ''MobileNumber'' in the conceptual side type ''NPSSModel.ApplicantMaster'' does not match with the type ''System.Int64'' of the member ''MobileNumber'' on the object side type ''NPSSOnlineRecruitmentPortal.DBModel.ApplicantMaster''.', N'', 0, CAST(0x0000A8EC00CC7232 AS DateTime), 13, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.Data.Entity.Core.MappingException"
  message="The type ''Edm.Int32'' of the member ''MobileNumber'' in the conceptual side type ''NPSSModel.ApplicantMaster'' does not match with the type ''System.Int64'' of the member ''MobileNumber'' on the object side type ''NPSSOnlineRecruitmentPortal.DBModel.ApplicantMaster''."
  source="EntityFramework"
  detail="System.Data.Entity.Core.MappingException: The type ''Edm.Int32'' of the member ''MobileNumber'' in the conceptual side type ''NPSSModel.ApplicantMaster'' does not match with the type ''System.Int64'' of the member ''MobileNumber'' on the object side type ''NPSSOnlineRecruitmentPortal.DBModel.ApplicantMaster''.&#xD;&#xA;   at System.Data.Entity.Core.Mapping.DefaultObjectMappingItemCollection.ValidateMembersMatch(EdmMember edmMember, EdmMember objectMember)&#xD;&#xA;   at System.Data.Entity.Core.Mapping.DefaultObjectMappingItemCollection.LoadEntityTypeOrComplexTypeMapping(ObjectTypeMapping objectMapping, EdmType edmType, EdmType objectType, DefaultObjectMappingItemCollection ocItemCollection, Dictionary`2 typeMappings)&#xD;&#xA;   at System.Data.Entity.Core.Mapping.DefaultObjectMappingItemCollection.LoadObjectMapping(EdmType edmType, EdmType objectType, DefaultObjectMappingItemCollection ocItemCollection, Dictionary`2 typeMappings)&#xD;&#xA;   at System.Data.Entity.Core.Mapping.DefaultObjectMappingItemCollection.LoadObjectMapping(EdmType cdmType, EdmType objectType, DefaultObjectMappingItemCollection ocItemCollection)&#xD;&#xA;   at System.Data.Entity.Core.Mapping.DefaultObjectMappingItemCollection.GetDefaultMapping(EdmType cdmType, EdmType clrType)&#xD;&#xA;   at System.Data.Entity.Core.Mapping.DefaultObjectMappingItemCollection.TryGetMap(String identity, DataSpace typeSpace, Boolean ignoreCase, Map&amp; map)&#xD;&#xA;   at System.Data.Entity.Core.Mapping.DefaultObjectMappingItemCollection.TryGetMap(String identity, DataSpace typeSpace, Map&amp; map)&#xD;&#xA;   at System.Data.Entity.Core.Mapping.DefaultObjectMappingItemCollection.TryGetMap(GlobalItem item, Map&amp; map)&#xD;&#xA;   at System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace.TryGetMap(GlobalItem item, DataSpace dataSpace, Map&amp; map)&#xD;&#xA;   at System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace.TryGetEdmSpaceType[T](T objectSpaceType, T&amp; edmSpaceType)&#xD;&#xA;   at System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace.GetEdmSpaceType[T](T objectSpaceType)&#xD;&#xA;   at System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace.GetEdmSpaceType(StructuralType objectSpaceType)&#xD;&#xA;   at System.Data.Entity.Internal.InternalContext.UpdateEntitySetMappings()&#xD;&#xA;   at System.Data.Entity.Internal.InternalContext.TryUpdateEntitySetMappingsForType(Type entityType)&#xD;&#xA;   at System.Data.Entity.Internal.InternalContext.UpdateEntitySetMappingsForType(Type entityType)&#xD;&#xA;   at System.Data.Entity.Internal.InternalContext.GetEntitySetAndBaseTypeForType(Type entityType)&#xD;&#xA;   at System.Data.Entity.Internal.Linq.InternalSet`1.Initialize()&#xD;&#xA;   at System.Data.Entity.Internal.Linq.InternalSet`1.get_InternalContext()&#xD;&#xA;   at System.Data.Entity.Internal.Linq.InternalSet`1.ActOnSet(Action action, EntityState newState, Object entity, String methodName)&#xD;&#xA;   at System.Data.Entity.Internal.Linq.InternalSet`1.Add(Object entity)&#xD;&#xA;   at System.Data.Entity.DbSet`1.Add(TEntity entity)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Application(ApplicationViewModel objApplication) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 60"
  time="2018-05-26T12:24:21.9282438Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_CONTENT_LENGTH:513&#xD;&#xA;HTTP_CONTENT_TYPE:application/json; charset=UTF-8&#xD;&#xA;HTTP_ACCEPT:application/json, text/javascript, */*; q=0.01&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/Application?postSelection=2&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_ORIGIN:http://localhost:2959&#xD;&#xA;HTTP_X_REQUESTED_WITH:XMLHttpRequest&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Content-Length: 513&#xD;&#xA;Content-Type: application/json; charset=UTF-8&#xD;&#xA;Accept: application/json, text/javascript, */*; q=0.01&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/Application?postSelection=2&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Origin: http://localhost:2959&#xD;&#xA;X-Requested-With: XMLHttpRequest&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="513" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="application/json; charset=UTF-8" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="63446" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="POST" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_CONTENT_LENGTH">
      <value
        string="513" />
    </item>
    <item
      name="HTTP_CONTENT_TYPE">
      <value
        string="application/json; charset=UTF-8" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="application/json, text/javascript, */*; q=0.01" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/Application?postSelection=2" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_ORIGIN">
      <value
        string="http://localhost:2959" />
    </item>
    <item
      name="HTTP_X_REQUESTED_WITH">
      <value
        string="XMLHttpRequest" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'0697670a-f1d0-4ccf-9bdf-ec364ff37aa6', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.Data.Entity.Validation.DbEntityValidationException', N'EntityFramework', N'Validation failed for one or more entities. See ''EntityValidationErrors'' property for more details.', N'', 0, CAST(0x0000A8EC00CDD8C2 AS DateTime), 14, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.Data.Entity.Validation.DbEntityValidationException"
  message="Validation failed for one or more entities. See ''EntityValidationErrors'' property for more details."
  source="EntityFramework"
  detail="System.Data.Entity.Validation.DbEntityValidationException: Validation failed for one or more entities. See ''EntityValidationErrors'' property for more details.&#xD;&#xA;   at System.Data.Entity.Internal.InternalContext.SaveChanges()&#xD;&#xA;   at System.Data.Entity.Internal.LazyInternalContext.SaveChanges()&#xD;&#xA;   at System.Data.Entity.DbContext.SaveChanges()&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Application(ApplicationViewModel objApplication) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 61"
  time="2018-05-26T12:29:27.9009008Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_CONTENT_LENGTH:513&#xD;&#xA;HTTP_CONTENT_TYPE:application/json; charset=UTF-8&#xD;&#xA;HTTP_ACCEPT:application/json, text/javascript, */*; q=0.01&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/Application?postSelection=2&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_ORIGIN:http://localhost:2959&#xD;&#xA;HTTP_X_REQUESTED_WITH:XMLHttpRequest&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Content-Length: 513&#xD;&#xA;Content-Type: application/json; charset=UTF-8&#xD;&#xA;Accept: application/json, text/javascript, */*; q=0.01&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/Application?postSelection=2&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Origin: http://localhost:2959&#xD;&#xA;X-Requested-With: XMLHttpRequest&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="513" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="application/json; charset=UTF-8" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="63546" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="POST" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_CONTENT_LENGTH">
      <value
        string="513" />
    </item>
    <item
      name="HTTP_CONTENT_TYPE">
      <value
        string="application/json; charset=UTF-8" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="application/json, text/javascript, */*; q=0.01" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/Application?postSelection=2" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_ORIGIN">
      <value
        string="http://localhost:2959" />
    </item>
    <item
      name="HTTP_X_REQUESTED_WITH">
      <value
        string="XMLHttpRequest" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'3f262a04-e208-4f74-ada6-726eedace08f', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.Data.Entity.Validation.DbEntityValidationException', N'EntityFramework', N'Validation failed for one or more entities. See ''EntityValidationErrors'' property for more details.', N'', 0, CAST(0x0000A8EC00CE5188 AS DateTime), 15, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.Data.Entity.Validation.DbEntityValidationException"
  message="Validation failed for one or more entities. See ''EntityValidationErrors'' property for more details."
  source="EntityFramework"
  detail="System.Data.Entity.Validation.DbEntityValidationException: Validation failed for one or more entities. See ''EntityValidationErrors'' property for more details.&#xD;&#xA;   at System.Data.Entity.Internal.InternalContext.SaveChanges()&#xD;&#xA;   at System.Data.Entity.Internal.LazyInternalContext.SaveChanges()&#xD;&#xA;   at System.Data.Entity.DbContext.SaveChanges()&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Application(ApplicationViewModel objApplication) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 61"
  time="2018-05-26T12:31:10.9593871Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_CONTENT_LENGTH:513&#xD;&#xA;HTTP_CONTENT_TYPE:application/json; charset=UTF-8&#xD;&#xA;HTTP_ACCEPT:application/json, text/javascript, */*; q=0.01&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/Application?postSelection=2&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_ORIGIN:http://localhost:2959&#xD;&#xA;HTTP_X_REQUESTED_WITH:XMLHttpRequest&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Content-Length: 513&#xD;&#xA;Content-Type: application/json; charset=UTF-8&#xD;&#xA;Accept: application/json, text/javascript, */*; q=0.01&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/Application?postSelection=2&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Origin: http://localhost:2959&#xD;&#xA;X-Requested-With: XMLHttpRequest&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="513" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="application/json; charset=UTF-8" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="63561" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="POST" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_CONTENT_LENGTH">
      <value
        string="513" />
    </item>
    <item
      name="HTTP_CONTENT_TYPE">
      <value
        string="application/json; charset=UTF-8" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="application/json, text/javascript, */*; q=0.01" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/Application?postSelection=2" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_ORIGIN">
      <value
        string="http://localhost:2959" />
    </item>
    <item
      name="HTTP_X_REQUESTED_WITH">
      <value
        string="XMLHttpRequest" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'c31fb9ed-ce48-413b-87c0-a9650f241883', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.Data.Entity.Validation.DbEntityValidationException', N'EntityFramework', N'Validation failed for one or more entities. See ''EntityValidationErrors'' property for more details.', N'', 0, CAST(0x0000A8EC00CE9B2E AS DateTime), 16, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.Data.Entity.Validation.DbEntityValidationException"
  message="Validation failed for one or more entities. See ''EntityValidationErrors'' property for more details."
  source="EntityFramework"
  detail="System.Data.Entity.Validation.DbEntityValidationException: Validation failed for one or more entities. See ''EntityValidationErrors'' property for more details.&#xD;&#xA;   at System.Data.Entity.Internal.InternalContext.SaveChanges()&#xD;&#xA;   at System.Data.Entity.Internal.LazyInternalContext.SaveChanges()&#xD;&#xA;   at System.Data.Entity.DbContext.SaveChanges()&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Application(ApplicationViewModel objApplication) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 61"
  time="2018-05-26T12:32:13.8069799Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_CONTENT_LENGTH:506&#xD;&#xA;HTTP_CONTENT_TYPE:application/json; charset=UTF-8&#xD;&#xA;HTTP_ACCEPT:application/json, text/javascript, */*; q=0.01&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/Application?postSelection=2&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_ORIGIN:http://localhost:2959&#xD;&#xA;HTTP_X_REQUESTED_WITH:XMLHttpRequest&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Content-Length: 506&#xD;&#xA;Content-Type: application/json; charset=UTF-8&#xD;&#xA;Accept: application/json, text/javascript, */*; q=0.01&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/Application?postSelection=2&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Origin: http://localhost:2959&#xD;&#xA;X-Requested-With: XMLHttpRequest&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="506" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="application/json; charset=UTF-8" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="63569" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="POST" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_CONTENT_LENGTH">
      <value
        string="506" />
    </item>
    <item
      name="HTTP_CONTENT_TYPE">
      <value
        string="application/json; charset=UTF-8" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="application/json, text/javascript, */*; q=0.01" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/Application?postSelection=2" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_ORIGIN">
      <value
        string="http://localhost:2959" />
    </item>
    <item
      name="HTTP_X_REQUESTED_WITH">
      <value
        string="XMLHttpRequest" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'b909f4ea-c7dc-497d-ac9b-9b3717590c3a', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.ArgumentException', N'System.Web.Mvc', N'The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
Parameter name: parameters', N'', 0, CAST(0x0000A8EC01037F72 AS DateTime), 19, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.ArgumentException"
  message="The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters"
  source="System.Web.Mvc"
  detail="System.ArgumentException: The parameters dictionary contains a null entry for parameter ''postSelection'' of non-nullable type ''System.Int32'' for method ''System.Web.Mvc.ActionResult Application(Int32)'' in ''NPSSOnlineRecruitmentPortal.Controllers.HomeController''. An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.&#xD;&#xA;Parameter name: parameters&#xD;&#xA;   at System.Web.Mvc.ActionDescriptor.ExtractParameterFromDictionary(ParameterInfo parameterInfo, IDictionary`2 parameters, MethodInfo methodInfo)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-26T15:44:48.1661193Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="54698" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'6aed665b-32da-4557-a6c6-fe43a17e1299', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.NullReferenceException', N'NPSSOnlineRecruitmentPortal', N'Object reference not set to an instance of an object.', N'', 0, CAST(0x0000A8EC0117A983 AS DateTime), 20, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.NullReferenceException"
  message="Object reference not set to an instance of an object."
  source="NPSSOnlineRecruitmentPortal"
  detail="System.NullReferenceException: Object reference not set to an instance of an object.&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Application(ApplicationViewModel objApplication) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 84"
  time="2018-05-26T16:58:13.1300760Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_CONTENT_LENGTH:737&#xD;&#xA;HTTP_CONTENT_TYPE:application/json; charset=UTF-8&#xD;&#xA;HTTP_ACCEPT:application/json, text/javascript, */*; q=0.01&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/Application?postSelection=3&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_ORIGIN:http://localhost:2959&#xD;&#xA;HTTP_X_REQUESTED_WITH:XMLHttpRequest&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Content-Length: 737&#xD;&#xA;Content-Type: application/json; charset=UTF-8&#xD;&#xA;Accept: application/json, text/javascript, */*; q=0.01&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/Application?postSelection=3&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Origin: http://localhost:2959&#xD;&#xA;X-Requested-With: XMLHttpRequest&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="737" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="application/json; charset=UTF-8" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="55756" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="POST" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_CONTENT_LENGTH">
      <value
        string="737" />
    </item>
    <item
      name="HTTP_CONTENT_TYPE">
      <value
        string="application/json; charset=UTF-8" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="application/json, text/javascript, */*; q=0.01" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/Application?postSelection=3" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_ORIGIN">
      <value
        string="http://localhost:2959" />
    </item>
    <item
      name="HTTP_X_REQUESTED_WITH">
      <value
        string="XMLHttpRequest" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'056c6042-4c38-418e-b990-9f0017c36240', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.NullReferenceException', N'NPSSOnlineRecruitmentPortal', N'Object reference not set to an instance of an object.', N'', 0, CAST(0x0000A8EC0117BD4F AS DateTime), 21, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.NullReferenceException"
  message="Object reference not set to an instance of an object."
  source="NPSSOnlineRecruitmentPortal"
  detail="System.NullReferenceException: Object reference not set to an instance of an object.&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Application(ApplicationViewModel objApplication) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 84"
  time="2018-05-26T16:58:30.0245744Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_CONTENT_LENGTH:737&#xD;&#xA;HTTP_CONTENT_TYPE:application/json; charset=UTF-8&#xD;&#xA;HTTP_ACCEPT:application/json, text/javascript, */*; q=0.01&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/Application?postSelection=3&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_ORIGIN:http://localhost:2959&#xD;&#xA;HTTP_X_REQUESTED_WITH:XMLHttpRequest&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Content-Length: 737&#xD;&#xA;Content-Type: application/json; charset=UTF-8&#xD;&#xA;Accept: application/json, text/javascript, */*; q=0.01&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/Application?postSelection=3&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Origin: http://localhost:2959&#xD;&#xA;X-Requested-With: XMLHttpRequest&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="737" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="application/json; charset=UTF-8" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="55761" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="POST" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_CONTENT_LENGTH">
      <value
        string="737" />
    </item>
    <item
      name="HTTP_CONTENT_TYPE">
      <value
        string="application/json; charset=UTF-8" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="application/json, text/javascript, */*; q=0.01" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/Application?postSelection=3" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_ORIGIN">
      <value
        string="http://localhost:2959" />
    </item>
    <item
      name="HTTP_X_REQUESTED_WITH">
      <value
        string="XMLHttpRequest" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'3015b4c8-d6ee-467a-9dc6-c17f63475187', N'/LM/W3SVC/95/ROOT', N'JAY', N'System.NullReferenceException', N'NPSSOnlineRecruitmentPortal', N'Object reference not set to an instance of an object.', N'', 0, CAST(0x0000A8EC011813F9 AS DateTime), 22, N'<error
  application="/LM/W3SVC/95/ROOT"
  host="JAY"
  type="System.NullReferenceException"
  message="Object reference not set to an instance of an object."
  source="NPSSOnlineRecruitmentPortal"
  detail="System.NullReferenceException: Object reference not set to an instance of an object.&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Application(ApplicationViewModel objApplication) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 84"
  time="2018-05-26T16:59:43.9775774Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_CONTENT_LENGTH:706&#xD;&#xA;HTTP_CONTENT_TYPE:application/json; charset=UTF-8&#xD;&#xA;HTTP_ACCEPT:application/json, text/javascript, */*; q=0.01&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost:2959&#xD;&#xA;HTTP_REFERER:http://localhost:2959/Home/Application?postSelection=3&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_ORIGIN:http://localhost:2959&#xD;&#xA;HTTP_X_REQUESTED_WITH:XMLHttpRequest&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Content-Length: 706&#xD;&#xA;Content-Type: application/json; charset=UTF-8&#xD;&#xA;Accept: application/json, text/javascript, */*; q=0.01&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost:2959&#xD;&#xA;Referer: http://localhost:2959/Home/Application?postSelection=3&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Origin: http://localhost:2959&#xD;&#xA;X-Requested-With: XMLHttpRequest&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/95/ROOT" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="706" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="application/json; charset=UTF-8" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="95" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/95" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="55777" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="POST" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="2959" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/10.0" />
    </item>
    <item
      name="URL">
      <value
        string="/Home/Application" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_CONTENT_LENGTH">
      <value
        string="706" />
    </item>
    <item
      name="HTTP_CONTENT_TYPE">
      <value
        string="application/json; charset=UTF-8" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="application/json, text/javascript, */*; q=0.01" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost:2959" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost:2959/Home/Application?postSelection=3" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_ORIGIN">
      <value
        string="http://localhost:2959" />
    </item>
    <item
      name="HTTP_X_REQUESTED_WITH">
      <value
        string="XMLHttpRequest" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'c3e11593-9a60-4140-aba9-274d2efe8525', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.ComponentModel.Win32Exception', N'', N'Access is denied', N'', 0, CAST(0x0000A8ED00AB777E AS DateTime), 28, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.ComponentModel.Win32Exception"
  message="Access is denied"
  detail="System.Data.Entity.Core.EntityException: The underlying provider failed on Open. ---&gt; System.Data.SqlClient.SqlException: A network-related or instance-specific error occurred while establishing a connection to SQL Server. The server was not found or was not accessible. Verify that the instance name is correct and that SQL Server is configured to allow remote connections. (provider: Named Pipes Provider, error: 40 - Could not open a connection to SQL Server) ---&gt; System.ComponentModel.Win32Exception: Access is denied&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at System.Data.SqlClient.SqlInternalConnectionTds..ctor(DbConnectionPoolIdentity identity, SqlConnectionString connectionOptions, SqlCredential credential, Object providerInfo, String newPassword, SecureString newSecurePassword, Boolean redirectedUserInstance, SqlConnectionString userConnectionOptions, SessionData reconnectSessionData, DbConnectionPool pool, String accessToken, Boolean applyTransientFaultHandling)&#xD;&#xA;   at System.Data.SqlClient.SqlConnectionFactory.CreateConnection(DbConnectionOptions options, DbConnectionPoolKey poolKey, Object poolGroupProviderInfo, DbConnectionPool pool, DbConnection owningConnection, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionFactory.CreatePooledConnection(DbConnectionPool pool, DbConnection owningObject, DbConnectionOptions options, DbConnectionPoolKey poolKey, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.CreateObject(DbConnection owningObject, DbConnectionOptions userOptions, DbConnectionInternal oldConnection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.UserCreateRequest(DbConnection owningObject, DbConnectionOptions userOptions, DbConnectionInternal oldConnection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.TryGetConnection(DbConnection owningObject, UInt32 waitForMultipleObjectsTimeout, Boolean allowCreate, Boolean onlyOneCheckConnection, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionPool.TryGetConnection(DbConnection owningObject, TaskCompletionSource`1 retry, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionFactory.TryGetConnection(DbConnection owningConnection, TaskCompletionSource`1 retry, DbConnectionOptions userOptions, DbConnectionInternal oldConnection, DbConnectionInternal&amp; connection)&#xD;&#xA;   at System.Data.ProviderBase.DbConnectionInternal.TryOpenConnectionInternal(DbConnection outerConnection, DbConnectionFactory connectionFactory, TaskCompletionSource`1 retry, DbConnectionOptions userOptions)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.TryOpenInner(TaskCompletionSource`1 retry)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.TryOpen(TaskCompletionSource`1 retry)&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.Open()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.&lt;&gt;c__DisplayClass1.&lt;Execute&gt;b__0()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.EntityClient.EntityConnection.Open()&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at System.Data.Entity.Core.EntityClient.EntityConnection.Open()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.EnsureConnection()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteInTransaction[T](Func`1 func, IDbExecutionStrategy executionStrategy, Boolean startLocalTransaction, Boolean releaseConnectionOnSuccess)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.&lt;&gt;c__DisplayClassb.&lt;GetResults&gt;b__9()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.GetResults(Nullable`1 forMergeOption)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectQuery`1.&lt;System.Collections.Generic.IEnumerable&lt;T&gt;.GetEnumerator&gt;b__0()&#xD;&#xA;   at System.Lazy`1.CreateValue()&#xD;&#xA;   at System.Lazy`1.LazyInitValue()&#xD;&#xA;   at System.Data.Entity.Internal.LazyEnumerator`1.MoveNext()&#xD;&#xA;   at System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)&#xD;&#xA;   at System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Application(Int32 postSelection) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 31&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-27T10:24:17.4856160Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CACHE_CONTROL:max-age=0&#xD;&#xA;HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Cache-Control: max-age=0&#xD;&#xA;Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Application" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="postSelection=2" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="50367" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Application" />
    </item>
    <item
      name="HTTP_CACHE_CONTROL">
      <value
        string="max-age=0" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/Home/PostSelection" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
  <queryString>
    <item
      name="postSelection">
      <value
        string="2" />
    </item>
  </queryString>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'e4fe75c7-d5bb-4e13-8967-a6db9f9b2f2b', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.Net.Mail.SmtpException', N'NPSSOnlineRecruitmentPortal', N'The SMTP server requires a secure connection or the client was not authenticated. The server response was: 5.5.1 Authentication Required. Learn more at', N'', 0, CAST(0x0000A8ED013C7343 AS DateTime), 44, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.Net.Mail.SmtpException"
  message="The SMTP server requires a secure connection or the client was not authenticated. The server response was: 5.5.1 Authentication Required. Learn more at"
  source="NPSSOnlineRecruitmentPortal"
  detail="System.Net.Mail.SmtpException: The SMTP server requires a secure connection or the client was not authenticated. The server response was: 5.5.1 Authentication Required. Learn more at&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.SendMailToMultipleUser(String toemailid, String attachment, Byte[] bytes) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 255&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.CreatePDF(String fileName, List`1 ds, String reportFileName) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 207&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 181&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)"
  time="2018-05-27T19:12:09.6090923Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="58682" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'82d796c9-edcf-4ca5-9f04-42917b150929', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.Net.Mail.SmtpException', N'NPSSOnlineRecruitmentPortal', N'The SMTP server requires a secure connection or the client was not authenticated. The server response was: 5.5.1 Authentication Required. Learn more at', N'', 0, CAST(0x0000A8ED013C7352 AS DateTime), 45, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.Net.Mail.SmtpException"
  message="The SMTP server requires a secure connection or the client was not authenticated. The server response was: 5.5.1 Authentication Required. Learn more at"
  source="NPSSOnlineRecruitmentPortal"
  detail="System.Net.Mail.SmtpException: The SMTP server requires a secure connection or the client was not authenticated. The server response was: 5.5.1 Authentication Required. Learn more at&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.SendMailToMultipleUser(String toemailid, String attachment, Byte[] bytes) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 255&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.CreatePDF(String fileName, List`1 ds, String reportFileName) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 207&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 181&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-27T19:12:09.6592324Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="58682" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'1c394d14-8725-4b25-807a-51c4a32370af', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.Net.Mail.SmtpException', N'NPSSOnlineRecruitmentPortal', N'The SMTP server requires a secure connection or the client was not authenticated. The server response was: 5.5.1 Authentication Required. Learn more at', N'', 0, CAST(0x0000A8ED013C7353 AS DateTime), 46, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.Net.Mail.SmtpException"
  message="The SMTP server requires a secure connection or the client was not authenticated. The server response was: 5.5.1 Authentication Required. Learn more at"
  source="NPSSOnlineRecruitmentPortal"
  detail="System.Net.Mail.SmtpException: The SMTP server requires a secure connection or the client was not authenticated. The server response was: 5.5.1 Authentication Required. Learn more at&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.SendMailToMultipleUser(String toemailid, String attachment, Byte[] bytes) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 255&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.CreatePDF(String fileName, List`1 ds, String reportFileName) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 207&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 181&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-27T19:12:09.6622335Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="58682" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'019619cb-b171-4b9d-9c84-f8a18b25e2ab', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.Data.SqlClient.SqlException', N'.Net SqlClient Data Provider', N'Must declare the scalar variable "@ApplicantID".', N'', 0, CAST(0x0000A8ED00E5C746 AS DateTime), 29, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.Data.SqlClient.SqlException"
  message="Must declare the scalar variable &quot;@ApplicantID&quot;."
  source=".Net SqlClient Data Provider"
  detail="System.Data.SqlClient.SqlException (0x80131904): Must declare the scalar variable &quot;@ApplicantID&quot;.&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)&#xD;&#xA;   at System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)&#xD;&#xA;   at System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean&amp; dataReady)&#xD;&#xA;   at System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()&#xD;&#xA;   at System.Data.SqlClient.SqlDataReader.get_MetaData()&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task&amp; task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task&amp; task, Boolean asyncWrite)&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)&#xD;&#xA;   at System.Data.Entity.Infrastructure.Interception.DbCommandDispatcher.&lt;&gt;c__DisplayClassb.&lt;Reader&gt;b__8()&#xD;&#xA;   at System.Data.Entity.Infrastructure.Interception.InternalDispatcher`1.Dispatch[TInterceptionContext,TResult](Func`1 operation, TInterceptionContext interceptionContext, Action`1 executing, Action`1 executed)&#xD;&#xA;   at System.Data.Entity.Infrastructure.Interception.DbCommandDispatcher.Reader(DbCommand command, DbCommandInterceptionContext interceptionContext)&#xD;&#xA;   at System.Data.Entity.Internal.InterceptableDbCommand.ExecuteDbDataReader(CommandBehavior behavior)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQueryInternal[TElement](String commandText, String entitySetName, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.&lt;&gt;c__DisplayClass63`1.&lt;ExecuteStoreQueryReliably&gt;b__62()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteInTransaction[T](Func`1 func, IDbExecutionStrategy executionStrategy, Boolean startLocalTransaction, Boolean releaseConnectionOnSuccess)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.&lt;&gt;c__DisplayClass63`1.&lt;ExecuteStoreQueryReliably&gt;b__61()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQueryReliably[TElement](String commandText, String entitySetName, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQuery[TElement](String commandText, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Internal.InternalContext.&lt;&gt;c__DisplayClass13`1.&lt;ExecuteSqlQuery&gt;b__12()&#xD;&#xA;   at System.Lazy`1.CreateValue()&#xD;&#xA;   at System.Lazy`1.LazyInitValue()&#xD;&#xA;   at System.Data.Entity.Internal.LazyEnumerator`1.MoveNext()&#xD;&#xA;   at System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)&#xD;&#xA;   at System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 175&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.Execute(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;ClientConnectionId:db2c162a-100b-4519-8cdd-a77d687fae08&#xD;&#xA;Error Number:137,State:2,Class:15"
  time="2018-05-27T13:56:35.8584409Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="55468" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'd0e67d36-5f4e-4908-b6b4-22d87844ba50', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.Data.SqlClient.SqlException', N'.Net SqlClient Data Provider', N'Must declare the scalar variable "@ApplicantID".', N'', 0, CAST(0x0000A8ED00E5D1C6 AS DateTime), 30, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.Data.SqlClient.SqlException"
  message="Must declare the scalar variable &quot;@ApplicantID&quot;."
  source=".Net SqlClient Data Provider"
  detail="System.Data.SqlClient.SqlException (0x80131904): Must declare the scalar variable &quot;@ApplicantID&quot;.&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)&#xD;&#xA;   at System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)&#xD;&#xA;   at System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean&amp; dataReady)&#xD;&#xA;   at System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()&#xD;&#xA;   at System.Data.SqlClient.SqlDataReader.get_MetaData()&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task&amp; task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task&amp; task, Boolean asyncWrite)&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)&#xD;&#xA;   at System.Data.Entity.Infrastructure.Interception.DbCommandDispatcher.&lt;&gt;c__DisplayClassb.&lt;Reader&gt;b__8()&#xD;&#xA;   at System.Data.Entity.Infrastructure.Interception.InternalDispatcher`1.Dispatch[TInterceptionContext,TResult](Func`1 operation, TInterceptionContext interceptionContext, Action`1 executing, Action`1 executed)&#xD;&#xA;   at System.Data.Entity.Infrastructure.Interception.DbCommandDispatcher.Reader(DbCommand command, DbCommandInterceptionContext interceptionContext)&#xD;&#xA;   at System.Data.Entity.Internal.InterceptableDbCommand.ExecuteDbDataReader(CommandBehavior behavior)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQueryInternal[TElement](String commandText, String entitySetName, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.&lt;&gt;c__DisplayClass63`1.&lt;ExecuteStoreQueryReliably&gt;b__62()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteInTransaction[T](Func`1 func, IDbExecutionStrategy executionStrategy, Boolean startLocalTransaction, Boolean releaseConnectionOnSuccess)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.&lt;&gt;c__DisplayClass63`1.&lt;ExecuteStoreQueryReliably&gt;b__61()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQueryReliably[TElement](String commandText, String entitySetName, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQuery[TElement](String commandText, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Internal.InternalContext.&lt;&gt;c__DisplayClass13`1.&lt;ExecuteSqlQuery&gt;b__12()&#xD;&#xA;   at System.Lazy`1.CreateValue()&#xD;&#xA;   at System.Lazy`1.LazyInitValue()&#xD;&#xA;   at System.Data.Entity.Internal.LazyEnumerator`1.MoveNext()&#xD;&#xA;   at System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)&#xD;&#xA;   at System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 175&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.Execute(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)&#xD;&#xA;ClientConnectionId:db2c162a-100b-4519-8cdd-a77d687fae08&#xD;&#xA;Error Number:137,State:2,Class:15"
  time="2018-05-27T13:56:44.8204269Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="55468" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'b2bb7a8a-24e2-4e58-9a73-71586e838d13', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.Data.SqlClient.SqlException', N'.Net SqlClient Data Provider', N'Must declare the scalar variable "@ApplicantID".', N'', 0, CAST(0x0000A8ED00E5D204 AS DateTime), 31, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.Data.SqlClient.SqlException"
  message="Must declare the scalar variable &quot;@ApplicantID&quot;."
  source=".Net SqlClient Data Provider"
  detail="System.Data.SqlClient.SqlException (0x80131904): Must declare the scalar variable &quot;@ApplicantID&quot;.&#xD;&#xA;   at System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)&#xD;&#xA;   at System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)&#xD;&#xA;   at System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean&amp; dataReady)&#xD;&#xA;   at System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()&#xD;&#xA;   at System.Data.SqlClient.SqlDataReader.get_MetaData()&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task&amp; task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task&amp; task, Boolean asyncWrite)&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)&#xD;&#xA;   at System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)&#xD;&#xA;   at System.Data.Entity.Infrastructure.Interception.DbCommandDispatcher.&lt;&gt;c__DisplayClassb.&lt;Reader&gt;b__8()&#xD;&#xA;   at System.Data.Entity.Infrastructure.Interception.InternalDispatcher`1.Dispatch[TInterceptionContext,TResult](Func`1 operation, TInterceptionContext interceptionContext, Action`1 executing, Action`1 executed)&#xD;&#xA;   at System.Data.Entity.Infrastructure.Interception.DbCommandDispatcher.Reader(DbCommand command, DbCommandInterceptionContext interceptionContext)&#xD;&#xA;   at System.Data.Entity.Internal.InterceptableDbCommand.ExecuteDbDataReader(CommandBehavior behavior)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQueryInternal[TElement](String commandText, String entitySetName, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.&lt;&gt;c__DisplayClass63`1.&lt;ExecuteStoreQueryReliably&gt;b__62()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteInTransaction[T](Func`1 func, IDbExecutionStrategy executionStrategy, Boolean startLocalTransaction, Boolean releaseConnectionOnSuccess)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.&lt;&gt;c__DisplayClass63`1.&lt;ExecuteStoreQueryReliably&gt;b__61()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQueryReliably[TElement](String commandText, String entitySetName, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQuery[TElement](String commandText, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Internal.InternalContext.&lt;&gt;c__DisplayClass13`1.&lt;ExecuteSqlQuery&gt;b__12()&#xD;&#xA;   at System.Lazy`1.CreateValue()&#xD;&#xA;   at System.Lazy`1.LazyInitValue()&#xD;&#xA;   at System.Data.Entity.Internal.LazyEnumerator`1.MoveNext()&#xD;&#xA;   at System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)&#xD;&#xA;   at System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 175&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.Execute(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)&#xD;&#xA;ClientConnectionId:db2c162a-100b-4519-8cdd-a77d687fae08&#xD;&#xA;Error Number:137,State:2,Class:15"
  time="2018-05-27T13:56:45.0254097Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="55468" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'dc26b7c4-6f48-408e-84e7-81e86a618858', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'Microsoft.ReportingServices.ReportProcessing.ReportProcessingException', N'Microsoft.ReportViewer.Common', N'DataSet1', N'', 0, CAST(0x0000A8ED00E68439 AS DateTime), 32, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="Microsoft.ReportingServices.ReportProcessing.ReportProcessingException"
  message="DataSet1"
  source="Microsoft.ReportViewer.Common"
  detail="Microsoft.Reporting.WebForms.LocalProcessingException: An error occurred during local report processing. ---&gt; Microsoft.ReportingServices.ReportProcessing.ProcessingAbortedException: An error has occurred during report processing. ---&gt; Microsoft.ReportingServices.ReportProcessing.ReportProcessingException: DataSet1&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.RuntimeDataSet.RunDataSetQuery()&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.TablixProcessing.RuntimeOnDemandDataSet.Process()&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.RuntimeDataSet.ProcessConcurrent(Object threadSet)&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.OnDemandProcessingContext.AbortHelper.ThrowAbortException(String reportUniqueName)&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.OnDemandProcessingContext.CheckAndThrowIfAborted()&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.RetrievalManager.FetchData(Boolean mergeTran)&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.RetrievalManager.PrefetchData(ReportInstance reportInstance, ParameterInfoCollection parameters, Boolean mergeTran)&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.Merge.FetchData(ReportInstance reportInstance, Boolean mergeTransaction)&#xD;&#xA;   at Microsoft.ReportingServices.ReportProcessing.ReportProcessing.ProcessOdpReport(Report report, OnDemandMetadata odpMetadataFromSnapshot, ProcessingContext pc, Boolean snapshotProcessing, Boolean reprocessSnapshot, Boolean processUserSortFilterEvent, Boolean processWithCachedData, ErrorContext errorContext, DateTime executionTime, IChunkFactory cacheDataChunkFactory, StoreServerParameters storeServerParameters, GlobalIDOwnerCollection globalIDOwnerCollection, SortFilterEventInfoMap oldUserSortInformation, EventInformation newUserSortInformation, String oldUserSortEventSourceUniqueName, ExecutionLogContext executionLogContext, OnDemandProcessingContext&amp; odpContext)&#xD;&#xA;   at Microsoft.ReportingServices.ReportProcessing.ReportProcessing.RenderReport(IRenderingExtension newRenderer, DateTime executionTimeStamp, ProcessingContext pc, RenderingContext rc, IChunkFactory cacheDataChunkFactory, IChunkFactory yukonCompiledDefinition, Boolean&amp; dataCached)&#xD;&#xA;   at Microsoft.ReportingServices.ReportProcessing.ReportProcessing.RenderReport(IRenderingExtension newRenderer, DateTime executionTimeStamp, ProcessingContext pc, RenderingContext rc, IChunkFactory yukonCompiledDefinition)&#xD;&#xA;   at Microsoft.Reporting.LocalService.CreateSnapshotAndRender(CatalogItemContextBase itemContext, ReportProcessing repProc, IRenderingExtension renderer, ProcessingContext pc, RenderingContext rc, SubreportCallbackHandler subreportHandler, ParameterInfoCollection parameters, DatasourceCredentialsCollection credentials)&#xD;&#xA;   at Microsoft.Reporting.LocalService.Render(CatalogItemContextBase itemContext, Boolean allowInternalRenderers, ParameterInfoCollection reportParameters, IEnumerable dataSources, DatasourceCredentialsCollection credentials, CreateAndRegisterStream createStreamCallback, ReportRuntimeSetup runtimeSetup)&#xD;&#xA;   at Microsoft.Reporting.WebForms.LocalReport.InternalRender(String format, Boolean allowInternalRenderers, String deviceInfo, PageCountMode pageCountMode, CreateAndRegisterStream createStreamCallback, Warning[]&amp; warnings)&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at Microsoft.Reporting.WebForms.LocalReport.InternalRender(String format, Boolean allowInternalRenderers, String deviceInfo, PageCountMode pageCountMode, CreateAndRegisterStream createStreamCallback, Warning[]&amp; warnings)&#xD;&#xA;   at Microsoft.Reporting.WebForms.LocalReport.InternalRender(String format, Boolean allowInternalRenderers, String deviceInfo, PageCountMode pageCountMode, String&amp; mimeType, String&amp; encoding, String&amp; fileNameExtension, String[]&amp; streams, Warning[]&amp; warnings)&#xD;&#xA;   at Microsoft.Reporting.WebForms.LocalReport.Render(String format, String deviceInfo, PageCountMode pageCountMode, String&amp; mimeType, String&amp; encoding, String&amp; fileNameExtension, String[]&amp; streams, Warning[]&amp; warnings)&#xD;&#xA;   at Microsoft.Reporting.WebForms.Report.Render(String format, String deviceInfo, String&amp; mimeType, String&amp; encoding, String&amp; fileNameExtension, String[]&amp; streams, Warning[]&amp; warnings)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.CreatePDF(String fileName, List`1 ds, String reportFileName) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 202&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 176&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.Execute(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)"
  time="2018-05-27T13:59:17.0983046Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="55597" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'7c0110ab-ad1e-4d68-b1b9-01f33c2fcba4', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'Microsoft.ReportingServices.ReportProcessing.ReportProcessingException', N'Microsoft.ReportViewer.Common', N'DataSet1', N'', 0, CAST(0x0000A8ED00E68473 AS DateTime), 33, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="Microsoft.ReportingServices.ReportProcessing.ReportProcessingException"
  message="DataSet1"
  source="Microsoft.ReportViewer.Common"
  detail="Microsoft.Reporting.WebForms.LocalProcessingException: An error occurred during local report processing. ---&gt; Microsoft.ReportingServices.ReportProcessing.ProcessingAbortedException: An error has occurred during report processing. ---&gt; Microsoft.ReportingServices.ReportProcessing.ReportProcessingException: DataSet1&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.RuntimeDataSet.RunDataSetQuery()&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.TablixProcessing.RuntimeOnDemandDataSet.Process()&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.RuntimeDataSet.ProcessConcurrent(Object threadSet)&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.OnDemandProcessingContext.AbortHelper.ThrowAbortException(String reportUniqueName)&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.OnDemandProcessingContext.CheckAndThrowIfAborted()&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.RetrievalManager.FetchData(Boolean mergeTran)&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.RetrievalManager.PrefetchData(ReportInstance reportInstance, ParameterInfoCollection parameters, Boolean mergeTran)&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.Merge.FetchData(ReportInstance reportInstance, Boolean mergeTransaction)&#xD;&#xA;   at Microsoft.ReportingServices.ReportProcessing.ReportProcessing.ProcessOdpReport(Report report, OnDemandMetadata odpMetadataFromSnapshot, ProcessingContext pc, Boolean snapshotProcessing, Boolean reprocessSnapshot, Boolean processUserSortFilterEvent, Boolean processWithCachedData, ErrorContext errorContext, DateTime executionTime, IChunkFactory cacheDataChunkFactory, StoreServerParameters storeServerParameters, GlobalIDOwnerCollection globalIDOwnerCollection, SortFilterEventInfoMap oldUserSortInformation, EventInformation newUserSortInformation, String oldUserSortEventSourceUniqueName, ExecutionLogContext executionLogContext, OnDemandProcessingContext&amp; odpContext)&#xD;&#xA;   at Microsoft.ReportingServices.ReportProcessing.ReportProcessing.RenderReport(IRenderingExtension newRenderer, DateTime executionTimeStamp, ProcessingContext pc, RenderingContext rc, IChunkFactory cacheDataChunkFactory, IChunkFactory yukonCompiledDefinition, Boolean&amp; dataCached)&#xD;&#xA;   at Microsoft.ReportingServices.ReportProcessing.ReportProcessing.RenderReport(IRenderingExtension newRenderer, DateTime executionTimeStamp, ProcessingContext pc, RenderingContext rc, IChunkFactory yukonCompiledDefinition)&#xD;&#xA;   at Microsoft.Reporting.LocalService.CreateSnapshotAndRender(CatalogItemContextBase itemContext, ReportProcessing repProc, IRenderingExtension renderer, ProcessingContext pc, RenderingContext rc, SubreportCallbackHandler subreportHandler, ParameterInfoCollection parameters, DatasourceCredentialsCollection credentials)&#xD;&#xA;   at Microsoft.Reporting.LocalService.Render(CatalogItemContextBase itemContext, Boolean allowInternalRenderers, ParameterInfoCollection reportParameters, IEnumerable dataSources, DatasourceCredentialsCollection credentials, CreateAndRegisterStream createStreamCallback, ReportRuntimeSetup runtimeSetup)&#xD;&#xA;   at Microsoft.Reporting.WebForms.LocalReport.InternalRender(String format, Boolean allowInternalRenderers, String deviceInfo, PageCountMode pageCountMode, CreateAndRegisterStream createStreamCallback, Warning[]&amp; warnings)&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at Microsoft.Reporting.WebForms.LocalReport.InternalRender(String format, Boolean allowInternalRenderers, String deviceInfo, PageCountMode pageCountMode, CreateAndRegisterStream createStreamCallback, Warning[]&amp; warnings)&#xD;&#xA;   at Microsoft.Reporting.WebForms.LocalReport.InternalRender(String format, Boolean allowInternalRenderers, String deviceInfo, PageCountMode pageCountMode, String&amp; mimeType, String&amp; encoding, String&amp; fileNameExtension, String[]&amp; streams, Warning[]&amp; warnings)&#xD;&#xA;   at Microsoft.Reporting.WebForms.LocalReport.Render(String format, String deviceInfo, PageCountMode pageCountMode, String&amp; mimeType, String&amp; encoding, String&amp; fileNameExtension, String[]&amp; streams, Warning[]&amp; warnings)&#xD;&#xA;   at Microsoft.Reporting.WebForms.Report.Render(String format, String deviceInfo, String&amp; mimeType, String&amp; encoding, String&amp; fileNameExtension, String[]&amp; streams, Warning[]&amp; warnings)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.CreatePDF(String fileName, List`1 ds, String reportFileName) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 202&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 176&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.Execute(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-27T13:59:17.2904324Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="55597" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'1f3ec9a6-9933-4cf1-8da4-10d7d47fa8c1', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'Microsoft.ReportingServices.ReportProcessing.ReportProcessingException', N'Microsoft.ReportViewer.Common', N'DataSet1', N'', 0, CAST(0x0000A8ED00E6847D AS DateTime), 34, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="Microsoft.ReportingServices.ReportProcessing.ReportProcessingException"
  message="DataSet1"
  source="Microsoft.ReportViewer.Common"
  detail="Microsoft.Reporting.WebForms.LocalProcessingException: An error occurred during local report processing. ---&gt; Microsoft.ReportingServices.ReportProcessing.ProcessingAbortedException: An error has occurred during report processing. ---&gt; Microsoft.ReportingServices.ReportProcessing.ReportProcessingException: DataSet1&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.RuntimeDataSet.RunDataSetQuery()&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.TablixProcessing.RuntimeOnDemandDataSet.Process()&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.RuntimeDataSet.ProcessConcurrent(Object threadSet)&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.OnDemandProcessingContext.AbortHelper.ThrowAbortException(String reportUniqueName)&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.OnDemandProcessingContext.CheckAndThrowIfAborted()&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.RetrievalManager.FetchData(Boolean mergeTran)&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.RetrievalManager.PrefetchData(ReportInstance reportInstance, ParameterInfoCollection parameters, Boolean mergeTran)&#xD;&#xA;   at Microsoft.ReportingServices.OnDemandProcessing.Merge.FetchData(ReportInstance reportInstance, Boolean mergeTransaction)&#xD;&#xA;   at Microsoft.ReportingServices.ReportProcessing.ReportProcessing.ProcessOdpReport(Report report, OnDemandMetadata odpMetadataFromSnapshot, ProcessingContext pc, Boolean snapshotProcessing, Boolean reprocessSnapshot, Boolean processUserSortFilterEvent, Boolean processWithCachedData, ErrorContext errorContext, DateTime executionTime, IChunkFactory cacheDataChunkFactory, StoreServerParameters storeServerParameters, GlobalIDOwnerCollection globalIDOwnerCollection, SortFilterEventInfoMap oldUserSortInformation, EventInformation newUserSortInformation, String oldUserSortEventSourceUniqueName, ExecutionLogContext executionLogContext, OnDemandProcessingContext&amp; odpContext)&#xD;&#xA;   at Microsoft.ReportingServices.ReportProcessing.ReportProcessing.RenderReport(IRenderingExtension newRenderer, DateTime executionTimeStamp, ProcessingContext pc, RenderingContext rc, IChunkFactory cacheDataChunkFactory, IChunkFactory yukonCompiledDefinition, Boolean&amp; dataCached)&#xD;&#xA;   at Microsoft.ReportingServices.ReportProcessing.ReportProcessing.RenderReport(IRenderingExtension newRenderer, DateTime executionTimeStamp, ProcessingContext pc, RenderingContext rc, IChunkFactory yukonCompiledDefinition)&#xD;&#xA;   at Microsoft.Reporting.LocalService.CreateSnapshotAndRender(CatalogItemContextBase itemContext, ReportProcessing repProc, IRenderingExtension renderer, ProcessingContext pc, RenderingContext rc, SubreportCallbackHandler subreportHandler, ParameterInfoCollection parameters, DatasourceCredentialsCollection credentials)&#xD;&#xA;   at Microsoft.Reporting.LocalService.Render(CatalogItemContextBase itemContext, Boolean allowInternalRenderers, ParameterInfoCollection reportParameters, IEnumerable dataSources, DatasourceCredentialsCollection credentials, CreateAndRegisterStream createStreamCallback, ReportRuntimeSetup runtimeSetup)&#xD;&#xA;   at Microsoft.Reporting.WebForms.LocalReport.InternalRender(String format, Boolean allowInternalRenderers, String deviceInfo, PageCountMode pageCountMode, CreateAndRegisterStream createStreamCallback, Warning[]&amp; warnings)&#xD;&#xA;   --- End of inner exception stack trace ---&#xD;&#xA;   at Microsoft.Reporting.WebForms.LocalReport.InternalRender(String format, Boolean allowInternalRenderers, String deviceInfo, PageCountMode pageCountMode, CreateAndRegisterStream createStreamCallback, Warning[]&amp; warnings)&#xD;&#xA;   at Microsoft.Reporting.WebForms.LocalReport.InternalRender(String format, Boolean allowInternalRenderers, String deviceInfo, PageCountMode pageCountMode, String&amp; mimeType, String&amp; encoding, String&amp; fileNameExtension, String[]&amp; streams, Warning[]&amp; warnings)&#xD;&#xA;   at Microsoft.Reporting.WebForms.LocalReport.Render(String format, String deviceInfo, PageCountMode pageCountMode, String&amp; mimeType, String&amp; encoding, String&amp; fileNameExtension, String[]&amp; streams, Warning[]&amp; warnings)&#xD;&#xA;   at Microsoft.Reporting.WebForms.Report.Render(String format, String deviceInfo, String&amp; mimeType, String&amp; encoding, String&amp; fileNameExtension, String[]&amp; streams, Warning[]&amp; warnings)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.CreatePDF(String fileName, List`1 ds, String reportFileName) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 202&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 176&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.Execute(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-27T13:59:17.3234539Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="55597" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'dac1e4bd-eda9-4409-ba27-4e1c6d3c2431', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.NullReferenceException', N'NPSSOnlineRecruitmentPortal', N'Object reference not set to an instance of an object.', N'', 0, CAST(0x0000A8ED013BD541 AS DateTime), 38, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.NullReferenceException"
  message="Object reference not set to an instance of an object."
  source="NPSSOnlineRecruitmentPortal"
  detail="System.NullReferenceException: Object reference not set to an instance of an object.&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.SendMailToMultipleUser(String toemailid, String attachment, Byte[] bytes) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 229&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.CreatePDF(String fileName, List`1 ds, String reportFileName) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 207&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 181&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)"
  time="2018-05-27T19:09:54.7765529Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/Home/Application?postSelection=1&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/Home/Application?postSelection=1&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="58633" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/Home/Application?postSelection=1" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'b51b1e93-6dcc-4b2f-b21a-834c3f89f1f1', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.NullReferenceException', N'NPSSOnlineRecruitmentPortal', N'Object reference not set to an instance of an object.', N'', 0, CAST(0x0000A8ED013BD767 AS DateTime), 39, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.NullReferenceException"
  message="Object reference not set to an instance of an object."
  source="NPSSOnlineRecruitmentPortal"
  detail="System.NullReferenceException: Object reference not set to an instance of an object.&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.SendMailToMultipleUser(String toemailid, String attachment, Byte[] bytes) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 229&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.CreatePDF(String fileName, List`1 ds, String reportFileName) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 207&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 181&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-27T19:09:56.6087143Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/Home/Application?postSelection=1&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/Home/Application?postSelection=1&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="58633" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/Home/Application?postSelection=1" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'f19f2de3-95fc-405e-a04d-b0adcfc0451a', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.NullReferenceException', N'NPSSOnlineRecruitmentPortal', N'Object reference not set to an instance of an object.', N'', 0, CAST(0x0000A8ED013BD77E AS DateTime), 40, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.NullReferenceException"
  message="Object reference not set to an instance of an object."
  source="NPSSOnlineRecruitmentPortal"
  detail="System.NullReferenceException: Object reference not set to an instance of an object.&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.SendMailToMultipleUser(String toemailid, String attachment, Byte[] bytes) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 229&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.CreatePDF(String fileName, List`1 ds, String reportFileName) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 207&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 181&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-27T19:09:56.6865222Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/Home/Application?postSelection=1&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/Home/Application?postSelection=1&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="58633" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/Home/Application?postSelection=1" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'aa683073-c589-40b2-b7a2-c4d9f4648fb9', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.NullReferenceException', N'NPSSOnlineRecruitmentPortal', N'Object reference not set to an instance of an object.', N'', 0, CAST(0x0000A8ED013C4D3D AS DateTime), 41, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.NullReferenceException"
  message="Object reference not set to an instance of an object."
  source="NPSSOnlineRecruitmentPortal"
  detail="System.NullReferenceException: Object reference not set to an instance of an object.&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.SendMailToMultipleUser(String toemailid, String attachment, Byte[] bytes) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 229&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.CreatePDF(String fileName, List`1 ds, String reportFileName) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 207&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 181&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)"
  time="2018-05-27T19:11:37.1628495Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="58669" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'b9ce3f45-5279-4d27-abc9-4f1927c7519d', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.NullReferenceException', N'NPSSOnlineRecruitmentPortal', N'Object reference not set to an instance of an object.', N'', 0, CAST(0x0000A8ED013C4D44 AS DateTime), 42, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.NullReferenceException"
  message="Object reference not set to an instance of an object."
  source="NPSSOnlineRecruitmentPortal"
  detail="System.NullReferenceException: Object reference not set to an instance of an object.&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.SendMailToMultipleUser(String toemailid, String attachment, Byte[] bytes) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 229&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.CreatePDF(String fileName, List`1 ds, String reportFileName) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 207&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 181&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-27T19:11:37.1857651Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="58669" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'ab6c7c97-b124-482c-aa1f-cdbf0848dae9', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.NullReferenceException', N'NPSSOnlineRecruitmentPortal', N'Object reference not set to an instance of an object.', N'', 0, CAST(0x0000A8ED013C4D50 AS DateTime), 43, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.NullReferenceException"
  message="Object reference not set to an instance of an object."
  source="NPSSOnlineRecruitmentPortal"
  detail="System.NullReferenceException: Object reference not set to an instance of an object.&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.SendMailToMultipleUser(String toemailid, String attachment, Byte[] bytes) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 229&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.CreatePDF(String fileName, List`1 ds, String reportFileName) in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 207&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 181&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-27T19:11:37.2257899Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="58669" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'7924c130-8fbe-4553-a16c-1be4e26f6faf', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.Data.Entity.Core.EntityCommandExecutionException', N'EntityFramework', N'The data reader is incompatible with the specified ''NPSSModel.ApplicantMaster''. A member of the type, ''ApplicantID'', does not have a corresponding column in the data reader with the same name.', N'', 0, CAST(0x0000A8ED00F2A2EF AS DateTime), 35, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.Data.Entity.Core.EntityCommandExecutionException"
  message="The data reader is incompatible with the specified ''NPSSModel.ApplicantMaster''. A member of the type, ''ApplicantID'', does not have a corresponding column in the data reader with the same name."
  source="EntityFramework"
  detail="System.Data.Entity.Core.EntityCommandExecutionException: The data reader is incompatible with the specified ''NPSSModel.ApplicantMaster''. A member of the type, ''ApplicantID'', does not have a corresponding column in the data reader with the same name.&#xD;&#xA;   at System.Data.Entity.Core.Query.InternalTrees.ColumnMapFactory.GetMemberOrdinalFromReader(DbDataReader storeDataReader, EdmMember member, EdmType currentType, Dictionary`2 renameList)&#xD;&#xA;   at System.Data.Entity.Core.Query.InternalTrees.ColumnMapFactory.GetColumnMapsForType(DbDataReader storeDataReader, EdmType edmType, Dictionary`2 renameList)&#xD;&#xA;   at System.Data.Entity.Core.Query.InternalTrees.ColumnMapFactory.CreateColumnMapFromReaderAndType(DbDataReader storeDataReader, EdmType edmType, EntitySet entitySet, Dictionary`2 renameList)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.InternalTranslate[TElement](DbDataReader reader, String entitySetName, MergeOption mergeOption, Boolean streaming, EntitySet&amp; entitySet, TypeUsage&amp; edmType)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQueryInternal[TElement](String commandText, String entitySetName, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.&lt;&gt;c__DisplayClass63`1.&lt;ExecuteStoreQueryReliably&gt;b__62()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteInTransaction[T](Func`1 func, IDbExecutionStrategy executionStrategy, Boolean startLocalTransaction, Boolean releaseConnectionOnSuccess)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.&lt;&gt;c__DisplayClass63`1.&lt;ExecuteStoreQueryReliably&gt;b__61()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQueryReliably[TElement](String commandText, String entitySetName, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQuery[TElement](String commandText, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Internal.InternalContext.&lt;&gt;c__DisplayClass13`1.&lt;ExecuteSqlQuery&gt;b__12()&#xD;&#xA;   at System.Lazy`1.CreateValue()&#xD;&#xA;   at System.Lazy`1.LazyInitValue()&#xD;&#xA;   at System.Data.Entity.Internal.LazyEnumerator`1.MoveNext()&#xD;&#xA;   at System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)&#xD;&#xA;   at System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 175&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.Execute(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)"
  time="2018-05-27T14:43:24.7439646Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="56067" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'99846f33-c159-4ae5-a96b-0371c86e594e', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.Data.Entity.Core.EntityCommandExecutionException', N'EntityFramework', N'The data reader is incompatible with the specified ''NPSSModel.ApplicantMaster''. A member of the type, ''ApplicantID'', does not have a corresponding column in the data reader with the same name.', N'', 0, CAST(0x0000A8ED00F2A3B0 AS DateTime), 36, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.Data.Entity.Core.EntityCommandExecutionException"
  message="The data reader is incompatible with the specified ''NPSSModel.ApplicantMaster''. A member of the type, ''ApplicantID'', does not have a corresponding column in the data reader with the same name."
  source="EntityFramework"
  detail="System.Data.Entity.Core.EntityCommandExecutionException: The data reader is incompatible with the specified ''NPSSModel.ApplicantMaster''. A member of the type, ''ApplicantID'', does not have a corresponding column in the data reader with the same name.&#xD;&#xA;   at System.Data.Entity.Core.Query.InternalTrees.ColumnMapFactory.GetMemberOrdinalFromReader(DbDataReader storeDataReader, EdmMember member, EdmType currentType, Dictionary`2 renameList)&#xD;&#xA;   at System.Data.Entity.Core.Query.InternalTrees.ColumnMapFactory.GetColumnMapsForType(DbDataReader storeDataReader, EdmType edmType, Dictionary`2 renameList)&#xD;&#xA;   at System.Data.Entity.Core.Query.InternalTrees.ColumnMapFactory.CreateColumnMapFromReaderAndType(DbDataReader storeDataReader, EdmType edmType, EntitySet entitySet, Dictionary`2 renameList)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.InternalTranslate[TElement](DbDataReader reader, String entitySetName, MergeOption mergeOption, Boolean streaming, EntitySet&amp; entitySet, TypeUsage&amp; edmType)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQueryInternal[TElement](String commandText, String entitySetName, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.&lt;&gt;c__DisplayClass63`1.&lt;ExecuteStoreQueryReliably&gt;b__62()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteInTransaction[T](Func`1 func, IDbExecutionStrategy executionStrategy, Boolean startLocalTransaction, Boolean releaseConnectionOnSuccess)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.&lt;&gt;c__DisplayClass63`1.&lt;ExecuteStoreQueryReliably&gt;b__61()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQueryReliably[TElement](String commandText, String entitySetName, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQuery[TElement](String commandText, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Internal.InternalContext.&lt;&gt;c__DisplayClass13`1.&lt;ExecuteSqlQuery&gt;b__12()&#xD;&#xA;   at System.Lazy`1.CreateValue()&#xD;&#xA;   at System.Lazy`1.LazyInitValue()&#xD;&#xA;   at System.Data.Entity.Internal.LazyEnumerator`1.MoveNext()&#xD;&#xA;   at System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)&#xD;&#xA;   at System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 175&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.Execute(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-27T14:43:25.3850981Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="56067" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
INSERT [dbo].[ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source], [Message], [User], [StatusCode], [TimeUtc], [Sequence], [AllXml]) VALUES (N'ed85f656-6157-4ae3-a506-6ee98d89fe39', N'/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal', N'JAY', N'System.Data.Entity.Core.EntityCommandExecutionException', N'EntityFramework', N'The data reader is incompatible with the specified ''NPSSModel.ApplicantMaster''. A member of the type, ''ApplicantID'', does not have a corresponding column in the data reader with the same name.', N'', 0, CAST(0x0000A8ED00F2A3B3 AS DateTime), 37, N'<error
  application="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal"
  host="JAY"
  type="System.Data.Entity.Core.EntityCommandExecutionException"
  message="The data reader is incompatible with the specified ''NPSSModel.ApplicantMaster''. A member of the type, ''ApplicantID'', does not have a corresponding column in the data reader with the same name."
  source="EntityFramework"
  detail="System.Data.Entity.Core.EntityCommandExecutionException: The data reader is incompatible with the specified ''NPSSModel.ApplicantMaster''. A member of the type, ''ApplicantID'', does not have a corresponding column in the data reader with the same name.&#xD;&#xA;   at System.Data.Entity.Core.Query.InternalTrees.ColumnMapFactory.GetMemberOrdinalFromReader(DbDataReader storeDataReader, EdmMember member, EdmType currentType, Dictionary`2 renameList)&#xD;&#xA;   at System.Data.Entity.Core.Query.InternalTrees.ColumnMapFactory.GetColumnMapsForType(DbDataReader storeDataReader, EdmType edmType, Dictionary`2 renameList)&#xD;&#xA;   at System.Data.Entity.Core.Query.InternalTrees.ColumnMapFactory.CreateColumnMapFromReaderAndType(DbDataReader storeDataReader, EdmType edmType, EntitySet entitySet, Dictionary`2 renameList)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.InternalTranslate[TElement](DbDataReader reader, String entitySetName, MergeOption mergeOption, Boolean streaming, EntitySet&amp; entitySet, TypeUsage&amp; edmType)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQueryInternal[TElement](String commandText, String entitySetName, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.&lt;&gt;c__DisplayClass63`1.&lt;ExecuteStoreQueryReliably&gt;b__62()&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteInTransaction[T](Func`1 func, IDbExecutionStrategy executionStrategy, Boolean startLocalTransaction, Boolean releaseConnectionOnSuccess)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.&lt;&gt;c__DisplayClass63`1.&lt;ExecuteStoreQueryReliably&gt;b__61()&#xD;&#xA;   at System.Data.Entity.SqlServer.DefaultSqlExecutionStrategy.Execute[TResult](Func`1 operation)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQueryReliably[TElement](String commandText, String entitySetName, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Core.Objects.ObjectContext.ExecuteStoreQuery[TElement](String commandText, ExecutionOptions executionOptions, Object[] parameters)&#xD;&#xA;   at System.Data.Entity.Internal.InternalContext.&lt;&gt;c__DisplayClass13`1.&lt;ExecuteSqlQuery&gt;b__12()&#xD;&#xA;   at System.Lazy`1.CreateValue()&#xD;&#xA;   at System.Lazy`1.LazyInitValue()&#xD;&#xA;   at System.Data.Entity.Internal.LazyEnumerator`1.MoveNext()&#xD;&#xA;   at System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)&#xD;&#xA;   at System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)&#xD;&#xA;   at NPSSOnlineRecruitmentPortal.Controllers.HomeController.Report() in f:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Controllers\HomeController.cs:line 175&#xD;&#xA;   at lambda_method(Closure , ControllerBase , Object[] )&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.&lt;&gt;c__DisplayClass1.&lt;WrapVoidAction&gt;b__0(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ActionMethodDispatcher.Execute(ControllerBase controller, Object[] parameters)&#xD;&#xA;   at System.Web.Mvc.ReflectedActionDescriptor.Execute(ControllerContext controllerContext, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.ControllerActionInvoker.InvokeActionMethod(ControllerContext controllerContext, ActionDescriptor actionDescriptor, IDictionary`2 parameters)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.ActionInvocation.InvokeSynchronousActionMethod()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;BeginInvokeSynchronousActionMethod&gt;b__36(IAsyncResult asyncResult, ActionInvocation innerInvokeState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`2.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethod(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3c()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.AsyncInvocationWithFilters.&lt;&gt;c__DisplayClass45.&lt;InvokeActionMethodFilterAsynchronouslyRecursive&gt;b__3e()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass30.&lt;BeginInvokeActionMethodWithFilters&gt;b__2f(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeActionMethodWithFilters(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;&gt;c__DisplayClass28.&lt;BeginInvokeAction&gt;b__19()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.&lt;&gt;c__DisplayClass1e.&lt;BeginInvokeAction&gt;b__1b(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResult`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncControllerActionInvoker.EndInvokeAction(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecuteCore&gt;b__1d(IAsyncResult asyncResult, ExecuteCoreState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecuteCore(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.&lt;BeginExecute&gt;b__15(IAsyncResult asyncResult, Controller controller)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Controller.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Controller.System.Web.Mvc.Async.IAsyncController.EndExecute(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.&lt;BeginProcessRequest&gt;b__4(IAsyncResult asyncResult, ProcessRequestState innerState)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncVoid`1.CallEndDelegate(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.WrappedAsyncResultBase`1.End()&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End[TResult](IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.Async.AsyncResultWrapper.End(IAsyncResult asyncResult, Object tag)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.EndProcessRequest(IAsyncResult asyncResult)&#xD;&#xA;   at System.Web.Mvc.MvcHandler.System.Web.IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)&#xD;&#xA;   at System.Web.HttpApplication.CallHandlerExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute()&#xD;&#xA;   at System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously)"
  time="2018-05-27T14:43:25.3971048Z">
  <serverVariables>
    <item
      name="ALL_HTTP">
      <value
        string="HTTP_CONNECTION:keep-alive&#xD;&#xA;HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;HTTP_ACCEPT_ENCODING:gzip, deflate, br&#xD;&#xA;HTTP_ACCEPT_LANGUAGE:en-US,en;q=0.9&#xD;&#xA;HTTP_HOST:localhost&#xD;&#xA;HTTP_REFERER:http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;HTTP_USER_AGENT:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;HTTP_UPGRADE_INSECURE_REQUESTS:1&#xD;&#xA;" />
    </item>
    <item
      name="ALL_RAW">
      <value
        string="Connection: keep-alive&#xD;&#xA;Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8&#xD;&#xA;Accept-Encoding: gzip, deflate, br&#xD;&#xA;Accept-Language: en-US,en;q=0.9&#xD;&#xA;Host: localhost&#xD;&#xA;Referer: http://localhost/NPSSOnlineRecruitmentPortal/&#xD;&#xA;User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36&#xD;&#xA;Upgrade-Insecure-Requests: 1&#xD;&#xA;" />
    </item>
    <item
      name="APPL_MD_PATH">
      <value
        string="/LM/W3SVC/1/ROOT/NPSSOnlineRecruitmentPortal" />
    </item>
    <item
      name="APPL_PHYSICAL_PATH">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\" />
    </item>
    <item
      name="AUTH_TYPE">
      <value
        string="" />
    </item>
    <item
      name="AUTH_USER">
      <value
        string="" />
    </item>
    <item
      name="AUTH_PASSWORD">
      <value
        string="*****" />
    </item>
    <item
      name="LOGON_USER">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_USER">
      <value
        string="" />
    </item>
    <item
      name="CERT_COOKIE">
      <value
        string="" />
    </item>
    <item
      name="CERT_FLAGS">
      <value
        string="" />
    </item>
    <item
      name="CERT_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERIALNUMBER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="CERT_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CERT_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="CONTENT_LENGTH">
      <value
        string="0" />
    </item>
    <item
      name="CONTENT_TYPE">
      <value
        string="" />
    </item>
    <item
      name="GATEWAY_INTERFACE">
      <value
        string="CGI/1.1" />
    </item>
    <item
      name="HTTPS">
      <value
        string="off" />
    </item>
    <item
      name="HTTPS_KEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SECRETKEYSIZE">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_ISSUER">
      <value
        string="" />
    </item>
    <item
      name="HTTPS_SERVER_SUBJECT">
      <value
        string="" />
    </item>
    <item
      name="INSTANCE_ID">
      <value
        string="1" />
    </item>
    <item
      name="INSTANCE_META_PATH">
      <value
        string="/LM/W3SVC/1" />
    </item>
    <item
      name="LOCAL_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="PATH_INFO">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="PATH_TRANSLATED">
      <value
        string="F:\project\NPSSOnlineRecruitmentPortal\NPSSOnlineRecruitmentPortal\Home\Report" />
    </item>
    <item
      name="QUERY_STRING">
      <value
        string="" />
    </item>
    <item
      name="REMOTE_ADDR">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_HOST">
      <value
        string="::1" />
    </item>
    <item
      name="REMOTE_PORT">
      <value
        string="56067" />
    </item>
    <item
      name="REQUEST_METHOD">
      <value
        string="GET" />
    </item>
    <item
      name="SCRIPT_NAME">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="SERVER_NAME">
      <value
        string="localhost" />
    </item>
    <item
      name="SERVER_PORT">
      <value
        string="80" />
    </item>
    <item
      name="SERVER_PORT_SECURE">
      <value
        string="0" />
    </item>
    <item
      name="SERVER_PROTOCOL">
      <value
        string="HTTP/1.1" />
    </item>
    <item
      name="SERVER_SOFTWARE">
      <value
        string="Microsoft-IIS/8.5" />
    </item>
    <item
      name="URL">
      <value
        string="/NPSSOnlineRecruitmentPortal/Home/Report" />
    </item>
    <item
      name="HTTP_CONNECTION">
      <value
        string="keep-alive" />
    </item>
    <item
      name="HTTP_ACCEPT">
      <value
        string="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" />
    </item>
    <item
      name="HTTP_ACCEPT_ENCODING">
      <value
        string="gzip, deflate, br" />
    </item>
    <item
      name="HTTP_ACCEPT_LANGUAGE">
      <value
        string="en-US,en;q=0.9" />
    </item>
    <item
      name="HTTP_HOST">
      <value
        string="localhost" />
    </item>
    <item
      name="HTTP_REFERER">
      <value
        string="http://localhost/NPSSOnlineRecruitmentPortal/" />
    </item>
    <item
      name="HTTP_USER_AGENT">
      <value
        string="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" />
    </item>
    <item
      name="HTTP_UPGRADE_INSECURE_REQUESTS">
      <value
        string="1" />
    </item>
  </serverVariables>
</error>')
GO
SET IDENTITY_INSERT [dbo].[ELMAH_Error] OFF
GO
SET IDENTITY_INSERT [dbo].[QualificationHeader] ON 

GO
INSERT [dbo].[QualificationHeader] ([QualificationHeaderID], [QualificationHeader], [FIELDTYPE], [ReportName]) VALUES (1, N'PASSING YEAR', 1, N'PASSINGYEAR')
GO
INSERT [dbo].[QualificationHeader] ([QualificationHeaderID], [QualificationHeader], [FIELDTYPE], [ReportName]) VALUES (2, N'INSTITUTE NAME', 0, N'INSTITUTENAME')
GO
INSERT [dbo].[QualificationHeader] ([QualificationHeaderID], [QualificationHeader], [FIELDTYPE], [ReportName]) VALUES (3, N'NOOFTRIALS', 1, N'NOOFTRIALS')
GO
INSERT [dbo].[QualificationHeader] ([QualificationHeaderID], [QualificationHeader], [FIELDTYPE], [ReportName]) VALUES (4, N'TOTALMARKS', 1, N'TOTALMARKS')
GO
INSERT [dbo].[QualificationHeader] ([QualificationHeaderID], [QualificationHeader], [FIELDTYPE], [ReportName]) VALUES (5, N'MARKS', 1, N'MARKS')
GO
INSERT [dbo].[QualificationHeader] ([QualificationHeaderID], [QualificationHeader], [FIELDTYPE], [ReportName]) VALUES (6, N'PERCENTAGE', 1, N'PERCENTAGE')
GO
INSERT [dbo].[QualificationHeader] ([QualificationHeaderID], [QualificationHeader], [FIELDTYPE], [ReportName]) VALUES (7, N'REMARKS', 0, N'REMARKS')
GO
SET IDENTITY_INSERT [dbo].[QualificationHeader] OFF
GO
/****** Object:  Index [PK_ELMAH_Error]    Script Date: 28-May-18 12:54:44 AM ******/
ALTER TABLE [dbo].[ELMAH_Error] ADD  CONSTRAINT [PK_ELMAH_Error] PRIMARY KEY NONCLUSTERED 
(
	[ErrorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ELMAH_Error] ADD  CONSTRAINT [DF_ELMAH_Error_ErrorId]  DEFAULT (newid()) FOR [ErrorId]
GO
