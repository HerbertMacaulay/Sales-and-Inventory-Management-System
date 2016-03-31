USE [master]
GO
/****** Object:  Database [SIMS]    Script Date: 31/03/2016 05:32:42 AM ******/
CREATE DATABASE [SIMS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SIMS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLSERVER2012\MSSQL\DATA\SIMS.mdf' , SIZE = 19456KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SIMS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLSERVER2012\MSSQL\DATA\SIMS_log.ldf' , SIZE = 12352KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SIMS] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SIMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SIMS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SIMS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SIMS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SIMS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SIMS] SET ARITHABORT OFF 
GO
ALTER DATABASE [SIMS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SIMS] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SIMS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SIMS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SIMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SIMS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SIMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SIMS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SIMS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SIMS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SIMS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SIMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SIMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SIMS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SIMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SIMS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SIMS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SIMS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SIMS] SET RECOVERY FULL 
GO
ALTER DATABASE [SIMS] SET  MULTI_USER 
GO
ALTER DATABASE [SIMS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SIMS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SIMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SIMS] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'SIMS', N'ON'
GO
USE [SIMS]
GO
/****** Object:  User [sims]    Script Date: 31/03/2016 05:32:44 AM ******/
CREATE USER [sims] FOR LOGIN [sims] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [aspnet_Membership_ReportingAccess]    Script Date: 31/03/2016 05:32:44 AM ******/
CREATE ROLE [aspnet_Membership_ReportingAccess]
GO
/****** Object:  DatabaseRole [aspnet_Membership_FullAccess]    Script Date: 31/03/2016 05:32:44 AM ******/
CREATE ROLE [aspnet_Membership_FullAccess]
GO
/****** Object:  DatabaseRole [aspnet_Membership_BasicAccess]    Script Date: 31/03/2016 05:32:44 AM ******/
CREATE ROLE [aspnet_Membership_BasicAccess]
GO
ALTER ROLE [db_owner] ADD MEMBER [sims]
GO
ALTER ROLE [aspnet_Membership_BasicAccess] ADD MEMBER [aspnet_Membership_FullAccess]
GO
ALTER ROLE [aspnet_Membership_ReportingAccess] ADD MEMBER [aspnet_Membership_FullAccess]
GO
/****** Object:  UserDefinedTableType [dbo].[ItemsType]    Script Date: 31/03/2016 05:32:44 AM ******/
CREATE TYPE [dbo].[ItemsType] AS TABLE(
	[barcode_data] [varchar](14) NOT NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[SalesType]    Script Date: 31/03/2016 05:32:44 AM ******/
CREATE TYPE [dbo].[SalesType] AS TABLE(
	[item_id] [int] NOT NULL,
	[item_name] [varchar](50) NOT NULL,
	[unit_price] [decimal](19, 2) NOT NULL,
	[quantity_sold] [int] NOT NULL,
	[total_price] [decimal](19, 2) NOT NULL
)
GO
/****** Object:  StoredProcedure [dbo].[AddAffiliate]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AddAffiliate]

@VendorId      int,
@StartDate     datetime,
@EndDate       datetime,
@CPC           float,
@CPA           float

as

insert into dbo.Affiliates (
    VendorId,
    StartDate,
    EndDate,
    CPC,
    Clicks,
    CPA,
    Acquisitions
)
values (
    @VendorId,
    @StartDate,
    @EndDate,
    @CPC,
    0,
    @CPA,
    0
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddAuthentication]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddAuthentication]
	@PackageID				int,
	@AuthenticationType     nvarchar(100),
	@IsEnabled				bit,
	@SettingsControlSrc     nvarchar(250),
	@LoginControlSrc		nvarchar(250),
	@LogoffControlSrc		nvarchar(250),
	@CreatedByUserID	int
AS
	INSERT INTO Authentication (
		PackageID,
		AuthenticationType,
		IsEnabled,
		SettingsControlSrc,
		LoginControlSrc,
		LogoffControlSrc,
		[CreatedByUserID],
		[CreatedOnDate],
		[LastModifiedByUserID],
		[LastModifiedOnDate]
	)
	VALUES (
		@PackageID,
		@AuthenticationType,
		@IsEnabled,
		@SettingsControlSrc,
		@LoginControlSrc,
		@LogoffControlSrc,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate()
	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddBanner]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AddBanner]

@BannerName    nvarchar(100),
@VendorId      int,
@ImageFile     nvarchar(100),
@URL           nvarchar(255),
@Impressions   int,
@CPM           float,
@StartDate     datetime,
@EndDate       datetime,
@UserName      nvarchar(100),
@BannerTypeId  int,
@Description   nvarchar(2000),
@GroupName     nvarchar(100),
@Criteria      bit,
@Width         int,
@Height        int

as

insert into dbo.Banners (
    VendorId,
    ImageFile,
    BannerName,
    URL,
    Impressions,
    CPM,
    Views,
    ClickThroughs,
    StartDate,
    EndDate,
    CreatedByUser,
    CreatedDate,
    BannerTypeId,
    Description,
    GroupName,
    Criteria,
    Width,
    Height
)
values (
    @VendorId,
    @ImageFile,
    @BannerName,
    @URL,
    @Impressions,
    @CPM,
    0,
    0,
    @StartDate,
    @EndDate,
    @UserName,
    getdate(),
    @BannerTypeId,
    @Description,
    @GroupName,
    @Criteria,
    @Width,
    @Height
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddContentItem]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddContentItem] 
	@Content			nvarchar(max),
	@ContentTypeID		int,
	@TabID				int,
	@ModuleID			int, 
	@ContentKey			nvarchar(250),
	@Indexed			bit,
	@CreatedByUserID	int,
	@StateID			int = NULL
AS
	INSERT INTO dbo.[ContentItems] (
		Content,
		ContentTypeID,
		TabID,
		ModuleID,
		ContentKey,
		Indexed,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate,
		StateID
	)

	VALUES (
		@Content,
		@ContentTypeID,
		@TabID,
		@ModuleID,
		@ContentKey,
		@Indexed,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate(),
		@StateID
	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddContentType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddContentType] 
	@ContentType	nvarchar(250)
AS
	INSERT INTO dbo.ContentTypes (
		ContentType
	)

	VALUES (
		@ContentType
	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddContentWorkflow]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddContentWorkflow]
@PortalID int,
@WorkflowName nvarchar(40),
@Description nvarchar(256),
@IsDeleted bit,
@StartAfterCreating bit,
@StartAfterEditing bit,
@DispositionEnabled bit
AS

INSERT INTO dbo.ContentWorkflows (
  [PortalID],
  [WorkflowName],
  [Description],
  [IsDeleted],
  [StartAfterCreating],
  [StartAfterEditing],
  [DispositionEnabled]
)
VALUES (
  @PortalID,
  @WorkflowName,
  @Description,
  @IsDeleted,
  @StartAfterCreating,
  @StartAfterEditing,
  @DispositionEnabled
)

SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddContentWorkflowLog]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddContentWorkflowLog]
	@Action nvarchar(40),
	@Comment nvarchar(256),
	@User int,
	@WorkflowID int,
	@ContentItemID int
AS
    INSERT INTO dbo.[ContentWorkflowLogs] (
		[Action],
		[Comment],
		[Date],
		[User],
		[WorkflowID],
		[ContentItemID]
	) VALUES (
		@Action,
		@Comment,
		getdate(),
		@User,
		@WorkflowID,
		@ContentItemID
	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddContentWorkflowSource]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddContentWorkflowSource]
	@WorkflowID INT,
    @SourceName NVARCHAR(20),
    @SourceType NVARCHAR(250)
AS
    INSERT INTO  dbo.ContentWorkflowSources(
		[WorkflowID],
		[SourceName],
		[SourceType])
    VALUES(
        @WorkflowID,
        @SourceName,
        @SourceType
    )

    SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddContentWorkflowState]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddContentWorkflowState]
	@WorkflowID	int,
	@StateName nvarchar(40),
	@Order int,
	@IsActive bit,
	@SendEmail bit,
	@SendMessage bit,
	@IsDisposalState bit,
	@OnCompleteMessageSubject nvarchar(256),
	@OnCompleteMessageBody nvarchar(1024),
	@OnDiscardMessageSubject nvarchar(256),
	@OnDiscardMessageBody nvarchar(1024)
AS

INSERT INTO dbo.ContentWorkflowStates (
	[WorkflowID],
	[StateName],
	[Order],
	[IsActive],
	[SendEmail],
	[SendMessage],
	[IsDisposalState],
	[OnCompleteMessageSubject],
	[OnCompleteMessageBody],
	[OnDiscardMessageSubject],
	[OnDiscardMessageBody]
)
VALUES (
	@WorkflowID,
	@StateName,
	@Order,
	@IsActive,
	@SendEmail,
	@SendMessage,
	@IsDisposalState,
	@OnCompleteMessageSubject,
	@OnCompleteMessageBody,
	@OnDiscardMessageSubject,
	@OnDiscardMessageBody
)

SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddContentWorkflowStatePermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddContentWorkflowStatePermission]
	@StateID int,
	@PermissionID int,
	@RoleID int,
	@AllowAccess bit,
	@UserID int,
	@CreatedByUserID int
AS

	INSERT INTO dbo.ContentWorkflowStatePermission (
		[StateID],
		[PermissionID],
		[RoleID],
		[AllowAccess],
		[UserID],
		[CreatedByUserID],
		[CreatedOnDate],
		[LastModifiedByUserID],
		[LastModifiedOnDate]
	) VALUES (
		@StateID,
		@PermissionID,
		@RoleID,
		@AllowAccess,
		@UserID,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate()
	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddDefaultFolderTypes]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDefaultFolderTypes]
	@PortalID int
AS
BEGIN
	INSERT INTO dbo.[FolderMappings] (PortalID, MappingName, FolderProviderType, Priority)
	SELECT @PortalID, 'Standard', 'StandardFolderProvider', 1
	UNION ALL
	SELECT @PortalID, 'Secure', 'SecureFolderProvider', 2
	UNION ALL
	SELECT @PortalID, 'Database', 'DatabaseFolderProvider', 3
END
GO
/****** Object:  StoredProcedure [dbo].[AddDesktopModule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDesktopModule]
	@PackageID		int,
	@ModuleName		nvarchar(128),
	@FolderName		nvarchar(128),
	@FriendlyName		nvarchar(128),
	@Description		nvarchar(2000),
	@Version		nvarchar(8),
	@IsPremium		bit,
	@IsAdmin		bit,
	@BusinessController	nvarchar(200),
	@SupportedFeatures	int,
	@Shareable		int,
	@CompatibleVersions	nvarchar(500),
	@Dependencies		nvarchar(400),
	@Permissions		nvarchar(400),
	@ContentItemId		int,
	@CreatedByUserID	int

AS
	INSERT INTO dbo.DesktopModules (
		PackageID,
		ModuleName,
		FolderName,
		FriendlyName,
		Description,
		Version,
		IsPremium,
		IsAdmin,
		BusinessControllerClass,
		SupportedFeatures,
		Shareable,
		CompatibleVersions,
		Dependencies,
		Permissions,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate,
		ContentItemId
	)
	VALUES (
		@PackageID,
		@ModuleName,
		@FolderName,
		@FriendlyName,
		@Description,
		@Version,
		@IsPremium,
		@IsAdmin,
		@BusinessController,
		@SupportedFeatures,
		@Shareable,
		@CompatibleVersions,
		@Dependencies,
		@Permissions,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate(),
		@ContentItemId
	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddDesktopModulePermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDesktopModulePermission]
    @PortalDesktopModuleID Int, -- not null!
    @PermissionId          Int, -- not null!
    @RoleId                Int, -- might be negative for virtual roles
    @AllowAccess           Bit, -- false: deny, true: grant
    @UserId                Int, -- -1 is replaced by Null
    @CreatedByUserId       Int  -- -1 is replaced by Null
AS
BEGIN
    INSERT INTO dbo.[DesktopModulePermission] (
        [PortalDesktopModuleID],
        [PermissionID],
        [RoleID],
        [AllowAccess],
        [UserID],
        [CreatedByUserID],
        [CreatedOnDate],
        [LastModifiedByUserID],
        [LastModifiedOnDate]
    ) VALUES (
        @PortalDesktopModuleID,
        @PermissionID,
        @RoleId,
        @AllowAccess,
        CASE WHEN @UserId = -1 THEN Null ELSE @UserId END,
        CASE WHEN @CreatedByUserID = -1 THEN Null ELSE @CreatedByUserID END,
        GetDate(),
        CASE WHEN @CreatedByUserID = -1 THEN Null ELSE @CreatedByUserID END,
        GetDate()
    )
    SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddEventLog]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[AddEventLog]
	@LogGUID varchar(36),
	@LogTypeKey nvarchar(35),
	@LogUserID int,
	@LogUserName nvarchar(50),
	@LogPortalID int,
	@LogPortalName nvarchar(100),
	@LogCreateDate datetime,
	@LogServerName nvarchar(50),
	@LogProperties ntext,
	@LogConfigID int,
	@ExceptionHash varchar(100) = NULL
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM  dbo.[EventLogTypes] WHERE LogTypeKey = @LogTypeKey)
	BEGIN
		-- Add new Event Type
			EXEC  dbo.[AddEventLogType] @LogTypeKey, @LogTypeKey, N'', N'DotNetNuke.Logging.EventLogType', N'GeneralAdminOperation'

		-- Add new Event Type Config
			EXEC  dbo.[AddEventLogConfig] @LogTypeKey, NULL, 0, -1, 0, 1, 1, 1, N'', N''

		-- As the new log config is unlogged, exit without logging
			Return
	END

	DECLARE @LogEventID bigint

	INSERT INTO  dbo.[EventLog]
		(LogGUID,
		LogTypeKey,
		LogUserID,
		LogUserName,
		LogPortalID,
		LogPortalName,
		LogCreateDate,
		LogServerName,
		LogProperties,
		LogConfigID,
		ExceptionHash)
	VALUES
		(@LogGUID,
		@LogTypeKey,
		@LogUserID,
		@LogUserName,
		@LogPortalID,
		@LogPortalName,
		@LogCreateDate,
		@LogServerName,
		@LogProperties,
		@LogConfigID,
		@ExceptionHash)

	SELECT @LogEventID = SCOPE_IDENTITY()

	DECLARE @NotificationActive bit
	DECLARE @NotificationThreshold bit
	DECLARE @ThresholdQueue int
	DECLARE @NotificationThresholdTime int
	DECLARE @NotificationThresholdTimeType int
	DECLARE @MinDateTime smalldatetime
	DECLARE @CurrentDateTime smalldatetime

	SET @CurrentDateTime = getDate()

	SELECT TOP 1 @NotificationActive = EmailNotificationIsActive,
		@NotificationThreshold = NotificationThreshold,
		@NotificationThresholdTime = NotificationThresholdTime,
		@NotificationThresholdTimeType = NotificationThresholdTimeType,
		@MinDateTime = 
			CASE
				 --seconds
				WHEN NotificationThresholdTimeType=1 THEN DateAdd(second, NotificationThresholdTime * -1, @CurrentDateTime)
				--minutes
				WHEN NotificationThresholdTimeType=2  THEN DateAdd(minute, NotificationThresholdTime * -1, @CurrentDateTime)
				--hours
				WHEN NotificationThresholdTimeType=3  THEN DateAdd(Hour, NotificationThresholdTime * -1, @CurrentDateTime)
				--days
				WHEN NotificationThresholdTimeType=4  THEN DateAdd(Day, NotificationThresholdTime * -1, @CurrentDateTime)
			END
	FROM  dbo.[EventLogConfig]
	WHERE ID = @LogConfigID

	IF @NotificationActive=1
	BEGIN
		
		SELECT @ThresholdQueue = COUNT(*)
		FROM  dbo.[EventLog] el
			INNER JOIN  dbo.[EventLogConfig] elc
				ON  el.LogConfigID =  elc.ID
		WHERE LogCreateDate > @MinDateTime

		IF @ThresholdQueue >= @NotificationThreshold
		BEGIN
			UPDATE  dbo.[EventLog]
			SET LogNotificationPending = 1 
			WHERE LogConfigID = @LogConfigID
				AND LogNotificationPending IS NULL		
				AND LogCreateDate > @MinDateTime
		END

	END
 
	SELECT @LogEventID
END
GO
/****** Object:  StoredProcedure [dbo].[AddEventLogConfig]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[AddEventLogConfig]
	@LogTypeKey nvarchar(35),
	@LogTypePortalID int,
	@LoggingIsActive bit,
	@KeepMostRecent int,
	@EmailNotificationIsActive bit,
	@NotificationThreshold int,
	@NotificationThresholdTime int,
	@NotificationThresholdTimeType int,
	@MailFromAddress nvarchar(50),
	@MailToAddress nvarchar(50)
AS

DECLARE @ID int
SET @ID = (SELECT EC.ID FROM dbo.EventLogConfig EC 
				WHERE (EC.LogTypeKey = @LogTypeKey OR (EC.LogTypeKey IS NULL AND @LogTypeKey IS NULL))  
					AND (EC.LogTypePortalID = @LogTypePortalID  OR (EC.LogTypePortalID IS NULL AND @LogTypePortalID IS NULL))
			)

IF @ID IS NULL
	BEGIN
		INSERT INTO dbo.EventLogConfig
			(LogTypeKey,
			LogTypePortalID,
			LoggingIsActive,
			KeepMostRecent,
			EmailNotificationIsActive,
			NotificationThreshold,
			NotificationThresholdTime,
			NotificationThresholdTimeType,
			MailFromAddress,
			MailToAddress)
		VALUES
			(@LogTypeKey,
			@LogTypePortalID,
			@LoggingIsActive,
			@KeepMostRecent,
			@EmailNotificationIsActive,
			@NotificationThreshold,
			@NotificationThresholdTime,
			@NotificationThresholdTimeType,
			@MailFromAddress,
			@MailToAddress)
	END
ELSE
	BEGIN
		UPDATE dbo.EventLogConfig
		SET 	LogTypeKey = @LogTypeKey,
			LogTypePortalID = @LogTypePortalID,
			LoggingIsActive = @LoggingIsActive,
			KeepMostRecent = @KeepMostRecent,
			EmailNotificationIsActive = @EmailNotificationIsActive,
			NotificationThreshold = @NotificationThreshold,
			NotificationThresholdTime = @NotificationThresholdTime,
			NotificationThresholdTimeType = @NotificationThresholdTimeType,
			MailFromAddress = @MailFromAddress,
			MailToAddress = @MailToAddress
		WHERE	ID = @ID
	END
GO
/****** Object:  StoredProcedure [dbo].[AddEventLogType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddEventLogType]
	@LogTypeKey nvarchar(35),
	@LogTypeFriendlyName nvarchar(50),
	@LogTypeDescription nvarchar(128),
	@LogTypeOwner nvarchar(100),
	@LogTypeCSSClass nvarchar(40)
AS
	INSERT INTO dbo.EventLogTypes
	(LogTypeKey,
	LogTypeFriendlyName,
	LogTypeDescription,
	LogTypeOwner,
	LogTypeCSSClass)
VALUES
	(@LogTypeKey,
	@LogTypeFriendlyName,
	@LogTypeDescription,
	@LogTypeOwner,
	@LogTypeCSSClass)
GO
/****** Object:  StoredProcedure [dbo].[AddEventMessage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddEventMessage]

	@EventName nvarchar(100),
	@Priority int,
	@ProcessorType nvarchar(250),
	@ProcessorCommand nvarchar(250),
	@Body nvarchar(250),
	@Sender nvarchar(250),
	@Subscriber nvarchar(100),
	@AuthorizedRoles nvarchar(250),
	@ExceptionMessage nvarchar(250),
	@SentDate datetime,
	@ExpirationDate datetime,
	@Attributes ntext

AS
	INSERT dbo.EventQueue	(
			EventName,
			Priority,
			ProcessorType,
			ProcessorCommand,
			Body,
			Sender,
			Subscriber,
			AuthorizedRoles,
			ExceptionMessage,
			SentDate,
			ExpirationDate,
			Attributes
		)
		VALUES	(
			@EventName,
			@Priority,
			@ProcessorType,
			@ProcessorCommand,
			@Body,
			@Sender,
			@Subscriber,
			@AuthorizedRoles,
			@ExceptionMessage,
			@SentDate,
			@ExpirationDate,
			@Attributes
		)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddException]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddException]
	@ExceptionHash varchar(100),
	@Message nvarchar(500),
	@StackTrace nvarchar(max),
	@InnerMessage nvarchar(500),
	@InnerStackTrace nvarchar(max),
	@Source nvarchar(500)
AS

IF NOT EXISTS (SELECT * FROM dbo.[Exceptions] WHERE ExceptionHash=@ExceptionHash)
INSERT INTO dbo.[Exceptions]
	(ExceptionHash,
	Message,
	StackTrace,
	InnerMessage,
	InnerStackTrace,
	Source)
VALUES
	(@ExceptionHash,
	@Message,
	@StackTrace,
	@InnerMessage,
	@InnerStackTrace,
	@Source)
GO
/****** Object:  StoredProcedure [dbo].[AddExceptionEvent]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddExceptionEvent]
  @LogEventID bigint,
  @AssemblyVersion varchar(20),
  @PortalId int,
  @UserId int,
  @TabId int,
  @RawUrl nvarchar(260),
  @Referrer nvarchar(260),
  @UserAgent nvarchar(260)
AS

INSERT INTO dbo.[ExceptionEvents]
	(LogEventID,
	AssemblyVersion,
	PortalId,
	UserId,
	TabId,
	RawUrl,
 Referrer,
 UserAgent)
VALUES
	(@LogEventID,
	@AssemblyVersion,
	@PortalId,
	@UserId,
	@TabId,
	@RawUrl,
 @Referrer,
 @UserAgent)
GO
/****** Object:  StoredProcedure [dbo].[AddExtensionUrlProvider]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddExtensionUrlProvider] 
	@ExtensionUrlProviderID	int, 
    @DesktopModuleId		int, 
    @ProviderName			nvarchar(150), 
    @ProviderType			nvarchar(1000), 
    @SettingsControlSrc		nvarchar(1000), 
    @IsActive				bit, 
    @RewriteAllUrls			bit, 
    @RedirectAllUrls		bit, 
    @ReplaceAllUrls			bit
AS

IF EXISTS (SELECT * FROM dbo.ExtensionUrlProviders WHERE ExtensionUrlProviderID = @ExtensionUrlProviderID)
	BEGIN
		UPDATE dbo.ExtensionUrlProviders
			SET
				DesktopModuleId = @DesktopModuleId,
				ProviderName = @ProviderName,
				ProviderType = @ProviderType,
				SettingsControlSrc = @SettingsControlSrc,
				IsActive = @IsActive,
				RewriteAllUrls = @RewriteAllUrls,
				RedirectAllUrls = @RedirectAllUrls,
				ReplaceAllUrls = @ReplaceAllUrls
			WHERE ExtensionUrlProviderID = @ExtensionUrlProviderID
	END
ELSE
	BEGIN
		INSERT INTO dbo.ExtensionUrlProviders (
				DesktopModuleId,
				ProviderName,
				ProviderType,
				SettingsControlSrc,
				IsActive,
				RewriteAllUrls,
				RedirectAllUrls,
				ReplaceAllUrls
		)
		VALUES (
				@DesktopModuleId,
				@ProviderName,
				@ProviderType,
				@SettingsControlSrc,
				@IsActive,
				@RewriteAllUrls,
				@RedirectAllUrls,
				@ReplaceAllUrls
		)
		
		SET @ExtensionUrlProviderID = @@IDENTITY
		
	END
	
SELECT @ExtensionUrlProviderID
GO
/****** Object:  StoredProcedure [dbo].[AddFile]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddFile]
	@PortalId   int,
	@UniqueId   uniqueidentifier,
	@VersionGuid  uniqueidentifier,
	@FileName   nvarchar(246),
	@Extension   nvarchar(100),
	@Size    int,
	@Width    int,
	@Height    int,
	@ContentType  nvarchar(200),
	@Folder    nvarchar(246),
	@FolderID   int,
	@CreatedByUserID   int,
	@Hash     varchar(40),
	@LastModificationTime	datetime, 
	@Title					nvarchar(256),
	@EnablePublishPeriod	bit,
	@StartDate				datetime,
	@EndDate				datetime,
	@ContentItemID			int
AS
BEGIN
	DECLARE @FileID int

	UPDATE dbo.[Files]
	SET
		/* retrieves FileId from table */
		@FileID = FileId,
		FileName = @FileName,
		VersionGuid = @VersionGuid,
		Extension = @Extension,
		Size = @Size,
		Width = @Width,
		Height = @Height,
		ContentType = @ContentType,
		FolderID = @FolderID,
		LastModifiedByUserID = @CreatedByUserID,
		LastModifiedOnDate = getdate(),
		SHA1Hash = @Hash,
		LastModificationTime = @LastModificationTime, 
		Title = @Title,
		EnablePublishPeriod = @EnablePublishPeriod,
		StartDate = @StartDate,
		EndDate = @EndDate,
		ContentItemID = @ContentItemID
	WHERE
		FolderID = @FolderID AND FileName = @FileName

	IF @@ROWCOUNT = 0
	BEGIN
	INSERT INTO dbo.[Files] (
		PortalId,
		UniqueId,
		VersionGuid,
		FileName,
		Extension,
		Size,
		Width,
		Height,
		ContentType,
		FolderID,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate,
		SHA1Hash,
		LastModificationTime, 
		Title,
		EnablePublishPeriod,
		StartDate,
		EndDate,
		ContentItemID
	)
	VALUES (
		@PortalId,
		@UniqueId,
		@VersionGuid,
		@FileName,
		@Extension,
		@Size,
		@Width,
		@Height,
		@ContentType,
		@FolderID,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate(),
		@Hash,
		@LastModificationTime, 
		@Title,
		@EnablePublishPeriod,
		@StartDate,
		@EndDate,
		@ContentItemID
	)

	SELECT @FileID = SCOPE_IDENTITY()
	END

	SELECT @FileID
END
GO
/****** Object:  StoredProcedure [dbo].[AddFileVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddFileVersion] 
	@FileId					int,
	@UniqueId				uniqueidentifier,
	@VersionGuid			uniqueidentifier,
	@FileName				nvarchar(246),
	@Extension				nvarchar(100),
	@Size					int,
	@Width					int,
	@Height					int,
	@ContentType			nvarchar(200),
	@Folder					nvarchar(246),
	@FolderID				int,
	@UserID					int,
	@Hash					varchar(40),
	@LastModificationTime	datetime, 
	@Title					nvarchar(256),
	@EnablePublishPeriod	bit,
	@StartDate				datetime,
	@EndDate				datetime,
	@ContentItemID			int,
	@IsPublished			bit,
	@Content				image = NULL
AS
BEGIN

	DECLARE @Version INT

	--	Calculate the new version = Max(Files.PublishedVersion, FileVersions.Versions) + 1
	SELECT @Version = MAX([Version]) + 1
	FROM (SELECT [Version]
			FROM dbo.[FileVersions]
			WHERE FileId = @FileId
			UNION
			SELECT PublishedVersion [Version]
			FROM dbo.Files
			WHERE FileId = @FileId) v

	IF  @IsPublished = 1
		BEGIN
			INSERT dbo.[FileVersions]
						([FileId]
						,[Version]
						,[FileName]
						,[Extension]
						,[Size]
						,[Width]
						,[Height]
						,[ContentType]
						,[Content]
						,[CreatedByUserID]
						,[CreatedOnDate]
						,[LastModifiedByUserID]
						,[LastModifiedOnDate]
						,[SHA1Hash])
			SELECT		[FileId]
						,[PublishedVersion]  [Version]				
						,CONVERT(nvarchar, [FileId]) + '_' + CONVERT(nvarchar, [PublishedVersion]) +'.v.resources' 
						,[Extension]
						,[Size]
						,[Width]
						,[Height]
						,[ContentType]
						,[Content]
						,[CreatedByUserID]
						,[CreatedOnDate]
						,[LastModifiedByUserID]
						,[LastModifiedOnDate]
						,[SHA1Hash]					
			FROM Files
			WHERE FileId = @FileId

			-- Change PublishedVersion
			UPDATE dbo.[Files]
			SET	 [PublishedVersion] = @Version
			WHERE FileId = @FileId
		END
	ELSE
		BEGIN
			INSERT dbo.[FileVersions]
							([FileId]
							,[Version]
							,[FileName]
							,[Extension]
							,[Size]
							,[Width]
							,[Height]
							,[ContentType]
							,[Content]
							,[CreatedByUserID]
							,[CreatedOnDate]
							,[LastModifiedByUserID]
							,[LastModifiedOnDate]
							,[SHA1Hash])
			VALUES (@FileId
					,@Version
					,CONVERT(nvarchar, @FileId) + '_' + CONVERT(nvarchar, @Version) +'.v.resources'
					,@Extension
					,@Size
					,@Width
					,@Height
					,@ContentType
					,@Content
					,@UserID
					,GETDATE()
					,@UserID
					,GETDATE()
					,@Hash)
		END

	SELECT @Version
END
GO
/****** Object:  StoredProcedure [dbo].[AddFolder]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddFolder]
	@PortalID 			int,
	@UniqueId	 		uniqueidentifier,
	@VersionGuid 		uniqueidentifier,
	@FolderPath 		nvarchar(300),
	@MappedPath 		nvarchar(300),
	@StorageLocation 	int,
	@IsProtected 		bit,
	@IsCached 			bit,
	@LastUpdated 		datetime,
	@CreatedByUserID  	int,
	@FolderMappingID	int = 0,
	@IsVersioned		bit = 0,
	@WorkflowID			int = NULL,
	@ParentID			int = NULL
AS
BEGIN
	IF @FolderMappingID = 0 BEGIN
		SELECT @FolderMappingID = FM.FolderMappingID
		FROM dbo.[FolderMappings] as FM
		WHERE ISNULL(FM.PortalID, -1) = ISNULL(@PortalID, -1)
		AND FolderProviderType = (
			CASE @StorageLocation
				WHEN 0 THEN 'StandardFolderProvider'
				WHEN 1 THEN 'SecureFolderProvider'
				WHEN 2 THEN 'DatabaseFolderProvider'
				ELSE 'StandardFolderProvider'
			END
		)
	END
	
	INSERT INTO dbo.[Folders] (
		PortalID, 
		UniqueId,
		VersionGuid,
		FolderPath,
		MappedPath, 
		StorageLocation, 
		IsProtected, 
		IsCached, 
		LastUpdated,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate,
		FolderMappingID,
		IsVersioned,
		WorkflowID,
		ParentID
	)
	VALUES (
		@PortalID, 
		@UniqueId,
		@VersionGuid,
		@FolderPath,
		@MappedPath, 
		@StorageLocation, 
		@IsProtected, 
		@IsCached, 
		@LastUpdated,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate(),
		@FolderMappingID,
		@IsVersioned,
		@WorkflowID,
		@ParentID
	)
	
	DECLARE @FolderId INT
    SELECT @FolderId = SCOPE_IDENTITY()
  
    SELECT @FolderId
END
GO
/****** Object:  StoredProcedure [dbo].[AddFolderMapping]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddFolderMapping]
	@PortalID int,
	@MappingName nvarchar(50),
	@FolderProviderType nvarchar(50),
	@CreatedByUserID int
AS
BEGIN
	DECLARE @Priority int

	SELECT TOP 1 @Priority = Priority + 1
	FROM dbo.[FolderMappings]
	WHERE [PortalID] = @PortalID
	ORDER BY Priority DESC

	INSERT INTO dbo.[FolderMappings] (
		PortalID,
		MappingName,
		FolderProviderType,
		Priority,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate
	)
	VALUES (
		@PortalID,
		@MappingName,
		@FolderProviderType,
		@Priority,
		@CreatedByUserID,
		GETDATE(),
		@CreatedByUserID,
		GETDATE()
	)

	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddFolderMappingsSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddFolderMappingsSetting]
	@FolderMappingID int,
	@SettingName nvarchar(50),
	@SettingValue nvarchar(2000),
	@CreatedByUserID int
AS
BEGIN
	INSERT INTO dbo.[FolderMappingsSettings] (
		FolderMappingID,
		SettingName,
		SettingValue,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate
	)
	VALUES (
		@FolderMappingID,
		@SettingName,
		@SettingValue,
		@CreatedByUserID,
		GETDATE(),
		@CreatedByUserID,
		GETDATE()
	)
END
GO
/****** Object:  StoredProcedure [dbo].[AddFolderPermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddFolderPermission]
    @FolderID           Int, -- not Null!
    @PermissionId       Int, -- not Null!
    @RoleId             Int, -- might be negative for virtual roles
    @AllowAccess        Bit, -- false: deny, true: grant
    @UserId             Int, -- -1 is replaced by Null
    @CreatedByUserId    Int  -- -1 is replaced by Null
AS
BEGIN
    INSERT INTO dbo.[FolderPermission] (
        [FolderID],
        [PermissionID],
        [RoleId],
        [AllowAccess],
        [UserId],
        [CreatedByUserId],
        [CreatedOnDate],
        [LastModifiedByUserId],
        [LastModifiedOnDate]
    ) VALUES (
        @FolderID,
        @PermissionID,
        @RoleId,
        @AllowAccess,
        CASE WHEN @UserId = -1 THEN Null ELSE @UserId END,
        CASE WHEN @CreatedByUserID = -1 THEN Null ELSE @CreatedByUserID END,
        GetDate(),
        CASE WHEN @CreatedByUserID = -1 THEN Null ELSE @CreatedByUserID END,
        GetDate()
    )
    SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddHeirarchicalTerm]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddHeirarchicalTerm] 
	@VocabularyID		int,
	@ParentTermID		int,
	@Name				nvarchar(250),
	@Description		nvarchar(2500),
	@Weight				int,
	@CreatedByUserID	int
AS

	DECLARE @Left int
	
	-- Get Left value of Sibling that we are inserting before
	SET @Left = (SELECT TOP 1 TermLeft FROM dbo.Taxonomy_Terms 
						WHERE VocabularyID = @VocabularyID 
							AND ParentTermID = @ParentTermID
							AND Name > @Name
						ORDER BY Name)
						
	-- Term is to be inserted at end of sibling list so get the Right value of the parent, which will become our new left value						
	IF @Left IS NULL
		SET @Left = (SELECT TermRight FROM dbo.Taxonomy_Terms 
							WHERE VocabularyID = @VocabularyID 
								AND TermID = @ParentTermID)
								
	-- Left is still null means this is the first term in this vocabulary - set the Left to 1
	IF @Left IS NULL
		SET @Left = 1
								
	BEGIN TRANSACTION
		-- Update Left values for all items that are after new term
		UPDATE dbo.Taxonomy_Terms 
			SET TermLeft = TermLeft + 2 
			WHERE TermLeft >= @Left
				AND VocabularyID = @VocabularyID

		IF @@ERROR = 0
			BEGIN
			-- Update Right values for all items that are after new term
				UPDATE dbo.Taxonomy_Terms 
					SET TermRight = TermRight + 2 
					WHERE TermRight >= @Left
						AND VocabularyID = @VocabularyID

				IF @@ERROR = 0
					BEGIN
							-- Insert new term
							INSERT INTO dbo.Taxonomy_Terms (
								VocabularyID,
								ParentTermID,
								[Name],
								Description,
								Weight,
								TermLeft,
								TermRight,
								CreatedByUserID,
								CreatedOnDate,
								LastModifiedByUserID,
								LastModifiedOnDate
							)

							VALUES (
								@VocabularyID,
								@ParentTermID,
								@Name,
								@Description,
								@Weight,
								@Left,
								@Left + 1,
								@CreatedByUserID,
								getdate(),
								@CreatedByUserID,
								getdate()
							)

							SELECT SCOPE_IDENTITY()

							IF @@ERROR = 0
								BEGIN
									COMMIT TRANSACTION
								END
							ELSE
								BEGIN
									-- Rollback the transaction
									ROLLBACK TRANSACTION		
								END
						END
				ELSE
					BEGIN
						-- Rollback the transaction
						ROLLBACK TRANSACTION
					END
			END
		ELSE
			BEGIN
				-- Rollback the transaction
				ROLLBACK TRANSACTION		
			END
GO
/****** Object:  StoredProcedure [dbo].[AddHostSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddHostSetting]

	@SettingName		nvarchar(50),
	@SettingValue		nvarchar(256),
	@SettingIsSecure	bit,
	@CreatedByUserID	int
AS
	insert into HostSettings (
	  SettingName,
	  SettingValue,
	  SettingIsSecure,
	  [CreatedByUserID],
	  [CreatedOnDate],
	  [LastModifiedByUserID],
	  [LastModifiedOnDate]
	) 
	values (
	  @SettingName,
	  @SettingValue,
	  @SettingIsSecure,
	  @CreatedByUserID,
	  getdate(),
	  @CreatedByUserID,
	  getdate()
	)
GO
/****** Object:  StoredProcedure [dbo].[AddHtmlText]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AddHtmlText]

@ModuleID        int,
@Content         ntext,
@Summary	     ntext,
@StateID         int,
@IsPublished     bit,
@UserID          int,
@History         int

as

declare @Version int

select @Version = max(Version) from dbo.HtmlText where ModuleID = @ModuleID

if @Version is null
  select @Version = 1
else
  select @Version = @Version + 1

insert into dbo.HtmlText (
  ModuleID,
  Content,
  Summary,
  Version,
  StateID,
  IsPublished,
  CreatedByUserID,
  CreatedOnDate,
  LastModifiedByUserID,
  LastModifiedOnDate
) 
values (
  @ModuleID,
  @Content,
  @Summary,
  @Version,
  @StateID,
  @IsPublished,
  @UserID,
  getdate(),
  @UserID,
  getdate()
)

if @History > 0
begin
  delete
  from   dbo.HtmlText
  where  ModuleID = @ModuleID
  and    Version <= (@Version - @History)
end

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddHtmlTextLog]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AddHtmlTextLog]

@ItemID          int,
@StateID         int,
@Comment         nvarchar(4000),
@Approved        bit,
@UserID          int

as

insert into dbo.HtmlTextLog (
  ItemID,
  StateID,
  Comment,
  Approved,
  CreatedByUserID,
  CreatedOnDate
)
values (
  @ItemID,
  @StateID,
  @Comment,
  @Approved,
  @UserID,
  getdate()
)
GO
/****** Object:  StoredProcedure [dbo].[AddHtmlTextUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AddHtmlTextUser]

@ItemID          int,
@StateID         int,
@ModuleID        int,
@TabID           int,
@UserID          int

as

insert into dbo.HtmlTextUsers (
  ItemID,
  StateID,
  ModuleID,
  TabID,
  UserID,
  CreatedOnDate
)
values (
  @ItemID,
  @StateID,
  @ModuleID,
  @TabID,
  @UserID,
  getdate()
)
GO
/****** Object:  StoredProcedure [dbo].[AddIPFilter]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddIPFilter]
	@IPAddress nvarchar(50),
	@SubnetMask nvarchar(50),
	@RuleType tinyint,
	@CreatedByUserID			int
AS 
	BEGIN
		INSERT INTO dbo.IPFilter  
		(
		[IPAddress]
           ,[SubnetMask]
           ,[RuleType]
           ,[CreatedByUserID]
           ,[CreatedOnDate]
           ,[LastModifiedByUserID]
           ,[LastModifiedOnDate]
		)  
		VALUES  
		( 
			@IPAddress , 
			@SubnetMask , 
			@RuleType,
			@CreatedByUserID , 
			getdate() , 
			@CreatedByUserID , 
			getdate() 
		) 
		 
		SELECT SCOPE_IDENTITY()
	END
GO
/****** Object:  StoredProcedure [dbo].[AddLanguage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddLanguage]

	@CultureCode		    nvarchar(50),
	@CultureName            nvarchar(200),
	@FallbackCulture        nvarchar(50),
	@CreatedByUserID	int

AS
	INSERT INTO dbo.Languages (
		CultureCode,
		CultureName,
		FallbackCulture,
		[CreatedByUserID],
		[CreatedOnDate],
		[LastModifiedByUserID],
		[LastModifiedOnDate]
	)
	VALUES (
		@CultureCode,
		@CultureName,
		@FallbackCulture,
		@CreatedByUserID,
	  	getdate(),
	  	@CreatedByUserID,
	  	getdate()
	)
	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddLanguagePack]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddLanguagePack]

	@PackageID			    int,
	@LanguageID			    int,
	@DependentPackageID		int,
	@CreatedByUserID	int

AS
	INSERT INTO dbo.LanguagePacks (
		PackageID,
		LanguageID,
		DependentPackageID,
		[CreatedByUserID],
		[CreatedOnDate],
		[LastModifiedByUserID],
		[LastModifiedOnDate]

	)
	VALUES (
		@PackageID,
		@LanguageID,
		@DependentPackageID,
		@CreatedByUserID,
	  	getdate(),
	  	@CreatedByUserID,
	  	getdate()
	)
	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddListEntry]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddListEntry]

	@ListName nvarchar(50), 
	@Value nvarchar(100), 
	@Text nvarchar(150),
	@ParentID int,
	@Level int, 
	@EnableSortOrder bit,
	@DefinitionID int, 
	@Description nvarchar(500),
	@PortalID int,
	@SystemList bit,
	@CreatedByUserID	int

AS
	DECLARE @SortOrder int

	IF @EnableSortOrder = 1
		SET @SortOrder = IsNull((SELECT MAX ([SortOrder]) From dbo.[Lists] Where [ListName] = @ListName), 0) + 1
	ELSE
		SET @SortOrder = 0

	-- Check if this entry exists
	If EXISTS (SELECT [EntryID] From dbo.[Lists] WHERE [ListName] = @ListName And [Value] = @Value And [Text] = @Text And [ParentID] = @ParentID)
	BEGIN
		SELECT -1
		RETURN 
	END

	INSERT INTO dbo.[Lists] 
		(
  		[ListName],
		[Value],
		[Text],
		[Level],
		[SortOrder],
		[DefinitionID],
		[ParentID],
		[Description],
		[PortalID],
		[SystemList],
		[CreatedByUserID],
		[CreatedOnDate],
		[LastModifiedByUserID],
		[LastModifiedOnDate]
		)
	VALUES (
		@ListName,
		@Value,
		@Text,
		@Level,
		@SortOrder,
		@DefinitionID,
		@ParentID,
		@Description,
		@PortalID,
		@SystemList,
  		@CreatedByUserID,
	  	getdate(),
	  	@CreatedByUserID,
	  	getdate()	
		)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddMetaData]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddMetaData] 
	@ContentItemID		int,
	@Name				nvarchar(100),
	@Value				nvarchar(MAX)
AS
	DECLARE @MetaDataID	int
	SET @MetaDataID = (SELECT MetaDataID FROM MetaData WHERE MetaDataName = @Name)
	
	IF @MetaDataID IS NULL
		BEGIN
			--Insert new item into MetaData table
			INSERT INTO dbo.MetaData ( MetaDataName ) VALUES ( @Name )

			SET @MetaDataID = (SELECT SCOPE_IDENTITY() )
		END
		
	INSERT INTO dbo.ContentItems_MetaData (
		ContentItemID,
		MetaDataID,
		MetaDataValue
	)
	VALUES (
		@ContentItemID,
		@MetaDataID,
		@Value
	)
GO
/****** Object:  StoredProcedure [dbo].[AddModule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddModule]
	@ContentItemID				int,
	@PortalID					int,
	@ModuleDefId				int,
	@AllTabs					bit,
	@StartDate					datetime,
	@EndDate					datetime,
	@InheritViewPermissions     bit,
	@IsShareable				bit,
	@IsShareableViewOnly		bit,
	@IsDeleted					bit,
	@CreatedByUserID  			int
	
AS
	INSERT INTO dbo.Modules (
		ContentItemID, 
		PortalId,
		ModuleDefId,
		AllTabs,
		StartDate,
		EndDate,
		InheritViewPermissions,
		IsShareable,
		IsShareableViewOnly,
		IsDeleted,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate
	)
	VALUES (
		@ContentItemID,
		@PortalID,
		@ModuleDefId,
		@AllTabs,
		@StartDate,
		@EndDate,
		@InheritViewPermissions,
		@IsShareable,
		@IsShareableViewOnly,
		@IsDeleted,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate()
	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddModuleControl]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddModuleControl]
	
	@ModuleDefID                int,
	@ControlKey                 nvarchar(50),
	@ControlTitle               nvarchar(50),
	@ControlSrc                 nvarchar(256),
	@IconFile                   nvarchar(100),
	@ControlType                int,
	@ViewOrder                  int,
	@HelpUrl                    nvarchar(200),
	@SupportsPartialRendering   bit,
	@SupportsPopUps				bit,
	@CreatedByUserID			int

AS
	INSERT INTO dbo.ModuleControls (
		ModuleDefID,
		ControlKey,
		ControlTitle,
		ControlSrc,
		IconFile,
		ControlType,
		ViewOrder,
		HelpUrl,
		SupportsPartialRendering,
		SupportsPopUps,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate
	)
	VALUES (
		@ModuleDefID,
		@ControlKey,
		@ControlTitle,
		@ControlSrc,
		@IconFile,
		@ControlType,
		@ViewOrder,
		@HelpUrl,
		@SupportsPartialRendering,
		@SupportsPopUps,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate()
	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddModuleDefinition]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddModuleDefinition]

	@DesktopModuleId int,    
	@FriendlyName    nvarchar(128),
	@DefinitionName nvarchar(128),
	@DefaultCacheTime int,
	@CreatedByUserID  int

as

insert into dbo.ModuleDefinitions (
	DesktopModuleId,
	FriendlyName,
	DefinitionName,
	DefaultCacheTime,
	CreatedByUserID,
	CreatedOnDate,
	LastModifiedByUserID,
	LastModifiedOnDate
)
values (
	@DesktopModuleId,
	@FriendlyName,
	@DefinitionName,
	@DefaultCacheTime,
	@CreatedByUserID,
	getdate(),
	@CreatedByUserID,
	getdate()
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddModulePermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddModulePermission]
    @ModuleID           Int, -- not null!
    @PortalID           Int, -- not null!
    @PermissionId       Int, -- not null!
    @RoleId             Int, -- might be negative for virtual roles
    @AllowAccess        Bit, -- false: deny, true: grant
    @UserId             Int, -- -1 is replaced by Null
    @CreatedByUserId    Int  -- -1 is replaced by Null
AS
BEGIN
    INSERT INTO dbo.[ModulePermission] (
        [ModuleID],
        [PortalID],
        [PermissionID],
        [RoleId],
        [AllowAccess],
        [UserId],
        [CreatedByUserId],
        [CreatedOnDate],
        [LastModifiedByUserId],
        [LastModifiedOnDate]
    ) VALUES (
        @ModuleID,
        @PortalID,
        @PermissionID,
        @RoleId,
        @AllowAccess,
        CASE WHEN @UserId = -1 THEN Null ELSE @UserId END,
        CASE WHEN @CreatedByUserID = -1 THEN Null ELSE @CreatedByUserID END,
        GetDate(),
        CASE WHEN @CreatedByUserID = -1 THEN Null ELSE @CreatedByUserID END,
        GetDate()
    )
    SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddModuleSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddModuleSetting]
	@ModuleId			int,
	@SettingName		nvarchar(50),
	@SettingValue		nvarchar(max),
	@CreatedByUserID	int
AS
	INSERT INTO dbo.ModuleSettings ( 
		ModuleId,
		SettingName,
		SettingValue,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate
	) 
	VALUES ( 
		@ModuleId, 
		@SettingName, 
		@SettingValue,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate()
	)
GO
/****** Object:  StoredProcedure [dbo].[AddPackage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPackage]
	@PortalID			int,
	@Name			    nvarchar(128),
	@FriendlyName	    nvarchar(250),
	@Description	    nvarchar(2000),
	@PackageType	    nvarchar(50),
	@Version		    nvarchar(50),
	@License		    ntext,
	@Manifest		    ntext,
	@Owner				nvarchar(100),
	@Organization		nvarchar(100),
	@Url				nvarchar(250),
	@Email				nvarchar(100),
	@ReleaseNotes	    ntext,
	@IsSystemPackage    bit,
	@CreatedByUserID	int,
	@FolderName			nvarchar(127),
	@IconFile			nvarchar(100)
AS
	INSERT INTO dbo.Packages
	(
		PortalID,
		[Name],
		FriendlyName,
		[Description],
		PackageType,
		Version,
		License,
		Manifest,
		ReleaseNotes,
		[Owner],
		Organization,
		Url,
		Email,
		IsSystemPackage,
		[CreatedByUserID],
		[CreatedOnDate],
		[LastModifiedByUserID],
		[LastModifiedOnDate],
		FolderName,
		IconFile
	)
	VALUES (
		@PortalID,
		@Name,
		@FriendlyName,
		@Description,
		@PackageType,
		@Version,
		@License,
		@Manifest,
		@ReleaseNotes,
		@Owner,
		@Organization,
		@Url,
		@Email,
		@IsSystemPackage,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate(),
		@FolderName,
		@IconFile
	)
	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddPasswordHistory]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPasswordHistory]
    @UserId			int,
    @Password			nvarchar(128),
    @PasswordSalt		nvarchar(128),
	@Retained			int,
    @CreatedByUserID  	int
AS

        BEGIN
		
          INSERT INTO dbo.PasswordHistory (
            UserId,
            [Password],
            PasswordSalt,
			CreatedByUserID,
			CreatedOnDate,
			LastModifiedByUserID,
			LastModifiedOnDate
          )
          VALUES (
            @UserId,
            @Password,
            @PasswordSalt,
            
			@CreatedByUserID,
			getdate(),
			@CreatedByUserID,
			getdate()
          )

		  DELETE FROM dbo.PasswordHistory where UserID=@UserId and PasswordHistoryID NOT IN (
					SELECT TOP (@Retained) PasswordHistoryID from dbo.PasswordHistory
					WHERE UserID=@UserId order by CreatedOnDate desc
					)

        END
GO
/****** Object:  StoredProcedure [dbo].[AddPermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPermission]
	@ModuleDefID		int,
	@PermissionCode		varchar(50),
	@PermissionKey		varchar(50),
	@PermissionName		varchar(50),
	@CreatedByUserID	int
AS

INSERT INTO dbo.Permission (
	[ModuleDefID],
	[PermissionCode],
	[PermissionKey],
	[PermissionName],
	[CreatedByUserID],
	[CreatedOnDate],
	[LastModifiedByUserID],
	[LastModifiedOnDate]
) VALUES (
	@ModuleDefID,
	@PermissionCode,
	@PermissionKey,
	@PermissionName,
	@CreatedByUserID,
	getdate(),
	@CreatedByUserID,
	getdate()
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddPortalAlias]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPortalAlias]
	@PortalID 			int,
	@HTTPAlias 			nvarchar(200),
	@CultureCode		nvarchar(10),
	@Skin				nvarchar(100),
	@BrowserType		nvarchar(10),
	@IsPrimary			bit,
	@CreatedByUserID	int

AS

	IF @IsPrimary = 1
		BEGIN
			UPDATE dbo.PortalAlias
				SET IsPrimary = 0
				WHERE (CultureCode = @CultureCode OR (CultureCode IS NULL AND @CultureCode IS NULL))
					AND (BrowserType = @BrowserType OR (BrowserType IS NULL AND @BrowserType IS NULL))
					AND (PortalID = @PortalID)
		END

	INSERT INTO dbo.PortalAlias (
		PortalID, 
		HTTPAlias,
		CultureCode,
		BrowserTYpe,
		Skin,
		IsPrimary,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate
	)
	VALUES (
		@PortalID, 
		@HTTPAlias,
		@CultureCode,
		@BrowserTYpe,
		@Skin,
		@IsPrimary,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate()
	 )

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddPortalDesktopModule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPortalDesktopModule]
	@PortalID			int,
	@DesktopModuleId	int,
	@CreatedByUserID	int

as

insert into dbo.PortalDesktopModules ( 
	PortalId,
	DesktopModuleId,
	CreatedByUserID,
	CreatedOnDate,
	LastModifiedByUserID,
	LastModifiedOnDate
)
values (
	@PortalID,
	@DesktopModuleId,
	@CreatedByUserID,
	getdate(),
	@CreatedByUserID,
	getdate()
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddPortalGroup]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPortalGroup]
	@PortalGroupName			nvarchar(100),
	@PortalGroupDescription		nvarchar(2000),
	@MasterPortalID				int,
	@AuthenticationDomain		nvarchar(200),
	@CreatedByUserID			int
AS 
	BEGIN
		INSERT INTO dbo.PortalGroups  
		( 
			PortalGroupName  , 
			PortalGroupDescription  ,
			MasterPortalID,
			AuthenticationDomain, 
			CreatedByUserID , 
			CreatedOnDate , 
			LastModifiedByUserID , 
			LastModifiedOnDate  
		)  
		VALUES  
		( 
			@PortalGroupName , 
			@PortalGroupDescription , 
			@MasterPortalID,
			@AuthenticationDomain, 
			@CreatedByUserID , 
			getdate() , 
			@CreatedByUserID , 
			getdate() 
		) 
		 
		SELECT SCOPE_IDENTITY()
	END
GO
/****** Object:  StoredProcedure [dbo].[AddPortalInfo]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPortalInfo]
	@PortalName         nvarchar(128),
	@Currency           char(3),
	@ExpiryDate         datetime,
	@HostFee            money,
	@HostSpace          int,
	@PageQuota          int,
	@UserQuota          int,
	@SiteLogHistory     int,
	@HomeDirectory		varchar(100),
	@CultureCode		nvarchar(50),
	@CreatedByUserID	int
AS

DECLARE @PortalID int

insert into dbo.Portals (
  ExpiryDate,
  UserRegistration,
  BannerAdvertising,
  Currency,
  HostFee,
  HostSpace,
  PageQuota,
  UserQuota,
  SiteLogHistory,
  DefaultLanguage,
  HomeDirectory,
  CreatedByUserID,
  CreatedOnDate,
  LastModifiedByUserID,
  LastModifiedOnDate
)
values (
  @ExpiryDate,
  0,
  0,
  @Currency,
  @HostFee,
  @HostSpace,
  @PageQuota,
  @UserQuota,
  @SiteLogHistory,
  @CultureCode,
  @HomeDirectory,
  @CreatedByUserID,
  getdate(),
  @CreatedByUserID,
  getdate()
)

SET @PortalID = SCOPE_IDENTITY()

IF @HomeDirectory = ''
BEGIN
	UPDATE dbo.Portals SET HomeDirectory = 'Portals/' + convert(varchar(10), @PortalID) WHERE PortalID = @PortalID
END

insert into dbo.PortalLocalization (PortalID,CultureCode,PortalName,Description,KeyWords)
			values (@PortalID,@CultureCode,@PortalName,@PortalName,@PortalName)
           
  
SELECT @PortalID
GO
/****** Object:  StoredProcedure [dbo].[AddPortalLanguage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPortalLanguage]
    @PortalId			int,
    @LanguageId			int,
    @IsPublished		bit,
    @CreatedByUserID	int

AS
    INSERT INTO dbo.PortalLanguages (
        PortalId,
        LanguageId,
        IsPublished,
        [CreatedByUserID],
        [CreatedOnDate],
        [LastModifiedByUserID],
        [LastModifiedOnDate]
    )
    VALUES (
        @PortalId,
        @LanguageId,
        @IsPublished,
        @CreatedByUserID,
        getdate(),
        @CreatedByUserID,
        getdate()
    )

    SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddProfile]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AddProfile]

@UserID        int, 
@PortalID      int

as

insert into dbo.Profile (
  UserId,
  PortalId,
  ProfileData,
  CreatedDate
)
values (
  @UserID,
  @PortalID,
  '',
  getdate()
)
GO
/****** Object:  StoredProcedure [dbo].[AddPropertyDefinition]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPropertyDefinition]
	@PortalId int,
	@ModuleDefId int,
	@DataType int,
	@DefaultValue nvarchar(max),
	@PropertyCategory nvarchar(50),
	@PropertyName nvarchar(50),
	@ReadOnly bit,
	@Required bit,
	@ValidationExpression nvarchar(2000),
	@ViewOrder int,
	@Visible bit,
    @Length int,
    @DefaultVisibility int,
	@CreatedByUserID int

AS
	DECLARE @PropertyDefinitionId int

	SELECT @PropertyDefinitionId = PropertyDefinitionId
		FROM   dbo.ProfilePropertyDefinition
		WHERE  (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
			AND PropertyName = @PropertyName
			
	IF @vieworder=-1
		BEGIN
			SELECT	@vieworder = MAX(ViewOrder) + 1 
			FROM	dbo.ProfilePropertyDefinition
		END

	IF @PropertyDefinitionId IS NULL
		BEGIN
			INSERT dbo.ProfilePropertyDefinition	(
					PortalId,
					ModuleDefId,
					Deleted,
					DataType,
					DefaultValue,
					PropertyCategory,
					PropertyName,
					ReadOnly,
					Required,
					ValidationExpression,
					ViewOrder,
					Visible,
					Length,
                    DefaultVisibility,
					[CreatedByUserID],
					[CreatedOnDate],
					[LastModifiedByUserID],
					[LastModifiedOnDate]

				)
				VALUES	(
					@PortalId,
					@ModuleDefId,
					0,
					@DataType,
					@DefaultValue,
					@PropertyCategory,
					@PropertyName,
					@ReadOnly,
					@Required,
					@ValidationExpression,
					@ViewOrder,
					@Visible,
					@Length,
                    @DefaultVisibility,
					@CreatedByUserID,
  					getdate(),
  					@CreatedByUserID,
  					getdate()
				)

			SELECT @PropertyDefinitionId = SCOPE_IDENTITY()
		END
	ELSE
		BEGIN
			UPDATE dbo.ProfilePropertyDefinition 
				SET DataType = @DataType,
					ModuleDefId = @ModuleDefId,
					DefaultValue = @DefaultValue,
					PropertyCategory = @PropertyCategory,
					ReadOnly = @ReadOnly,
					Required = @Required,
					ValidationExpression = @ValidationExpression,
					ViewOrder = @ViewOrder,
					Deleted = 0,
					Visible = @Visible,
					Length = @Length,
                    DefaultVisibility = @DefaultVisibility,
					[LastModifiedByUserID] = @CreatedByUserID,	
					[LastModifiedOnDate] = getdate()
				WHERE PropertyDefinitionId = @PropertyDefinitionId
		END
		
	SELECT @PropertyDefinitionId
GO
/****** Object:  StoredProcedure [dbo].[AddRole]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddRole] 
	@PortalID         int,
	@RoleGroupId      int,
	@RoleName         nvarchar(50),
	@Description      nvarchar(1000),
	@ServiceFee       money,
	@BillingPeriod    int,
	@BillingFrequency char(1),
	@TrialFee         money,
	@TrialPeriod      int,
	@TrialFrequency   char(1),
	@IsPublic         bit,
	@AutoAssignment   bit,
	@RSVPCode         nvarchar(50),
	@IconFile         nvarchar(100),
	@CreatedByUserID  int,
	@Status			  int,
	@SecurityMode   int,
	@IsSystemRole bit
AS
	INSERT INTO dbo.Roles (
	  PortalId,
	  RoleGroupId,
	  RoleName,
	  Description,
	  ServiceFee,
	  BillingPeriod,
	  BillingFrequency,
	  TrialFee,
	  TrialPeriod,
	  TrialFrequency,
	  IsPublic,
	  AutoAssignment,
	  RSVPCode,
	  IconFile,
	  CreatedByUserID,
	  CreatedOnDate,
	  LastModifiedByUserID,
	  LastModifiedOnDate,
	  Status,
	  SecurityMode,
	  IsSystemRole
	)
	VALUES (
	  @PortalID,
	  @RoleGroupId,
	  @RoleName,
	  @Description,
	  @ServiceFee,
	  @BillingPeriod,
	  @BillingFrequency,
	  @TrialFee,
	  @TrialPeriod,
	  @TrialFrequency,
	  @IsPublic,
	  @AutoAssignment,
	  @RSVPCode,
	  @IconFile,
	  @CreatedByUserID,
	  getdate(),
	  @CreatedByUserID,
	  getdate(),
	  @Status,
	  @SecurityMode,
	  @IsSystemRole
	)
	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddRoleGroup]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddRoleGroup] 
	@PortalID         int,
	@RoleGroupName    nvarchar(50),
	@Description      nvarchar(1000),
	@CreatedByUserID  int
AS

	INSERT INTO dbo.RoleGroups (
	  PortalId,
	  RoleGroupName,
	  Description,
	  CreatedByUserID,
	  CreatedOnDate,
	  LastModifiedByUserID,
	  LastModifiedOnDate
	)
	VALUES (
	  @PortalID,
	  @RoleGroupName,
	  @Description,
	  @CreatedByUserID,
	  getdate(),
	  @CreatedByUserID,
	  getdate()
	)

SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddSchedule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddSchedule]
	@TypeFullName varchar(200)
	,@TimeLapse int
	,@TimeLapseMeasurement varchar(2)
	,@RetryTimeLapse int
	,@RetryTimeLapseMeasurement varchar(2)
	,@RetainHistoryNum int
	,@AttachToEvent varchar(50)
	,@CatchUpEnabled bit
	,@Enabled bit
	,@ObjectDependencies varchar(300)
	,@Servers varchar(150)
	,@CreatedByUserID	int
	,@FriendlyName varchar(200)
	,@ScheduleStartDate datetime
AS
	INSERT INTO  dbo.Schedule(
		 TypeFullName
		,TimeLapse
		,TimeLapseMeasurement
		,RetryTimeLapse
		,RetryTimeLapseMeasurement
		,RetainHistoryNum
		,AttachToEvent
		,CatchUpEnabled
		,Enabled
		,ObjectDependencies
		,Servers
		,FriendlyName
		,[CreatedByUserID]
		,[CreatedOnDate]
		,[LastModifiedByUserID]
		,[LastModifiedOnDate]
		,ScheduleStartDate
		)
	VALUES
		(@TypeFullName
		,@TimeLapse
		,@TimeLapseMeasurement
		,@RetryTimeLapse
		,@RetryTimeLapseMeasurement
		,@RetainHistoryNum
		,@AttachToEvent
		,@CatchUpEnabled
		,@Enabled
		,@ObjectDependencies
		,@Servers
		,@FriendlyName
		,@CreatedByUserID
		,getdate()
		,@CreatedByUserID
		,getdate()
		,@ScheduleStartDate
		)
		select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddScheduleHistory]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddScheduleHistory]
@ScheduleID int,
@StartDate datetime,
@Server varchar(150)
AS
INSERT INTO dbo.ScheduleHistory
(ScheduleID,
StartDate,
Server)
VALUES
(@ScheduleID,
@StartDate,
@Server)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddScheduleItemSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddScheduleItemSetting]
	@ScheduleID int,
	@Name nvarchar(50),
	@Value nvarchar(256)
AS
BEGIN
	UPDATE dbo.[ScheduleItemSettings]
	SET SettingValue = @Value
	WHERE ScheduleID = @ScheduleID
	AND SettingName = @Name

	IF @@ROWCOUNT = 0 BEGIN
		INSERT INTO dbo.[ScheduleItemSettings] (ScheduleID, SettingName, Settingvalue)
		VALUES (@ScheduleID, @Name, @Value)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[AddScopeType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddScopeType] 
	@ScopeType			nvarchar(250)
AS
	INSERT INTO dbo.Taxonomy_ScopeTypes (
		ScopeType
	)

	VALUES (
		@ScopeType
	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddSearchCommonWord]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddSearchCommonWord]
	@CommonWord nvarchar(255),
	@Locale nvarchar(10)
AS

INSERT INTO dbo.SearchCommonWords (
	[CommonWord],
	[Locale]
) VALUES (
	@CommonWord,
	@Locale
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddSimpleTerm]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddSimpleTerm] 
	@VocabularyID		int,
	@Name				nvarchar(250),
	@Description		nvarchar(2500),
	@Weight				int,
	@CreatedByUserID	int
AS
	INSERT INTO dbo.Taxonomy_Terms (
		VocabularyID,
		[Name],
		Description,
		Weight,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate
	)

	VALUES (
		@VocabularyID,
		@Name,
		@Description,
		@Weight,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate()
	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddSiteLog]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AddSiteLog]

@DateTime                      datetime, 
@PortalID                      int,
@UserID                        int                   = null,
@Referrer                      nvarchar(255)         = null,
@Url                           nvarchar(255)         = null,
@UserAgent                     nvarchar(255)         = null,
@UserHostAddress               nvarchar(255)         = null,
@UserHostName                  nvarchar(255)         = null,
@TabId                         int                   = null,
@AffiliateId                   int                   = null

as
 
declare @SiteLogHistory int

insert into dbo.SiteLog ( 
  DateTime,
  PortalId,
  UserId,
  Referrer,
  Url,
  UserAgent,
  UserHostAddress,
  UserHostName,
  TabId,
  AffiliateId
)
values (
  @DateTime,
  @PortalID,
  @UserID,
  @Referrer,
  @Url,
  @UserAgent,
  @UserHostAddress,
  @UserHostName,
  @TabId,
  @AffiliateId
)
GO
/****** Object:  StoredProcedure [dbo].[AddSkin]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddSkin]
	@SkinPackageID		int,
    @SkinSrc			nvarchar(200)		
AS
	BEGIN
		IF NOT EXISTS (
			SELECT 1 FROM dbo.Skins S
				WHERE S.SkinPackageID = @SkinPackageID AND S.SkinSrc = @SkinSrc
			)
			BEGIN
				INSERT INTO dbo.Skins (SkinPackageID, SkinSrc)
				VALUES (@SkinPackageID, @SkinSrc)
			END
	END
	
	SELECT SkinID FROM dbo.Skins S
		WHERE S.SkinPackageID = @SkinPackageID AND S.SkinSrc = @SkinSrc
GO
/****** Object:  StoredProcedure [dbo].[AddSkinControl]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddSkinControl]
	
	@PackageID					int,
	@ControlKey                 nvarchar(50),
	@ControlSrc                 nvarchar(256),
	@SupportsPartialRendering   bit,
	@CreatedByUserID	int

AS
	INSERT INTO dbo.SkinControls (
	  PackageID,
	  ControlKey,
	  ControlSrc,
      SupportsPartialRendering,
		[CreatedByUserID],
		[CreatedOnDate],
		[LastModifiedByUserID],
		[LastModifiedOnDate]
	)
	VALUES (
	  @PackageID,
	  @ControlKey,
	  @ControlSrc,
      @SupportsPartialRendering,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate()
	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddSkinPackage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddSkinPackage]
	@PackageID  int,
	@PortalID   int,
	@SkinName   nvarchar(50),
	@SkinType   nvarchar(20),
	@CreatedByUserID	int
AS
	INSERT INTO dbo.SkinPackages (
	  PackageID,
	  PortalID,
	  SkinName,
	  SkinType,
	[CreatedByUserID],
	[CreatedOnDate],
	[LastModifiedByUserID],
	[LastModifiedOnDate]
	)
	VALUES (
	  @PackageID,
	  @PortalID,
	  @SkinName,
	  @SkinType,
	  @CreatedByUserID,
	  getdate(),
	  @CreatedByUserID,
	  getdate()
	)
	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddSynonymsGroup]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddSynonymsGroup]
	@SynonymsTags 			nvarchar(MAX),
	@CreatedByUserID 		int,
	@PortalID				int,
	@CultureCode            nvarchar(50)
AS
BEGIN	
	INSERT INTO dbo.[SynonymsGroups](
		[SynonymsTags],  
		[CreatedByUserID],  
		[CreatedOnDate],  
		[LastModifiedByUserID],  
		[LastModifiedOnDate],
		[PortalID],
		[CultureCode]
	) VALUES (
		@SynonymsTags,
		@CreatedByUserID,
	    GETUTCDATE(),
		@CreatedByUserID,
		GETUTCDATE(),
		@PortalID,
		@CultureCode
	)	

	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddSystemMessage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AddSystemMessage]

@PortalID     int,
@MessageName  nvarchar(50),
@MessageValue ntext

as

insert into dbo.SystemMessages (
  PortalID,
  MessageName,
  MessageValue
)
values (
  @PortalID,
  @MessageName,
  @MessageValue
)
GO
/****** Object:  StoredProcedure [dbo].[AddTab]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddTab] 
    @ContentItemID			int,
    @PortalID				int,
    @TabOrder				int,
    @UniqueId				uniqueidentifier,
    @VersionGuid			uniqueidentifier,
    @DefaultLanguageGuid	uniqueidentifier,
    @LocalizedVersionGuid	uniqueidentifier,
    @TabName				nvarchar(200),
    @IsVisible				bit,
    @DisableLink			bit,
    @ParentId				int,
    @IconFile				nvarchar(100),
    @IconFileLarge			nvarchar(100),
    @Title					nvarchar(200),
    @Description			nvarchar(500),
    @KeyWords				nvarchar(500),
    @Url					nvarchar(255),
    @SkinSrc				nvarchar(200),
    @ContainerSrc			nvarchar(200),
    @StartDate				datetime,
    @EndDate				datetime,
    @RefreshInterval		int,
    @PageHeadText			nvarchar(Max),
    @IsSecure				bit,
    @PermanentRedirect		bit,
    @SiteMapPriority		float,
    @CreatedByUserID		int,
    @CultureCode			nvarchar(50),
	@IsSystem				bit

AS
    INSERT INTO dbo.Tabs (
        ContentItemID,
        PortalID,
        TabOrder,
        UniqueId,
        VersionGuid,
        DefaultLanguageGuid,
        LocalizedVersionGuid,
        TabName,
        IsVisible,
        DisableLink,
        ParentId,
        IconFile,
        IconFileLarge,
        Title,
        Description,
        KeyWords,
        IsDeleted,
        Url,
        SkinSrc,
        ContainerSrc,
        StartDate,
        EndDate,
        RefreshInterval,
        PageHeadText,
        IsSecure,
        PermanentRedirect,
        SiteMapPriority,
        CreatedByUserID,
        CreatedOnDate,
        LastModifiedByUserID,
        LastModifiedOnDate,
        CultureCode,
		IsSystem
    )
    VALUES (
        @ContentItemID,
        @PortalID,
        @TabOrder,
        @UniqueId,
        @VersionGuid,
        @DefaultLanguageGuid,
        @LocalizedVersionGuid,
        @TabName,
        @IsVisible,
        @DisableLink,
        @ParentId,
        @IconFile,
        @IconFileLarge,
        @Title,
        @Description,
        @KeyWords,
        0,
        @Url,
        @SkinSrc,
        @ContainerSrc,
        @StartDate,
        @EndDate,
        @RefreshInterval,
        @PageHeadText,
        @IsSecure,
        @PermanentRedirect,
        @SiteMapPriority,
        @CreatedByUserID,
        getdate(),
        @CreatedByUserID,
        getdate(),
        @CultureCode,
		@IsSystem
    )
	DECLARE @TabId INT
    SELECT @TabId = SCOPE_IDENTITY()
    EXEC dbo.BuildTabLevelAndPath @TabId
	SELECT @TabId
    RETURN @TabId
GO
/****** Object:  StoredProcedure [dbo].[AddTabAfter]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddTabAfter] 
	@AfterTabID				int,
	@ContentItemID			int,
    @PortalID				int,
    @UniqueId				uniqueidentifier,
    @VersionGuid			uniqueidentifier,
    @DefaultLanguageGuid	uniqueidentifier,
    @LocalizedVersionGuid	uniqueidentifier,
    @TabName				nvarchar(200),
    @IsVisible				bit,
    @DisableLink			bit,
    @ParentId				int,
    @IconFile				nvarchar(100),
    @IconFileLarge			nvarchar(100),
    @Title					nvarchar(200),
    @Description			nvarchar(500),
    @KeyWords				nvarchar(500),
    @Url					nvarchar(255),
    @SkinSrc				nvarchar(200),
    @ContainerSrc			nvarchar(200),
    @StartDate				datetime,
    @EndDate				datetime,
    @RefreshInterval		int,
    @PageHeadText			nvarchar(max),
    @IsSecure				bit,
    @PermanentRedirect		bit,
    @SiteMapPriority		float,
    @CreatedByUserID		int,
    @CultureCode			nvarchar(50),
	@IsSystem				bit

AS
	BEGIN
		DECLARE @TabId int
		DECLARE @TabOrder INT 
		SET @TabOrder = (SELECT TabOrder FROM dbo.Tabs WHERE TabID = @AfterTabID)
		
		-- Update TabOrders for all Tabs higher than @TabOrder
		UPDATE dbo.Tabs
			SET TabOrder = TabOrder + 2
			WHERE (ParentId = @ParentId OR (ParentId IS NULL AND @ParentID IS NULL))
				AND TabOrder > @TabOrder
				AND (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
		
		-- Create Tab
		SET @TabOrder = @TabOrder + 2
		EXECUTE @TabId = dbo.AddTab 
							@ContentItemID,
							@PortalID,
							@TabOrder,
							@UniqueId,
							@VersionGuid,
							@DefaultLanguageGuid,
							@LocalizedVersionGuid,
							@TabName,
							@IsVisible,
							@DisableLink,
							@ParentId,
							@IconFile,
							@IconFileLarge,
							@Title,
							@Description,
							@KeyWords,
							@Url,
							@SkinSrc,
							@ContainerSrc,
							@StartDate,
							@EndDate,
							@RefreshInterval,
							@PageHeadText,
							@IsSecure,
							@PermanentRedirect,
							@SiteMapPriority,
							@CreatedByUserID,
							@CultureCode,
							@IsSystem;
		
		-- Update Content Item
		UPDATE dbo.ContentItems
			SET TabID = @TabId
			WHERE ContentItemID = @ContentItemID

		SELECT @TabId
	END
GO
/****** Object:  StoredProcedure [dbo].[AddTabBefore]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddTabBefore] 
	@BeforeTabID			int,
	@ContentItemID			int,
    @PortalID				int,
    @UniqueId				uniqueidentifier,
    @VersionGuid			uniqueidentifier,
    @DefaultLanguageGuid	uniqueidentifier,
    @LocalizedVersionGuid	uniqueidentifier,
    @TabName				nvarchar(200),
    @IsVisible				bit,
    @DisableLink			bit,
    @ParentId				int,
    @IconFile				nvarchar(100),
    @IconFileLarge			nvarchar(100),
    @Title					nvarchar(200),
    @Description			nvarchar(500),
    @KeyWords				nvarchar(500),
    @Url					nvarchar(255),
    @SkinSrc				nvarchar(200),
    @ContainerSrc			nvarchar(200),
    @StartDate				datetime,
    @EndDate				datetime,
    @RefreshInterval		int,
    @PageHeadText			nvarchar(max),
    @IsSecure				bit,
    @PermanentRedirect		bit,
    @SiteMapPriority		float,
    @CreatedByUserID		int,
    @CultureCode			nvarchar(50),
	@IsSystem				bit

AS

	BEGIN
		DECLARE @TabId int
		DECLARE @TabOrder INT 
		SELECT @TabOrder = TabOrder FROM dbo.Tabs WHERE TabID = @BeforeTabID
		
		-- Update TabOrders for all Tabs higher than @TabOrder
		UPDATE dbo.Tabs
			SET TabOrder = TabOrder + 2
			WHERE (ParentId = @ParentId OR (ParentId IS NULL AND @ParentID IS NULL))
				AND TabOrder >= @TabOrder
				AND (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
		
		-- Create Tab
		EXECUTE @TabId = dbo.AddTab 
							@ContentItemID,
							@PortalID,
							@TabOrder,
							@UniqueId,
							@VersionGuid,
							@DefaultLanguageGuid,
							@LocalizedVersionGuid,
							@TabName,
							@IsVisible,
							@DisableLink,
							@ParentId,
							@IconFile,
							@IconFileLarge,
							@Title,
							@Description,
							@KeyWords,
							@Url,
							@SkinSrc,
							@ContainerSrc,
							@StartDate,
							@EndDate,
							@RefreshInterval,
							@PageHeadText,
							@IsSecure,
							@PermanentRedirect,
							@SiteMapPriority,
							@CreatedByUserID,
							@CultureCode,
							@IsSystem;
		
		-- Update Content Item
		UPDATE dbo.ContentItems
			SET TabID = @TabId
			WHERE ContentItemID = @ContentItemID

		SELECT @TabId
	END
GO
/****** Object:  StoredProcedure [dbo].[AddTabModule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddTabModule]
    @TabId                  int,
    @ModuleId               int,
	@ModuleTitle			nvarchar(256),
	@Header					ntext,
	@Footer					ntext,
    @ModuleOrder            int,
    @PaneName               nvarchar(50),
    @CacheTime              int,
    @CacheMethod			varchar(50),
    @Alignment              nvarchar(10),
    @Color                  nvarchar(20),
    @Border                 nvarchar(1),
    @IconFile               nvarchar(100),
    @Visibility             int,
    @ContainerSrc           nvarchar(200),
    @DisplayTitle           bit,
    @DisplayPrint           bit,
    @DisplaySyndicate       bit,
    @IsWebSlice				bit,
    @WebSliceTitle			nvarchar(256),
    @WebSliceExpiryDate     datetime,
    @WebSliceTTL			int,
    @UniqueId				uniqueidentifier,
    @VersionGuid			uniqueidentifier,
    @DefaultLanguageGuid	uniqueidentifier,
    @LocalizedVersionGuid	uniqueidentifier,
    @CultureCode			nvarchar(10),
    @CreatedByUserID  		int

AS
    INSERT INTO dbo.TabModules ( 
        TabId,
        ModuleId,
        ModuleTitle,
        Header,
        Footer,
		ModuleOrder,
        PaneName,
        CacheTime,
        CacheMethod,
        Alignment,
        Color,
        Border,
        IconFile,
        Visibility,
        ContainerSrc,
        DisplayTitle,
        DisplayPrint,
        DisplaySyndicate,
        IsWebSlice,
        WebSliceTitle,
        WebSliceExpiryDate,
        WebSliceTTL,
        UniqueId,
        VersionGuid,
        DefaultLanguageGuid,
        LocalizedVersionGuid,
        CultureCode,
        CreatedByUserID,
        CreatedOnDate,
        LastModifiedByUserID,
        LastModifiedOnDate
    )
    VALUES (
        @TabId,
        @ModuleId,
        @ModuleTitle,
        @Header,
        @Footer,
        @ModuleOrder,
        @PaneName,
        @CacheTime,
        @CacheMethod,
        @Alignment,
        @Color,
        @Border,
        @IconFile,
        @Visibility,
        @ContainerSrc,
        @DisplayTitle,
        @DisplayPrint,
        @DisplaySyndicate,
        @IsWebSlice,
        @WebSliceTitle,
        @WebSliceExpiryDate,
        @WebSliceTTL,
        @UniqueId,
        @VersionGuid,
        @DefaultLanguageGuid,
        @LocalizedVersionGuid,
        @CultureCode,
        @CreatedByUserID,
        getdate(),
        @CreatedByUserID,
        getdate()
    )
GO
/****** Object:  StoredProcedure [dbo].[AddTabModuleSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddTabModuleSetting]
	@TabModuleId   		int,
	@SettingName   		nvarchar(50),
	@SettingValue  		nvarchar(max),
	@CreatedByUserID  	int
AS
	INSERT INTO dbo.TabModuleSettings ( 
		TabModuleId,
		SettingName, 
		SettingValue,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate
	) 
	VALUES ( 
		@TabModuleId,
		@SettingName, 
		@SettingValue,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate()
	)
GO
/****** Object:  StoredProcedure [dbo].[AddTabPermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddTabPermission]
    @TabID              Int, -- not null!
    @PermissionId       Int, -- not null!
    @RoleId             Int, -- might be negative for virtual roles
    @AllowAccess        Bit, -- false: deny, true: grant
    @UserId             Int, -- -1 is replaced by Null
    @CreatedByUserId    Int  -- -1 is replaced by Null
AS
BEGIN
    INSERT INTO dbo.[TabPermission] (
        [TabID],
        [PermissionID],
        [RoleId],
        [AllowAccess],
        [UserId],
        [CreatedByUserId],
        [CreatedOnDate],
        [LastModifiedByUserId],
        [LastModifiedOnDate]
    ) VALUES (
        @TabID,
        @PermissionID,
        @RoleId,
        @AllowAccess,
        CASE WHEN @UserId = -1 THEN Null ELSE @UserId END,
        CASE WHEN @CreatedByUserID = -1 THEN Null ELSE @CreatedByUserID END,
        GetDate(),
        CASE WHEN @CreatedByUserID = -1 THEN Null ELSE @CreatedByUserID END,
        GetDate()
    )
    SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddTabSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddTabSetting]
	@TabID				INT,
	@SettingName		NVARCHAR(50),
	@SettingValue		NVARCHAR(2000),
	@CreatedByUserID	INT

AS

	INSERT INTO dbo.TabSettings ( 
		TabID,
		SettingName,
		SettingValue,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate
	) 
	VALUES ( 
		@TabId, 
		@SettingName, 
		@SettingValue,
		@CreatedByUserID,
		GETDATE(),
		@CreatedByUserID,
		GETDATE()
	)
GO
/****** Object:  StoredProcedure [dbo].[AddTabToEnd]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddTabToEnd]
	@ContentItemID			int,
    @PortalID				int,
    @UniqueId				uniqueidentifier,
    @VersionGuid			uniqueidentifier,
    @DefaultLanguageGuid	uniqueidentifier,
    @LocalizedVersionGuid	uniqueidentifier,
    @TabName				nvarchar(200),
    @IsVisible				bit,
    @DisableLink			bit,
    @ParentId				int,
    @IconFile				nvarchar(100),
    @IconFileLarge			nvarchar(100),
    @Title					nvarchar(200),
    @Description			nvarchar(500),
    @KeyWords				nvarchar(500),
    @Url					nvarchar(255),
    @SkinSrc				nvarchar(200),
    @ContainerSrc			nvarchar(200),
    @StartDate				datetime,
    @EndDate				datetime,
    @RefreshInterval		int,
    @PageHeadText			nvarchar(max),
    @IsSecure				bit,
    @PermanentRedirect		bit,
    @SiteMapPriority		float,
    @CreatedByUserID		int,
    @CultureCode			nvarchar(50),
	@IsSystem				bit

AS

	BEGIN
		DECLARE @TabId int
		DECLARE @TabOrder int 
		SET @TabOrder = (SELECT MAX(TabOrder) FROM dbo.Tabs 
						 WHERE (PortalId = @PortalID OR (PortalId IS NULL AND @PortalID IS NULL)) AND
							   (ParentId = @ParentId OR (ParentId IS NULL AND @ParentID IS NULL))
						)
		IF @TabOrder IS NULL
			SET @TabOrder = 1
		ELSE
			SET @TabOrder = @TabOrder + 2

		-- Create Tab
		EXECUTE @TabId = dbo.AddTab 
							@ContentItemID,
							@PortalID,
							@TabOrder,
							@UniqueId,
							@VersionGuid,
							@DefaultLanguageGuid,
							@LocalizedVersionGuid,
							@TabName,
							@IsVisible,
							@DisableLink,
							@ParentId,
							@IconFile,
							@IconFileLarge,
							@Title,
							@Description,
							@KeyWords,
							@Url,
							@SkinSrc,
							@ContainerSrc,
							@StartDate,
							@EndDate,
							@RefreshInterval,
							@PageHeadText,
							@IsSecure,
							@PermanentRedirect,
							@SiteMapPriority,
							@CreatedByUserID,
							@CultureCode,
							@IsSystem;
		
		-- Update Content Item
		UPDATE dbo.ContentItems
			SET TabID = @TabId
			WHERE ContentItemID = @ContentItemID

		SELECT @TabId
	END
GO
/****** Object:  StoredProcedure [dbo].[AddTermToContent]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddTermToContent] 
	@TermID			int,
	@ContentItemID	int
AS
	INSERT INTO dbo.ContentItems_Tags (
		TermID,
		ContentItemID
	)

	VALUES (
		@TermID,
		@ContentItemID
	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddUrl]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AddUrl]

@PortalID     int,
@Url          nvarchar(255)

as

insert into dbo.Urls (
  PortalID,
  Url
)
values (
  @PortalID,
  @Url
)
GO
/****** Object:  StoredProcedure [dbo].[AddUrlLog]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AddUrlLog]

@UrlTrackingID int,
@UserID        int

as

insert into dbo.UrlLog (
  UrlTrackingID,
  ClickDate,
  UserID
)
values (
  @UrlTrackingID,
  getdate(),
  @UserID
)
GO
/****** Object:  StoredProcedure [dbo].[AddUrlTracking]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AddUrlTracking]

@PortalID     int,
@Url          nvarchar(255),
@UrlType      char(1),
@LogActivity  bit,
@TrackClicks  bit,
@ModuleId     int,
@NewWindow    bit

as

insert into dbo.UrlTracking (
  PortalID,
  Url,
  UrlType,
  Clicks,
  LastClick,
  CreatedDate,
  LogActivity,
  TrackClicks,
  ModuleId,
  NewWindow
)
values (
  @PortalID,
  @Url,
  @UrlType,
  0,
  null,
  getdate(),
  @LogActivity,
  @TrackClicks,
  @ModuleId,
  @NewWindow
)
GO
/****** Object:  StoredProcedure [dbo].[AddUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddUser]

	@PortalID		int,
	@Username		nvarchar(100),
	@FirstName		nvarchar(50),
	@LastName		nvarchar(50),
	@AffiliateId    int,
	@IsSuperUser    bit,
	@Email          nvarchar(256),
	@DisplayName    nvarchar(100),
	@UpdatePassword	bit,
	@Authorised		bit,
	@CreatedByUserID int
AS

DECLARE @UserID int

SELECT @UserID = UserID
	FROM dbo.Users
	WHERE  Username = @Username

IF @UserID is null
	BEGIN
		INSERT INTO dbo.Users (
			Username,
			FirstName, 
			LastName, 
			AffiliateId,
			IsSuperUser,
			Email,
			DisplayName,
			UpdatePassword,
			CreatedByUserID,
			CreatedOnDate,
			LastModifiedByUserID,
			LastModifiedOnDate
		  )
		VALUES (
			@Username,
			@FirstName, 
			@LastName, 
			@AffiliateId,
			@IsSuperUser,
			@Email,
			@DisplayName,
			@UpdatePassword,
			@CreatedByUserID,
			getdate(),
			@CreatedByUserID,
			getdate()
		)

		SELECT @UserID = SCOPE_IDENTITY()
	END

	IF not exists ( SELECT 1 FROM dbo.UserPortals WHERE UserID = @UserID AND PortalID = @PortalID ) AND @PortalID > -1
		BEGIN
			INSERT INTO dbo.UserPortals (
				UserID,
				PortalID,
				Authorised,
				CreatedDate
			)
			VALUES (
				@UserID,
				@PortalID,
				@Authorised,
				getdate()
			)
		END

SELECT @UserID
GO
/****** Object:  StoredProcedure [dbo].[AddUserAuthentication]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddUserAuthentication]
	@UserID					int,
	@AuthenticationType     nvarchar(100),
	@AuthenticationToken    nvarchar(1000),
	@CreatedByUserID	int

AS
	INSERT INTO dbo.UserAuthentication (
		UserID,
		AuthenticationType,
		AuthenticationToken,
		[CreatedByUserID],
		[CreatedOnDate],
		[LastModifiedByUserID],
		[LastModifiedOnDate]

	)
	values (
		@UserID,
		@AuthenticationType,
		@AuthenticationToken,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate()

	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddUserPortal]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddUserPortal]

	@PortalID		int,
	@UserID			int
AS

	IF not exists ( SELECT 1 FROM dbo.UserPortals WHERE UserID = @UserID AND PortalID = @PortalID ) AND @PortalID > -1
		BEGIN
			INSERT INTO dbo.UserPortals (
				UserID,
				PortalID,
				Authorised,
				CreatedDate
			)
			VALUES (
				@UserID,
				@PortalID,
				1,
				getdate()
			)
		END
GO
/****** Object:  StoredProcedure [dbo].[AddUserRole]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddUserRole]
	@PortalID		int,
	@UserID			int,
	@RoleId			int,
	@Status			int,
	@IsOwner		bit,
	@EffectiveDate	datetime = null,
	@ExpiryDate		datetime = null,
	@CreatedByUserID  int
AS

DECLARE @UserRoleId int

SELECT @UserRoleId = null

SELECT @UserRoleId = UserRoleId
	FROM dbo.UserRoles
	WHERE  UserId = @UserID AND RoleId = @RoleId
 
IF @UserRoleId IS NOT NULL
	BEGIN
		UPDATE dbo.UserRoles
			SET 
				Status = @Status,
				IsOwner = @IsOwner,
				ExpiryDate = @ExpiryDate,
				EffectiveDate = @EffectiveDate,
				IsTrialUsed = 1,
				LastModifiedByUserID = @CreatedByUserID,
				LastModifiedOnDate = getdate()
			WHERE  UserRoleId = @UserRoleId
		SELECT @UserRoleId
	END
ELSE
	BEGIN
		INSERT INTO dbo.UserRoles (
			UserId,
			RoleId,
			Status,
			IsOwner,
			EffectiveDate,
			ExpiryDate,
			IsTrialUsed,
			CreatedByUserID,
			CreatedOnDate,
			LastModifiedByUserID,
			LastModifiedOnDate
		  )
		VALUES (
			@UserID,
			@RoleId,
			@Status,
			@IsOwner,
			@EffectiveDate,
			@ExpiryDate,
			1,
			@CreatedByUserID,
			getdate(),
			@CreatedByUserID,
			getdate()
		  )

	SELECT SCOPE_IDENTITY()
    END
GO
/****** Object:  StoredProcedure [dbo].[AddVendor]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[AddVendor]

@PortalID 	int,
@VendorName nvarchar(50),
@Unit    	nvarchar(50),
@Street 	nvarchar(50),
@City		nvarchar(50),
@Region	    nvarchar(50),
@Country	nvarchar(50),
@PostalCode	nvarchar(50),
@Telephone	nvarchar(50),
@Fax   	    nvarchar(50),
@Cell   	nvarchar(50),
@Email    	nvarchar(50),
@Website	nvarchar(100),
@FirstName	nvarchar(50),
@LastName	nvarchar(50),
@UserName   nvarchar(100),
@LogoFile   nvarchar(100),
@KeyWords   text,
@Authorized bit

as

insert into dbo.Vendors (
  VendorName,
  Unit,
  Street,
  City,
  Region,
  Country,
  PostalCode,
  Telephone,
  PortalId,
  Fax,
  Cell,
  Email,
  Website,
  FirstName,
  Lastname,
  ClickThroughs,
  Views,
  CreatedByUser,
  CreatedDate,
  LogoFile,
  KeyWords,
  Authorized
)
values (
  @VendorName,
  @Unit,
  @Street,
  @City,
  @Region,
  @Country,
  @PostalCode,
  @Telephone,
  @PortalID,
  @Fax,
  @Cell,
  @Email,
  @Website,
  @FirstName,
  @LastName,
  0,
  0,
  @UserName,
  getdate(), 
  @LogoFile,
  @KeyWords,
  @Authorized
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddVendorClassification]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AddVendorClassification]

@VendorId           int,
@ClassificationId   int

as

insert into dbo.VendorClassification ( 
  VendorId,
  ClassificationId
)
values (
  @VendorId,
  @ClassificationId
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[AddVocabulary]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddVocabulary] 
	@VocabularyTypeID	int,
	@Name				nvarchar(250),
	@Description		nvarchar(2500),
	@Weight				int,
	@ScopeID			int,
	@ScopeTypeID		int,
	@CreatedByUserID	int
AS
	INSERT INTO dbo.Taxonomy_Vocabularies (
		VocabularyTypeID,
		[Name],
		Description,
		Weight,
		ScopeID,
		ScopeTypeID,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate
	)

	VALUES (
		@VocabularyTypeID,
		@Name,
		@Description,
		@Weight,
		@ScopeID,
		@ScopeTypeID,
		@CreatedByUserID,
		getdate(),
		@CreatedByUserID,
		getdate()
	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[aspnet_AnyDataInTables]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_AnyDataInTables]
    @TablesToCheck int
AS
BEGIN
    -- Check Membership table if (@TablesToCheck & 1) is set
    IF ((@TablesToCheck & 1) <> 0 AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N'vw_aspnet_MembershipUsers') AND (type = 'V'))))
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_Membership))
        BEGIN
            SELECT N'aspnet_Membership'
            RETURN
        END
    END

    -- Check aspnet_Roles table if (@TablesToCheck & 2) is set
    IF ((@TablesToCheck & 2) <> 0  AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N'vw_aspnet_Roles') AND (type = 'V'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 RoleId FROM dbo.aspnet_Roles))
        BEGIN
            SELECT N'aspnet_Roles'
            RETURN
        END
    END

    -- Check aspnet_Profile table if (@TablesToCheck & 4) is set
    IF ((@TablesToCheck & 4) <> 0  AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N'vw_aspnet_Profiles') AND (type = 'V'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_Profile))
        BEGIN
            SELECT N'aspnet_Profile'
            RETURN
        END
    END

    -- Check aspnet_PersonalizationPerUser table if (@TablesToCheck & 8) is set
    IF ((@TablesToCheck & 8) <> 0  AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N'vw_aspnet_WebPartState_User') AND (type = 'V'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_PersonalizationPerUser))
        BEGIN
            SELECT N'aspnet_PersonalizationPerUser'
            RETURN
        END
    END

    -- Check aspnet_PersonalizationPerUser table if (@TablesToCheck & 16) is set
    IF ((@TablesToCheck & 16) <> 0  AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N'aspnet_WebEvent_LogEvent') AND (type = 'P'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 * FROM dbo.aspnet_WebEvent_Events))
        BEGIN
            SELECT N'aspnet_WebEvent_Events'
            RETURN
        END
    END

    -- Check aspnet_Users table if (@TablesToCheck & 1,2,4 & 8) are all set
    IF ((@TablesToCheck & 1) <> 0 AND
        (@TablesToCheck & 2) <> 0 AND
        (@TablesToCheck & 4) <> 0 AND
        (@TablesToCheck & 8) <> 0 AND
        (@TablesToCheck & 32) <> 0 AND
        (@TablesToCheck & 128) <> 0 AND
        (@TablesToCheck & 256) <> 0 AND
        (@TablesToCheck & 512) <> 0 AND
        (@TablesToCheck & 1024) <> 0)
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_Users))
        BEGIN
            SELECT N'aspnet_Users'
            RETURN
        END
        IF (EXISTS(SELECT TOP 1 ApplicationId FROM dbo.aspnet_Applications))
        BEGIN
            SELECT N'aspnet_Applications'
            RETURN
        END
    END
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Applications_CreateApplication]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Applications_CreateApplication]
    @ApplicationName      nvarchar(256),
    @ApplicationId        uniqueidentifier OUTPUT
AS
BEGIN
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName

    IF(@ApplicationId IS NULL)
    BEGIN
        DECLARE @TranStarted   bit
        SET @TranStarted = 0

        IF( @@TRANCOUNT = 0 )
        BEGIN
	        BEGIN TRANSACTION
	        SET @TranStarted = 1
        END
        ELSE
    	    SET @TranStarted = 0

        SELECT  @ApplicationId = ApplicationId
        FROM dbo.aspnet_Applications WITH (UPDLOCK, HOLDLOCK)
        WHERE LOWER(@ApplicationName) = LoweredApplicationName

        IF(@ApplicationId IS NULL)
        BEGIN
            SELECT  @ApplicationId = NEWID()
            INSERT  dbo.aspnet_Applications (ApplicationId, ApplicationName, LoweredApplicationName)
            VALUES  (@ApplicationId, @ApplicationName, LOWER(@ApplicationName))
        END


        IF( @TranStarted = 1 )
        BEGIN
            IF(@@ERROR = 0)
            BEGIN
	        SET @TranStarted = 0
	        COMMIT TRANSACTION
            END
            ELSE
            BEGIN
                SET @TranStarted = 0
                ROLLBACK TRANSACTION
            END
        END
    END
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_CheckSchemaVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_CheckSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128)
AS
BEGIN
    IF (EXISTS( SELECT  *
                FROM    dbo.aspnet_SchemaVersions
                WHERE   Feature = LOWER( @Feature ) AND
                        CompatibleSchemaVersion = @CompatibleSchemaVersion ))
        RETURN 0

    RETURN 1
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_ChangePasswordQuestionAndAnswer]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_ChangePasswordQuestionAndAnswer]
    @ApplicationName       nvarchar(256),
    @UserName              nvarchar(256),
    @NewPasswordQuestion   nvarchar(256),
    @NewPasswordAnswer     nvarchar(128)
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Membership m, dbo.aspnet_Users u, dbo.aspnet_Applications a
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId
    IF (@UserId IS NULL)
    BEGIN
        RETURN(1)
    END

    UPDATE dbo.aspnet_Membership
    SET    PasswordQuestion = @NewPasswordQuestion, PasswordAnswer = @NewPasswordAnswer
    WHERE  UserId=@UserId
    RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_CreateUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_CreateUser]
    @ApplicationName                        nvarchar(256),
    @UserName                               nvarchar(256),
    @Password                               nvarchar(128),
    @PasswordSalt                           nvarchar(128),
    @Email                                  nvarchar(256),
    @PasswordQuestion                       nvarchar(256),
    @PasswordAnswer                         nvarchar(128),
    @IsApproved                             bit,
    @CurrentTimeUtc                         datetime,
    @CreateDate                             datetime = NULL,
    @UniqueEmail                            int      = 0,
    @PasswordFormat                         int      = 0,
    @UserId                                 uniqueidentifier OUTPUT
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL

    DECLARE @NewUserId uniqueidentifier
    SELECT @NewUserId = NULL

    DECLARE @IsLockedOut bit
    SET @IsLockedOut = 0

    DECLARE @LastLockoutDate  datetime
    SET @LastLockoutDate = CONVERT( datetime, '17540101', 112 )

    DECLARE @FailedPasswordAttemptCount int
    SET @FailedPasswordAttemptCount = 0

    DECLARE @FailedPasswordAttemptWindowStart  datetime
    SET @FailedPasswordAttemptWindowStart = CONVERT( datetime, '17540101', 112 )

    DECLARE @FailedPasswordAnswerAttemptCount int
    SET @FailedPasswordAnswerAttemptCount = 0

    DECLARE @FailedPasswordAnswerAttemptWindowStart  datetime
    SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )

    DECLARE @NewUserCreated bit
    DECLARE @ReturnValue   int
    SET @ReturnValue = 0

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    EXEC dbo.aspnet_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    SET @CreateDate = @CurrentTimeUtc

    SELECT  @NewUserId = UserId FROM dbo.aspnet_Users WHERE LOWER(@UserName) = LoweredUserName AND @ApplicationId = ApplicationId
    IF ( @NewUserId IS NULL )
    BEGIN
        SET @NewUserId = @UserId
        EXEC @ReturnValue = dbo.aspnet_Users_CreateUser @ApplicationId, @UserName, 0, @CreateDate, @NewUserId OUTPUT
        SET @NewUserCreated = 1
    END
    ELSE
    BEGIN
        SET @NewUserCreated = 0
        IF( @NewUserId <> @UserId AND @UserId IS NOT NULL )
        BEGIN
            SET @ErrorCode = 6
            GOTO Cleanup
        END
    END

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @ReturnValue = -1 )
    BEGIN
        SET @ErrorCode = 10
        GOTO Cleanup
    END

    IF ( EXISTS ( SELECT UserId
                  FROM   dbo.aspnet_Membership
                  WHERE  @NewUserId = UserId ) )
    BEGIN
        SET @ErrorCode = 6
        GOTO Cleanup
    END

    SET @UserId = @NewUserId

    IF (@UniqueEmail = 1)
    BEGIN
        IF (EXISTS (SELECT *
                    FROM  dbo.aspnet_Membership m WITH ( UPDLOCK, HOLDLOCK )
                    WHERE ApplicationId = @ApplicationId AND LoweredEmail = LOWER(@Email)))
        BEGIN
            SET @ErrorCode = 7
            GOTO Cleanup
        END
    END

    IF (@NewUserCreated = 0)
    BEGIN
        UPDATE dbo.aspnet_Users
        SET    LastActivityDate = @CreateDate
        WHERE  @UserId = UserId
        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    INSERT INTO dbo.aspnet_Membership
                ( ApplicationId,
                  UserId,
                  Password,
                  PasswordSalt,
                  Email,
                  LoweredEmail,
                  PasswordQuestion,
                  PasswordAnswer,
                  PasswordFormat,
                  IsApproved,
                  IsLockedOut,
                  CreateDate,
                  LastLoginDate,
                  LastPasswordChangedDate,
                  LastLockoutDate,
                  FailedPasswordAttemptCount,
                  FailedPasswordAttemptWindowStart,
                  FailedPasswordAnswerAttemptCount,
                  FailedPasswordAnswerAttemptWindowStart )
         VALUES ( @ApplicationId,
                  @UserId,
                  @Password,
                  @PasswordSalt,
                  @Email,
                  LOWER(@Email),
                  @PasswordQuestion,
                  @PasswordAnswer,
                  @PasswordFormat,
                  @IsApproved,
                  @IsLockedOut,
                  @CreateDate,
                  @CreateDate,
                  @CreateDate,
                  @LastLockoutDate,
                  @FailedPasswordAttemptCount,
                  @FailedPasswordAttemptWindowStart,
                  @FailedPasswordAnswerAttemptCount,
                  @FailedPasswordAnswerAttemptWindowStart )

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
	    SET @TranStarted = 0
	    COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_FindUsersByEmail]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_FindUsersByEmail]
    @ApplicationName       nvarchar(256),
    @EmailToMatch          nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    IF( @EmailToMatch IS NULL )
        INSERT INTO #PageIndexForUsers (UserId)
            SELECT u.UserId
            FROM   dbo.aspnet_Users u, dbo.aspnet_Membership m
            WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND m.Email IS NULL
            ORDER BY m.LoweredEmail
    ELSE
        INSERT INTO #PageIndexForUsers (UserId)
            SELECT u.UserId
            FROM   dbo.aspnet_Users u, dbo.aspnet_Membership m
            WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND m.LoweredEmail LIKE LOWER(@EmailToMatch)
            ORDER BY m.LoweredEmail

    SELECT  u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY m.LoweredEmail

    SELECT  @TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers
    RETURN @TotalRecords
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_FindUsersByName]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_FindUsersByName]
    @ApplicationName       nvarchar(256),
    @UserNameToMatch       nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
        SELECT u.UserId
        FROM   dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND u.LoweredUserName LIKE LOWER(@UserNameToMatch)
        ORDER BY u.UserName


    SELECT  u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY u.UserName

    SELECT  @TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers
    RETURN @TotalRecords
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetAllUsers]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetAllUsers]
    @ApplicationName       nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0


    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
    SELECT u.UserId
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u
    WHERE  u.ApplicationId = @ApplicationId AND u.UserId = m.UserId
    ORDER BY u.UserName

    SELECT @TotalRecords = @@ROWCOUNT

    SELECT u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY u.UserName
    RETURN @TotalRecords
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetNumberOfUsersOnline]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetNumberOfUsersOnline]
    @ApplicationName            nvarchar(256),
    @MinutesSinceLastInActive   int,
    @CurrentTimeUtc             datetime
AS
BEGIN
    DECLARE @DateActive datetime
    SELECT  @DateActive = DATEADD(minute,  -(@MinutesSinceLastInActive), @CurrentTimeUtc)

    DECLARE @NumOnline int
    SELECT  @NumOnline = COUNT(*)
    FROM    dbo.aspnet_Users u WITH(NOLOCK),
            dbo.aspnet_Applications a WITH(NOLOCK),
            dbo.aspnet_Membership m WITH(NOLOCK)
    WHERE   u.ApplicationId = a.ApplicationId                  AND
            LastActivityDate > @DateActive                     AND
            a.LoweredApplicationName = LOWER(@ApplicationName) AND
            u.UserId = m.UserId
    RETURN(@NumOnline)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetPassword]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetPassword]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @MaxInvalidPasswordAttempts     int,
    @PasswordAttemptWindow          int,
    @CurrentTimeUtc                 datetime,
    @PasswordAnswer                 nvarchar(128) = NULL
AS
BEGIN
    DECLARE @UserId                                 uniqueidentifier
    DECLARE @PasswordFormat                         int
    DECLARE @Password                               nvarchar(128)
    DECLARE @passAns                                nvarchar(128)
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId,
            @Password = m.Password,
            @passAns = m.PasswordAnswer,
            @PasswordFormat = m.PasswordFormat,
            @IsLockedOut = m.IsLockedOut,
            @LastLockoutDate = m.LastLockoutDate,
            @FailedPasswordAttemptCount = m.FailedPasswordAttemptCount,
            @FailedPasswordAttemptWindowStart = m.FailedPasswordAttemptWindowStart,
            @FailedPasswordAnswerAttemptCount = m.FailedPasswordAnswerAttemptCount,
            @FailedPasswordAnswerAttemptWindowStart = m.FailedPasswordAnswerAttemptWindowStart
    FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m WITH ( UPDLOCK )
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF ( @@rowcount = 0 )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    IF( @IsLockedOut = 1 )
    BEGIN
        SET @ErrorCode = 99
        GOTO Cleanup
    END

    IF ( NOT( @PasswordAnswer IS NULL ) )
    BEGIN
        IF( ( @passAns IS NULL ) OR ( LOWER( @passAns ) <> LOWER( @PasswordAnswer ) ) )
        BEGIN
            IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAnswerAttemptWindowStart ) )
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = 1
            END
            ELSE
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount + 1
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
            END

            BEGIN
                IF( @FailedPasswordAnswerAttemptCount >= @MaxInvalidPasswordAttempts )
                BEGIN
                    SET @IsLockedOut = 1
                    SET @LastLockoutDate = @CurrentTimeUtc
                END
            END

            SET @ErrorCode = 3
        END
        ELSE
        BEGIN
            IF( @FailedPasswordAnswerAttemptCount > 0 )
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = 0
                SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            END
        END

        UPDATE dbo.aspnet_Membership
        SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
            FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
            FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
            FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
            FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
        WHERE @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    IF( @ErrorCode = 0 )
        SELECT @Password, @PasswordFormat

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetPasswordWithFormat]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetPasswordWithFormat]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @UpdateLastLoginActivityDate    bit,
    @CurrentTimeUtc                 datetime
AS
BEGIN
    DECLARE @IsLockedOut                        bit
    DECLARE @UserId                             uniqueidentifier
    DECLARE @Password                           nvarchar(128)
    DECLARE @PasswordSalt                       nvarchar(128)
    DECLARE @PasswordFormat                     int
    DECLARE @FailedPasswordAttemptCount         int
    DECLARE @FailedPasswordAnswerAttemptCount   int
    DECLARE @IsApproved                         bit
    DECLARE @LastActivityDate                   datetime
    DECLARE @LastLoginDate                      datetime

    SELECT  @UserId          = NULL

    SELECT  @UserId = u.UserId, @IsLockedOut = m.IsLockedOut, @Password=Password, @PasswordFormat=PasswordFormat,
            @PasswordSalt=PasswordSalt, @FailedPasswordAttemptCount=FailedPasswordAttemptCount,
		    @FailedPasswordAnswerAttemptCount=FailedPasswordAnswerAttemptCount, @IsApproved=IsApproved,
            @LastActivityDate = LastActivityDate, @LastLoginDate = LastLoginDate
    FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF (@UserId IS NULL)
        RETURN 1

    IF (@IsLockedOut = 1)
        RETURN 99

    SELECT   @Password, @PasswordFormat, @PasswordSalt, @FailedPasswordAttemptCount,
             @FailedPasswordAnswerAttemptCount, @IsApproved, @LastLoginDate, @LastActivityDate

    IF (@UpdateLastLoginActivityDate = 1 AND @IsApproved = 1)
    BEGIN
        UPDATE  dbo.aspnet_Membership
        SET     LastLoginDate = @CurrentTimeUtc
        WHERE   UserId = @UserId

        UPDATE  dbo.aspnet_Users
        SET     LastActivityDate = @CurrentTimeUtc
        WHERE   @UserId = UserId
    END


    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetUserByEmail]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetUserByEmail]
    @ApplicationName  nvarchar(256),
    @Email            nvarchar(256)
AS
BEGIN
    IF( @Email IS NULL )
        SELECT  u.UserName
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                u.UserId = m.UserId AND
                m.LoweredEmail IS NULL
    ELSE
        SELECT  u.UserName
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                u.UserId = m.UserId AND
                LOWER(@Email) = m.LoweredEmail

    IF (@@rowcount = 0)
        RETURN(1)
    RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetUserByName]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetUserByName]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @CurrentTimeUtc       datetime,
    @UpdateLastActivity   bit = 0
AS
BEGIN
    DECLARE @UserId uniqueidentifier

    IF (@UpdateLastActivity = 1)
    BEGIN
        -- select user ID from aspnet_users table
        SELECT TOP 1 @UserId = u.UserId
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE    LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                LOWER(@UserName) = u.LoweredUserName AND u.UserId = m.UserId

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1

        UPDATE   dbo.aspnet_Users
        SET      LastActivityDate = @CurrentTimeUtc
        WHERE    @UserId = UserId

        SELECT m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
                m.CreateDate, m.LastLoginDate, u.LastActivityDate, m.LastPasswordChangedDate,
                u.UserId, m.IsLockedOut, m.LastLockoutDate
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE  @UserId = u.UserId AND u.UserId = m.UserId 
    END
    ELSE
    BEGIN
        SELECT TOP 1 m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
                m.CreateDate, m.LastLoginDate, u.LastActivityDate, m.LastPasswordChangedDate,
                u.UserId, m.IsLockedOut,m.LastLockoutDate
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE    LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                LOWER(@UserName) = u.LoweredUserName AND u.UserId = m.UserId

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1
    END

    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetUserByUserId]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetUserByUserId]
    @UserId               uniqueidentifier,
    @CurrentTimeUtc       datetime,
    @UpdateLastActivity   bit = 0
AS
BEGIN
    IF ( @UpdateLastActivity = 1 )
    BEGIN
        UPDATE   dbo.aspnet_Users
        SET      LastActivityDate = @CurrentTimeUtc
        FROM     dbo.aspnet_Users
        WHERE    @UserId = UserId

        IF ( @@ROWCOUNT = 0 ) -- User ID not found
            RETURN -1
    END

    SELECT  m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate, m.LastLoginDate, u.LastActivityDate,
            m.LastPasswordChangedDate, u.UserName, m.IsLockedOut,
            m.LastLockoutDate
    FROM    dbo.aspnet_Users u, dbo.aspnet_Membership m
    WHERE   @UserId = u.UserId AND u.UserId = m.UserId

    IF ( @@ROWCOUNT = 0 ) -- User ID not found
       RETURN -1

    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_ResetPassword]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_ResetPassword]
    @ApplicationName             nvarchar(256),
    @UserName                    nvarchar(256),
    @NewPassword                 nvarchar(128),
    @MaxInvalidPasswordAttempts  int,
    @PasswordAttemptWindow       int,
    @PasswordSalt                nvarchar(128),
    @CurrentTimeUtc              datetime,
    @PasswordFormat              int = 0,
    @PasswordAnswer              nvarchar(128) = NULL
AS
BEGIN
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @UserId                                 uniqueidentifier
    SET     @UserId = NULL

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF ( @UserId IS NULL )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    SELECT @IsLockedOut = IsLockedOut,
           @LastLockoutDate = LastLockoutDate,
           @FailedPasswordAttemptCount = FailedPasswordAttemptCount,
           @FailedPasswordAttemptWindowStart = FailedPasswordAttemptWindowStart,
           @FailedPasswordAnswerAttemptCount = FailedPasswordAnswerAttemptCount,
           @FailedPasswordAnswerAttemptWindowStart = FailedPasswordAnswerAttemptWindowStart
    FROM dbo.aspnet_Membership WITH ( UPDLOCK )
    WHERE @UserId = UserId

    IF( @IsLockedOut = 1 )
    BEGIN
        SET @ErrorCode = 99
        GOTO Cleanup
    END

    UPDATE dbo.aspnet_Membership
    SET    Password = @NewPassword,
           LastPasswordChangedDate = @CurrentTimeUtc,
           PasswordFormat = @PasswordFormat,
           PasswordSalt = @PasswordSalt
    WHERE  @UserId = UserId AND
           ( ( @PasswordAnswer IS NULL ) OR ( LOWER( PasswordAnswer ) = LOWER( @PasswordAnswer ) ) )

    IF ( @@ROWCOUNT = 0 )
        BEGIN
            IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAnswerAttemptWindowStart ) )
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = 1
            END
            ELSE
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount + 1
            END

            BEGIN
                IF( @FailedPasswordAnswerAttemptCount >= @MaxInvalidPasswordAttempts )
                BEGIN
                    SET @IsLockedOut = 1
                    SET @LastLockoutDate = @CurrentTimeUtc
                END
            END

            SET @ErrorCode = 3
        END
    ELSE
        BEGIN
            IF( @FailedPasswordAnswerAttemptCount > 0 )
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = 0
                SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            END
        END

    IF( NOT ( @PasswordAnswer IS NULL ) )
    BEGIN
        UPDATE dbo.aspnet_Membership
        SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
            FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
            FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
            FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
            FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
        WHERE @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_SetPassword]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_SetPassword]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256),
    @NewPassword      nvarchar(128),
    @PasswordSalt     nvarchar(128),
    @CurrentTimeUtc   datetime,
    @PasswordFormat   int = 0
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF (@UserId IS NULL)
        RETURN(1)

    UPDATE dbo.aspnet_Membership
    SET Password = @NewPassword, PasswordFormat = @PasswordFormat, PasswordSalt = @PasswordSalt,
        LastPasswordChangedDate = @CurrentTimeUtc
    WHERE @UserId = UserId
    RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_UnlockUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_UnlockUser]
    @ApplicationName                         nvarchar(256),
    @UserName                                nvarchar(256)
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF ( @UserId IS NULL )
        RETURN 1

    UPDATE dbo.aspnet_Membership
    SET IsLockedOut = 0,
        FailedPasswordAttemptCount = 0,
        FailedPasswordAttemptWindowStart = CONVERT( datetime, '17540101', 112 ),
        FailedPasswordAnswerAttemptCount = 0,
        FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 ),
        LastLockoutDate = CONVERT( datetime, '17540101', 112 )
    WHERE @UserId = UserId

    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_UpdateUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_UpdateUser]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @Email                nvarchar(256),
    @Comment              ntext,
    @IsApproved           bit,
    @LastLoginDate        datetime,
    @LastActivityDate     datetime,
    @UniqueEmail          int,
    @CurrentTimeUtc       datetime
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId, @ApplicationId = a.ApplicationId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF (@UserId IS NULL)
        RETURN(1)

    IF (@UniqueEmail = 1)
    BEGIN
        IF (EXISTS (SELECT *
                    FROM  dbo.aspnet_Membership WITH (UPDLOCK, HOLDLOCK)
                    WHERE ApplicationId = @ApplicationId  AND @UserId <> UserId AND LoweredEmail = LOWER(@Email)))
        BEGIN
            RETURN(7)
        END
    END

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
	SET @TranStarted = 0

    UPDATE dbo.aspnet_Users WITH (ROWLOCK)
    SET
         LastActivityDate = @LastActivityDate
    WHERE
       @UserId = UserId

    IF( @@ERROR <> 0 )
        GOTO Cleanup

    UPDATE dbo.aspnet_Membership WITH (ROWLOCK)
    SET
         Email            = @Email,
         LoweredEmail     = LOWER(@Email),
         Comment          = @Comment,
         IsApproved       = @IsApproved,
         LastLoginDate    = @LastLoginDate
    WHERE
       @UserId = UserId

    IF( @@ERROR <> 0 )
        GOTO Cleanup

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN -1
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_UpdateUserInfo]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_UpdateUserInfo]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @IsPasswordCorrect              bit,
    @UpdateLastLoginActivityDate    bit,
    @MaxInvalidPasswordAttempts     int,
    @PasswordAttemptWindow          int,
    @CurrentTimeUtc                 datetime,
    @LastLoginDate                  datetime,
    @LastActivityDate               datetime
AS
BEGIN
    DECLARE @UserId                                 uniqueidentifier
    DECLARE @IsApproved                             bit
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId,
            @IsApproved = m.IsApproved,
            @IsLockedOut = m.IsLockedOut,
            @LastLockoutDate = m.LastLockoutDate,
            @FailedPasswordAttemptCount = m.FailedPasswordAttemptCount,
            @FailedPasswordAttemptWindowStart = m.FailedPasswordAttemptWindowStart,
            @FailedPasswordAnswerAttemptCount = m.FailedPasswordAnswerAttemptCount,
            @FailedPasswordAnswerAttemptWindowStart = m.FailedPasswordAnswerAttemptWindowStart
    FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m WITH ( UPDLOCK )
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF ( @@rowcount = 0 )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    IF( @IsLockedOut = 1 )
    BEGIN
        GOTO Cleanup
    END

    IF( @IsPasswordCorrect = 0 )
    BEGIN
        IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAttemptWindowStart ) )
        BEGIN
            SET @FailedPasswordAttemptWindowStart = @CurrentTimeUtc
            SET @FailedPasswordAttemptCount = 1
        END
        ELSE
        BEGIN
            SET @FailedPasswordAttemptWindowStart = @CurrentTimeUtc
            SET @FailedPasswordAttemptCount = @FailedPasswordAttemptCount + 1
        END

        BEGIN
            IF( @FailedPasswordAttemptCount >= @MaxInvalidPasswordAttempts )
            BEGIN
                SET @IsLockedOut = 1
                SET @LastLockoutDate = @CurrentTimeUtc
            END
        END
    END
    ELSE
    BEGIN
        IF( @FailedPasswordAttemptCount > 0 OR @FailedPasswordAnswerAttemptCount > 0 )
        BEGIN
            SET @FailedPasswordAttemptCount = 0
            SET @FailedPasswordAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            SET @FailedPasswordAnswerAttemptCount = 0
            SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            SET @LastLockoutDate = CONVERT( datetime, '17540101', 112 )
        END
    END

    IF( @UpdateLastLoginActivityDate = 1 )
    BEGIN
        UPDATE  dbo.aspnet_Users
        SET     LastActivityDate = @LastActivityDate
        WHERE   @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END

        UPDATE  dbo.aspnet_Membership
        SET     LastLoginDate = @LastLoginDate
        WHERE   UserId = @UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END


    UPDATE dbo.aspnet_Membership
    SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
        FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
        FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
        FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
        FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
    WHERE @UserId = UserId

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_RegisterSchemaVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_RegisterSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128),
    @IsCurrentVersion          bit,
    @RemoveIncompatibleSchema  bit
AS
BEGIN
    IF( @RemoveIncompatibleSchema = 1 )
    BEGIN
        DELETE FROM dbo.aspnet_SchemaVersions WHERE Feature = LOWER( @Feature )
    END
    ELSE
    BEGIN
        IF( @IsCurrentVersion = 1 )
        BEGIN
            UPDATE dbo.aspnet_SchemaVersions
            SET IsCurrentVersion = 0
            WHERE Feature = LOWER( @Feature )
        END
    END

    INSERT  dbo.aspnet_SchemaVersions( Feature, CompatibleSchemaVersion, IsCurrentVersion )
    VALUES( LOWER( @Feature ), @CompatibleSchemaVersion, @IsCurrentVersion )
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Setup_RemoveAllRoleMembers]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Setup_RemoveAllRoleMembers]
    @name   sysname
AS
BEGIN
    CREATE TABLE #aspnet_RoleMembers
    (
        Group_name      sysname,
        Group_id        smallint,
        Users_in_group  sysname,
        User_id         smallint
    )

    INSERT INTO #aspnet_RoleMembers
    EXEC sp_helpuser @name

    DECLARE @user_id smallint
    DECLARE @cmd nvarchar(500)
    DECLARE c1 cursor FORWARD_ONLY FOR
        SELECT User_id FROM #aspnet_RoleMembers

    OPEN c1

    FETCH c1 INTO @user_id
    WHILE (@@fetch_status = 0)
    BEGIN
        SET @cmd = 'EXEC sp_droprolemember ' + '''' + @name + ''', ''' + USER_NAME(@user_id) + ''''
        EXEC (@cmd)
        FETCH c1 INTO @user_id
    END

    CLOSE c1
    DEALLOCATE c1
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UnRegisterSchemaVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_UnRegisterSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128)
AS
BEGIN
    DELETE FROM dbo.aspnet_SchemaVersions
        WHERE   Feature = LOWER(@Feature) AND @CompatibleSchemaVersion = CompatibleSchemaVersion
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Users_CreateUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Users_CreateUser]
    @ApplicationId    uniqueidentifier,
    @UserName         nvarchar(256),
    @IsUserAnonymous  bit,
    @LastActivityDate DATETIME,
    @UserId           uniqueidentifier OUTPUT
AS
BEGIN
    IF( @UserId IS NULL )
        SELECT @UserId = NEWID()
    ELSE
    BEGIN
        IF( EXISTS( SELECT UserId FROM dbo.aspnet_Users
                    WHERE @UserId = UserId ) )
            RETURN -1
    END

    INSERT dbo.aspnet_Users (ApplicationId, UserId, UserName, LoweredUserName, IsAnonymous, LastActivityDate)
    VALUES (@ApplicationId, @UserId, @UserName, LOWER(@UserName), @IsUserAnonymous, @LastActivityDate)

    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Users_DeleteUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_Users_DeleteUser]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256),
    @TablesToDeleteFrom int,
    @NumTablesDeletedFrom int OUTPUT
AS
BEGIN
    DECLARE @UserId               uniqueidentifier
    SELECT  @UserId               = NULL
    SELECT  @NumTablesDeletedFrom = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
	SET @TranStarted = 0

    DECLARE @ErrorCode   int
    DECLARE @RowCount    int

    SET @ErrorCode = 0
    SET @RowCount  = 0

    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a
    WHERE   u.LoweredUserName       = LOWER(@UserName)
        AND u.ApplicationId         = a.ApplicationId
        AND LOWER(@ApplicationName) = a.LoweredApplicationName

    IF (@UserId IS NULL)
    BEGIN
        GOTO Cleanup
    END

    -- Delete from Membership table if (@TablesToDeleteFrom & 1) is set
    IF ((@TablesToDeleteFrom & 1) <> 0 AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N'vw_aspnet_MembershipUsers') AND (type = 'V'))))
    BEGIN
        DELETE FROM dbo.aspnet_Membership WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
               @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_UsersInRoles table if (@TablesToDeleteFrom & 2) is set
    IF ((@TablesToDeleteFrom & 2) <> 0  AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N'vw_aspnet_UsersInRoles') AND (type = 'V'))) )
    BEGIN
        DELETE FROM dbo.aspnet_UsersInRoles WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_Profile table if (@TablesToDeleteFrom & 4) is set
    IF ((@TablesToDeleteFrom & 4) <> 0  AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N'vw_aspnet_Profiles') AND (type = 'V'))) )
    BEGIN
        DELETE FROM dbo.aspnet_Profile WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_PersonalizationPerUser table if (@TablesToDeleteFrom & 8) is set
    IF ((@TablesToDeleteFrom & 8) <> 0  AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N'vw_aspnet_WebPartState_User') AND (type = 'V'))) )
    BEGIN
        DELETE FROM dbo.aspnet_PersonalizationPerUser WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_Users table if (@TablesToDeleteFrom & 1,2,4 & 8) are all set
    IF ((@TablesToDeleteFrom & 1) <> 0 AND
        (@TablesToDeleteFrom & 2) <> 0 AND
        (@TablesToDeleteFrom & 4) <> 0 AND
        (@TablesToDeleteFrom & 8) <> 0 AND
        (EXISTS (SELECT UserId FROM dbo.aspnet_Users WHERE @UserId = UserId)))
    BEGIN
        DELETE FROM dbo.aspnet_Users WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    IF( @TranStarted = 1 )
    BEGIN
	    SET @TranStarted = 0
	    COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:
    SET @NumTablesDeletedFrom = 0

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
	    ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[BuildTabLevelAndPath]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BuildTabLevelAndPath](@TabId INT, @IncludeChild BIT = 0)
	AS
	BEGIN
		DECLARE @ParentId INT, @Level INT, @TabPath NVARCHAR(255), @TabName NVARCHAR(200)
		SELECT @ParentId = ParentId, @TabName = TabName FROM dbo.[Tabs] WHERE TabID = @TabId
		IF @ParentId > 0
		BEGIN
			SELECT 
				@Level = [Level] + 1,
				@TabPath = TabPath + '//' + dbo.[RemoveStringCharacters](@TabName, '&? ./''#:*')
			 FROM dbo.[Tabs] WHERE TabID = @ParentId
		END
		ELSE
		BEGIN
			SELECT @Level = 0, @TabPath = '//' + dbo.[RemoveStringCharacters](@TabName, '&? ./''#:*')
		END
		
		UPDATE dbo.[Tabs] SET [Level] = @Level, TabPath = @TabPath WHERE TabID = @TabId
		
		IF @IncludeChild = 1
		BEGIN
			DECLARE @ChildTabs TABLE(TabID INT)
			DECLARE @ChildID INT
			INSERT INTO @ChildTabs SELECT TabID FROM dbo.[Tabs] WHERE ParentId =  @TabId
			WHILE EXISTS (SELECT TOP 1 TabID FROM @ChildTabs)
				BEGIN
					SET @ChildID = (SELECT TOP 1 TabID FROM @ChildTabs)
					EXEC dbo.[BuildTabLevelAndPath] @ChildID, @IncludeChild
					DELETE FROM @ChildTabs WHERE TabID = @ChildID
				END
		END
	END
GO
/****** Object:  StoredProcedure [dbo].[CalculatePagingInformation]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CalculatePagingInformation]
-- this procedure is deprecated, please use more efficient functions pageLowerBound AND pageUpperBound instead!
-- 2147483647 = Cast(0x7fffffff AS Int)
	@pageIndex 		Int, 	    -- negative to return all rows!
	@pageSize 		Int, 		-- negative OR 0 returns all rows
	@rowsToReturn  	Int output, -- row number of record AFTER last row (0 based) 
	@pageLowerBound Int output, -- row number of first record (0 based)
	@pageUpperBound Int output  -- row number of record AFTER last row (1 based)
AS
BEGIN 
	IF IsNull(@pageSize, 2147483647) < 2147483647 AND IsNull(@PageIndex, -1) >= 0 BEGIN
		SET @pageLowerBound = dbo.pageLowerBound(@pageIndex, @pageSize) - 1
		SET @rowsToReturn   = dbo.pageUpperBound(@pageIndex, @pageSize) 
		SET @pageUpperBound = @rowsToReturn + 1 
	END ELSE BEGIN
		SET @pageLowerBound = 0
		SET @rowsToReturn   = 2147483647 
		SET @pageUpperBound = 2147483647 
	END
END
GO
/****** Object:  StoredProcedure [dbo].[CanDeleteSkin]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CanDeleteSkin]
	@SkinType char(1),
	@SkinFolderName nvarchar(200) 
AS
	BEGIN
		IF exists(SELECT * FROM dbo.Tabs WHERE (SkinSrc like '%![' + @SkinType + '!]' + @SkinFolderName + '%' ESCAPE '!') 
					OR (ContainerSrc like '%![' + @SkinType + '!]' + @SkinFolderName + '%' ESCAPE '!'))
			SELECT 0
		ELSE
			BEGIN
				IF exists(SELECT * FROM dbo.TabModules WHERE ContainerSrc like '%![' + @SkinType + '!]' + @SkinFolderName + '%' ESCAPE '!')
					SELECT 0
				ELSE
					SELECT 1
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[ChangeUsername]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ChangeUsername]
	@UserId         int,
	@NewUsername	nvarchar(256)
AS
BEGIN
	DECLARE @OldUsername NVARCHAR(256)
	SET @OldUsername = (SELECT UserName FROM dbo.Users WHERE UserId = @UserId)

	UPDATE dbo.Users
		SET		Username=@NewUsername
		WHERE	UserId=@UserId

	UPDATE dbo.aspnet_Users
		SET		UserName=@NewUsername,
				LoweredUserName=LOWER(@NewUsername) 
		WHERE	UserName=@OldUsername

END
GO
/****** Object:  StoredProcedure [dbo].[ClearFileContent]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ClearFileContent]

	@FileId      int

AS

UPDATE dbo.Files
	SET    Content = NULL
	WHERE  FileId = @FileId
GO
/****** Object:  StoredProcedure [dbo].[ConvertTabToNeutralLanguage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[ConvertTabToNeutralLanguage]
    @PortalId INT ,
    @TabId INT ,
    @CultureCode NVARCHAR(10)
AS 
    BEGIN
        SET NOCOUNT ON;

        UPDATE  dbo.Tabs
        SET     CultureCode = NULL
        WHERE   PortalID = @PortalId
                AND TabID = @TabID
                AND CultureCode = @CultureCode
    END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_AddNotificationTypeAction]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_AddNotificationTypeAction]
	@NotificationTypeID int,
	@NameResourceKey nvarchar(100),
	@DescriptionResourceKey nvarchar(100),
	@ConfirmResourceKey nvarchar(100),
	@APICall nvarchar(500),
	@CreatedByUserID int
AS
BEGIN
	DECLARE @Order int 
	
	SELECT @Order = MAX([Order])
	FROM dbo.[CoreMessaging_NotificationTypeActions]
	WHERE [NotificationTypeID] = @NotificationTypeID
	
	IF @Order IS NULL
		SET @Order = 1
	ELSE
		SET @Order = @Order + 2
		
	INSERT INTO dbo.[CoreMessaging_NotificationTypeActions] (
		[NotificationTypeID],
		[NameResourceKey],
		[DescriptionResourceKey],
		[ConfirmResourceKey],
		[Order],
		[APICall],
		[CreatedByUserID],
		[CreatedOnDate],
		[LastModifiedByUserID],
		[LastModifiedOnDate]
	) VALUES (
		@NotificationTypeID,
		@NameResourceKey,
		@DescriptionResourceKey,
		@ConfirmResourceKey,
		@Order,
		@APICall,
		@CreatedByUserID,
		GETDATE(),
		@CreatedByUserID,
		GETDATE()
	)
	
	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_AddSubscription]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_AddSubscription]
	@UserId INT ,
	@PortalId INT ,
	@SubscriptionTypeId INT ,
	@ObjectKey NVARCHAR(255) ,
	@Description NVARCHAR(255),
	@ModuleId INT ,
	@TabId INT,
	@ObjectData NVARCHAR(MAX)
AS 
	BEGIN
        DECLARE @SubscriptionId INT = NULL   
        
        SELECT  TOP 1 @SubscriptionId = SubscriptionId
		FROM    dbo.CoreMessaging_Subscriptions
		WHERE   UserId = @UserId
				AND (( @PortalId is null and PortalId is null) or (PortalId = @PortalId))
				AND SubscriptionTypeId = @SubscriptionTypeID
				AND ObjectKey = @ObjectKey
				AND ((@ModuleId is null and ModuleId is null ) or (ModuleId = @ModuleId))	
				AND ((@TabId is null and TabId is null ) or (TabId = @TabId))
		      
        IF (@SubscriptionId IS NULL) 
			BEGIN
				INSERT  INTO dbo.CoreMessaging_Subscriptions
						( UserId ,
							PortalId ,
							SubscriptionTypeId ,
							ObjectKey ,
							Description,
							CreatedOnDate ,
							ModuleId ,
							TabId,
							ObjectData
						)
				VALUES  ( @UserId ,
							@PortalId ,
							@SubscriptionTypeId ,
							@ObjectKey ,
							@Description,
							GETUTCDATE() ,
							@ModuleId ,
							@TabId,
							@ObjectData
						)

				SELECT  SCOPE_IDENTITY() AS [SubscriptionId]
			END
		ELSE 
			BEGIN
				UPDATE  dbo.CoreMessaging_Subscriptions
				SET     UserId = @UserId ,
						PortalId = @PortalId ,
						SubscriptionTypeId = @SubscriptionTypeId ,
						ObjectKey = @ObjectKey ,
						Description = @Description ,
						ModuleId = @ModuleId ,
						TabId = @TabId,
						ObjectData = @ObjectData
				WHERE   SubscriptionId = @SubscriptionId

				SELECT  @SubscriptionId AS [SubscriptionId]
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_AddSubscriptionType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_AddSubscriptionType]
	@SubscriptionName NVARCHAR(50) ,
	@FriendlyName NVARCHAR(50) ,
	@DesktopModuleId INT
AS 
	INSERT  dbo.CoreMessaging_SubscriptionTypes
			( SubscriptionName ,
			  FriendlyName ,
			  DesktopModuleId
			)
	VALUES  ( @SubscriptionName ,
			  @FriendlyName ,
			  @DesktopModuleId 
			)
	SELECT  SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_CheckReplyHasRecipients]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_CheckReplyHasRecipients]
	@ConversationId Int, -- Not Null
	@UserId 		Int  -- Not Null
AS 
BEGIN
	SELECT COUNT(M.UserID)
	FROM       dbo.vw_CoreMessaging_Messages AS M
	INNER JOIN dbo.vw_Users AS U ON M.UserID = U.UserID AND M.PortalID = IsNull(U.PortalID, M.PortalID)
	WHERE (M.MessageID = @ConversationId) 
	  AND (M.UserID   <> @UserId) 
	  AND (U.IsDeleted = 0)
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_ConvertLegacyMessages]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_ConvertLegacyMessages]    
	@PageIndex       int,
	@PageSize        int
AS

-- Set the page bounds
DECLARE @PageLowerBound INT, @PageUpperBound INT;

SET @PageLowerBound =  (@PageIndex * @PageSize) + 1
SET @PageUpperBound =  (@PageIndex * @PageSize) + @PageSize

	DECLARE @MessageID bigint	
	DECLARE @PortalID INT
	DECLARE @FromUserName nvarchar(50)
	DECLARE @FromUserID INT
	DECLARE @ToUserName nvarchar(50)
	DECLARE @ToUserID int
	DECLARE @Status tinyint
	DECLARE @Subject nvarchar(max)
	DECLARE @Body nvarchar(max)
	DECLARE @Date datetime
	DECLARE @EmailSent bit
	DECLARE @EmailSentDate datetime
	DECLARE @EmailSchedulerInstance UNIQUEIDENTIFIER
	DECLARE @RowNumber INT
	
	DECLARE @NewMessageID int	
	DECLARE @Counter int		

	DECLARE MessageList cursor FAST_FORWARD for

	WITH messageItems  AS
	(
		SELECT  [MessageID], [PortalID],[FromUserName],[FromUserID], [ToUserName], [ToUserID], [Status], [Subject], [Body], [Date], [EmailSent], [EmailSentDate], [EmailSchedulerInstance] 
				,ROW_NUMBER() OVER(ORDER BY MessageID ASC) AS RowNumber
		FROM	dbo.[Messaging_Messages]
	)
	
	SELECT * from messageItems where RowNumber BETWEEN @PageLowerBound AND @PageUpperBound
	ORDER BY RowNumber ASC
	OPEN MessageList
	FETCH NEXT FROM MessageList 
		INTO @MessageID, @PortalID, @FromUserName, @FromUserID, @ToUserName, @ToUserID, @Status, @Subject, @Body, @Date, @EmailSent, @EmailSentDate, @EmailSchedulerInstance, @RowNumber 

	WHILE @@FETCH_STATUS = 0
	BEGIN
			--Create SocialMessage Record
            INSERT dbo.[CoreMessaging_Messages](                    
  					[PortalID],
					[To],
					[From],					
					[Subject],
					[Body],
					[ConversationID],
					[ReplyAllAllowed],
					[SenderUserID],
                    [CreatedByUserID],
                    [CreatedOnDate],
                    [LastModifiedByUserID],
                    [LastModifiedOnDate]			        
                    )
            VALUES  (       
					@PortalID,
					@ToUserName,
					@FromUserName,
					@Subject,
					@Body,
					NULL,
					1, --ReplyAllAllowed,
					@FromUserID,
                    @FromUserID , -- CreatedBy - int
					dateadd(second, (-1 * datediff(second, getutcdate(), getdate())), @Date), -- CreatedOn - utc datetime
                    @FromUserID , -- LastModifiedBy - int
                    GETDATE() -- LastModifiedOn - datetime			        
                    )
            -- update conversation id                       
            SELECT  @NewMessageID = SCOPE_IDENTITY()
			UPDATE  dbo.[CoreMessaging_Messages] SET [ConversationID] = @NewMessageID WHERE [MessageID] = @NewMessageID 															
			
			--Create SocialRecipient Record for recipient and sender. 2 records total
			Set @Counter = 0 
			
			--No need to create two records if message sent to self	
			IF @ToUserID = @FromUserID BEGIN Set @Counter = 1 END
					
			WHILE @Counter < 2
			BEGIN
				SET @Counter = @Counter + 1
			
				INSERT dbo.[CoreMessaging_MessageRecipients](
						[MessageID],
						[UserID],
						[Read],
						[Archived],
						[CreatedByUserID],
						[CreatedOnDate],
						[LastModifiedByUserID],
						[LastModifiedOnDate],
						[EmailSent],
						[EmailSentDate],
						[EmailSchedulerInstance]                    
						)
				VALUES  (
						@NewMessageID,
						CASE @Counter
							WHEN 1 THEN @ToUserID 
							ELSE @FromUserID 
						END,												
						CASE @Status
							WHEN 1 THEN 0 --Status 1 means Unread, 2 means Read, 3 means Deleted
							ELSE 1
						END,
						CASE @Status
							WHEN 3 THEN 1 --Status 1 means Unread, 2 means Read, 3 means Deleted
							ELSE 0
						END,
						@FromUserID , -- CreatedBy - int
						@Date , -- CreatedOn - datetime
						@FromUserID , -- LastModifiedBy - int
						@Date, -- LastModifiedOn - datetime
						@EmailSent,
						@EmailSentDate,
						@EmailSchedulerInstance
						)			
			END
		
		--Delete the Legacy record
		DELETE FROM dbo.[Messaging_Messages] WHERE MessageID = @MessageID
		
		FETCH NEXT FROM MessageList 
			INTO @MessageID,@PortalID, @FromUserName, @FromUserID, @ToUserName, @ToUserID, @Status, @Subject, @Body, @Date, @EmailSent, @EmailSentDate, @EmailSchedulerInstance, @RowNumber 
	END
	CLOSE MessageList
	DEALLOCATE MessageList
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_CountArchivedConversations]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_CountArchivedConversations]
	@UserID INT,
	@PortalID INT
AS
BEGIN
	SELECT COUNT(DISTINCT M.ConversationID) AS TotalRecords
	    FROM dbo.[CoreMessaging_Messages] M
	    JOIN dbo.[CoreMessaging_MessageRecipients] MR ON M.MessageID = MR.MessageID
	    WHERE Archived = 1
	        AND NotificationTypeID IS NULL AND PortalID = @PortalID AND UserID = @UserID
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_CountArchivedMessages]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_CountArchivedMessages]
	@UserID int,
	@PortalID int
AS
BEGIN
	SELECT COUNT(DISTINCT M.MessageID) AS TotalRecords
	FROM dbo.[CoreMessaging_Messages] M
	JOIN dbo.[CoreMessaging_MessageRecipients] MR ON M.MessageID = MR.MessageID
	WHERE Archived = 1
	AND NotificationTypeID IS NULL AND PortalID = @PortalID AND UserID = @UserID
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_CountArchivedMessagesByConversation]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_CountArchivedMessagesByConversation]
	@ConversationID int
AS
BEGIN
	SELECT COUNT(*) AS TotalArchivedThreads
	FROM dbo.[CoreMessaging_MessageRecipients]
	WHERE MessageID IN (SELECT MessageID FROM dbo.[CoreMessaging_Messages] WHERE ConversationID = @ConversationID)
	AND [Archived] = 1
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_CountLegacyMessages]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_CountLegacyMessages]    
AS
	--Return total records
	SELECT COUNT(*) AS TotalRecords
	FROM dbo.[Messaging_Messages]
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_CountMessagesByConversation]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_CountMessagesByConversation]
	@ConversationID int
AS
BEGIN
	SELECT COUNT(*) AS TotalRecords
	FROM dbo.CoreMessaging_Messages
	WHERE (ConversationID = @ConversationID)
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_CountNewThreads]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_CountNewThreads]
	@UserID int,
	@PortalID INT
AS
BEGIN
	SELECT COUNT(*) AS TotalNewThreads
	FROM dbo.[CoreMessaging_MessageRecipients] MR
	JOIN dbo.[CoreMessaging_Messages] M ON MR.MessageID = M.MessageID
	WHERE MR.UserID = @UserID
	AND MR.[Read] = 0
	AND M.PortalID=@PortalID
	AND M.NotificationTypeID IS NULL
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_CountNotifications]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_CountNotifications]
	@UserID int,
	@PortalID INT
AS
BEGIN
	-- Return total notifications for user
	SELECT COUNT(*) AS TotalNotifications
	FROM dbo.[CoreMessaging_MessageRecipients] MR
	JOIN dbo.[CoreMessaging_Messages] M ON MR.MessageID = M.MessageID
	WHERE M.NotificationTypeId IS NOT NULL
	AND M.PortalID=@PortalID
	AND MR.UserID = @UserID
	AND (M.ExpirationDate IS NULL OR (M.ExpirationDate IS NOT NULL AND M.ExpirationDate > GETDATE())) -- Do not return expired notifications
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_CountSentConversations]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_CountSentConversations]
	@UserID INT,
	@PortalID INT
AS
BEGIN
	SELECT COUNT(DISTINCT ConversationID) AS TotalRecords
	    FROM dbo.[CoreMessaging_Messages] m
        INNER JOIN dbo.[CoreMessaging_MessageRecipients] mr ON mr.MessageID = m.MessageID AND mr.UserID = m.SenderUserID --make sure sender haven't delete the message.
	    WHERE SenderUserID = @UserID
	        AND NotificationTypeID IS NULL AND PortalID = @PortalID
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_CountSentMessages]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_CountSentMessages]
	@UserID int,
	@PortalID int
AS
BEGIN
	SELECT COUNT(MessageID) AS TotalRecords
	FROM dbo.[CoreMessaging_Messages]
	WHERE SenderUserID = @UserID
	AND NotificationTypeID IS NULL AND PortalID = @PortalID
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_CountTotalConversations]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_CountTotalConversations]
	@UserID int,
	@PortalID int
AS
BEGIN
	SELECT COUNT(DISTINCT M.ConversationID) AS TotalConversations
	FROM dbo.[CoreMessaging_Messages] M
	JOIN dbo.[CoreMessaging_MessageRecipients] MR ON M.MessageID = MR.MessageID
	WHERE NotificationTypeID IS NULL AND PortalID = @PortalID AND Archived = 0 AND UserID = @UserID
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_CreateMessageRecipientsForRole]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_CreateMessageRecipientsForRole]
    @MessageID int,         -- message id
    @RoleIDs nvarchar(max), -- comma separated list of RoleIds
	@CreateUpdateUserID INT -- create / update user id
AS
BEGIN    
    ;WITH CTE_RoleIDs(RowNumber, RowValue)
    AS
    (
	SELECT * FROM dbo.ConvertListToTable(',', @RoleIDs)
    ),
	CTE_DistinctUserIDs(UserID)
    AS
    (
  		SELECT DISTINCT UserID
	    FROM dbo.vw_UserRoles ur
        INNER JOIN CTE_RoleIDs cr ON ur.RoleID = cr.RowValue
    )

    INSERT dbo.CoreMessaging_MessageRecipients(
			[MessageID],
			[UserID],
			[Read],
			[Archived],
            [CreatedByUserID],
            [CreatedOnDate],
            [LastModifiedByUserID],
            [LastModifiedOnDate]
            )
			SELECT
			  @MessageID,
			  UserID,
			  0,
			  0,
              @CreateUpdateUserID , -- CreatedBy - int
              GETDATE(), -- CreatedOn - datetime
              @CreateUpdateUserID , -- LastModifiedBy - int
              GETDATE() -- LastModifiedOn - datetime
           FROM CTE_DistinctUserIDs
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_CreateMessageReply]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_CreateMessageReply]
    @ConversationID    INT,           -- parent message id
	@PortalID			INT,			--portalID of message
    @Body               nvarchar(max), -- message body
    @SenderUserID       INT,           -- create / update user id
    @From               nvarchar(200), -- message from
	@CreateUpdateUserID INT            -- create / update user id
AS
    DECLARE @ReplyAllAllowed BIT
    DECLARE @NewMessageID INT
    DECLARE @OriginalSenderUserID INT
    DECLARE @OriginalTo nvarchar(2000)
    DECLARE @OriginalSubject nvarchar(400)

	--Was Sender a Recipient in the Original Message.
	SELECT @ReplyAllAllowed = [ReplyAllAllowed],
	       @OriginalSenderUserID = [SenderUserID],
		   @OriginalTo = REPLACE(REPLACE([TO] + ',' + [FROM], ',' + @From, ''), @From + ',', ''),
		   @OriginalSubject = [Subject]
	FROM dbo.CoreMessaging_Messages m
	INNER JOIN dbo.CoreMessaging_MessageRecipients mr ON m.MessageID = mr.MessageID
	AND m.MessageID = @ConversationID
	AND mr.UserID = @SenderUserID

	--Reply can only be create if Sender was Recipient of Orginial message
	IF @ReplyAllAllowed IS NULL
	BEGIN
		SELECT -1
		RETURN
	END

	--Create new message
	INSERT dbo.CoreMessaging_Messages(
					[PortalID],
  					[To],
					[From],
					[Subject],
					[Body],
					[ConversationID],
					[ReplyAllAllowed],
					[SenderUserID],
                    [CreatedByUserID],
                    [CreatedOnDate],
                    [LastModifiedByUserID],
                    [LastModifiedOnDate]
                    )
            VALUES  (
					@PortalID,
     			    @OriginalTo,
					@From,
				    @OriginalSubject,
					@Body,
					@ConversationID,
					@ReplyAllAllowed,
					@SenderUserID,
                    @CreateUpdateUserID , -- CreatedBy - int
                    GETUTCDATE() , -- CreatedOn - datetime
                    @CreateUpdateUserID , -- LastModifiedBy - int
                    GETDATE() -- LastModifiedOn - datetime
                    )

	SELECT @NewMessageID = SCOPE_IDENTITY()

	IF (@ReplyAllAllowed = 0) --original message was sent to a Role, reply will be sent to the original sender only
	BEGIN
		INSERT INTO dbo.CoreMessaging_MessageRecipients
		        ( [MessageID],
		          [UserID],
		          [Read],
		          [Archived],
		          CreatedByUserID,
		          CreatedOnDate,
		          LastModifiedByUserID,
		          LastModifiedOnDate
		        )
		VALUES  ( @NewMessageID, -- MessageID - int
		          @OriginalSenderUserID, -- UserID - int
		          0, -- Read - bit
		          0, -- Archived - bit
		          @CreateUpdateUserID , -- CreatedByUserID - int
		          GETDATE() , -- CreatedOnDate - datetime
		          @CreateUpdateUserID , -- LastModifiedByUserID - int
		          GETDATE()  -- LastModifiedOnDate - datetime
		        )
        
        IF @OriginalSenderUserID <> @SenderUserID
        BEGIN
            INSERT INTO dbo.CoreMessaging_MessageRecipients
		            ( [MessageID],
		              [UserID],
		              [Read],
		              [Archived],
		              CreatedByUserID,
		              CreatedOnDate,
		              LastModifiedByUserID,
		              LastModifiedOnDate
		            )
		    VALUES  ( @NewMessageID, -- MessageID - int
		              @SenderUserID, -- UserID - int
		              1, -- Read - bit
		              0, -- Archived - bit
		              @CreateUpdateUserID , -- CreatedByUserID - int
		              GETDATE() , -- CreatedOnDate - datetime
		              @CreateUpdateUserID , -- LastModifiedByUserID - int
		              GETDATE()  -- LastModifiedOnDate - datetime
		            )
        END
	END
	ELSE --Reply should be sent to all the original Recipients
	BEGIN
		INSERT dbo.CoreMessaging_MessageRecipients(
			[MessageID],
			[UserID],
			[Read],
			[Archived],
            [CreatedByUserID],
            [CreatedOnDate],
            [LastModifiedByUserID],
            [LastModifiedOnDate]
            )
			SELECT
			  @NewMessageID,
			  UserID,
			  0,
			  0,
              @CreateUpdateUserID , -- CreatedBy - int
              GETDATE() , -- CreatedOn - datetime
              @CreateUpdateUserID , -- LastModifiedBy - int
              GETDATE() -- LastModifiedOn - datetime
           FROM dbo.CoreMessaging_MessageRecipients
           WHERE MessageID = @ConversationID
	END

	SELECT  @NewMessageID
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_CreateNotificationType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_CreateNotificationType]
	@Name nvarchar(100),
	@Description nvarchar(2000),
	@TTL int,
	@DesktopModuleId int,
	@CreatedUpdatedUserID int,
	@IsTask bit
AS
BEGIN
	INSERT INTO dbo.[CoreMessaging_NotificationTypes] (
		[Name],
		[Description],
		[TTL],
		[DesktopModuleId],
		[CreatedByUserID],
		[CreatedOnDate],
		[LastModifiedByUserID],
		[LastModifiedOnDate],
		[IsTask]
	) VALUES (
		@Name,
		@Description,
		@TTL,
		@DesktopModuleId,
		@CreatedUpdatedUserID,
		GETDATE(),
		@CreatedUpdatedUserID,
		GETDATE(),
		@IsTask
	)
		
	SELECT SCOPE_IDENTITY()	
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_DeleteLegacyMessage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_DeleteLegacyMessage]
    @MessageID int
AS
	DELETE FROM dbo.Messaging_Messages
	WHERE  [MessageID] = @MessageID
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_DeleteMessage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_DeleteMessage]
	@MessageID int
AS
	DELETE FROM dbo.CoreMessaging_Messages
	WHERE  [MessageID] = @MessageID
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_DeleteMessageAttachment]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_DeleteMessageAttachment]
    @MessageAttachmentID int
AS
	DELETE FROM dbo.CoreMessaging_MessageAttachments
	WHERE  [MessageAttachmentID] = @MessageAttachmentID
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_DeleteMessageRecipient]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_DeleteMessageRecipient]
    @RecipientID int
AS
	DELETE FROM dbo.CoreMessaging_MessageRecipients
	WHERE  [RecipientID] = @RecipientID
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_DeleteMessageRecipientByMessageAndUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_DeleteMessageRecipientByMessageAndUser]
    @MessageID int,
    @UserID int
AS
BEGIN
	DELETE
	FROM dbo.[CoreMessaging_MessageRecipients]
	WHERE [MessageID] = @MessageID AND [UserID] = @UserID
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_DeleteNotification]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_DeleteNotification]
	@NotificationID int
AS
BEGIN
	DELETE
	FROM dbo.[CoreMessaging_Messages]
	WHERE [MessageID] = @NotificationID AND [NotificationTypeID] IS NOT NULL
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_DeleteNotificationType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_DeleteNotificationType]
	@NotificationTypeID int
AS
BEGIN
	-- First delete related data
	DELETE
	FROM dbo.[CoreMessaging_Messages]
	WHERE [NotificationTypeID] = @NotificationTypeID
	
	DELETE
	FROM dbo.[CoreMessaging_NotificationTypeActions]
	WHERE [NotificationTypeID] = @NotificationTypeID

	-- Finally delete the Notification type
	DELETE
	FROM dbo.[CoreMessaging_NotificationTypes]
	WHERE [NotificationTypeID] = @NotificationTypeID
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_DeleteNotificationTypeAction]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_DeleteNotificationTypeAction]
	@NotificationTypeActionID int
AS
BEGIN
	DELETE 
	FROM dbo.[CoreMessaging_NotificationTypeActions]
	WHERE [NotificationTypeActionID] = @NotificationTypeActionID
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_DeleteSubscription]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_DeleteSubscription]
	@SubscriptionId int
AS 
BEGIN
	DELETE FROM dbo.[CoreMessaging_Subscriptions] WHERE [SubscriptionId] = @SubscriptionId

	IF @@ROWCOUNT <> 0
		SELECT 0 AS [ResultStatus]
	ELSE
		SELECT -1 AS [ResultStatus]
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_DeleteSubscriptionsByObjectKey]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_DeleteSubscriptionsByObjectKey]
	@PortalId int,
	@ObjectKey NVARCHAR(255)
AS
BEGIN
	DELETE
	FROM dbo.CoreMessaging_Subscriptions
	WHERE PortalId = @PortalId
		AND ObjectKey = @ObjectKey
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_DeleteSubscriptionType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_DeleteSubscriptionType]
	@SubscriptionTypeId int
AS
BEGIN
	DELETE FROM dbo.[CoreMessaging_SubscriptionTypes] WHERE [SubscriptionTypeId] = @SubscriptionTypeId

	IF @@ROWCOUNT <> 0
		SELECT 0 AS [ResultStatus]
	ELSE
		SELECT -1 AS [ResultStatus]
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_DeleteUserFromConversation]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_DeleteUserFromConversation]
	@ConversationID INT,
    @UserID INT
AS
    --Remove the User from recipients list
	DELETE FROM dbo.[CoreMessaging_MessageRecipients]
		WHERE [UserID] = @UserID
		AND MessageID IN (SELECT MessageID FROM dbo.[CoreMessaging_Messages] WHERE ConversationID = @ConversationID)
    
    --Remove Messages which has no recipient
    DELETE FROM dbo.[CoreMessaging_Messages]
        FROM dbo.[CoreMessaging_Messages] m
        LEFT JOIN dbo.[CoreMessaging_MessageRecipients] mr on MR.MessageID = m.MessageID
        WHERE ConversationID = @ConversationID AND mr.MessageID IS NULL
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_DeleteUserNotifications]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_DeleteUserNotifications]
	@UserId int,
	@PortalId int
AS
BEGIN
	DELETE FROM dbo.CoreMessaging_Messages
	WHERE PortalId = @PortalId
	  AND MessageID IN (SELECT MessageID FROM dbo.CoreMessaging_MessageRecipients WHERE UserID = @UserId)

	SELECT @@ROWCOUNT
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetArchiveBox]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetArchiveBox]
	@UserID INT,
	@PortalID INT,
	@AfterMessageID INT,
	@NumberOfRecords INT,
	@SortField NVARCHAR(25) = 'CreatedOnDate',
	@SortAscending BIT = 0
AS
BEGIN
	;WITH RollUpMessageIDs AS
	(
		SELECT MAX(m.MessageID) AS TopMessageID
		FROM dbo.[CoreMessaging_MessageRecipients] mr
		INNER JOIN dbo.[CoreMessaging_Messages] m ON mr.MessageID = m.MessageID
		WHERE NotificationTypeID IS NULL AND PortalID = @PortalID AND MR.UserID = @UserID AND MR.Archived = 1
		GROUP BY ConversationID
	), ArchiveBox AS
	(
		SELECT DISTINCT m.[MessageID], [ConversationID], [Subject], convert(nvarchar(50), [Body]) AS Body,
				[To], [From], [ReplyAllAllowed], [SenderUserID],
				m.[CreatedByUserID], m.[CreatedOnDate],
				m.[LastModifiedByUserID], m.[LastModifiedOnDate],
				(SELECT COUNT(*) FROM dbo.[CoreMessaging_MessageAttachments] WHERE MessageID = m.MessageID) AS AttachmentCount,
				(SELECT COUNT(*) FROM dbo.[CoreMessaging_MessageRecipients] WHERE MessageID IN (SELECT MessageID FROM dbo.[CoreMessaging_Messages] WHERE ConversationID = m.ConversationID) AND UserID = @UserID AND [READ] = 0) AS NewThreadCount,
				(SELECT COUNT(*) FROM dbo.[CoreMessaging_MessageRecipients] WHERE MessageID IN (SELECT MessageID FROM dbo.[CoreMessaging_Messages] WHERE ConversationID = m.ConversationID) AND UserID = @UserID) AS ThreadCount,
				ROW_NUMBER() OVER(ORDER BY
					 CASE WHEN @SortField = 'CreatedOnDate' AND @SortAscending = 1 THEN m.[CreatedOnDate] END ASC,
					 CASE WHEN @SortField = 'CreatedOnDate' AND @SortAscending = 0 THEN m.[CreatedOnDate] END DESC,
					 CASE WHEN @SortField = 'From' AND @SortAscending = 1 THEN [From] END ASC,
					 CASE WHEN @SortField = 'From' AND @SortAscending = 0 THEN [From] END DESC,
					 CASE WHEN @SortField = 'Subject' AND @SortAscending = 1 THEN [Subject] END ASC,
					 CASE WHEN @SortField = 'Subject' AND @SortAscending = 0 THEN [Subject] END DESC
					) AS RowNumber
		FROM dbo.[CoreMessaging_Messages] AS m
		WHERE m.MessageID IN (SELECT TopMessageID FROM RollUpMessageIDs)
	)
	SELECT * FROM ArchiveBox
	WHERE (@AfterMessageID > 0 AND RowNumber BETWEEN (SELECT RowNumber + 1 FROM ArchiveBox WHERE [MessageID] = @AfterMessageID) AND (SELECT RowNumber + @NumberOfRecords FROM ArchiveBox WHERE [MessageID] = @AfterMessageID)) OR
	(@AfterMessageID = -1 AND RowNumber BETWEEN 1 AND @NumberOfRecords)
	ORDER BY RowNumber ASC
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetLastSentMessage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetLastSentMessage]
	@UserID int,
	@PortalID INT
AS
BEGIN
	SELECT TOP 1 *	
	FROM dbo.[CoreMessaging_Messages]
	WHERE SenderUserID = @UserID	
	AND PortalID=@PortalID
	AND NotificationTypeID IS NULL
	ORDER BY MessageID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetMessage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetMessage]
    @MessageID INT
AS 
	SELECT [MessageID], [PortalId], [NotificationTypeID], [To], [From], [Subject], [Body], [ConversationID], [ReplyAllAllowed], [SenderUserID], [CreatedByUserID], [CreatedOnDate], [LastModifiedByUserID], [LastModifiedOnDate] 
	FROM   dbo.[CoreMessaging_Messages] 
	WHERE  [MessageID] = @MessageID
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetMessageAttachment]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetMessageAttachment]
    @MessageAttachmentID INT
AS
	SELECT [MessageID], [FileID], [CreatedByUserID], [CreatedOnDate], [LastModifiedByUserID], [LastModifiedOnDate]
	FROM   dbo.CoreMessaging_MessageAttachments
	WHERE  [MessageAttachmentID] = @MessageAttachmentID
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetMessageAttachmentsByMessage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetMessageAttachmentsByMessage]
    @MessageID INT
AS
	SELECT [MessageID], [FileID], [CreatedByUserID], [CreatedOnDate], [LastModifiedByUserID], [LastModifiedOnDate]
	FROM   dbo.CoreMessaging_MessageAttachments
	WHERE  [MessageID] = @MessageID
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetMessageConversations]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetMessageConversations]
	@UserID int,
	@PortalID int,
	@AfterMessageID int,
	@NumberOfRecords int,
	@SortField nvarchar(25) = 'CreatedOnDate',
	@SortAscending bit = 0,
	@Read bit = 0,
	@Archived bit = 0,
	@SentOnly bit = 0
AS
BEGIN
	--Get the top message for each conversation
	;WITH RollUpMessageIDs AS
	(
		SELECT MAX(m.MessageID) AS TopMessageID
		FROM dbo.[CoreMessaging_MessageRecipients] mr
		INNER JOIN dbo.[CoreMessaging_Messages] m ON mr.MessageID = m.MessageID
		WHERE ((Archived = @Archived) or (@Archived is null AND [Archived] IS NOT null))
		AND (([Read] = @Read) or (@Read is null AND [READ] IS NOT null))
		AND ((@SentOnly = 1 AND SenderUserID = @UserID) or (@SentOnly is NULL AND UserID = @UserID) or (@SentOnly = 0 AND UserID = @UserID))
		AND m.NotificationTypeID IS NULL AND m.PortalID=@PortalID
		GROUP BY ConversationID
	)
	,Conversations  AS
	(
		SELECT  DISTINCT [MessageID], [ConversationID], [Subject], convert(nvarchar(50), [Body]) AS Body,
				[To], [From], [ReplyAllAllowed], [SenderUserID],
				[CreatedByUserID], [CreatedOnDate],
				[LastModifiedByUserID], [LastModifiedOnDate],
				(SELECT COUNT(*) FROM dbo.CoreMessaging_MessageAttachments WHERE MessageID IN (SELECT MessageID FROM dbo.CoreMessaging_Messages WHERE ConversationID = m.ConversationID)) AS AttachmentCount,
				(SELECT COUNT(*) FROM dbo.CoreMessaging_MessageRecipients WHERE MessageID IN (SELECT MessageID FROM dbo.CoreMessaging_Messages WHERE ConversationID = m.ConversationID) AND UserID = @UserID AND [READ] = 0) AS NewThreadCount,
				(SELECT COUNT(*) FROM dbo.CoreMessaging_MessageRecipients WHERE MessageID IN (SELECT MessageID FROM dbo.CoreMessaging_Messages WHERE ConversationID = m.ConversationID) AND UserID = @UserID) AS ThreadCount,
				ROW_NUMBER() OVER(ORDER BY
					 CASE WHEN @SortField = 'CreatedOnDate' AND @SortAscending = 1 THEN [CreatedOnDate] END ASC,
					 CASE WHEN @SortField = 'CreatedOnDate' AND @SortAscending = 0 THEN [CreatedOnDate] END DESC,
					 CASE WHEN @SortField = 'From' AND @SortAscending = 1 THEN [From] END ASC,
					 CASE WHEN @SortField = 'From' AND @SortAscending = 0 THEN [From] END DESC,
					 CASE WHEN @SortField = 'Subject' AND @SortAscending = 1 THEN [Subject] END ASC,
					 CASE WHEN @SortField = 'Subject' AND @SortAscending = 0 THEN [Subject] END DESC
					) AS RowNumber
		FROM dbo.CoreMessaging_Messages AS m
		WHERE MessageID IN (SELECT TopMessageID FROM RollUpMessageIDs)
	)
	SELECT * FROM Conversations
	WHERE (@AfterMessageID > 0 AND RowNumber BETWEEN (SELECT RowNumber + 1 FROM Conversations WHERE [MessageID] = @AfterMessageID) AND (SELECT RowNumber + @NumberOfRecords FROM Conversations WHERE [MessageID] = @AfterMessageID)) OR
	(@AfterMessageID = -1 AND RowNumber BETWEEN 1 AND @NumberOfRecords)
	ORDER BY RowNumber ASC
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetMessageRecipient]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetMessageRecipient]
    @RecipientID INT
AS
	SELECT [RecipientID], [MessageID], [UserID], [Read], [Archived], [CreatedByUserID], [CreatedOnDate], [LastModifiedByUserID], [LastModifiedOnDate]
	FROM   dbo.CoreMessaging_MessageRecipients
	WHERE  [RecipientID] = @RecipientID
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetMessageRecipientsByMessage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetMessageRecipientsByMessage]
    @MessageID INT
AS
	SELECT [RecipientID], [MessageID], [UserID], [Read], [Archived], [CreatedByUserID], [CreatedOnDate], [LastModifiedByUserID], [LastModifiedOnDate]
	FROM   dbo.CoreMessaging_MessageRecipients
	WHERE  [MessageID] = @MessageID
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetMessageRecipientsByMessageAndUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetMessageRecipientsByMessageAndUser]
    @MessageID INT,
    @UserID INT
AS
	SELECT [RecipientID], [MessageID], [UserID], [Read], [Archived], [CreatedByUserID], [CreatedOnDate], [LastModifiedByUserID], [LastModifiedOnDate]
	FROM   dbo.CoreMessaging_MessageRecipients
	WHERE  [MessageID] = @MessageID
	AND   [UserID] = @UserID
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetMessageRecipientsByUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetMessageRecipientsByUser]
    @UserID INT
AS
	SELECT [RecipientID], [MessageID], [UserID], [Read], [Archived], [CreatedByUserID], [CreatedOnDate], [LastModifiedByUserID], [LastModifiedOnDate]
	FROM   dbo.CoreMessaging_MessageRecipients
	WHERE  [UserID] = @UserID
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetMessagesBySender]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetMessagesBySender]
    @SenderUserID INT,
	@PortalID INT
AS
BEGIN
	SELECT [MessageID], [To], [From], [Subject], [Body], [ConversationID], [ReplyAllAllowed], [SenderUserID], [CreatedByUserID], [CreatedOnDate], [LastModifiedByUserID], [LastModifiedOnDate] 
	FROM   dbo.[CoreMessaging_Messages] 
	WHERE  [SenderUserID] = @SenderUserID AND [PortalID] = @PortalID
	AND [NotificationTypeID] IS NULL
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetMessageThread]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetMessageThread]
    @ConversationID int,
	@UserID int,
	@AfterMessageID int,
	@NumberOfRecords int,
	@SortField nvarchar(25) = 'CreatedOnDate',
	@SortAscending bit = 0
AS
BEGIN
	--Cannot return thread if user was not a recipient
	IF NOT EXISTS (SELECT MR.RecipientID FROM dbo.[CoreMessaging_MessageRecipients] MR JOIN dbo.[CoreMessaging_Messages] M ON MR.MessageID = M.MessageID WHERE MR.UserID = @UserID AND M.NotificationTypeID IS NULL) BEGIN
		SELECT 0
		RETURN
	END

	;WITH inboxItems  AS
	(
		SELECT  DISTINCT [RecipientID], [Subject], [Body], [SenderUserID],
				[Read], [Archived], [UserID], [To], [From], [ReplyAllAllowed], [ConversationID],
				m.[MessageID],
				m.[CreatedByUserID], m.[CreatedOnDate],
				m.[LastModifiedByUserID], m.[LastModifiedOnDate],
				(SELECT COUNT(*) FROM dbo.CoreMessaging_MessageAttachments WHERE MessageID = mr.MessageID) AS AttachmentCount,
				(SELECT COUNT(*) FROM dbo.CoreMessaging_MessageRecipients WHERE MessageID IN (SELECT MessageID FROM dbo.CoreMessaging_Messages WHERE ConversationID = m.ConversationID) AND UserID = @UserID AND [READ] = 0) AS NewThreadCount,
				(SELECT COUNT(*) FROM dbo.CoreMessaging_MessageRecipients WHERE MessageID IN (SELECT MessageID FROM dbo.CoreMessaging_Messages WHERE ConversationID = m.ConversationID) AND UserID = @UserID) AS ThreadCount,
				ROW_NUMBER() OVER(ORDER BY
					 CASE WHEN @SortField = 'CreatedOnDate' AND @SortAscending = 1 THEN m.[CreatedOnDate] END ASC,
					 CASE WHEN @SortField = 'CreatedOnDate' AND @SortAscending = 0 THEN m.[CreatedOnDate] END DESC,
					 CASE WHEN @SortField = 'From' AND @SortAscending = 1 THEN [From] END ASC,
					 CASE WHEN @SortField = 'From' AND @SortAscending = 0 THEN [From] END DESC,
					 CASE WHEN @SortField = 'Subject' AND @SortAscending = 1 THEN [Subject] END ASC,
					 CASE WHEN @SortField = 'Subject' AND @SortAscending = 0 THEN [Subject] END DESC
					) AS RowNumber
		FROM	dbo.CoreMessaging_MessageRecipients AS mr
		INNER JOIN dbo.CoreMessaging_Messages AS m ON mr.MessageID = m.MessageID
		WHERE mr.UserID = @UserID
		AND ConversationID = @ConversationID
	)
	SELECT * FROM inboxItems
	WHERE (@AfterMessageID > 0 AND RowNumber BETWEEN (SELECT RowNumber + 1 FROM inboxItems WHERE [MessageID] = @AfterMessageID) AND (SELECT RowNumber + @NumberOfRecords FROM inboxItems WHERE [MessageID] = @AfterMessageID)) OR
	(@AfterMessageID = -1 AND RowNumber BETWEEN 1 AND @NumberOfRecords)
	ORDER BY RowNumber ASC
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetNextMessagesForDigestDispatch]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetNextMessagesForDigestDispatch]
	@Frequency INT ,
	@SchedulerInstance UNIQUEIDENTIFIER ,
	@BatchSize INT
AS 
	BEGIN
		UPDATE  dbo.[CoreMessaging_MessageRecipients]
		SET     EmailSchedulerInstance = @SchedulerInstance
		WHERE   RecipientID IN (
				SELECT 
						RecipientID
				FROM    dbo.[vw_MessagesForDispatch] MFD
				WHERE UserID IN (
							SELECT TOP ( @BatchSize  )
									UserID
							FROM    dbo.[vw_MessagesForDispatch] MFD
							WHERE   EmailSent = 0
									AND [Read] = 0
									AND Archived = 0
									AND EmailFrequency = @Frequency
									AND ( ( EmailSchedulerInstance IS NULL
											AND EmailSentDate IS NULL
										  )
										  OR EmailSchedulerInstance = '00000000-0000-0000-0000-000000000000'
										)        
							GROUP BY UserID
							ORDER BY UserID      
						)  
						AND EmailSent = 0
						AND [Read] = 0
						AND Archived = 0
						AND EmailFrequency = @Frequency
						AND ( ( EmailSchedulerInstance IS NULL
								AND EmailSentDate IS NULL
							  )
							  OR EmailSchedulerInstance = '00000000-0000-0000-0000-000000000000'
							))

		SELECT  *
		FROM    dbo.[CoreMessaging_MessageRecipients] CMR
				INNER JOIN dbo.[CoreMessaging_Messages] CMM ON CMR.MessageID = CMM.MessageID
		WHERE   EmailSent = 0
				AND EmailSentDate IS NULL
				AND [Read] = 0
				AND Archived = 0
				AND ( EmailSchedulerInstance = @SchedulerInstance )
		ORDER BY UserID ,
				CMM.CreatedOnDate DESC                      
	END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetNextMessagesForInstantDispatch]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetNextMessagesForInstantDispatch]
	@SchedulerInstance UNIQUEIDENTIFIER ,
	@BatchSize INT
AS 
	BEGIN
		UPDATE  dbo.[CoreMessaging_MessageRecipients]
		SET     EmailSchedulerInstance = @SchedulerInstance
		WHERE   RecipientID IN (
				SELECT TOP ( @BatchSize )
						RecipientID 
				FROM    dbo.[vw_MessagesForDispatch] MFD
				WHERE   EmailSent = 0
						AND [Read] = 0
						AND Archived = 0
						AND EmailFrequency = 0
						AND ( ( EmailSchedulerInstance IS NULL
								AND EmailSentDate IS NULL
							  )
							  OR EmailSchedulerInstance = '00000000-0000-0000-0000-000000000000'
							)
				ORDER BY MFD.CreatedOnDate DESC ,
						UserID )

		SELECT  *
		FROM    dbo.[CoreMessaging_MessageRecipients] CMR
				INNER JOIN dbo.[CoreMessaging_Messages] CMM ON CMR.MessageID = CMM.MessageID
		WHERE   EmailSent = 0
				AND EmailSentDate IS NULL
				AND [Read] = 0
				AND Archived = 0
				AND ( EmailSchedulerInstance = @SchedulerInstance )
		ORDER BY UserID ,
				CMM.CreatedOnDate DESC	
	END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetNotification]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetNotification]
	@NotificationId int
AS
BEGIN
	SELECT
		M.[MessageID],
		M.[NotificationTypeId],
		M.[To],
		M.[From],
		M.[Subject],
		M.[Body],
		M.[SenderUserID],
		M.[ExpirationDate],
        M.[IncludeDismissAction],
		M.[CreatedByUserID],
		M.[CreatedOnDate],
		M.[LastModifiedByUserID],
		M.[LastModifiedOnDate],
        M.[Context]
	FROM dbo.[CoreMessaging_Messages] AS M
	WHERE [NotificationTypeId] IS NOT NULL
	AND M.MessageID = @NotificationId
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetNotificationByContext]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetNotificationByContext]
	@notificationTypeId int,
	@Context nvarchar(200)
AS
BEGIN
	SELECT
		M.[MessageID],
		M.[NotificationTypeId],
		M.[To],
		M.[From],
		M.[Subject],
		M.[Body],
		M.[SenderUserID],
		M.[ExpirationDate],
        M.[IncludeDismissAction],
		M.[CreatedByUserID],
		M.[CreatedOnDate],
		M.[LastModifiedByUserID],
		M.[LastModifiedOnDate],
        M.[Context]
	FROM dbo.[CoreMessaging_Messages] AS M
	WHERE [NotificationTypeId] IS NOT NULL
	AND M.NotificationTypeId = @notificationTypeId
	AND M.Context = @context
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetNotifications]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetNotifications]
	@UserID int,
	@PortalID int,
	@AfterNotificationID int,
	@NumberOfRecords int
AS
BEGIN
	--Get the top message for each conversation
	;WITH Notifications AS
	(
		SELECT
			M.[MessageID],
			M.[NotificationTypeId],
			M.[To],
			M.[From],
			M.[Subject],
			M.[Body],
			M.[SenderUserID],
			M.[ExpirationDate],
            M.[IncludeDismissAction],
			M.[CreatedByUserID],
			M.[CreatedOnDate],
			M.[LastModifiedByUserID],
			M.[LastModifiedOnDate],
            M.[Context],
			ROW_NUMBER() OVER(ORDER BY M.[CreatedOnDate] DESC) AS RowNumber
		FROM dbo.[CoreMessaging_Messages] AS M
		JOIN dbo.[CoreMessaging_MessageRecipients] MR ON M.MessageID = MR.MessageID
		WHERE [NotificationTypeId] IS NOT NULL
		AND MR.UserID = @UserID
		AND M.PortalID = @PortalID
		AND (M.[ExpirationDate] IS NULL OR (M.[ExpirationDate] IS NOT NULL AND M.[ExpirationDate] > GETUTCDATE()))
	)	
	SELECT * FROM Notifications
	WHERE (@AfterNotificationID > 0 AND RowNumber BETWEEN (SELECT RowNumber + 1 FROM Notifications WHERE [MessageID] = @AfterNotificationID) AND (SELECT RowNumber + @NumberOfRecords FROM Notifications WHERE [MessageID] = @AfterNotificationID)) OR
	(@AfterNotificationID = -1 AND RowNumber BETWEEN 1 AND @NumberOfRecords)
	ORDER BY RowNumber ASC
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetNotificationType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetNotificationType]
	@NotificationTypeID int
AS
BEGIN
	SELECT [NotificationTypeID], [Name], [Description], [TTL], [DesktopModuleId], [CreatedByUserID], [CreatedOnDate], [LastModifiedByUserID], [LastModifiedOnDate], [IsTask]
	FROM dbo.[CoreMessaging_NotificationTypes]
	WHERE [NotificationTypeID] = @NotificationTypeID
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetNotificationTypeAction]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetNotificationTypeAction]
	@NotificationTypeActionID int
AS
BEGIN
	SELECT [NotificationTypeActionID], [NotificationTypeID], [NameResourceKey], [DescriptionResourceKey], [ConfirmResourceKey], [Order], [APICall], [CreatedByUserID], [CreatedOnDate], [LastModifiedByUserID], [LastModifiedOnDate]
	FROM dbo.[CoreMessaging_NotificationTypeActions]
	WHERE [NotificationTypeActionID] = @NotificationTypeActionID
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetNotificationTypeActionByName]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetNotificationTypeActionByName]
	@NotificationTypeID int,
	@NameResourceKey nvarchar(100)
AS
BEGIN
	SELECT [NotificationTypeActionID], [NotificationTypeID], [NameResourceKey], [DescriptionResourceKey], [ConfirmResourceKey], [Order], [APICall], [CreatedByUserID], [CreatedOnDate], [LastModifiedByUserID], [LastModifiedOnDate]
	FROM dbo.[CoreMessaging_NotificationTypeActions]
	WHERE [NotificationTypeID] = @NotificationTypeID AND [NameResourceKey] LIKE @NameResourceKey
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetNotificationTypeActions]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetNotificationTypeActions]
	@NotificationTypeID int
AS
BEGIN
	SELECT [NotificationTypeActionID], [NotificationTypeID], [NameResourceKey], [DescriptionResourceKey], [ConfirmResourceKey], [Order], [APICall], [CreatedByUserID], [CreatedOnDate], [LastModifiedByUserID], [LastModifiedOnDate]
	FROM dbo.[CoreMessaging_NotificationTypeActions]
	WHERE [NotificationTypeID] = @NotificationTypeID
	ORDER BY [Order]
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetNotificationTypeByName]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetNotificationTypeByName]
	@Name nvarchar(100)
AS
BEGIN
	SELECT [NotificationTypeID], [Name], [Description], [TTL], [DesktopModuleId], [CreatedByUserID], [CreatedOnDate], [LastModifiedByUserID], [LastModifiedOnDate], [IsTask]
	FROM dbo.[CoreMessaging_NotificationTypes]
	WHERE [Name] LIKE @Name
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetSentBox]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetSentBox]
	@UserID INT,
	@PortalID INT,
	@AfterMessageId INT,
	@NumberOfRecords INT,
	@SortField NVARCHAR(25) = 'CreatedOnDate',
	@SortAscending BIT = 0
AS
BEGIN
	;WITH RollUpMessageIDs AS
	(
		SELECT MAX(m.MessageID) AS TopMessageID
		FROM dbo.[CoreMessaging_MessageRecipients] mr
		INNER JOIN dbo.[CoreMessaging_Messages] m ON mr.MessageID = m.MessageID AND mr.UserID = m.SenderUserID --make sure sender haven't delete the message.
		WHERE SenderUserID = @UserID AND NotificationTypeID IS NULL AND PortalID = @PortalID
		GROUP BY ConversationID
	), SentBox AS
	(
		SELECT DISTINCT m.[MessageID], [ConversationID], [Subject], CONVERT(NVARCHAR(50), [Body]) AS Body,
				[To], [From], [ReplyAllAllowed], [SenderUserID],
				m.[CreatedByUserID], m.[CreatedOnDate],
				m.[LastModifiedByUserID], m.[LastModifiedOnDate],
				(SELECT COUNT(*) FROM dbo.CoreMessaging_MessageAttachments WHERE MessageID = m.MessageID) AS AttachmentCount,
				(SELECT COUNT(*) FROM dbo.CoreMessaging_MessageRecipients WHERE MessageID IN (SELECT MessageID FROM dbo.CoreMessaging_Messages WHERE ConversationID = m.ConversationID) AND UserID = @UserID AND [READ] = 0) AS NewThreadCount,
				(SELECT COUNT(*) FROM dbo.CoreMessaging_MessageRecipients WHERE MessageID IN (SELECT MessageID FROM dbo.CoreMessaging_Messages WHERE ConversationID = m.ConversationID) AND UserID = @UserID) AS ThreadCount,
				ROW_NUMBER() OVER(ORDER BY
					 CASE WHEN @SortField = 'CreatedOnDate' AND @SortAscending = 1 THEN m.[CreatedOnDate] END ASC,
					 CASE WHEN @SortField = 'CreatedOnDate' AND @SortAscending = 0 THEN m.[CreatedOnDate] END DESC,
					 CASE WHEN @SortField = 'From' AND @SortAscending = 1 THEN [From] END ASC,
					 CASE WHEN @SortField = 'From' AND @SortAscending = 0 THEN [From] END DESC,
					 CASE WHEN @SortField = 'Subject' AND @SortAscending = 1 THEN [Subject] END ASC,
					 CASE WHEN @SortField = 'Subject' AND @SortAscending = 0 THEN [Subject] END DESC
					) AS RowNumber
		FROM dbo.CoreMessaging_Messages AS m
		WHERE m.MessageID IN (SELECT TopMessageID FROM RollUpMessageIDs)
	)
	SELECT * FROM SentBox
	WHERE (@AfterMessageID > 0 AND RowNumber BETWEEN (SELECT RowNumber + 1 FROM SentBox WHERE [MessageID] = @AfterMessageID) AND (SELECT RowNumber + @NumberOfRecords FROM SentBox WHERE [MessageID] = @AfterMessageID)) OR
	(@AfterMessageID = -1 AND RowNumber BETWEEN 1 AND @NumberOfRecords)
	ORDER BY RowNumber ASC
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetSubscriptionsByContent]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetSubscriptionsByContent]
	@PortalId int,
	@SubscriptionTypeID int,
	@ObjectKey NVARCHAR(255)
AS
BEGIN
	SELECT *
	FROM dbo.[CoreMessaging_Subscriptions]
	WHERE 
		(( @PortalId is null and PortalId is null) or (PortalId = @PortalId))
		AND SubscriptionTypeID = @SubscriptionTypeID
		AND ObjectKey = @ObjectKey
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetSubscriptionsByUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetSubscriptionsByUser]
	@PortalId int,
	@UserId int,
	@SubscriptionTypeID int
AS
BEGIN
	SELECT *
	FROM dbo.[CoreMessaging_Subscriptions]
	WHERE 
			(( @PortalId is null and PortalId is null) or (PortalId = @PortalId))
			AND UserId = @UserId
			AND (@SubscriptionTypeID IS NULL OR SubscriptionTypeID = @SubscriptionTypeID)
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetSubscriptionTypes]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetSubscriptionTypes]
AS 
	SELECT  *
	FROM    dbo.CoreMessaging_SubscriptionTypes
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetToasts]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetToasts]	
    @UserId int,
    @PortalId int
AS
BEGIN	
    SELECT DISTINCT m.*
    FROM dbo.CoreMessaging_MessageRecipients mr 
        INNER JOIN dbo.CoreMessaging_Messages m
    ON mr.MessageID = m.MessageID	
    WHERE mr.UserID = @UserID
    AND   m.PortalID = @PortalID
    AND   mr.SendToast = 1
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_GetUserPreference]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_GetUserPreference]
	@PortalId INT ,	
	@UserId INT
AS 
BEGIN
	SELECT PortalId, UserId, MessagesEmailFrequency, NotificationsEmailFrequency
	FROM dbo.CoreMessaging_UserPreferences UP
	WHERE	UP.PortalId = @PortalId
		AND
			UP.UserId = @UserId	
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_IsSubscribed]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_IsSubscribed]
	@PortalId INT ,
	@UserId INT ,
	@SubscriptionTypeId INT ,
	@ObjectKey NVARCHAR(255) ,
	@ModuleId INT ,
	@TabId INT
AS 
	BEGIN
		SELECT  TOP 1 *
		FROM    dbo.CoreMessaging_Subscriptions
		WHERE   UserId = @UserId
				AND (( @PortalId is null and PortalId is null) or (PortalId = @PortalId))
				AND SubscriptionTypeId = @SubscriptionTypeID
				AND ObjectKey = @ObjectKey
				AND ((@ModuleId is null and ModuleId is null ) or (ModuleId = @ModuleId))	
				AND ((@TabId is null and TabId is null ) or (TabId = @TabId))
	END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_IsToastPending]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_IsToastPending]	
    @NotificationId int
AS
BEGIN
    SELECT Sendtoast 
    FROM dbo.[CoreMessaging_MessageRecipients]
    WHERE MessageId = @NotificationId
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_MarkMessageAsDispatched]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_MarkMessageAsDispatched]
	@MessageId int,
	@RecipientId int
AS
BEGIN
	Update dbo.CoreMessaging_MessageRecipients set EmailSent = 1, EmailSentDate =GETDATE()   where MessageID =@MessageId AND RecipientId=@RecipientId
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_MarkMessageAsSent]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_MarkMessageAsSent]
	@MessageId int,
	@RecipientId int
AS
BEGIN
	Update dbo.CoreMessaging_MessageRecipients set EmailSent = 1  where MessageID =@MessageId AND RecipientId=@RecipientId
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_MarkReadyForToast]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_MarkReadyForToast]	
    @MessageId int,
    @UserId int
AS
BEGIN	
    UPDATE dbo.[CoreMessaging_MessageRecipients]
    SET Sendtoast = 1,
    [LastModifiedOnDate] = GETDATE()
    WHERE MessageId = @MessageId
    AND UserId = @UserId
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_MarkToastSent]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_MarkToastSent]	
    @MessageId int,
	@UserId INT
AS
BEGIN	
    UPDATE dbo.CoreMessaging_MessageRecipients
    SET Sendtoast = 0,
    [LastModifiedOnDate] = GETDATE()
    WHERE MessageId = @MessageId
	AND UserId = @UserId
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_SaveMessage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_SaveMessage]
    @MessageID INT,
	@PortalID INT,
	@To nvarchar(2000),
	@From nvarchar(200),
    @Subject nvarchar(400),
    @Body nvarchar(max),
    @ConversationID int,
    @ReplyAllAllowed bit,
    @SenderUserID int,
	@CreateUpdateUserID INT
    
AS 
    IF ( @MessageID = -1 ) 
        BEGIN
            INSERT dbo.CoreMessaging_Messages(                    
  					[PortalID],
					[To],
					[From],					
					[Subject],
					[Body],
					[ConversationID],
					[ReplyAllAllowed],
					[SenderUserID],
                    [CreatedByUserID],
                    [CreatedOnDate],
                    [LastModifiedByUserID],
                    [LastModifiedOnDate]			        
                    )
            VALUES  (       
     			    @PortalID,
					@To,
					@From,
				    @Subject,			
					@Body,
					NULL,
					@ReplyAllAllowed,
					@SenderUserID,
                    @CreateUpdateUserID , -- CreatedBy - int
                    GETUTCDATE(), -- CreatedOn - datetime
                    @CreateUpdateUserID , -- LastModifiedBy - int
                    GETDATE() -- LastModifiedOn - datetime			        
                    )
                    
            SELECT  @MessageID = SCOPE_IDENTITY()
			UPDATE  dbo.CoreMessaging_Messages SET [ConversationID] = @MessageID WHERE [MessageID] = @MessageID 
        END
    ELSE 
        BEGIN
            UPDATE  dbo.CoreMessaging_Messages
            SET     [To] = @To,
					[From] = @From,
					[Subject] = @Subject,			
					[Body] = @Body,
					[ConversationID] = @ConversationID,
					[ReplyAllAllowed] = @ReplyAllAllowed,
					[SenderUserID] = SenderUserID,
                    LastModifiedByUserID = @CreateUpdateUserID,
                    LastModifiedOnDate = GETDATE()
            WHERE   MessageID = @MessageID
        END
        
    SELECT  @MessageID
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_SaveMessageAttachment]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_SaveMessageAttachment]
    @MessageAttachmentID int,
    @MessageID int,
    @FileID int,
	@CreateUpdateUserID INT
AS
    IF ( @MessageAttachmentID = -1 )
        BEGIN
            INSERT dbo.CoreMessaging_MessageAttachments(
					[FileID],
					[MessageID],
                    [CreatedByUserID],
                    [CreatedOnDate],
                    [LastModifiedByUserID],
                    [LastModifiedOnDate]
                    )
            VALUES  (
					@FileID,
					@MessageID,
                    @CreateUpdateUserID , -- CreatedBy - int
                    GETDATE() , -- CreatedOn - datetime
                    @CreateUpdateUserID , -- LastModifiedBy - int
                    GETDATE() -- LastModifiedOn - datetime
                    )

            SELECT  @MessageAttachmentID = SCOPE_IDENTITY()
        END
    ELSE
        BEGIN
            UPDATE  dbo.CoreMessaging_MessageAttachments
            SET     [FileID] = @FileID,
					[MessageID] = @MessageID,
                    LastModifiedByUserID = @CreateUpdateUserID,
                    LastModifiedOnDate = GETDATE()
            WHERE   MessageAttachmentID = @MessageAttachmentID
        END

    SELECT  @MessageAttachmentID
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_SaveMessageRecipient]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_SaveMessageRecipient]
    @RecipientID int,
    @MessageID int,
    @UserID int,
    @Read bit,
	@Archived bit,
	@CreateUpdateUserID INT
AS
BEGIN
    IF ( @RecipientID = -1 )
        BEGIN
            INSERT dbo.CoreMessaging_MessageRecipients(
					[MessageID],
					[UserID],
					[Read],
					[Archived],
                    [CreatedByUserID],
                    [CreatedOnDate],
                    [LastModifiedByUserID],
                    [LastModifiedOnDate]
                    )
            VALUES  (
					@MessageID,
					@UserID,
					@Read,
					@Archived,
                    @CreateUpdateUserID , -- CreatedBy - int
                    GETDATE(), -- CreatedOn - datetime
                    @CreateUpdateUserID , -- LastModifiedBy - int
                    GETDATE() -- LastModifiedOn - datetime
                    )

            SELECT  @RecipientID = SCOPE_IDENTITY()
        END
    ELSE
        BEGIN
            UPDATE  dbo.CoreMessaging_MessageRecipients
            SET     [MessageID] = @MessageID,
					[UserID] = @UserID,
					[Read] = @Read,
					[Archived] = @Archived,
                    LastModifiedByUserID = @CreateUpdateUserID,
                    LastModifiedOnDate = GETDATE()
            WHERE   RecipientID = @RecipientID
        END

    SELECT  @RecipientID
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_SendNotification]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_SendNotification]
	@NotificationTypeID int,
	@PortalID INT,
	@To nvarchar(2000),
	@From nvarchar(200),
    @Subject nvarchar(400),
    @Body nvarchar(max),
    @SenderUserID int,
	@CreateUpdateUserID int,
	@ExpirationDate datetime,
    @IncludeDismissAction bit,
    @Context nvarchar(200)
AS
BEGIN
	INSERT dbo.[CoreMessaging_Messages] (
		[NotificationTypeID],
		[PortalID],
		[To],
		[From],
		[Subject],
		[Body],
		[SenderUserID],
		[ExpirationDate],
        [IncludeDismissAction],
        [Context],
		[CreatedByUserID],
		[CreatedOnDate],
		[LastModifiedByUserID],
		[LastModifiedOnDate]
	) VALUES (
		@NotificationTypeID,
		@PortalID,
		@To,
		@From,
		@Subject,
		@Body,
		@SenderUserID,
		@ExpirationDate,
        @IncludeDismissAction,
        @Context,
		@CreateUpdateUserID, -- CreatedBy
		GETUTCDATE(), -- CreatedOn
		@CreateUpdateUserID, -- LastModifiedBy
		GETDATE() -- LastModifiedOn
	)

	SELECT  SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_SetUserPreference]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_SetUserPreference]
	@PortalId INT ,	
	@UserId INT,
	@MessagesEmailFrequency INT,
	@NotificationsEmailFrequency INT
AS 
BEGIN	
	UPDATE dbo.CoreMessaging_UserPreferences
	SET MessagesEmailFrequency = @MessagesEmailFrequency
		,NotificationsEmailFrequency = @NotificationsEmailFrequency
	WHERE PortalId = @PortalId
	AND UserId = @UserId

	IF @@ROWCOUNT = 0 BEGIN
		INSERT INTO dbo.CoreMessaging_UserPreferences (PortalId, UserId, MessagesEmailFrequency, NotificationsEmailFrequency)
		VALUES (@PortalId, @UserId, @MessagesEmailFrequency, @NotificationsEmailFrequency)
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_UpdateMessageArchivedStatus]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_UpdateMessageArchivedStatus]
	@ConversationID int,
	@UserID int,
	@Archived bit
AS
BEGIN
	UPDATE dbo.[CoreMessaging_MessageRecipients]
	SET [Archived] = @Archived
	WHERE UserID = @UserID
	AND MessageID IN (SELECT MessageID FROM dbo.[CoreMessaging_Messages] WHERE ConversationID = @ConversationID)

	IF @Archived = 1 BEGIN
		-- If archiving, set also as read
		UPDATE dbo.[CoreMessaging_MessageRecipients]
		SET [Read] = 1
		WHERE [UserID] = @UserID
		AND MessageID IN (SELECT MessageID FROM dbo.[CoreMessaging_Messages] WHERE ConversationID = @ConversationID)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_UpdateMessageReadStatus]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_UpdateMessageReadStatus]
	@ConversationID int,
	@UserID          int,
	@Read			 bit
AS
BEGIN
UPDATE dbo.[CoreMessaging_MessageRecipients] SET [Read]=@Read 
WHERE UserID = @UserID
AND MessageID IN (SELECT MessageID FROM dbo.[CoreMessaging_Messages] WHERE ConversationID=@ConversationID)
END
GO
/****** Object:  StoredProcedure [dbo].[CoreMessaging_UpdateSubscriptionDescription]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoreMessaging_UpdateSubscriptionDescription]
	@ObjectKey NVARCHAR(255), 
    @PortalId INT,
    @Description NVARCHAR(255)	
AS 
	BEGIN
		UPDATE dbo.CoreMessaging_Subscriptions
		SET [Description] = @Description
		WHERE PortalId = @PortalId 
		AND ObjectKey LIKE @ObjectKey		
		SELECT @@ROWCOUNT AS [ResultStatus]      
	END
GO
/****** Object:  StoredProcedure [dbo].[CountLegacyFiles]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CountLegacyFiles]
AS
BEGIN

SELECT COUNT(*) FROM dbo.[Files] WHERE ContentItemID IS NULL
END
GO
/****** Object:  StoredProcedure [dbo].[Dashboard_AddControl]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Dashboard_AddControl]  

	@PackageId							INT,
	@DashboardControlKey 				NVARCHAR(50),
	@IsEnabled							BIT,
	@DashboardControlSrc				NVARCHAR(250),
	@DashboardControlLocalResources 	NVARCHAR(250),
	@ControllerClass					NVARCHAR(250),
	@ViewOrder							INT

AS
	IF @ViewOrder = -1
		SET @ViewOrder = (SELECT TOP 1 ViewOrder FROM Dashboard_Controls ORDER BY ViewOrder DESC) + 1

    IF EXISTS(SELECT DashboardControlID FROM dbo.Dashboard_Controls WHERE ViewOrder = @ViewOrder)
	BEGIN
		UPDATE dbo.Dashboard_Controls SET ViewOrder = ViewOrder + 1 WHERE ViewOrder >= @ViewOrder
	END

	INSERT INTO dbo.Dashboard_Controls (
		PackageId,
		DashboardControlKey,
		IsEnabled,
		DashboardControlSrc,
		DashboardControlLocalResources,
		ControllerClass,
		ViewOrder
	)
	VALUES (
		@PackageId,
		@DashboardControlKey,
		@IsEnabled,
		@DashboardControlSrc,
		@DashboardControlLocalResources,
		@ControllerClass,
		@ViewOrder
	)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[Dashboard_DeleteControl]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Dashboard_DeleteControl]  

	@DashboardControlID int

AS
	DELETE dbo.Dashboard_Controls 
	WHERE DashboardControlID = @DashboardControlID
GO
/****** Object:  StoredProcedure [dbo].[Dashboard_GetControls]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetControls] 
	@IsEnabled bit
AS
BEGIN
	IF @IsEnabled = 0 BEGIN
		SELECT *
		FROM dbo.[Dashboard_Controls]
		ORDER BY ViewOrder
	END
	ELSE BEGIN
		SELECT *
		FROM dbo.[Dashboard_Controls]
		WHERE IsEnabled = 1
		ORDER BY ViewOrder
	END
END
GO
/****** Object:  StoredProcedure [dbo].[Dashboard_GetDashboardControlByKey]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetDashboardControlByKey]  
	@DashboardControlKey nvarchar(50)
AS
	
	SELECT *
	  FROM dbo.Dashboard_Controls
		WHERE DashboardControlKey = @DashboardControlKey
GO
/****** Object:  StoredProcedure [dbo].[Dashboard_GetDashboardControlByPackageId]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetDashboardControlByPackageId]  
	@PackageID INT
AS
	
	SELECT *
	  FROM dbo.Dashboard_Controls
		WHERE PackageID = @PackageID AND PackageID <> -1
GO
/****** Object:  StoredProcedure [dbo].[Dashboard_GetDbBackups]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetDbBackups]
AS
	DECLARE @ProductEdition INT
	SET @ProductEdition = CAST(ServerProperty('EngineEdition') as INT)

	IF (@ProductEdition = 5) --Check for SQL Azure
	BEGIN
		SELECT      
			'Unsupported' as name, 
			NULL as StartDate, 
			NULL as FinishDate, 
			0 as size, 
			NULL as database_name, 
			'UNKNOWN' as BackupType
	END
	ELSE
	BEGIN
		EXEC('SELECT TOP 20     
				name, 
				backup_start_date as StartDate, 
				backup_finish_date as FinishDate, 
				backup_size/1024 as size, 
				database_name, 
				CASE type
					WHEN ''D'' THEN ''Database''
					WHEN ''I'' THEN ''Differential database''
					WHEN ''L'' THEN ''Log''
					WHEN ''F'' THEN ''File or filegroup''
					WHEN ''G'' THEN ''Differential file''
					WHEN ''P'' THEN ''Partial''
					WHEN ''Q'' THEN ''Differential partial''
				END AS BackupType
				FROM         
				msdb..backupset
				WHERE
				database_name = DB_NAME() 
				ORDER BY backup_start_date DESC')
	END
GO
/****** Object:  StoredProcedure [dbo].[Dashboard_GetDbFileInfo]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetDbFileInfo]
AS
	IF OBJECT_ID('sys.database_files') IS NULL
		BEGIN
		SELECT 'Total Size' AS FileType,
					'Total' AS Name,
					SUM(reserved_page_count)*8 AS Size,
					'n/a' AS FileName
				FROM sys.dm_db_partition_stats
		END
	ELSE
		BEGIN
			SELECT	CASE LOWER(RIGHT(physical_name,3))
						WHEN 'mdf' THEN 'DATA'
						WHEN 'ldf' THEN 'LOG'
						ELSE 'UNKNOWN'
					END as FileType,
						name AS Name,
						size*8 AS Size,
						physical_name AS FileName
					FROM sys.database_files
		END
GO
/****** Object:  StoredProcedure [dbo].[Dashboard_GetDbInfo]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Dashboard_GetDbInfo]
AS
	
	SELECT
		ServerProperty('ProductVersion') AS ProductVersion, 
		ServerProperty('ProductLevel') AS ServicePack, 
		ServerProperty('Edition') AS ProductEdition, 
		@@VERSION AS SoftwarePlatform
GO
/****** Object:  StoredProcedure [dbo].[Dashboard_GetInstalledModules]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetInstalledModules]
AS
	SELECT		
		DesktopModuleID, 
		ModuleName,
		FriendlyName,
		Version,
		(SELECT     COUNT(*) AS Instances
			FROM          dbo.DesktopModules 
				INNER JOIN dbo.ModuleDefinitions ON dbo.DesktopModules.DesktopModuleID = dbo.ModuleDefinitions.DesktopModuleID 
				INNER JOIN dbo.Modules ON dbo.ModuleDefinitions.ModuleDefID = dbo.Modules.ModuleDefID
			WHERE      (dbo.DesktopModules.DesktopModuleID = DM.DesktopModuleID)) AS Instances
	FROM dbo.DesktopModules AS DM
	WHERE (IsAdmin = 0)
	ORDER BY [FriendlyName] ASC
GO
/****** Object:  StoredProcedure [dbo].[Dashboard_UpdateControl]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Dashboard_UpdateControl]  

	@DashboardControlID 				INT,
	@DashboardControlKey 				NVARCHAR(50),
	@IsEnabled							BIT,
	@DashboardControlSrc				NVARCHAR(250),
	@DashboardControlLocalResources 	NVARCHAR(250),
	@ControllerClass					NVARCHAR(250),
	@ViewOrder							INT

AS
    DECLARE @OldOrder INT
    SELECT @OldOrder = ViewOrder FROM dbo.Dashboard_Controls WHERE DashboardControlID = @DashboardControlID
	UPDATE dbo.Dashboard_Controls 
		SET DashboardControlKey = @DashboardControlKey,
			IsEnabled = @IsEnabled,
			DashboardControlSrc = @DashboardControlSrc,
			DashboardControlLocalResources = @DashboardControlLocalResources,
			ControllerClass = @ControllerClass,
			ViewOrder = @ViewOrder
	WHERE DashboardControlID = @DashboardControlID

    IF @OldOrder IS NOT NULL AND @OldOrder < @ViewOrder
	BEGIN
		UPDATE dbo.Dashboard_Controls SET ViewOrder = ViewOrder - 1 WHERE ViewOrder BETWEEN @OldOrder AND @ViewOrder AND DashboardControlID <> @DashboardControlID
	END
    ELSE IF @OldOrder IS NOT NULL AND @OldOrder > @ViewOrder
    BEGIN
		UPDATE dbo.Dashboard_Controls SET ViewOrder = ViewOrder + 1 WHERE ViewOrder BETWEEN @ViewOrder AND @OldOrder AND DashboardControlID <> @DashboardControlID
	END
GO
/****** Object:  StoredProcedure [dbo].[DeleteAffiliate]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteAffiliate]

@AffiliateId int

as

delete
from   dbo.Affiliates
where  AffiliateId = @AffiliateId
GO
/****** Object:  StoredProcedure [dbo].[DeleteAuthentication]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteAuthentication]
	@AuthenticationID int
AS
	DECLARE @AuthType nvarchar(100)
	SET @AuthType = (SELECT AuthenticationType FROM dbo.Authentication WHERE AuthenticationID = @AuthenticationID)
	
	-- Delete UserAuthentication rows
	IF (@AuthType Is Not Null)
		BEGIN
			DELETE FROM dbo.UserAuthentication
				WHERE AuthenticationType = @AuthType
		END

	-- Delete Record
	DELETE 
		FROM   dbo.Authentication
		WHERE AuthenticationID = @AuthenticationID
GO
/****** Object:  StoredProcedure [dbo].[DeleteBanner]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteBanner]

@BannerId int

as

delete
from dbo.Banners
where  BannerId = @BannerId
GO
/****** Object:  StoredProcedure [dbo].[DeleteContentItem]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteContentItem] 
	@ContentItemId			int
AS
	DELETE FROM dbo.ContentItems
	WHERE ContentItemId = @ContentItemId
GO
/****** Object:  StoredProcedure [dbo].[DeleteContentType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteContentType] 
	@ContentTypeId	int
AS
	DELETE FROM dbo.ContentTypes
	WHERE ContentTypeId = @ContentTypeId
GO
/****** Object:  StoredProcedure [dbo].[DeleteContentWorkflowLogs]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteContentWorkflowLogs]
	@ContentItemID int,
	@WorkflowID int
AS
    DELETE FROM dbo.[ContentWorkflowLogs]
	WHERE ContentItemID = @ContentItemID AND WorkflowID = @WorkflowID

	SELECT @@ROWCOUNT
GO
/****** Object:  StoredProcedure [dbo].[DeleteContentWorkflowState]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteContentWorkflowState]
	@StateID int
AS
    DELETE FROM dbo.ContentWorkflowStates
    WHERE StateID = @StateID
GO
/****** Object:  StoredProcedure [dbo].[DeleteContentWorkflowStatePermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteContentWorkflowStatePermission]
	@WorkflowStatePermissionID int
AS
    DELETE FROM dbo.ContentWorkflowStatePermission
    WHERE WorkflowStatePermissionID = @WorkflowStatePermissionID
GO
/****** Object:  StoredProcedure [dbo].[DeleteDesktopModule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteDesktopModule]
	@DesktopModuleId int
AS
-- delete custom permissions
DELETE FROM dbo.Permission
WHERE moduledefid in 
	(SELECT moduledefid 
	FROM dbo.ModuleDefinitions
	WHERE desktopmoduleid = @DesktopModuleId)
	
DELETE FROM dbo.DesktopModules 
WHERE DesktopModuleId = @DesktopModuleId
GO
/****** Object:  StoredProcedure [dbo].[DeleteDesktopModulePermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteDesktopModulePermission]
	@DesktopModulePermissionID int
AS
    DELETE FROM dbo.DesktopModulePermission
    WHERE DesktopModulePermissionID = @DesktopModulePermissionID
GO
/****** Object:  StoredProcedure [dbo].[DeleteDesktopModulePermissionsByPortalDesktopModuleID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteDesktopModulePermissionsByPortalDesktopModuleID]
	@PortalDesktopModuleID int
AS
    DELETE FROM dbo.DesktopModulePermission
    WHERE PortalDesktopModuleID = @PortalDesktopModuleID
GO
/****** Object:  StoredProcedure [dbo].[DeleteDesktopModulePermissionsByUserID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteDesktopModulePermissionsByUserID]
    @UserId   INT,  -- required, not null!
	@PortalId INT -- Null affects all sites
AS
    DELETE FROM dbo.[DesktopModulePermission]
    WHERE UserID = @UserId
     AND (PortalDesktopModuleID IN (SELECT PortalDesktopModuleID 
									FROM dbo.[PortalDesktopModules] 
									WHERE PortalID = @PortalId) OR IsNull(@PortalId, -1) = -1)
GO
/****** Object:  StoredProcedure [dbo].[DeleteEventLog]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteEventLog]	
    @LogGUID varchar(36)
AS
BEGIN
    IF @LogGUID is null
    BEGIN
        DELETE FROM dbo.EventLog
    END ELSE BEGIN
        DELETE FROM dbo.EventLog WHERE LogGUID = @LogGUID
    END
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteEventLogConfig]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteEventLogConfig]
	@ID int
AS
DELETE FROM dbo.EventLogConfig
WHERE ID = @ID
GO
/****** Object:  StoredProcedure [dbo].[DeleteEventLogType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteEventLogType]
	@LogTypeKey nvarchar(35)
AS
DELETE FROM dbo.EventLogTypes
WHERE	LogTypeKey = @LogTypeKey
GO
/****** Object:  StoredProcedure [dbo].[DeleteExtensionUrlProvider]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteExtensionUrlProvider] 
	@ExtensionUrlProviderID	int
AS

DELETE FROM dbo.ExtensionUrlProviders
	WHERE ExtensionUrlProviderID = @ExtensionUrlProviderID
GO
/****** Object:  StoredProcedure [dbo].[DeleteFile]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFile]	
    @PortalID int,
	@FileName nvarchar(246),
	@FolderID int
AS
BEGIN
    IF @PortalID is null
    BEGIN
        DELETE FROM dbo.Files WHERE FileName = @FileName AND FolderID = @FolderID AND PortalId IS Null
    END ELSE BEGIN
        DELETE FROM dbo.Files WHERE FileName = @FileName AND FolderID = @FolderID AND PortalId = @PortalID
    END
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteFiles]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFiles]	
    @PortalID int
AS
BEGIN
    IF @PortalID is null
    BEGIN
        DELETE FROM dbo.Files WHERE PortalId is null
    END ELSE BEGIN
        DELETE FROM dbo.Files WHERE PortalId = @PortalID
    END
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteFileVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFileVersion] 
	@FileId int,
	@Version int
AS
BEGIN
	DECLARE @PublishedVersion int

	-- Check there is at least one version
	IF NOT EXISTS(SELECT FileID FROM FileVersions WHERE FileId = @FileId)
	BEGIN
		SELECT NULL
		RETURN
	END
		
	SELECT @PublishedVersion = PublishedVersion
	FROM dbo.Files
	WHERE FileId = @FileId

	IF @PublishedVersion = @Version 
	BEGIN
		-- Get the previous version
		SELECT @PublishedVersion = MAX(Version)
		FROM dbo.FileVersions 
		WHERE FileId = @FileId
			AND Version < @Version

		-- If there is no previous version, get the min exsisting version
		IF @PublishedVersion IS NULL 
			SELECT @PublishedVersion = MIN(Version)
			FROM dbo.FileVersions 
			WHERE FileId = @FileId

		-- Update the published version
		IF @PublishedVersion IS NOT NULL 
		BEGIN
			UPDATE dbo.Files
			SET [PublishedVersion] = @PublishedVersion,
				[Extension] = v.[Extension],
				[Size] = v.[Size],
				[Width] = v.Width,		
				[Height] = v.Height,
				[ContentType] = v.ContentType,
				[Content] = v.Content,
				[LastModifiedByUserID] = v.LastModifiedByUserID,
				[LastModifiedOnDate] = v.LastModifiedOnDate,
				[SHA1Hash] = v.SHA1Hash
			FROM dbo.files AS f
				INNER JOIN dbo.FileVersions AS v
				ON ( f.FileId = v.FileId AND v.Version = @PublishedVersion)		
			WHERE f.FileId = @FileId

			DELETE FROM dbo.FileVersions
			WHERE FileId = @FileId 
			AND Version = @PublishedVersion
		END
	END

	DELETE FROM dbo.FileVersions
	WHERE FileId = @FileId 
	  AND Version = @Version

	SELECT @PublishedVersion
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteFolder]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFolder]	
    @PortalID int,
    @FolderPath nvarchar(300)
AS
BEGIN
    IF @PortalID is null
    BEGIN
        DELETE FROM dbo.Folders
        WHERE PortalID is null AND FolderPath = @FolderPath
    END ELSE BEGIN
        DELETE FROM dbo.Folders
        WHERE PortalID = @PortalID AND FolderPath = @FolderPath
    END
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteFolderMapping]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFolderMapping]
	@FolderMappingID int
AS
BEGIN
	DELETE
	FROM dbo.[FolderMappings]
	WHERE FolderMappingID = @FolderMappingID
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteFolderPermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFolderPermission]
	@FolderPermissionID int
AS

DELETE FROM dbo.FolderPermission
WHERE
	[FolderPermissionID] = @FolderPermissionID
GO
/****** Object:  StoredProcedure [dbo].[DeleteFolderPermissionsByFolderPath]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFolderPermissionsByFolderPath]
    @PortalId   Int,            -- Null for Host menu tabs
    @FolderPath nVarChar(300)   -- must be a valid path
AS
BEGIN
    DELETE FROM dbo.[FolderPermission]
    WHERE FolderID IN (SELECT FolderID FROM dbo.[Folders]
                                       WHERE FolderPath = @FolderPath AND (IsNull(PortalID, -1) = IsNull(@PortalId, -1)))
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteFolderPermissionsByUserID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFolderPermissionsByUserID]
    @PortalId Int,  -- Null|-1 for Host menu tabs
    @UserId   Int   -- Not Null
AS
    DELETE FROM dbo.[FolderPermission]
    WHERE UserID = @UserId
     AND FolderID IN (SELECT FolderID FROM dbo.[Folders] 
	                  WHERE (PortalID = @PortalId Or IsNull(@PortalId, -1) = IsNull(PortalID, -1)))
GO
/****** Object:  StoredProcedure [dbo].[DeleteHeirarchicalTerm]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteHeirarchicalTerm]	
    @TermId			int    
AS
BEGIN
    DECLARE @Left int, @Right int, @VocabularyID int, @Width int

	SELECT
		@Left = tt.TermLeft
		, @Right = tt.TermRight
		, @VocabularyID = tt.VocabularyID
		, @Width = @Right - @Left + 1
	FROM
		dbo.Taxonomy_Terms tt
	WHERE
		tt.TermID = @TermID

	BEGIN TRANSACTION

	-- Delete term(s)
	DELETE FROM dbo.Taxonomy_Terms
	WHERE TermLeft > = @Left AND TermLeft > 0
	  AND TermRight <= @Right AND TermRight > 0
	  AND VocabularyID = @VocabularyID

	IF @@ERROR = 0
	BEGIN
		-- Update Left values for all items that are after deleted term
		UPDATE dbo.Taxonomy_Terms
	    SET TermLeft = TermLeft - @Width
		WHERE TermLeft >= @Left + @Width
			AND VocabularyID = @VocabularyID

        IF @@ERROR = 0
        BEGIN
            -- Update Right values for all items that are after deleted term
            UPDATE dbo.Taxonomy_Terms
            SET TermRight = TermRight - @Width
            WHERE TermRight >= @Right
                AND VocabularyID = @VocabularyID

            IF @@ERROR = 0
            BEGIN
                COMMIT TRANSACTION
                RETURN
            END
        END
    END
    
	ROLLBACK TRANSACTION
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteHtmlText]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteHtmlText]

@ModuleID int,
@ItemID int

as

delete
from   dbo.HtmlText
where  ModuleID = @ModuleID
and ItemID = @ItemID
GO
/****** Object:  StoredProcedure [dbo].[DeleteHtmlTextUsers]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteHtmlTextUsers]

as

delete
from   HtmlTextUsers
where  HtmlTextUserID in 
  ( select HtmlTextUserID
    from   HtmlTextUsers
    inner join dbo.HtmlText on dbo.HtmlTextUsers.ItemID = dbo.HtmlText.ItemID
    where HtmlTextUsers.ItemID = HtmlText.ItemID
    and HtmlTextUsers.StateID <> HtmlText.StateID )
GO
/****** Object:  StoredProcedure [dbo].[DeleteIPFilter]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteIPFilter]
	@IPFilterID	int
AS 
	BEGIN
		DELETE FROM dbo.IPFilter  
			WHERE IPFilterID = @IPFilterID
	END
GO
/****** Object:  StoredProcedure [dbo].[DeleteJavaScriptLibrary]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteJavaScriptLibrary]
	@JavaScriptLibraryID INT
AS
	DELETE FROM dbo.[JavaScriptLibraries]
	WHERE JavaScriptLibraryID = @JavaScriptLibraryID
GO
/****** Object:  StoredProcedure [dbo].[DeleteLanguage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteLanguage]
	@LanguageID		Int -- Not Null
AS
BEGIN
    DECLARE @CultureCode AS nVarChar(10);
    SELECT @CultureCode = CultureCode FROM dbo.[Languages] WHERE LanguageId = @LanguageId;
    DELETE FROM dbo.[PortalLocalization] WHERE @CultureCode = CultureCode;
    DELETE FROM dbo.[PortalSettings]     WHERE @CultureCode = CultureCode;
    DELETE FROM dbo.[Languages]          WHERE @LanguageID  = LanguageID;
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteLanguagePack]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteLanguagePack]

	@LanguagePackID		int

AS
    DELETE
	    FROM	dbo.LanguagePacks
	    WHERE   LanguagePackID = @LanguagePackID
GO
/****** Object:  StoredProcedure [dbo].[DeleteList]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[DeleteList]
	@ListName nvarchar(50),
	@ParentKey nvarchar(150)

AS
DELETE 
	FROM dbo.vw_Lists
	WHERE ListName = @ListName
		AND ParentKey =@ParentKey
GO
/****** Object:  StoredProcedure [dbo].[DeleteListEntryByID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[DeleteListEntryByID]

@EntryId   int,
@DeleteChild bit

as

Delete
From dbo.Lists
Where  [EntryID] = @EntryID

If @DeleteChild = 1
Begin
	Delete 
	From dbo.Lists
	Where [ParentID] = @EntryID
End
GO
/****** Object:  StoredProcedure [dbo].[DeleteMetaData]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteMetaData] 
	@ContentItemId		int,
	@Name				nvarchar(100),
	@Value				nvarchar(MAX)
	
AS
	DELETE FROM dbo.ContentItems_MetaData
	FROM dbo.ContentItems_MetaData AS cm
		INNER JOIN dbo.MetaData AS m ON cm.MetaDataID = m.MetaDataID
	WHERE cm.ContentItemId = @ContentItemId AND m.MetaDataName = @Name AND cm.MetaDataValue = @Value
GO
/****** Object:  StoredProcedure [dbo].[DeleteModule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteModule]

@ModuleId   int

as

delete
from   dbo.Modules 
where  ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[DeleteModuleControl]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteModuleControl]

@ModuleControlId int

as

delete
from   dbo.ModuleControls
where  ModuleControlId = @ModuleControlId
GO
/****** Object:  StoredProcedure [dbo].[DeleteModuleDefinition]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteModuleDefinition]
	@ModuleDefId int
AS

-- delete custom permissions
DELETE FROM dbo.Permission
WHERE moduledefid = @ModuleDefId
	
DELETE FROM dbo.ModuleDefinitions
WHERE  ModuleDefId = @ModuleDefId
GO
/****** Object:  StoredProcedure [dbo].[DeleteModulePermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteModulePermission]
	@ModulePermissionID int
AS

DELETE FROM dbo.ModulePermission
WHERE
	[ModulePermissionID] = @ModulePermissionID
GO
/****** Object:  StoredProcedure [dbo].[DeleteModulePermissionsByModuleID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteModulePermissionsByModuleID]
	@ModuleID int,
	@PortalID int
AS
	DELETE FROM dbo.ModulePermission
		WHERE ModuleID = @ModuleID
			AND PortalID = @PortalID
GO
/****** Object:  StoredProcedure [dbo].[DeleteModulePermissionsByUserID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[DeleteModulePermissionsByUserID]
	@PortalID int,
	@UserID int
AS
	DELETE FROM dbo.ModulePermission
		FROM dbo.ModulePermission MP
			INNER JOIN dbo.Modules AS M ON MP.ModuleID = M.ModuleID
		WHERE M.PortalID = @PortalID
		AND MP.UserID = @UserID
GO
/****** Object:  StoredProcedure [dbo].[DeleteModuleSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteModuleSetting]
@ModuleId      int,
@SettingName   nvarchar(50)
as

DELETE FROM dbo.ModuleSettings 
WHERE ModuleId = @ModuleId
AND SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[DeleteModuleSettings]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteModuleSettings]
@ModuleId      int
as

DELETE FROM dbo.ModuleSettings 
WHERE ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[DeletePackage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePackage]
	@PackageID		int
AS
	DELETE 
		FROM   dbo.Packages
		WHERE  [PackageID] = @PackageID
GO
/****** Object:  StoredProcedure [dbo].[DeletePermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePermission]
	@PermissionID int
AS

DELETE FROM dbo.Permission
WHERE
	[PermissionID] = @PermissionID
GO
/****** Object:  StoredProcedure [dbo].[DeletePortalAlias]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[DeletePortalAlias]
@PortalAliasID int

as

DELETE FROM dbo.PortalAlias 
WHERE PortalAliasID = @PortalAliasID
GO
/****** Object:  StoredProcedure [dbo].[DeletePortalDesktopModules]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePortalDesktopModules]
    @PortalID        int,
    @DesktopModuleId int
AS
BEGIN
    IF @PortalID is not null AND @DesktopModuleId is not null
        DELETE FROM dbo.PortalDesktopModules WHERE PortalId = @PortalID AND DesktopModuleId = @DesktopModuleId
    ELSE 
        BEGIN
            IF @PortalID is not null
                DELETE FROM dbo.PortalDesktopModules WHERE PortalId = @PortalID
            ELSE
                BEGIN 
                    IF @DesktopModuleId is not null
                        DELETE FROM dbo.PortalDesktopModules WHERE DesktopModuleId = @DesktopModuleId
                END
        END
END
GO
/****** Object:  StoredProcedure [dbo].[DeletePortalGroup]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePortalGroup]
	@PortalGroupID	int
AS 
	BEGIN
		DELETE FROM dbo.PortalGroups  
			WHERE PortalGroupID = @PortalGroupID
	END
GO
/****** Object:  StoredProcedure [dbo].[DeletePortalInfo]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePortalInfo]
	@PortalID int

AS
	/* Delete all the Portal Modules */
	DELETE
	FROM dbo.Modules
	WHERE PortalId = @PortalID

	/* Delete all the Portal Skins */
	DELETE
	FROM dbo.Packages
	WHERE  PortalId = @PortalID

	/* Delete Portal */
	DELETE
	FROM dbo.Portals
	WHERE  PortalId = @PortalID
GO
/****** Object:  StoredProcedure [dbo].[DeletePortalLanguages]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePortalLanguages]
    @PortalId   Int, -- Null ignored (use referential integrity to delete from all Portals)
    @LanguageId Int  -- Null ignored (use referential integrity to delete for all languages)
AS
BEGIN
    IF @PortalId Is Not Null AND IsNull(@LanguageId, -1) != -1 BEGIN
       DECLARE @CultureCode nVarchar(10);
       SELECT @CultureCode = CultureCode FROM dbo.[Languages] WHERE LanguageId = @LanguageId;
       DELETE FROM dbo.[PortalLanguages]    WHERE PortalId = @PortalId AND @LanguageId  = LanguageId;
       DELETE FROM dbo.[PortalLocalization] WHERE PortalId = @PortalId AND @CultureCode = CultureCode;
       DELETE FROM dbo.[PortalSettings]     WHERE PortalId = @PortalId AND @CultureCode = CultureCode;
    END
    -- ELSE rely on referential integrity (portal or language will be deleted as well)
END
GO
/****** Object:  StoredProcedure [dbo].[DeletePortalSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePortalSetting]
	@PortalID      Int,          -- Not Null
	@SettingName   nVarChar(50), -- Not Null
	@CultureCode   nVarChar(10)  -- Null|'' for all languages and neutral settings
AS
BEGIN
	DELETE FROM dbo.[PortalSettings]
	 WHERE (PortalID    = @PortalID)
	   AND (SettingName = @SettingName)
	   AND (CultureCode = @CultureCode OR IsNull(@CultureCode, '') = '')
END
GO
/****** Object:  StoredProcedure [dbo].[DeletePortalSettings]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePortalSettings]
	@PortalID      Int,          -- Not Null
	@CultureCode   nVarChar(10)  -- Null|'' for all languages and neutral settings

AS
BEGIN
	DELETE FROM dbo.[PortalSettings]
	 WHERE (PortalID    = @PortalID)
	   AND (CultureCode = @CultureCode OR IsNull(@CultureCode, '') = '')
END
GO
/****** Object:  StoredProcedure [dbo].[DeletePropertyDefinition]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePropertyDefinition]

	@PropertyDefinitionId int

AS

UPDATE dbo.ProfilePropertyDefinition 
	SET Deleted = 1
	WHERE  PropertyDefinitionId = @PropertyDefinitionId
GO
/****** Object:  StoredProcedure [dbo].[DeleteRelationship]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteRelationship] @RelationshipID INT	
AS 
	BEGIN
		DELETE FROM dbo.Relationships  
			WHERE RelationshipID = @RelationshipID
	END
GO
/****** Object:  StoredProcedure [dbo].[DeleteRelationshipType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteRelationshipType] @RelationshipTypeID INT	
AS 
	BEGIN
		DELETE FROM dbo.RelationshipTypes  
			WHERE RelationshipTypeID = @RelationshipTypeID
	END
GO
/****** Object:  StoredProcedure [dbo].[DeleteRole]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteRole]
    @RoleId Int -- ID of role to delete. System Roles ignored (deletion of system roles not supported)
AS
BEGIN
    IF @RoleId >= 0 BEGIN
        DELETE FROM dbo.[DesktopModulePermission] WHERE RoleID = @RoleId
        DELETE FROM dbo.[FolderPermission]        WHERE RoleID = @RoleId
        DELETE FROM dbo.[ModulePermission]        WHERE RoleID = @RoleId
        DELETE FROM dbo.[TabPermission]           WHERE RoleID = @RoleId
        DELETE FROM dbo.[Roles]                   WHERE RoleID = @RoleId
    END
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteRoleGroup]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteRoleGroup]

	@RoleGroupId      int
	
AS

DELETE  
FROM dbo.RoleGroups
WHERE  RoleGroupId = @RoleGroupId
GO
/****** Object:  StoredProcedure [dbo].[DeleteSchedule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteSchedule]
@ScheduleID int
AS
DELETE FROM dbo.Schedule
WHERE ScheduleID = @ScheduleID
GO
/****** Object:  StoredProcedure [dbo].[DeleteScopeType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteScopeType] 
	@ScopeTypeId			int
AS
	DELETE FROM dbo.Taxonomy_ScopeTypes
	WHERE ScopeTypeId = @ScopeTypeId
GO
/****** Object:  StoredProcedure [dbo].[DeleteSearchCommonWord]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteSearchCommonWord]
	@CommonWordID int
AS

DELETE FROM dbo.SearchCommonWords
WHERE
	[CommonWordID] = @CommonWordID
GO
/****** Object:  StoredProcedure [dbo].[DeleteSearchStopWords]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteSearchStopWords]
	@StopWordsID int
AS
BEGIN	
	DELETE FROM dbo.SearchStopWords WHERE StopWordsID = @StopWordsID
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteSearchWord]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteSearchWord]
	@SearchWordsID int
AS

DELETE FROM dbo.SearchWord
WHERE
	[SearchWordsID] = @SearchWordsID
GO
/****** Object:  StoredProcedure [dbo].[DeleteServer]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteServer]
	@ServerID			int
AS
	DELETE FROM dbo.WebServers WHERE ServerID=@ServerID
GO
/****** Object:  StoredProcedure [dbo].[DeleteSimpleTerm]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteSimpleTerm] 
	@TermId			int
AS
	DELETE FROM dbo.Taxonomy_Terms
	WHERE TermID = @TermID
GO
/****** Object:  StoredProcedure [dbo].[DeleteSiteLog]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteSiteLog]
	@DateTime                      datetime, 
	@PortalID                      int

AS
	DELETE FROM dbo.SiteLog WITH(READPAST)
	WHERE  PortalId = @PortalID
		AND    DateTime < @DateTime
GO
/****** Object:  StoredProcedure [dbo].[DeleteSkin]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteSkin]

	@SkinID		int

AS

DELETE
	FROM	dbo.Skins
	WHERE   SkinID = @SkinID
GO
/****** Object:  StoredProcedure [dbo].[DeleteSkinControl]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteSkinControl]
	@SkinControlId int
AS
    DELETE
    FROM   dbo.SkinControls
    WHERE  SkinControlId = @SkinControlId
GO
/****** Object:  StoredProcedure [dbo].[DeleteSkinPackage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteSkinPackage]

	@SkinPackageID		int

AS
    DELETE
	    FROM	dbo.SkinPackages
	WHERE   SkinPackageID = @SkinPackageID
GO
/****** Object:  StoredProcedure [dbo].[DeleteSynonymsGroup]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteSynonymsGroup]
	@SynonymsGroupID int
AS
BEGIN	
	DELETE FROM dbo.SynonymsGroups WHERE SynonymsGroupID = @SynonymsGroupID
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteSystemMessage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteSystemMessage]

@PortalID     int,
@MessageName  nvarchar(50)

as

delete
from   dbo.SystemMessages
where  PortalID = @PortalID
and    MessageName = @MessageName
GO
/****** Object:  StoredProcedure [dbo].[DeleteTab]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteTab]
    @TabId Int  -- ID of tab to delete; Not Null and > 0
AS
BEGIN
    DECLARE @TabOrder Int
    DECLARE @ParentId Int
    DECLARE @ContentItemId Int
    SELECT @TabOrder = TabOrder, @ParentId = ParentID, @ContentItemID = ContentItemID FROM dbo.[Tabs] WHERE TabID = @TabId

    -- Delete Tab --
    DELETE FROM dbo.[Tabs] WHERE  TabID = @TabId

    -- Update TabOrder of remaining Tabs --
    UPDATE dbo.[Tabs]
        SET TabOrder = TabOrder - 2
        WHERE IsNull(ParentID, -1) = IsNull(@ParentId , -1) AND TabOrder > @TabOrder

    -- Delete Content Item --
    DELETE FROM dbo.[ContentItems] WHERE ContentItemID = @ContentItemId
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteTabModule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteTabModule]
	@TabId      int,
	@ModuleId   int,
	@SoftDelete	bit
AS
IF @SoftDelete = 1
	UPDATE dbo.TabModules
		SET	IsDeleted = 1,
			VersionGuid = newId(),
			LastModifiedOnDate=GETDATE()
	WHERE  TabId = @TabId
		AND    ModuleId = @ModuleId
ELSE
	DELETE
	FROM   dbo.TabModules 
	WHERE  TabId = @TabId
		AND    ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[DeleteTabModuleSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteTabModuleSetting]
@TabModuleId      int,
@SettingName   nvarchar(50)
as

DELETE FROM TabModuleSettings 
WHERE TabModuleId = @TabModuleId
AND SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[DeleteTabModuleSettings]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteTabModuleSettings]
@TabModuleId      int
as

DELETE FROM dbo.TabModuleSettings 
WHERE TabModuleId = @TabModuleId
GO
/****** Object:  StoredProcedure [dbo].[DeleteTabPermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteTabPermission]
	@TabPermissionID int
AS

DELETE FROM dbo.TabPermission
WHERE
	[TabPermissionID] = @TabPermissionID
GO
/****** Object:  StoredProcedure [dbo].[DeleteTabPermissionsByTabID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteTabPermissionsByTabID]
	@TabID int
AS

DELETE FROM dbo.TabPermission
WHERE
	[TabID] = @TabID
GO
/****** Object:  StoredProcedure [dbo].[DeleteTabPermissionsByUserID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[DeleteTabPermissionsByUserID]
	@PortalID int,
	@UserID int
AS
	DELETE FROM dbo.TabPermission
		FROM dbo.TabPermission TP
			INNER JOIN dbo.Tabs AS T ON TP.TabID = T.TabID
		WHERE T.PortalID = @PortalID
		AND TP.UserID = @UserID
GO
/****** Object:  StoredProcedure [dbo].[DeleteTabSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteTabSetting]
	@TabID      	INT,
	@SettingName	NVARCHAR(50)

AS

	DELETE	FROM dbo.TabSettings 
	WHERE	TabID = @TabID
	AND		SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[DeleteTabSettings]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteTabSettings]
	@TabID      	INT

AS

	DELETE	FROM dbo.TabSettings 
	WHERE	TabID = @TabID
GO
/****** Object:  StoredProcedure [dbo].[DeleteTabUrl]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteTabUrl] 
	@TabID				int,
	@SeqNum				int
AS
	DELETE FROM dbo.TabUrls
	WHERE TabId = @TabID AND SeqNum = @SeqNum
GO
/****** Object:  StoredProcedure [dbo].[DeleteTabVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteTabVersion]
    @Id INT
AS
BEGIN
    DELETE FROM dbo.[TabVersions] WHERE TabVersionId = @Id
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteTabVersionDetail]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteTabVersionDetail]
    @Id INT
AS
BEGIN
    DELETE FROM dbo.[TabVersionDetails] WHERE TabVersionDetailId = @Id
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteTranslatedTabs]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteTranslatedTabs]
    @PortalID INT ,
    @CultureCode NVARCHAR(10)
AS 
    BEGIN

        SET NOCOUNT ON;
		
        BEGIN TRY

            BEGIN TRANSACTION DeleteTranslatedTabs
		
			-- first store ContentItem records to be deleted
            DECLARE @TempDeleteCI TABLE ( ContentItemId INT )
        
            INSERT  INTO @TempDeleteCI
                    SELECT  ContentItemId
                    FROM    dbo.Tabs
                    WHERE   ( PortalID = @PortalID )
                            AND ( CultureCode = @CultureCode )

		-- delete all tabs in the portal that have been localized to the requested cultureCode
		-- This will also delete related tabmodule records
            DELETE  FROM dbo.Tabs
            WHERE   ( PortalID = @PortalID )
                    AND ( CultureCode = @CultureCode )

		
		-- append ContentItems to be deleted from stale modules
            INSERT  INTO @TempDeleteCI
                    SELECT  ContentItemID
                    FROM    dbo.ContentItems CI
                    WHERE   EXISTS ( SELECT *
                                     FROM   dbo.Modules M
                                     WHERE  ( CI.ModuleID = M.ModuleID )
                                            AND NOT EXISTS ( SELECT
                                                              *
                                                             FROM
                                                              dbo.TabModules TM
                                                             WHERE
                                                              M.ModuleID = TM.ModuleID ) )

		-- delete stale modules (these are modules that do not have a corresponding TabModules record,
		-- in other words: modules that are not placed on any page anymore)
            DELETE  FROM dbo.Modules
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   dbo.TabModules
                                 WHERE  dbo.Modules.ModuleID = dbo.TabModules.ModuleID )

		-- finally delete all corresponding content items
            DELETE  FROM dbo.ContentItems
            WHERE   ContentItemID IN ( SELECT   ContentItemID
                                       FROM     @TempDeleteCI )

            COMMIT TRANSACTION DeleteTranslatedTabs

        END TRY
  
        BEGIN CATCH
            IF @@TRANCOUNT > 0 
                ROLLBACK TRANSACTION DeleteTranslatedTabs


            DECLARE @ErrorMessage NVARCHAR(4000);
            DECLARE @ErrorSeverity INT;

            SELECT  @ErrorMessage = ERROR_MESSAGE() ,
                    @ErrorSeverity = ERROR_SEVERITY();

            RAISERROR (@ErrorMessage, @ErrorSeverity, 1 );			
			
        END CATCH	      

    END
GO
/****** Object:  StoredProcedure [dbo].[DeleteUrl]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteUrl]

@PortalID     int,
@Url          nvarchar(255)

as

delete
from   dbo.Urls
where  PortalID = @PortalID
and    Url = @Url
GO
/****** Object:  StoredProcedure [dbo].[DeleteUrlTracking]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteUrlTracking]

@PortalID     int,
@Url          nvarchar(255),
@ModuleID     int

as

delete
from   dbo.UrlTracking
where  PortalID = @PortalID
and    Url = @Url
and    ((ModuleId = @ModuleId) or (ModuleId is null and @ModuleId is null))
GO
/****** Object:  StoredProcedure [dbo].[DeleteUserPortal]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteUserPortal]
	@UserID		int,
	@PortalID   int
AS
	IF @PortalID IS NULL
		BEGIN
			UPDATE dbo.Users
				SET
					IsDeleted = 1
				WHERE  UserId = @UserID
		END
	ELSE
		BEGIN
			UPDATE dbo.UserPortals
				SET
					IsDeleted = 1
				WHERE  UserId = @UserID
					AND PortalId = @PortalID
		END
GO
/****** Object:  StoredProcedure [dbo].[DeleteUserRelationship]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteUserRelationship] @UserRelationshipID INT	
AS 
	BEGIN
		DELETE FROM dbo.UserRelationships  
			WHERE UserRelationshipID = @UserRelationshipID
	END
GO
/****** Object:  StoredProcedure [dbo].[DeleteUserRelationshipPreference]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteUserRelationshipPreference]
	@PreferenceID INT	
AS 
	BEGIN
		DELETE FROM dbo.UserRelationshipPreferences  
		WHERE PreferenceID = @PreferenceID

	END
GO
/****** Object:  StoredProcedure [dbo].[DeleteUserRole]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteUserRole]

@UserID int,
@RoleId int

as

delete
from dbo.UserRoles
where  UserId = @UserID
and    RoleId = @RoleId
GO
/****** Object:  StoredProcedure [dbo].[DeleteUsersOnline]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteUsersOnline]
	@TimeWindow int	
AS
BEGIN
    DECLARE @dt datetime
	SET @dt = DATEADD(MINUTE, -@TimeWindow, GETDATE())

	DELETE FROM dbo.AnonymousUsers WHERE LastActiveDate < @dt

	DELETE FROM dbo.UsersOnline WHERE LastActiveDate < @dt
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteVendor]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteVendor]

@VendorId int

as

delete
from dbo.Vendors
where  VendorId = @VendorId
GO
/****** Object:  StoredProcedure [dbo].[DeleteVendorClassifications]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteVendorClassifications]

@VendorId  int

as

delete
from dbo.VendorClassification
where  VendorId = @VendorId
GO
/****** Object:  StoredProcedure [dbo].[DeleteVocabulary]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteVocabulary] 
	@VocabularyID			int
AS
	DELETE FROM dbo.Taxonomy_Vocabularies
	WHERE VocabularyID = @VocabularyID
GO
/****** Object:  StoredProcedure [dbo].[EnsureLocalizationExists]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EnsureLocalizationExists]
	@PortalID       Int,
	@CultureCode	nvarchar(10)
AS
BEGIN
	DECLARE @MasterLanguage nvarchar(10) = Null;
	DECLARE @LocalizationExists bit = 0;

	IF NOT EXISTS (SELECT * FROM dbo.[Languages] L 
					JOIN dbo.[PortalLanguages] P ON L.LanguageID = P.LanguageID 
					WHERE P.PortalID = @PortalID AND L.CultureCode = @CultureCode)
		RETURN; -- language does not exist for this portal

	IF EXISTS (SELECT * FROM dbo.[PortalLocalization] 
				WHERE CultureCode = @CultureCode AND PortalID = @PortalID)
		RETURN; -- already localized
	
	IF EXISTS (SELECT * FROM dbo.[PortalLocalization] L
					JOIN dbo.[Portals] P ON L.PortalID = P.PortalID AND L.CultureCode = P.DefaultLanguage
					WHERE P.PortalID = @PortalID)
		SELECT @MasterLanguage = DefaultLanguage 
		FROM dbo.[Portals] 
		WHERE PortalID = @PortalID
	ELSE IF EXISTS (SELECT * FROM dbo.[PortalLocalization] 
					WHERE CultureCode = 'en-US' and PortalID = @PortalID)
		SET @MasterLanguage = 'en-US'
	ELSE -- neither default nor system language available: take the language that was assigned first
		SELECT TOP (1) CultureCode 
		FROM dbo.[PortalLocalization] 
		WHERE PortalID = @PortalID 
		ORDER BY PortalID ASC;

	IF NOT (@MasterLanguage Is Null OR @MasterLanguage LIKE @CultureCode) 
	BEGIN  -- copy localized values from (existing and different) master language:					
		INSERT INTO dbo.[PortalLocalization]
		(	PortalId,
			CultureCode,
			PortalName,
			LogoFile,
			FooterText,
			Description,
			KeyWords,
			BackgroundFile, 
			HomeTabId,
			LoginTabId,
			UserTabId,
			AdminTabId,
			RegisterTabId,
			SearchTabId,
			CreatedByUserID,
			CreatedOnDate,
			LastModifiedByUserID,
			LastModifiedOnDate
		) SELECT
			PortalId,
			@CultureCode,
			PortalName,
			LogoFile,
			FooterText,
			Description,
			KeyWords,
			BackgroundFile, 
			HomeTabId,
			LoginTabId,
			UserTabId,
			AdminTabId,
			RegisterTabId,
			SearchTabId,
			-1,
			GETDATE(),
			-1,
			GETDATE()
		 FROM dbo.[PortalLocalization] 
		 WHERE PortalID = @PortalID AND CultureCode = @MasterLanguage;
	
		-- copy missing localized settings:
		DECLARE	
			@LocalPortalSettings TABLE(
		    [PortalID]             INT             NOT NULL,
		    [CultureCode]          NVARCHAR (10)   NOT NULL,
		    [SettingName]          NVARCHAR (50)   NOT NULL,
		    [SettingValue]         NVARCHAR (2000) NULL
		);

		INSERT INTO @LocalPortalSettings
		(
			PortalID,
			CultureCode,
			SettingName,
			SettingValue
		)
		SELECT
			PortalID,
			CultureCode,
			SettingName,
			SettingValue
		FROM dbo.[PortalSettings]
		WHERE PortalID = @PortalID AND CultureCode = @CultureCode

		MERGE INTO @LocalPortalSettings target
		USING (SELECT * FROM dbo.[PortalSettings]
				WHERE PortalId = @PortalID and CultureCode = @MasterLanguage) source 
		ON (target.SettingName = source.SettingName)
		WHEN NOT MATCHED THEN 
			INSERT (  
				PortalID,   
				CultureCode,   
				SettingName,   
				SettingValue) 
			VALUES (
				source.PortalID, 
				@CultureCode, 
				source.SettingName, 
				source.SettingValue
			);

		MERGE INTO dbo.[PortalSettings]  target
		USING (SELECT * FROM @LocalPortalSettings) source 
		ON (target.PortalID = source.PortalID AND 
			target.CultureCode = source.CultureCode AND 
			target.SettingName = source.SettingName)
		WHEN NOT MATCHED THEN 
			INSERT (  
				PortalID,   
				CultureCode,   
				SettingName,   
				SettingValue,
				CreatedByUserID, 
				CreatedOnDate, 
				LastModifiedByUserID, 
				LastModifiedOnDate) 
			VALUES (
				source.PortalID, 
				@CultureCode, 
				source.SettingName, 
				source.SettingValue,
				-1,
				GETDATE(),
				-1,
				GETDATE()
			);
	END;
END
GO
/****** Object:  StoredProcedure [dbo].[EnsureNeutralLanguage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EnsureNeutralLanguage]
    @PortalId INT ,
    @CultureCode NVARCHAR(10)
AS 
    BEGIN
        SET NOCOUNT ON;

        UPDATE  dbo.Tabs
        SET     CultureCode = NULL
        WHERE   PortalID = @PortalId
                AND CultureCode = @CultureCode
    END
GO
/****** Object:  StoredProcedure [dbo].[FindBanners]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FindBanners]
	@PortalID     int,
	@BannerTypeId int,
	@GroupName    nvarchar(100)

AS
SELECT  B.BannerId,
		B.VendorId,
		BannerName,
		URL,
		CASE WHEN LEFT(LOWER(ImageFile), 6) = 'fileid' 
			THEN
				(SELECT Folder + FileName  
					FROM dbo.vw_Files 
					WHERE 'fileid=' + convert(varchar,dbo.vw_Files.FileID) = ImageFile
				) 
			ELSE 
				ImageFile  
			END 
		AS ImageFile,
		Impressions,
		CPM,
		B.Views,
		B.ClickThroughs,
		StartDate,
		EndDate,
		BannerTypeId,
		Description,
		GroupName,
		Criteria,
		B.Width,
		B.Height,
		B.ImageFile AS ImageFileRaw
FROM    dbo.Banners B
INNER JOIN dbo.Vendors V ON B.VendorId = V.VendorId
WHERE   (B.BannerTypeId = @BannerTypeId or @BannerTypeId is null)
AND     (B.GroupName = @GroupName or @GroupName is null)
AND     ((V.PortalId = @PortalID) or (@PortalID is null and V.PortalId is null))
AND     V.Authorized = 1 
AND     (getdate() <= B.EndDate or B.EndDate is null)
ORDER BY BannerId
GO
/****** Object:  StoredProcedure [dbo].[FindDatabaseVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[FindDatabaseVersion]

@Major  int,
@Minor  int,
@Build  int

as

select 1
from   dbo.Version
where  Major = @Major
and    Minor = @Minor
and    Build = @Build
GO
/****** Object:  StoredProcedure [dbo].[GetAffiliate]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAffiliate]
	@AffiliateId int
AS

	SELECT	*
	FROM	dbo.Affiliates 
	WHERE	AffiliateId = @AffiliateId
GO
/****** Object:  StoredProcedure [dbo].[GetAffiliates]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAffiliates]
    @VendorId INT
AS
    SELECT AffiliateId,
           StartDate,
           EndDate,
           CPC,
           Clicks,
           Clicks * CPC AS 'CPCTotal',
           CPA,
           Acquisitions,
           Acquisitions * CPA 'CPATotal'
    FROM   dbo.Affiliates
    WHERE  VendorId = @VendorId
    ORDER  BY StartDate DESC
GO
/****** Object:  StoredProcedure [dbo].[GetAllFiles]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllFiles]
AS
BEGIN
	SELECT   
	  FileId,  
	  PortalId,  
	  [FileName],  
	  Extension,  
	  Size,  
	  Width,  
	  Height,  
	  ContentType,  
	  FolderID,  
	  Folder,  
	  StorageLocation,  
	  IsCached,
	  UniqueId,
	  VersionGuid,
	  SHA1Hash,
	  FolderMappingID,  
	  LastModificationTime,  
	  Title,  
	  EnablePublishPeriod,  
	  StartDate,  
	  EndDate,  
	  CreatedByUserID,  
	  CreatedOnDate,  
	  LastModifiedByUserID,  
	  LastModifiedOnDate,  
	  PublishedVersion,  
	  ContentItemID
	FROM dbo.[vw_Files] 	
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllHtmlText]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetAllHtmlText]

@ModuleID int

as

select dbo.HtmlText.*,
       dbo.WorkflowStates.*,
       dbo.Workflow.WorkflowName,
       dbo.Users.DisplayName,
       dbo.Modules.PortalID
from   dbo.HtmlText
inner join dbo.Modules on dbo.Modules.ModuleID = dbo.HtmlText.ModuleID
inner join dbo.WorkflowStates on dbo.WorkflowStates.StateID = dbo.HtmlText.StateID
inner join dbo.Workflow on dbo.WorkflowStates.WorkflowID = dbo.Workflow.WorkflowID
left outer join dbo.Users on dbo.HtmlText.LastModifiedByUserID = dbo.Users.UserID
where  dbo.HtmlText.ModuleID = @ModuleID
order by dbo.HtmlText.LastModifiedOnDate desc
GO
/****** Object:  StoredProcedure [dbo].[GetAllModules]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllModules]

AS
SELECT	* 
FROM dbo.vw_Modules
GO
/****** Object:  StoredProcedure [dbo].[GetAllProfiles]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetAllProfiles]
AS
SELECT * FROM dbo.Profile
GO
/****** Object:  StoredProcedure [dbo].[GetAllRelationshipTypes]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllRelationshipTypes]
AS 
    SELECT  RelationshipTypeID,
            Direction,
            Name ,            
            Description,
            CreatedByUserID ,
            CreatedOnDate ,
            LastModifiedByUserID ,
            LastModifiedOnDate
    FROM    dbo.RelationshipTypes    
	ORDER BY RelationshipTypeID ASC
GO
/****** Object:  StoredProcedure [dbo].[GetAllSynonymsGroups]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllSynonymsGroups]
	@PortalID int,
	@CultureCode nvarchar(50)
AS
BEGIN
	SELECT   
	  [SynonymsGroupID],  
	  [SynonymsTags],  
	  [PortalID],
	  [CreatedByUserID],  
	  [CreatedOnDate],  
	  [LastModifiedByUserID],  
	  [LastModifiedOnDate]
	FROM dbo.SynonymsGroups 
	WHERE [PortalID] = @PortalID
	AND [CultureCode] = @CultureCode
	ORDER BY LastModifiedOnDate DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllTabs]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllTabs] 
AS
	SELECT *
		FROM dbo.vw_Tabs
		ORDER BY Level, ParentID, TabOrder
GO
/****** Object:  StoredProcedure [dbo].[GetAllTabsModules]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetAllTabsModules]
	@PortalID int,
	@AllTabs bit
AS
	SELECT	* 
	FROM dbo.vw_Modules M
	WHERE  M.PortalID = @PortalID 
		AND M.IsDeleted = 0
		AND M.AllTabs = @AllTabs
		AND M.TabModuleID =(SELECT min(TabModuleID) 
			FROM dbo.TabModules
			WHERE ModuleID = M.ModuleID)
	ORDER BY M.ModuleId
GO
/****** Object:  StoredProcedure [dbo].[GetAllTabsModulesByModuleID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllTabsModulesByModuleID]
    @ModuleID	int
AS
	SELECT	* 
	FROM dbo.vw_Modules
	WHERE  ModuleID = @ModuleID
GO
/****** Object:  StoredProcedure [dbo].[GetAllUsers]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllUsers]
	@PortalID        int,
	@PageIndex       int,
	@PageSize        INT,
	@IncludeDeleted  bit,
	@SuperUsersOnly  bit	
AS
	BEGIN
		-- Set the page bounds
		DECLARE 
			@PageLowerBound INT, 
			@PageUpperBound INT, 
			@RowsToReturn int

		EXEC dbo.CalculatePagingInformation @PageIndex, @PageSize, @RowsToReturn output, @PageLowerBound output, @PageUpperBound output

		IF @PortalID IS NULL
			BEGIN
				WITH [tmpUsers] AS (
					SELECT U.*, row_number() over (ORDER BY U.UserName) AS rowid
						FROM dbo.vw_Users u
						WHERE U.IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
							--less than equal done to cover IsDeleted in (1,0) for IncludeDeleted...else just IsDeleted = 0
							  AND U.IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
				)
				SELECT * FROM [tmpUsers]
					WHERE rowid > @PageLowerBound AND rowid < @PageUpperBound
					ORDER BY rowid
			END 
		ELSE 
			BEGIN
				WITH [tmpUsers] AS (
					SELECT U.*, row_number() over (order by U.UserName) AS rowid
						FROM dbo.vw_Users u
						WHERE U.PortalID = @PortalID AND U.IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
						  AND U.IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
				)
				SELECT * FROM [tmpUsers]
					WHERE rowid > @PageLowerBound AND rowid < @PageUpperBound
					ORDER by rowid
			END

		SET ROWCOUNT 0
 
		IF @PortalId IS NULL
			BEGIN
				SELECT COUNT(*) as TotalRecords
					FROM   dbo.vw_Users as U
					WHERE U.IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
				          AND U.IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
			END 
		ELSE 
			BEGIN
				SELECT COUNT(*) as TotalRecords
					FROM   dbo.vw_Users U
						WHERE U.PortalId = @PortalId
							AND U.IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
							AND U.IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[GetAuthenticationService]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAuthenticationService]

	@AuthenticationID int

AS
	SELECT *
		FROM   dbo.Authentication
		WHERE AuthenticationID = @AuthenticationID
GO
/****** Object:  StoredProcedure [dbo].[GetAuthenticationServiceByPackageID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAuthenticationServiceByPackageID]

	@PackageID int

AS
	SELECT *
		FROM  dbo.Authentication
		WHERE PackageID = @PackageID
GO
/****** Object:  StoredProcedure [dbo].[GetAuthenticationServiceByType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAuthenticationServiceByType]

	@AuthenticationType nvarchar(100)

AS
	SELECT *
		FROM  dbo.Authentication
		WHERE AuthenticationType = @AuthenticationType
GO
/****** Object:  StoredProcedure [dbo].[GetAuthenticationServices]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAuthenticationServices]
AS
	SELECT *
		FROM   dbo.Authentication
GO
/****** Object:  StoredProcedure [dbo].[GetAvailableUsersForIndex]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAvailableUsersForIndex]
    @PortalId INT ,
    @StartDate DATETIME ,
    @startUserId INT = 0,
    @numberOfUsers INT = 500
AS 
    BEGIN
		DECLARE @PivotSql NVARCHAR(MAX)

		SELECT @PivotSql = COALESCE(@PivotSql + ',','') + '[' + PropertyName + ']'
		 FROM dbo.[ProfilePropertyDefinition] pd
		 INNER JOIN dbo.[Lists] l ON ListName = 'DataType' AND SystemList = 1 AND Value IN ( 'Text', 'RichText' ) AND l.EntryID = pd.DataType
		 WHERE ISNULL(pd.PortalID, -1) = ISNULL(@PortalId, -1)
		   AND Deleted = 0
		ORDER BY ViewOrder

		DECLARE @Sql NVARCHAR(MAX)

		SELECT @Sql = '
        WITH    ValidDataType
                  AS ( SELECT   EntryID
                       FROM     dbo.[Lists]
                       WHERE    ListName = ''DataType''
                                AND SystemList = 1
                                AND Value IN ( ''Text'', ''RichText'' )
                     ),
                  ValidUsers AS 
                  (
                                      SELECT UserId FROM ( SELECT   UserId, ROW_NUMBER() OVER(ORDER BY UserId ASC) AS rownumber
                         FROM ( SELECT DISTINCT
                                            ( u.UserID )
                                  FROM      dbo.[Users] u
                                            INNER JOIN dbo.[UserPortals] up ON up.UserId = u.UserID
                                            INNER JOIN dbo.[vw_Profile] p ON p.UserID = u.UserID
                                            INNER JOIN dbo.[ProfilePropertyDefinition] pd ON pd.PropertyDefinitionID = p.PropertyDefinitionID AND pd.Visible = 1 AND pd.PortalID = @PortalId
                                            INNER JOIN ValidDataType dt ON dt.EntryID = pd.DataType
                                  WHERE     (up.PortalId = @PortalId OR up.PortalId IS NULL)
                                            AND (u.LastModifiedOnDate > @StartDate OR (p.LastUpdatedDate IS NOT NULL AND (p.LastUpdatedDate > @StartDate OR pd.LastModifiedOnDate > @StartDate)))
                                            AND ((p.PropertyValue IS NOT NULL AND p.PropertyValue <> '''') OR u.LastModifiedOnDate > @StartDate OR p.LastUpdatedDate IS NULL OR p.LastUpdatedDate > @StartDate)
                                ) AS T WHERE UserID > @startUserId) AS T
                                WHERE rownumber <= @numberOfUsers
                     )

		SELECT * FROM (
        SELECT u.UserID ,
               u.DisplayName,
               u.LastModifiedOnDate,
			   u.Username,
			   u.IsSuperUser,
			   u.Email,
			   u.CreatedOnDate,
			   p.PropertyName,
			   p.PropertyValue + ''$$$'' + 
			   CAST(CASE WHEN (p.Visibility IS NULL) THEN 0 ELSE p.Visibility END AS VARCHAR(10)) + ''$$$'' +
			   p.ExtendedVisibility + ''$$$'' +
			   CONVERT(VARCHAR(20), CASE WHEN u.LastModifiedOnDate > p.LastUpdatedDate OR p.LastUpdatedDate IS NULL THEN u.LastModifiedOnDate ELSE p.LastUpdatedDate END, 20) AS [PropertyValue]
		FROM
			dbo.[Users] u
			INNER JOIN ValidUsers vu on vu.UserId = u.UserID
			INNER JOIN dbo.[vw_Profile] p ON p.UserID = u.UserID
			INNER JOIN dbo.[ProfilePropertyDefinition] pd ON pd.PropertyDefinitionID = p.PropertyDefinitionID AND pd.Visible = 1 AND pd.PortalID = @PortalID
			INNER JOIN ValidDataType dt ON dt.EntryID = pd.DataType) AS T
		PIVOT (MAX(PropertyValue) for PropertyName in (' + @PivotSql + ')) AS T
		ORDER BY UserId
		'
		EXECUTE sp_executesql @Sql, 
                              N'@PortalId INT ,
                                @StartDate DATETIME ,
                                @startUserId INT,
                                @numberOfUsers INT', 
                              @PortalId, @StartDate, @startUserId, @numberOfUsers
    END
GO
/****** Object:  StoredProcedure [dbo].[GetBanner]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetBanner]
@BannerId int
as
select B.BannerId,
	   B.VendorId,
	   case when F.FileName is null then B.ImageFile else dbo.Folders.FolderPath + F.FileName end As ImageFile,
	   B.BannerName,
	   B.Impressions,
	   B.CPM,
	   B.Views,
	   B.ClickThroughs,
	   B.StartDate,
	   B.EndDate,
	   U.FirstName + ' ' + U.LastName AS CreatedByUser,
	   B.CreatedDate,
	   B.BannerTypeId,
	   B.Description,
	   B.GroupName,
	   B.Criteria,
	   B.URL,        
	   B.Width,
	   B.Height,
	   B.ImageFile AS ImageFileRaw
from   dbo.Folders INNER JOIN
       dbo.Files AS F ON dbo.Folders.FolderID = F.FolderID RIGHT OUTER JOIN
       dbo.Banners AS B INNER JOIN
       dbo.Vendors AS V ON B.VendorId = V.VendorId LEFT OUTER JOIN
       dbo.Users AS U ON B.CreatedByUser = U.UserID ON 'FileId=' + CONVERT(varchar, F.FileId) = B.ImageFile
where  B.BannerId = @BannerId
GO
/****** Object:  StoredProcedure [dbo].[GetBannerGroups]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetBannerGroups]
	@PortalID int
AS

SELECT  GroupName
FROM dbo.Banners
INNER JOIN dbo.Vendors ON 
	dbo.Banners.VendorId = dbo.Vendors.VendorId
WHERE (dbo.Vendors.PortalId = @PortalID) OR 
	(@PortalID is null and dbo.Vendors.PortalId is null)
GROUP BY GroupName
ORDER BY GroupName
GO
/****** Object:  StoredProcedure [dbo].[GetBanners]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetBanners]

@VendorId int

as

select BannerId,
       BannerName,
       URL,
       Impressions,
       CPM,
       Views,
       ClickThroughs,
       StartDate,
       EndDate,
       BannerTypeId,
       Description,
       GroupName,
       Criteria,
       Width,
       Height
from   dbo.Banners
where  VendorId = @VendorId
order  by CreatedDate desc
GO
/****** Object:  StoredProcedure [dbo].[GetContentItem]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentItem] 
	@ContentItemId			int
AS
	SELECT *
	FROM dbo.ContentItems
	WHERE ContentItemId = @ContentItemId
GO
/****** Object:  StoredProcedure [dbo].[GetContentItems]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentItems] 
	@ContentTypeId	int,
	@TabId			int,
	@ModuleId		int
AS
	SELECT *
	FROM dbo.ContentItems
	WHERE (ContentTypeId = @ContentTypeId OR @ContentTypeId IS NULL)
		AND (TabId = @TabId OR @TabId IS NULL)
		AND (ModuleId = @ModuleId OR @ModuleId IS NULL)
GO
/****** Object:  StoredProcedure [dbo].[GetContentItemsByContentType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentItemsByContentType] 
	@ContentTypeId int
AS
	SELECT * FROM dbo.ContentItems WHERE ContentTypeID = @ContentTypeId
GO
/****** Object:  StoredProcedure [dbo].[GetContentItemsByModuleId]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentItemsByModuleId] 
	@ModuleId int
AS
	SELECT * FROM dbo.ContentItems WHERE ModuleID = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[GetContentItemsByTabId]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentItemsByTabId] 
	@TabId int
AS
	SELECT * FROM dbo.ContentItems WHERE TabID = @TabId
GO
/****** Object:  StoredProcedure [dbo].[GetContentItemsByTerm]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentItemsByTerm]
 @Term nvarchar(250)
AS
BEGIN
DECLARE @TermID int
  , @TermLeft int
  , @TermRight int
  , @VocabularyID int

 SELECT
  @TermID = TermID
  , @TermLeft = TermLeft
  , @TermRight = TermRight
  , @VocabularyID = VocabularyID
 FROM
  dbo.Taxonomy_Terms
 WHERE
  Name = @Term

 IF @TermLeft = 0 AND @TermRight = 0
 BEGIN
  -- Simple Term
  SELECT c.*
  FROM dbo.ContentItems As c
   INNER JOIN dbo.ContentItems_Tags ct ON ct.ContentItemID = c.ContentItemID
   INNER JOIN dbo.Taxonomy_Terms t ON t.TermID = ct.TermID
  WHERE t.TermID = @TermID
 END ELSE BEGIN
  -- Hierarchical Term
  SELECT c.*
  FROM dbo.ContentItems As c
   INNER JOIN dbo.ContentItems_Tags ct ON ct.ContentItemID = c.ContentItemID
   INNER JOIN dbo.Taxonomy_Terms t ON t.TermID = ct.TermID
  WHERE t.TermLeft >= @TermLeft
   AND t.TermRight <= @TermRight
   AND t.VocabularyID = @VocabularyID
 END
END
GO
/****** Object:  StoredProcedure [dbo].[GetContentItemsByVocabularyId]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentItemsByVocabularyId] 
	@VocabularyID int
AS
BEGIN
	SELECT c.*
	FROM dbo.ContentItems As c
		INNER JOIN dbo.ContentItems_Tags ct ON ct.ContentItemID = c.ContentItemID
		INNER JOIN dbo.Taxonomy_Terms t ON t.TermID = ct.TermID
	WHERE t.VocabularyID = @VocabularyID
END
GO
/****** Object:  StoredProcedure [dbo].[GetContentTypes]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentTypes] 
AS
	SELECT *
	FROM dbo.ContentTypes
GO
/****** Object:  StoredProcedure [dbo].[GetContentWorkflow]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentWorkflow]
@WorkflowID int
AS

SELECT 
  [WorkflowID],
  [PortalID],
  [WorkflowName],
  [Description],
  [IsDeleted],
  [StartAfterCreating],
  [StartAfterEditing],
  [DispositionEnabled]
FROM dbo.ContentWorkflows
WHERE WorkflowID = @WorkflowID
GO
/****** Object:  StoredProcedure [dbo].[GetContentWorkflowLogs]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentWorkflowLogs]
	@ContentItemID int,
	@WorkflowID int
AS
    SELECT *
	FROM dbo.[ContentWorkflowLogs]
	WHERE ContentItemID = @ContentItemID AND WorkflowID = @WorkflowID
GO
/****** Object:  StoredProcedure [dbo].[GetContentWorkflows]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentWorkflows]
	@PortalID int
AS

SELECT
	[WorkflowID],
	[PortalID],
	[WorkflowName],
	[Description],
	[IsDeleted],
	[StartAfterCreating],
	[StartAfterEditing],
	[DispositionEnabled]
FROM dbo.ContentWorkflows
WHERE (PortalID = @PortalID OR PortalID IS null)
GO
/****** Object:  StoredProcedure [dbo].[GetContentWorkflowSource]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentWorkflowSource]
	@WorkflowID INT,
    @SourceName NVARCHAR(20)
AS
    SELECT 
		[SourceID],
		[WorkflowID],
		[SourceName],
		[SourceType]
	FROM dbo.ContentWorkflowSources
    WHERE WorkflowID = @WorkflowID AND SourceName = @SourceName
GO
/****** Object:  StoredProcedure [dbo].[GetContentWorkflowState]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentWorkflowState]
	@StateID int
AS
    SELECT
		[StateID],
		[WorkflowID],
		[StateName],
		[Order],
		[IsActive],
		[SendEmail],
		[SendMessage],
		[IsDisposalState],
		[OnCompleteMessageSubject],
		[OnCompleteMessageBody],
		[OnDiscardMessageSubject],
		[OnDiscardMessageBody]
	FROM dbo.ContentWorkflowStates
    WHERE StateID = @StateID
GO
/****** Object:  StoredProcedure [dbo].[GetContentWorkflowStatePermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentWorkflowStatePermission]
	@WorkflowStatePermissionID	int
AS
    SELECT *
    FROM dbo.vw_ContentWorkflowStatePermissions
    WHERE WorkflowStatePermissionID = @WorkflowStatePermissionID
GO
/****** Object:  StoredProcedure [dbo].[GetContentWorkflowStatePermissions]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentWorkflowStatePermissions]
AS
    SELECT *
    FROM dbo.vw_ContentWorkflowStatePermissions
GO
/****** Object:  StoredProcedure [dbo].[GetContentWorkflowStatePermissionsByStateID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentWorkflowStatePermissionsByStateID]
	@StateID int
AS
    SELECT *
    FROM dbo.vw_ContentWorkflowStatePermissions
	WHERE StateID = @StateID
GO
/****** Object:  StoredProcedure [dbo].[GetContentWorkflowStates]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentWorkflowStates]
	@WorkflowID int
AS
    SELECT 
		[StateID],
		[WorkflowID],
		[StateName],
		[Order],
		[IsActive],
		[SendEmail],
		[SendMessage],
		[IsDisposalState],
		[OnCompleteMessageSubject],
		[OnCompleteMessageBody],
		[OnDiscardMessageSubject],
		[OnDiscardMessageBody]
	FROM dbo.ContentWorkflowStates
    WHERE WorkflowID = @WorkflowID
GO
/****** Object:  StoredProcedure [dbo].[GetContentWorkflowStateUsageCount]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentWorkflowStateUsageCount]
	@StateId INT
AS
	SELECT COUNT(ci.ContentItemID)
	FROM dbo.[ContentItems] ci 
	WHERE ci.StateId = @StateId
GO
/****** Object:  StoredProcedure [dbo].[GetContentWorkflowUsage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentWorkflowUsage]
	@WorkflowId INT,
	@PageIndex INT,
	@PageSize INT
AS
	DECLARE @StartIndex INT = ((@PageIndex - 1) * @PageSize) + 1
	DECLARE @EndIndex INT = (@PageIndex * @PageSize)
	
	;WITH ContenResourcesSet AS
    (
		SELECT wu.*, ROW_NUMBER() OVER (Order BY wu.ContentType, wu.ContentName) AS [Index]
		FROM dbo.[vw_ContentWorkflowUsage] wu 		
		WHERE wu.WorkflowID = @WorkflowId
    )
   SELECT * FROM ContenResourcesSet WHERE [Index] BETWEEN @StartIndex AND @EndIndex
GO
/****** Object:  StoredProcedure [dbo].[GetContentWorkflowUsageCount]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContentWorkflowUsageCount]
	@WorkflowId INT
AS
	SELECT COUNT(*)
	FROM dbo.[vw_ContentWorkflowUsage] wu 	
	WHERE wu.WorkflowID = @WorkflowId
GO
/****** Object:  StoredProcedure [dbo].[GetCustomAliasesForTabs]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCustomAliasesForTabs] 
AS
	SELECT HttpAlias
	FROM  dbo.[PortalAlias] pa 
	WHERE PortalAliasId IN (SELECT PortalAliasId FROM dbo.[TabUrls])
	ORDER BY HttpAlias
GO
/****** Object:  StoredProcedure [dbo].[GetDatabaseInstallVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetDatabaseInstallVersion]
AS
SELECT  TOP 1 Major ,
        Minor ,
        Build
FROM    dbo.Version V
WHERE   VersionId IN ( SELECT   MAX(VersionId) AS VersionID
                       FROM     dbo.[Version]
                       GROUP BY CONVERT(NVARCHAR(8), CreatedDate, 112) )
GO
/****** Object:  StoredProcedure [dbo].[GetDatabaseServer]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDatabaseServer]
AS
	SELECT ServerProperty('Edition') AS ProductName,
           ServerProperty('ProductVersion') AS Version
GO
/****** Object:  StoredProcedure [dbo].[GetDatabaseTime]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDatabaseTime]
AS
BEGIN
	SELECT GETDATE()
END
GO
/****** Object:  StoredProcedure [dbo].[GetDatabaseTimeUtc]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDatabaseTimeUtc]
AS
BEGIN
	SELECT GETUTCDATE()
END
GO
/****** Object:  StoredProcedure [dbo].[GetDatabaseVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetDatabaseVersion]

as

select Major,
       Minor,
       Build
from   dbo.Version 
where  VersionId = ( select max(VersionId) from dbo.Version )
GO
/****** Object:  StoredProcedure [dbo].[GetDefaultLanguageByModule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDefaultLanguageByModule]
(
	@ModuleList varchar(1000)
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @TempList table
	(
		ModuleID int
	)

	DECLARE @ModuleID varchar(10), @Pos int

	SET @ModuleList = LTRIM(RTRIM(@ModuleList))+ ','
	SET @Pos = CHARINDEX(',', @ModuleList, 1)

	IF REPLACE(@ModuleList, ',', '') <> ''
	BEGIN
		WHILE @Pos > 0
		BEGIN
			SET @ModuleID = LTRIM(RTRIM(LEFT(@ModuleList, @Pos - 1)))
			IF @ModuleID <> ''
			BEGIN
				INSERT INTO @TempList (ModuleID) VALUES (CAST(@ModuleID AS int)) 
			END
			SET @ModuleList = RIGHT(@ModuleList, LEN(@ModuleList) - @Pos)
			SET @Pos = CHARINDEX(',', @ModuleList, 1)

		END
	END	

SELECT DISTINCT m.ModuleID, p.DefaultLanguage
FROM            dbo.Modules  m
INNER JOIN      dbo.Portals p ON p.PortalID = m.PortalID
WHERE		m.ModuleID in (SELECT ModuleID FROM @TempList)
ORDER BY        m.ModuleID	
		
END
GO
/****** Object:  StoredProcedure [dbo].[GetDeletedUsers]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDeletedUsers]
	@PortalID			int
AS
 IF @PortalID is null
  BEGIN
	SELECT  *
	FROM	dbo.vw_Users
	WHERE  PortalId IS Null
		AND IsDeleted = 1
	ORDER BY UserName
  END ELSE BEGIN
	SELECT  *
	FROM	dbo.vw_Users
	WHERE  PortalId = @PortalID		
		AND IsDeleted = 1
	ORDER BY UserName
  END
GO
/****** Object:  StoredProcedure [dbo].[GetDesktopModulePermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDesktopModulePermission]
	@DesktopModulePermissionID	int
AS
    SELECT *
    FROM dbo.vw_DesktopModulePermissions
    WHERE DesktopModulePermissionID = @DesktopModulePermissionID
GO
/****** Object:  StoredProcedure [dbo].[GetDesktopModulePermissions]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDesktopModulePermissions]
AS
    SELECT *
    FROM dbo.vw_DesktopModulePermissions
GO
/****** Object:  StoredProcedure [dbo].[GetDesktopModulePermissionsByPortalDesktopModuleID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDesktopModulePermissionsByPortalDesktopModuleID]
	@PortalDesktopModuleID int
AS
    SELECT *
    FROM dbo.vw_DesktopModulePermissions
	WHERE   PortalDesktopModuleID = @PortalDesktopModuleID
GO
/****** Object:  StoredProcedure [dbo].[GetDesktopModules]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDesktopModules]
AS
	SELECT *
	FROM  dbo.vw_DesktopModules
	ORDER BY FriendlyName
GO
/****** Object:  StoredProcedure [dbo].[GetDesktopModulesByPortal]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDesktopModulesByPortal]
	@PortalId int 
AS 
	SELECT DISTINCT DM.* 
	FROM dbo.vw_DesktopModules DM 
	WHERE ( IsPremium = 0 ) 
	OR  ( DesktopModuleID IN ( 
		SELECT DesktopModuleID 
		FROM dbo.PortalDesktopModules PDM 
		WHERE PDM.PortalId = @PortalId ) ) 
	ORDER BY FriendlyName
GO
/****** Object:  StoredProcedure [dbo].[GetDuplicateEmailCount]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDuplicateEmailCount]
    @PortalId INT
AS 
	SELECT ISNULL((SELECT COUNT(*) TotalCount FROM dbo.[Users] U Inner Join dbo.[UserPortals] UP on UP.[UserId] = U.[UserId] WHERE UP.PortalId = @PortalId  GROUP BY U.[Email] HAVING COUNT(*) > 1), 0)
GO
/****** Object:  StoredProcedure [dbo].[GetEnabledAuthenticationServices]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEnabledAuthenticationServices]
AS
	SELECT *
		FROM   dbo.Authentication
		WHERE  IsEnabled = 1
GO
/****** Object:  StoredProcedure [dbo].[GetEventLog]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEventLog]
    @PortalID   Int,            -- Might be Null for all sites
    @LogTypeKey nVarChar(35),   -- Key of log type or Null for all
    @PageSize   Int,            -- Number of items per page
    @PageIndex  Int             -- Page number starting with 0
AS
BEGIN
     WITH [eLog] AS (
         SELECT ROW_NUMBER() OVER (ORDER BY E.LogCreateDate Desc) AS RowNumber, e.*
          FROM dbo.vw_EventLog e
          WHERE (e.LogPortalID = @PortalID     OR IsNull(@PortalID,   -1) = -1)
            AND (e.LogTypeKey LIKE @LogTypeKey OR IsNull(@LogTypeKey, '') = '')
     )
     SELECT * FROM [eLog]
      WHERE RowNumber >= dbo.PageLowerBound(@PageIndex, @PageSize)
        AND RowNumber <= dbo.PageUpperBound(@PageIndex, @PageSize)
      ORDER BY RowNumber

    SELECT COUNT(1) AS TotalRecords
     FROM dbo.vw_EventLog e
     WHERE (e.LogPortalID = @PortalID     OR IsNull(@PortalID,   -1) = -1)
       AND (e.LogTypeKey Like @LogTypeKey OR IsNull(@LogTypeKey, '') = '')

END
GO
/****** Object:  StoredProcedure [dbo].[GetEventLogByLogGUID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEventLogByLogGUID]
	@LogGUID varchar(36)
AS
SELECT *
FROM dbo.vw_EventLog
WHERE (LogGUID = @LogGUID)
GO
/****** Object:  StoredProcedure [dbo].[GetEventLogConfig]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEventLogConfig]
	@ID int
AS
SELECT c.*, t.LogTypeFriendlyName
FROM dbo.EventLogConfig AS c
	INNER JOIN dbo.EventLogTypes AS t ON t.LogTypeKey = c.LogTypeKey
WHERE (ID = @ID or @ID IS NULL)
ORDER BY t.LogTypeFriendlyName ASC
GO
/****** Object:  StoredProcedure [dbo].[GetEventLogPendingNotif]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEventLogPendingNotif]
	@LogConfigID int
AS
SELECT *
FROM dbo.vw_EventLog
WHERE LogNotificationPending = 1
AND LogConfigID = @LogConfigID
GO
/****** Object:  StoredProcedure [dbo].[GetEventLogPendingNotifConfig]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEventLogPendingNotifConfig]
AS

SELECT 	COUNT(*) as PendingNotifs,
	elc.ID,
	elc.LogTypeKey, 
	elc.LogTypePortalID, 
	elc.LoggingIsActive,
	elc.KeepMostRecent,
	elc.EmailNotificationIsActive,
	elc.NotificationThreshold,
	elc.NotificationThresholdTime,
	elc.NotificationThresholdTimeType,
	elc.MailToAddress, 
	elc.MailFromAddress
FROM dbo.EventLogConfig elc
INNER JOIN dbo.EventLog
ON dbo.EventLog.LogConfigID = elc.ID
WHERE dbo.EventLog.LogNotificationPending = 1
GROUP BY elc.ID,
	elc.LogTypeKey, 
	elc.LogTypePortalID, 
	elc.LoggingIsActive,
	elc.KeepMostRecent,
	elc.EmailNotificationIsActive,
	elc.NotificationThreshold,
	elc.NotificationThresholdTime,
	elc.NotificationThresholdTimeType,
	elc.MailToAddress, 
	elc.MailFromAddress
GO
/****** Object:  StoredProcedure [dbo].[GetEventLogType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEventLogType]
AS
SELECT *
FROM dbo.EventLogTypes
GO
/****** Object:  StoredProcedure [dbo].[GetEventMessages]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEventMessages]
	
	@EventName nvarchar(100)

AS
	SELECT * 
	FROM dbo.EventQueue
	WHERE EventName = @EventName
		AND IsComplete = 0
	ORDER BY SentDate
GO
/****** Object:  StoredProcedure [dbo].[GetEventMessagesBySubscriber]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEventMessagesBySubscriber]
	
	@EventName nvarchar(100),
	@Subscriber nvarchar(100)

AS
	SELECT * 
	FROM dbo.EventQueue
	WHERE EventName = @EventName
		AND Subscriber = @Subscriber
		AND IsComplete = 0
	ORDER BY SentDate
GO
/****** Object:  StoredProcedure [dbo].[GetExpiredPortals]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetExpiredPortals]

AS
SELECT * FROM dbo.vw_Portals
WHERE ExpiryDate < getDate()
GO
/****** Object:  StoredProcedure [dbo].[GetExtensionUrlProviders]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetExtensionUrlProviders] 
	@PortalID	int 
AS
	SELECT 
		p.*, 
		pc.PortalID
	FROM  dbo.ExtensionUrlProviderConfiguration pc 
		RIGHT OUTER JOIN dbo.ExtensionUrlProviders p 
			ON pc.ExtensionUrlProviderID = p.ExtensionUrlProviderID
	WHERE pc.PortalID = @PortalID OR pc.PortalID IS Null

	SELECT ExtensionUrlProviderID, 
			PortalID, 
			SettingName, 
			SettingValue
	FROM dbo.ExtensionUrlProviderSetting
	WHERE PortalID = PortalID

	SELECT DISTINCT 
			P.ExtensionUrlProviderID,
			TM.TabID
		FROM dbo.DesktopModules DM
			INNER JOIN dbo.ModuleDefinitions MD ON DM.DesktopModuleID = MD.DesktopModuleID 
			INNER JOIN dbo.Modules M ON MD.ModuleDefID = M.ModuleDefID 
			INNER JOIN dbo.TabModules TM ON M.ModuleID = TM.ModuleID 
			INNER JOIN dbo.vw_ExtensionUrlProviders P ON DM.DesktopModuleID = P.DesktopModuleId
		WHERE     (P.PortalID = @PortalID) OR (P.PortalID IS NULL)
		  
		UNION
			SELECT  
				P.ExtensionUrlProviderID,
				PT.TabId
			FROM    dbo.ExtensionUrlProviderTab PT
				INNER JOIN dbo.ExtensionUrlProviders P ON P.ExtensionUrlProviderID = PT.ExtensionUrlProviderID
			WHERE   (PT.IsActive = 1)
GO
/****** Object:  StoredProcedure [dbo].[GetFile]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFile]
	@FileName nvarchar(246),
	@FolderID int,
	@RetrieveUnpublishedFiles bit = 0
AS
BEGIN
	IF @RetrieveUnpublishedFiles = 0 BEGIN
		SELECT FileId,
			   PortalId,
			   [FileName],
			   Extension,
			   Size,
			   Width,
			   Height,
			   ContentType,
			   FolderID,
			   Folder,
			   StorageLocation,
			   IsCached,
			   UniqueId,
			   VersionGuid,	   
			   SHA1Hash,
			   FolderMappingID,
			   LastModificationTime,
			   Title,
			   EnablePublishPeriod,
			   StartDate,
			   EndDate,
			   CreatedByUserID,
			   CreatedOnDate,
			   LastModifiedByUserID,
			   LastModifiedOnDate,
			   ContentItemID,
			   PublishedVersion
		FROM dbo.[vw_PublishedFiles] 			
		WHERE [FileName] = @FileName AND FolderID = @FolderID
	END
	ELSE BEGIN
		SELECT FileId,
			   PortalId,
			   [FileName],
			   Extension,
			   Size,
			   Width,
			   Height,
			   ContentType,
			   FolderID,
			   Folder,
			   StorageLocation,
			   IsCached,
			   UniqueId,
			   VersionGuid,	   
			   SHA1Hash,
			   FolderMappingID,
			   LastModificationTime,
			   Title,
			   EnablePublishPeriod,
			   StartDate,
			   EndDate,
			   CreatedByUserID,
			   CreatedOnDate,
			   LastModifiedByUserID,
			   LastModifiedOnDate,
			   ContentItemID,
			   PublishedVersion
		FROM dbo.[vw_Files]
		WHERE [FileName] = @FileName AND FolderID = @FolderID
	END
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileById]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFileById]
	@FileId int	,
	@RetrieveUnpublishedFiles bit = 0
AS
BEGIN
	IF @RetrieveUnpublishedFiles = 0 BEGIN
		SELECT FileId,
			   PortalId,
			   [FileName],
			   Extension,
			   Size,
			   Width,
			   Height,
			   ContentType,
			   FolderID,
			   Folder,
			   StorageLocation,
			   IsCached,
			   UniqueId,
			   VersionGuid,
			   SHA1Hash,
			   FolderMappingID,
			   LastModificationTime,
			   Title,
			   EnablePublishPeriod,
			   StartDate,
			   EndDate,
			   CreatedByUserID,
			   CreatedOnDate,
			   LastModifiedByUserID,
			   LastModifiedOnDate,
			   PublishedVersion,
			   ContentItemID
		FROM dbo.[vw_PublishedFiles]
		WHERE FileId = @FileId
	END
	ELSE BEGIN
		SELECT FileId,
			   PortalId,
			   [FileName],
			   Extension,
			   Size,
			   Width,
			   Height,
			   ContentType,
			   FolderID,
			   Folder,
			   StorageLocation,
			   IsCached,
			   [UniqueId],
			   [VersionGuid],
			   SHA1Hash,
			   FolderMappingID,
			   LastModificationTime,
			   Title,
			   EnablePublishPeriod,
			   StartDate,
			   EndDate,
			   CreatedByUserID,
			   CreatedOnDate,
			   LastModifiedByUserID,
			   LastModifiedOnDate,
			   PublishedVersion,
			   ContentItemID
		FROM dbo.[vw_Files] 
		WHERE FileId = @FileId
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileByUniqueID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFileByUniqueID]
    @UniqueID   uniqueidentifier
AS
	SELECT	* 
	FROM	dbo.Files
	WHERE	UniqueID = @UniqueID
GO
/****** Object:  StoredProcedure [dbo].[GetFileContent]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFileContent]
	@FileId int
AS
BEGIN
	SELECT Content
	FROM dbo.[Files]
	WHERE FileId = @FileId
END
GO
/****** Object:  StoredProcedure [dbo].[GetFiles]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFiles]
    @FolderID Int,                      -- not null!
    @RetrieveUnpublishedFiles Bit = 0   -- include files, hidden by status or date?
AS
	IF @RetrieveUnpublishedFiles = 0 
	BEGIN
		SELECT
			F.FileId,
			F.PortalId,
			F.[FileName],
			F.Extension,
			F.[Size],
			F.Width,
			F.Height,
			F.ContentType,
			F.FolderID,
			F.Folder,
			F.StorageLocation,
			F.IsCached,
			F.FolderMappingID,
			F.UniqueId,
			F.VersionGuid,
			F.SHA1Hash,
			F.LastModificationTime,
			F.Title,
			F.EnablePublishPeriod,
			F.StartDate,
			F.EndDate,
			F.CreatedByUserID,
			F.CreatedOnDate,
			F.LastModifiedByUserID,
			F.LastModifiedOnDate,
			F.PublishedVersion,
			F.ContentItemID
		FROM dbo.[vw_PublishedFiles] F			
		WHERE F.FolderID = @FolderID
		ORDER BY [FolderID], [FileName]
	END
	ELSE BEGIN
		SELECT
			F.FileId,
			F.PortalId,
			F.[FileName],
			F.Extension,
			F.[Size],
			F.Width,
			F.Height,
			F.ContentType,
			F.FolderID,
			F.Folder,
			F.StorageLocation,
			F.IsCached,
			F.FolderMappingID,
			F.UniqueId,
			F.VersionGuid,
			F.SHA1Hash,
			F.LastModificationTime,
			F.Title,
			F.EnablePublishPeriod,
			F.StartDate,
			F.EndDate,
			F.CreatedByUserID,
			F.CreatedOnDate,
			F.LastModifiedByUserID,
			F.LastModifiedOnDate,
			F.PublishedVersion,
			F.ContentItemID
		FROM dbo.[vw_Files] F			
		WHERE F.FolderID = @FolderID
		ORDER BY [FolderID], [FileName]
	END
GO
/****** Object:  StoredProcedure [dbo].[GetFileVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFileVersion] 
	@FileId int,
	@Version int
AS
BEGIN
	SELECT 
	   [FileId]
      ,[Version]
      ,[FileName]
      ,[Extension]
      ,[Size]
      ,[Width]
      ,[Height]
      ,[ContentType]
      ,[CreatedByUserID]
      ,[CreatedOnDate]
      ,[LastModifiedByUserID]
      ,[LastModifiedOnDate]
      ,[SHA1Hash]
	FROM dbo.FileVersions fv
	WHERE FileId = @FileId
	  AND Version = @Version
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileVersionContent]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFileVersionContent]

	@FileId		int,
	@Version	int

AS
	SELECT Content
	FROM dbo.[FileVersions]
	WHERE FileId = @FileId
		AND Version = @Version
GO
/****** Object:  StoredProcedure [dbo].[GetFileVersions]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFileVersions] 
@FileId int
AS
BEGIN
	SELECT 
	   [FileId]
      ,[Version]
      ,[FileName]
      ,[Extension]
      ,[Size]
      ,[Width]
      ,[Height]
      ,[ContentType]
      ,[CreatedByUserID]
      ,[CreatedOnDate]
      ,[LastModifiedByUserID]
      ,[LastModifiedOnDate]
      ,[SHA1Hash]
	FROM dbo.FileVersions fv
	WHERE fv.FileId = @FileId
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileVersionsInFolder]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFileVersionsInFolder]
@FolderId int
AS
BEGIN
	SELECT 
	   fv.[FileId]
      ,fv.[Version]
      ,fv.[FileName]
      ,fv.[Extension]
      ,fv.[Size]
      ,fv.[Width]
      ,fv.[Height]
      ,fv.[ContentType]
      ,fv.[CreatedByUserID]
      ,fv.[CreatedOnDate]
      ,fv.[LastModifiedByUserID]
      ,fv.[LastModifiedOnDate]
      ,fv.[SHA1Hash]
	FROM dbo.FileVersions fv, dbo.Files f
    WHERE fv.FileId = f.FileId and f.FolderId = @FolderId
END
GO
/****** Object:  StoredProcedure [dbo].[GetFolderByFolderID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFolderByFolderID]
	@FolderID int
AS
BEGIN
	SELECT *
	FROM dbo.[Folders]
	WHERE FolderID = @FolderID
END
GO
/****** Object:  StoredProcedure [dbo].[GetFolderByFolderPath]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFolderByFolderPath]
 @PortalID int,
 @FolderPath nvarchar(300)
AS
BEGIN
 if @PortalID is not null
 begin
  SELECT *
  FROM dbo.Folders
  WHERE PortalID = @PortalID AND FolderPath = @FolderPath
 end else begin
  SELECT *
  FROM dbo.Folders
  WHERE PortalID is null AND  FolderPath = @FolderPath
 end
END
GO
/****** Object:  StoredProcedure [dbo].[GetFolderByUniqueID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFolderByUniqueID]
    @UniqueID   uniqueidentifier
AS
	SELECT	* 
	FROM	dbo.Folders
	WHERE	UniqueID = @UniqueID
GO
/****** Object:  StoredProcedure [dbo].[GetFolderMapping]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFolderMapping]
	@FolderMappingID int
AS
BEGIN
	SELECT *
	FROM dbo.[FolderMappings]
	WHERE FolderMappingID = @FolderMappingID
END
GO
/****** Object:  StoredProcedure [dbo].[GetFolderMappingByMappingName]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFolderMappingByMappingName]
	@PortalID int,
	@MappingName nvarchar(50)
AS
BEGIN
	SELECT *
	FROM dbo.[FolderMappings]
	WHERE ISNULL(PortalID, -1) = ISNULL(@PortalID, -1) AND MappingName = @MappingName
END
GO
/****** Object:  StoredProcedure [dbo].[GetFolderMappings]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFolderMappings]
	@PortalID int
AS
BEGIN
	SELECT *
	FROM dbo.[FolderMappings]
	WHERE ISNULL(PortalID, -1) = ISNULL(@PortalID, -1)
	ORDER BY Priority
END
GO
/****** Object:  StoredProcedure [dbo].[GetFolderMappingsSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFolderMappingsSetting]
	@FolderMappingID int,
	@SettingName nvarchar(50)
AS
BEGIN
	SELECT *
	FROM dbo.[FolderMappingsSettings]
	WHERE FolderMappingID = @FolderMappingID AND SettingName = @SettingName
END
GO
/****** Object:  StoredProcedure [dbo].[GetFolderMappingsSettings]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFolderMappingsSettings]
	@FolderMappingID int
AS
BEGIN
	SELECT SettingName, SettingValue
	FROM dbo.[FolderMappingsSettings]
	WHERE FolderMappingID = @FolderMappingID
END
GO
/****** Object:  StoredProcedure [dbo].[GetFolderPermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFolderPermission]
	
	@FolderPermissionID int

AS
SELECT *
FROM dbo.vw_FolderPermissions
WHERE FolderPermissionID = @FolderPermissionID
GO
/****** Object:  StoredProcedure [dbo].[GetFolderPermissionsByFolderPath]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFolderPermissionsByFolderPath]
	
	@PortalID int,
	@FolderPath nvarchar(300), 
	@PermissionID int

AS
SELECT *
FROM dbo.vw_FolderPermissions

WHERE	((FolderPath = @FolderPath 
				AND ((PortalID = @PortalID) OR (PortalID IS NULL AND @PortalID IS NULL)))
			OR (FolderPath IS NULL AND PermissionCode = 'SYSTEM_FOLDER'))
	AND	(PermissionID = @PermissionID OR @PermissionID = -1)
GO
/****** Object:  StoredProcedure [dbo].[GetFolderPermissionsByPortal]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFolderPermissionsByPortal]
    @PortalId Int   -- Null|-1 for Host menu tabs
AS
    SELECT *
    FROM dbo.[vw_FolderPermissions]
    WHERE IsNull(PortalID, -1) = IsNull(@PortalId, -1)
GO
/****** Object:  StoredProcedure [dbo].[GetFolders]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFolders]
	@PortalID int -- Null|-1: Host Portal
AS
BEGIN
	SELECT *
	FROM dbo.Folders
	WHERE IsNull(PortalID, -1) = IsNull(@PortalID, -1) 
	ORDER BY PortalID, FolderPath -- include portalId to use proper index
END
GO
/****** Object:  StoredProcedure [dbo].[GetFoldersByPermissions]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFoldersByPermissions] 
	@PortalID int,
	@Permissions nvarchar(300),
	@UserID int,
	@FolderID int,
	@FolderPath nvarchar(300)

AS
	DECLARE @IsSuperUser BIT
	DECLARE @Admin BIT
	DECLARE @Read INT
	DECLARE @Write INT
	DECLARE @Browse INT
	DECLARE @Add INT

	--Determine Admin or SuperUser
	IF @UserId IN (
		SELECT UserId 
		FROM dbo.[UserRoles] 
		WHERE RoleId IN (
			SELECT RoleId 
			FROM dbo.[Roles] 
			WHERE PortalId = @PortalId 
			AND RoleName = 'Administrators')) 
	BEGIN 
		SET @Admin = 1 
	END;
	
	SELECT @IsSuperUser = IsSuperUser 
	FROM dbo.[Users] 
	WHERE UserId = @UserId;

	--Retrieve Permission Ids
	IF @Permissions LIKE '%READ%' BEGIN SELECT TOP 1 @Read = PermissionID FROM dbo.[Permission] WHERE PermissionCode = 'SYSTEM_FOLDER' AND PermissionKey = 'READ' END;
	IF @Permissions LIKE '%WRITE%' BEGIN SELECT TOP 1 @Write = PermissionID FROM dbo.[Permission] WHERE PermissionCode = 'SYSTEM_FOLDER' AND PermissionKey = 'WRITE' END;
	IF @Permissions LIKE '%BROWSE%' BEGIN SELECT TOP 1 @Browse = PermissionID FROM dbo.[Permission] WHERE PermissionCode = 'SYSTEM_FOLDER' AND PermissionKey = 'BROWSE' END;
	IF @Permissions LIKE '%ADD%' BEGIN SELECT TOP 1 @Add = PermissionID FROM dbo.[Permission] WHERE PermissionCode = 'SYSTEM_FOLDER' AND PermissionKey = 'ADD' END;

	IF @PortalID IS NULL
		BEGIN
			SELECT DISTINCT F.*
			FROM dbo.[Folders] F
			WHERE F.PortalID IS NULL
				AND (F.FolderID = @FolderID OR @FolderID = -1)
				AND (F.FolderPath = @FolderPath OR @FolderPath = '')
		  
			 ORDER BY F.FolderPath
		END
	ELSE
		BEGIN
			CREATE TABLE #Skip_Folders(folderid INT PRIMARY KEY(folderid))
			INSERT INTO #Skip_Folders
				 SELECT DISTINCT folderid FROM dbo.[FolderPermission] FP
									JOIN dbo.[Permission] P ON FP.PermissionID = P.PermissionID
									WHERE
										((P.PermissionKey = 'WRITE' OR @IsSuperUser=1 OR @Admin=1) OR
										FP.PermissionID = CASE WHEN @Read > 0 THEN @Read END OR
										FP.PermissionID = CASE WHEN @Write > 0 THEN @Write END OR
										FP.PermissionID = CASE WHEN @Browse > 0 THEN @Browse END OR
										FP.PermissionID = CASE WHEN @Add > 0 THEN @Add END)
										AND FP.FolderID NOT IN (SELECT DISTINCT folderid FROM dbo.[FolderPermission] WHERE allowaccess=0 AND (userid=@UserId OR roleid=-1 OR roleid IN (SELECT roleid FROM dbo.[UserRoles] WHERE UserID=@UserId)))		

			SELECT DISTINCT F.*
			FROM dbo.[Folders] F
				JOIN dbo.[FolderPermission] FP ON F.FolderId = FP.FolderID
				JOIN dbo.[Permission] P ON FP.PermissionID = P.PermissionID
				JOIN #Skip_Folders sf ON sf.folderid=f.folderid 
			WHERE ((F.PortalID = @PortalID) OR (F.PortalID IS NULL AND @PortalID IS NULL))
				AND (F.FolderID = @FolderID OR @FolderID = -1)
				AND (F.FolderPath = @FolderPath OR @FolderPath = '')
				AND 
					((P.PermissionKey = 'WRITE' OR @IsSuperUser=1 OR @Admin=1) OR
						FP.PermissionID = CASE WHEN @Read > 0 THEN @Read END OR
						FP.PermissionID = CASE WHEN @Write > 0 THEN @Write END OR
						FP.PermissionID = CASE WHEN @Browse > 0 THEN @Browse END OR
						FP.PermissionID = CASE WHEN @Add > 0 THEN @Add END)
				AND FP.AllowAccess = 1
			 ORDER BY F.FolderPath

			 DROP TABLE #Skip_Folders
		END
GO
/****** Object:  StoredProcedure [dbo].[GetHostSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetHostSetting]

@SettingName nvarchar(50)

as

select SettingValue
from dbo.HostSettings
where  SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[GetHostSettings]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetHostSettings]
AS
	IF NOT EXISTS ( select 1 from dbo.HostSettings where SettingName = 'GUID' )
	  INSERT INTO dbo.HostSettings ( SettingName, SettingValue, SettingIsSecure ) values ( 'GUID', newid(), 0 )

	SELECT SettingName,
		   SettingValue,
		   SettingIsSecure,
		   CreatedByUserID,
		   CreatedOnDate,
	       LastModifiedByUserID,
		   LastModifiedOnDate
	FROM   dbo.HostSettings
GO
/****** Object:  StoredProcedure [dbo].[GetHtmlText]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetHtmlText]

@ModuleID int,
@ItemID int

as

select dbo.HtmlText.*,
       dbo.WorkflowStates.*,
       dbo.Workflow.WorkflowName,
       dbo.Users.DisplayName,
       dbo.Modules.PortalID
from   dbo.HtmlText
inner join dbo.Modules on dbo.Modules.ModuleID = dbo.HtmlText.ModuleID
inner join dbo.WorkflowStates on dbo.WorkflowStates.StateID = dbo.HtmlText.StateID
inner join dbo.Workflow on dbo.WorkflowStates.WorkflowID = dbo.Workflow.WorkflowID
left outer join dbo.Users on dbo.HtmlText.LastModifiedByUserID = dbo.Users.UserID
where  dbo.HtmlText.ModuleID = @ModuleID
and ItemID = @ItemID
GO
/****** Object:  StoredProcedure [dbo].[GetHtmlTextLog]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetHtmlTextLog]

@ItemID int

as

select HtmlTextLog.ItemID,
       HtmlTextLog.StateID,
       WorkflowStates.StateName,
       HtmlTextLog.Comment,
       HtmlTextLog.Approved,
       HtmlTextLog.CreatedByUserID,
       Users.DisplayName,
       HtmlTextLog.CreatedOnDate
from dbo.HtmlTextLog
inner join dbo.WorkflowStates on dbo.HtmlTextLog.StateID = dbo.WorkflowStates.StateID
left outer join dbo.Users on dbo.HtmlTextLog.CreatedByUserID = dbo.Users.UserID
where ItemID = @ItemID
order by HtmlTextLog.CreatedOnDate desc
GO
/****** Object:  StoredProcedure [dbo].[GetHtmlTextUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetHtmlTextUser]

@UserID int

as

select HtmlTextUsers.*,
       WorkflowStates.StateName
from   dbo.HtmlTextUsers
inner join dbo.WorkflowStates on dbo.HtmlTextUsers.StateID = dbo.WorkflowStates.StateID
where  HtmlTextUsers.UserID = @UserID
order by HtmlTextUsers.CreatedOnDate asc
GO
/****** Object:  StoredProcedure [dbo].[GetIPFilter]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetIPFilter]
@InputFilter int
AS 
	SELECT * FROM dbo.IPFilter where IPFilterID=@InputFilter
GO
/****** Object:  StoredProcedure [dbo].[GetIPFilters]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetIPFilters]

AS 
	SELECT * FROM dbo.IPFilter
GO
/****** Object:  StoredProcedure [dbo].[GetJavaScriptLibraries]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetJavaScriptLibraries]
AS
	SELECT * FROM dbo.JavaScriptLibraries
GO
/****** Object:  StoredProcedure [dbo].[GetLanguagePackByPackage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetLanguagePackByPackage]

	@PackageID int

AS
	SELECT * FROM dbo.LanguagePacks 
        WHERE  PackageID = @PackageID
GO
/****** Object:  StoredProcedure [dbo].[GetLanguages]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetLanguages]
AS
	SELECT *
		FROM   dbo.Languages
GO
/****** Object:  StoredProcedure [dbo].[GetLanguagesByPortal]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetLanguagesByPortal]
    @PortalId			int
AS
    SELECT 
        L.*,
        PL.PortalId,
        PL.IsPublished
    FROM   dbo.Languages L
        INNER JOIN dbo.PortalLanguages PL On L.LanguageID = PL.LanguageID
    WHERE PL.PortalID = @PortalID
GO
/****** Object:  StoredProcedure [dbo].[GetLegacyFolderCount]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetLegacyFolderCount]
AS
	SELECT COUNT(*)
	FROM dbo.Folders
		WHERE ParentID IS NULL AND FolderPath <> ''
GO
/****** Object:  StoredProcedure [dbo].[GetList]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetList]
	@ListName nvarchar(50),
	@ParentKey nvarchar(150),
	@PortalID int
AS
SELECT DISTINCT
		ListName,
		[Level],
		DefinitionID,
		PortalID,
		SystemList,
		EntryCount,
		ParentID,
		ParentKey,
		Parent,
		ParentList,
		MaxSortOrder
	FROM dbo.vw_Lists
	WHERE ListName = @ListName
		AND ParentKey = @ParentKey
		AND PortalID = @PortalID
	ORDER BY [Level], ListName
GO
/****** Object:  StoredProcedure [dbo].[GetListEntries]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetListEntries]
	@ListName nvarchar(50),
	@ParentKey nvarchar(150),
	@PortalID int
AS
SELECT *
	FROM dbo.vw_Lists
	WHERE (ListName = @ListName OR @ListName='')
		AND (ParentKey = @ParentKey OR @ParentKey = '')
		AND (PortalID = @PortalID OR PortalID = -1 OR @PortalID IS NULL or SystemList=1)
	ORDER BY [Level], ListName, SortOrder, Text
GO
/****** Object:  StoredProcedure [dbo].[GetListEntry]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetListEntry]

	@ListName nvarchar(50),
	@Value nvarchar(200),
	@EntryID int

AS
	SELECT *
	FROM dbo.vw_Lists
	WHERE ([ListName] = @ListName OR @ListName='')
		AND ([EntryID]=@EntryID OR @EntryID = -1)
		AND ([Value]=@Value OR @Value = '')
GO
/****** Object:  StoredProcedure [dbo].[GetLists]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetLists]
	
	@PortalID int

AS
	SELECT DISTINCT 
		ListName,
		[Level],
		DefinitionID,
		PortalID,
		SystemList,
		EntryCount,
		ParentID,
		ParentKey,
		Parent,
		ParentList,
		MaxSortOrder
	FROM dbo.vw_Lists
	WHERE PortalID = @PortalID
	ORDER BY [Level], ListName
GO
/****** Object:  StoredProcedure [dbo].[GetMetaData]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetMetaData] 
	@ContentItemId   int
AS
	SELECT md.MetaDataName, cmd.MetaDataValue
	FROM dbo.[ContentItems_MetaData] cmd
	JOIN dbo.[MetaData] md on (cmd.MetaDataID = md.MetaDataID)
	WHERE ContentItemId = @ContentItemId
GO
/****** Object:  StoredProcedure [dbo].[GetModule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetModule]

	@ModuleId int,
	@TabId    int
	
AS
SELECT	* 
FROM dbo.vw_Modules
WHERE   ModuleId = @ModuleId
AND     (TabId = @TabId or @TabId is null)
GO
/****** Object:  StoredProcedure [dbo].[GetModuleByDefinition]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetModuleByDefinition]
      @PortalId int,
      @DefinitionName nvarchar(128)
AS
	SELECT M.*   
	FROM dbo.vw_Modules M
		INNER JOIN dbo.ModuleDefinitions as MD ON M.ModuleDefID = MD.ModuleDefID
		INNER JOIN dbo.Tabs as T ON M.TabID = T.TabID
	WHERE ((M.PortalId = @PortalId) or (M.PortalId is null and @PortalID is null))
		AND MD.DefinitionName = @DefinitionName
		AND M.IsDeleted = 0
		AND T.IsDeleted = 0
GO
/****** Object:  StoredProcedure [dbo].[GetModuleByUniqueID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetModuleByUniqueID]
    @UniqueID   uniqueidentifier
AS
	SELECT	* 
	FROM	dbo.vw_Modules
	WHERE	UniqueID = @UniqueID
GO
/****** Object:  StoredProcedure [dbo].[GetModuleControls]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetModuleControls]
AS
    SELECT *
    FROM   dbo.ModuleControls
	ORDER BY  ControlKey, ViewOrder
GO
/****** Object:  StoredProcedure [dbo].[GetModuleDefinitions]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetModuleDefinitions]
AS
    SELECT *
    FROM   dbo.ModuleDefinitions
GO
/****** Object:  StoredProcedure [dbo].[GetModulePackagesInUse]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetModulePackagesInUse]
	@PortalID INT,
	@ForHost BIT
AS

IF (@ForHost = 1)
	-- Get in use for all host pages and portal pages
	SELECT AllPackages.* FROM dbo.Packages AS AllPackages
		INNER JOIN (
			SELECT DISTINCT P.PackageID
			FROM dbo.Packages P
				INNER JOIN dbo.DesktopModules DM 
					ON P.PackageID=DM.PackageID
				INNER JOIN dbo.vw_Modules M
					ON M.DesktopModuleID=DM.DesktopModuleID
				INNER JOIN dbo.tabs T 
					ON T.TabID=M.TabID
			WHERE T.IsDeleted=0
				AND M.IsDeleted=0) AS InUsePackages
		ON AllPackages.PackageID = InUsePackages.PackageID
	ORDER BY AllPackages.FriendlyName
ELSE
	-- Get in use for portal or host only
	SELECT AllPackages.* FROM dbo.Packages AS AllPackages
		INNER JOIN (
			SELECT DISTINCT P.PackageID
			FROM dbo.Packages P
				INNER JOIN dbo.DesktopModules DM 
					ON P.PackageID=DM.PackageID
				INNER JOIN dbo.vw_Modules M
					ON M.DesktopModuleID=DM.DesktopModuleID
				INNER JOIN dbo.tabs T 
					ON T.TabID=M.TabID
			WHERE ((@PortalID IS NULL AND T.PortalID IS NULL) OR T.PortalID = @PortalID)
				AND T.IsDeleted=0
				AND M.IsDeleted=0) AS InUsePackages
		ON AllPackages.PackageID = InUsePackages.PackageID
	ORDER BY AllPackages.FriendlyName
GO
/****** Object:  StoredProcedure [dbo].[GetModulePermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetModulePermission]
	
	@ModulePermissionID int

AS
SELECT *
FROM dbo.vw_ModulePermissions
WHERE ModulePermissionID = @ModulePermissionID
GO
/****** Object:  StoredProcedure [dbo].[GetModulePermissionsByModuleID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetModulePermissionsByModuleID]
    @ModuleId       Int,   -- Null|-1 for all modules
    @PermissionId   Int    -- Null|-1 for all permissions
AS
BEGIN
	IF (IsNull(@ModuleId, -1) = -1) -- separate branches with individual query optimization
		SELECT *
		  FROM dbo.[vw_ModulePermissions]
		 WHERE (PermissionID = @PermissionId OR IsNull(@PermissionId, -1) = -1)
	 ELSE
		SELECT *
		FROM dbo.[vw_ModulePermissions]
		WHERE ((ModuleID = @ModuleId) OR (ModuleID IS NULL AND PermissionCode = 'SYSTEM_MODULE_DEFINITION'))
		AND (PermissionID = @PermissionId OR IsNull(@PermissionId, -1) = -1)
END
GO
/****** Object:  StoredProcedure [dbo].[GetModulePermissionsByPortal]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetModulePermissionsByPortal]
    @PortalId Int -- Not Null!
AS
    SELECT *
    FROM dbo.[vw_ModulePermissions]
    WHERE PortalID = @PortalID
GO
/****** Object:  StoredProcedure [dbo].[GetModulePermissionsByTabID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetModulePermissionsByTabID]
    @TabId Int -- Not Null!
AS
    SELECT MP.*
    FROM        dbo.[Tabs]                 AS T
    INNER JOIN  dbo.[TabModules]           AS TM ON TM.TabID    = T.TabID
    INNER JOIN  dbo.[vw_ModulePermissions] AS MP ON TM.ModuleID = MP.ModuleID AND T.PortalID = MP.PortalID
    WHERE T.TabID = @TabId
GO
/****** Object:  StoredProcedure [dbo].[GetModules]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetModules]

	@PortalID int
	
AS
SELECT	* 
FROM dbo.vw_Modules
WHERE  PortalId = @PortalID
ORDER BY ModuleId
GO
/****** Object:  StoredProcedure [dbo].[GetModuleSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetModuleSetting]
    @ModuleId      Int,          -- not null!
    @SettingName   nVarChar(50)  -- not null or empty!
AS
	BEGIN
		SELECT
			MS.SettingName,
			CASE WHEN Lower(MS.SettingValue) LIKE 'fileid=%'
				 THEN dbo.FilePath(MS.SettingValue)
				 ELSE MS.SettingValue  END AS SettingValue
		FROM dbo.[ModuleSettings] MS
		WHERE  ModuleID = @ModuleId AND SettingName = @SettingName
	END
GO
/****** Object:  StoredProcedure [dbo].[GetModuleSettings]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetModuleSettings]
    @ModuleId Int -- Null: settings from all modules
AS
	BEGIN
		SELECT
			MS.SettingName,
			CASE WHEN Lower(MS.SettingValue) LIKE 'fileid=%'
				 THEN dbo.FilePath(MS.SettingValue)
				 ELSE MS.SettingValue END           AS SettingValue
		FROM   dbo.[ModuleSettings] MS
		WHERE  ModuleID = @ModuleId or IsNull(@ModuleId, -1) = -1
		OPTION (OPTIMIZE FOR (@ModuleId UNKNOWN))
	END
GO
/****** Object:  StoredProcedure [dbo].[GetModuleSettingsByTab]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetModuleSettingsByTab]
    @TabId Int
AS
	BEGIN
		SELECT
			MS.ModuleID,
			MS.SettingName,
			CASE WHEN Lower(MS.SettingValue) LIKE 'fileid=%'
				 THEN dbo.FilePath(MS.SettingValue)
				 ELSE MS.SettingValue END           
				 AS SettingValue
		FROM   dbo.[ModuleSettings] MS
			INNER JOIN dbo.[TabModules] TM ON MS.ModuleID = TM.ModuleID
		WHERE  TM.TabID = @TabId
		ORDER BY MS.ModuleID
	END
GO
/****** Object:  StoredProcedure [dbo].[GetOnlineUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOnlineUser]
	@UserID int
AS

	SELECT
		U.UserID,
		U.UserName
	FROM dbo.Users U
	WHERE U.UserID = @UserID
		AND EXISTS (
			select 1 from dbo.UsersOnline UO where UO.UserID = U.UserID
		)
GO
/****** Object:  StoredProcedure [dbo].[GetOnlineUsers]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOnlineUsers]
	@PortalID int
AS
	SELECT *
		FROM dbo.UsersOnline UO
			INNER JOIN dbo.vw_Users U ON UO.UserID = U.UserID 
			INNER JOIN dbo.UserPortals UP ON U.UserID = UP.UserId
		WHERE  UP.PortalID = @PortalID AND U.PortalID = @PortalID
GO
/****** Object:  StoredProcedure [dbo].[GetPackageDependencies]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPackageDependencies]
AS
	SELECT * FROM dbo.[PackageDependencies]
GO
/****** Object:  StoredProcedure [dbo].[GetPackages]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPackages]
	@PortalID	int
AS
	SELECT *
		FROM   dbo.Packages
		WHERE (PortalID = @PortalID OR @PortalID IS NULL OR PortalID IS NULL)
		ORDER BY PackageType ASC, [FriendlyName] ASC
GO
/****** Object:  StoredProcedure [dbo].[GetPackageTypes]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPackageTypes]
AS
	SELECT * FROM dbo.PackageTypes
GO
/****** Object:  StoredProcedure [dbo].[GetPasswordHistory]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPasswordHistory]
    @UserID			int
AS
        SELECT * from dbo.PasswordHistory where UserID=@UserID
GO
/****** Object:  StoredProcedure [dbo].[GetPermissions]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPermissions]
AS
	SELECT * FROM dbo.Permission
	ORDER BY ViewOrder
GO
/****** Object:  StoredProcedure [dbo].[GetPortalAliases]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPortalAliases]
AS
	SELECT * FROM dbo.PortalAlias
GO
/****** Object:  StoredProcedure [dbo].[GetPortalByPortalAliasID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPortalByPortalAliasID]

	@PortalAliasId  int

AS
SELECT P.*
FROM dbo.vw_Portals P
	INNER JOIN dbo.PortalAlias PA ON P.PortalID = PA.PortalID
WHERE PA.PortalAliasId = @PortalAliasId
GO
/****** Object:  StoredProcedure [dbo].[GetPortalDefaultLanguage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPortalDefaultLanguage]

	@PortalId            int

AS
	SELECT defaultlanguage
		FROM dbo.Portals
		where portalid=@PortalId
GO
/****** Object:  StoredProcedure [dbo].[GetPortalDesktopModules]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPortalDesktopModules]
	@PortalId int,
	@DesktopModuleId int

AS
	SELECT PortalDesktopModules.*,
		   PortalName,
		   FriendlyName
	FROM   PortalDesktopModules
		INNER JOIN vw_Portals ON PortalDesktopModules.PortalId = vw_Portals.PortalId
		INNER JOIN DesktopModules ON PortalDesktopModules.DesktopModuleId = DesktopModules.DesktopModuleId
	WHERE  ((PortalDesktopModules.PortalId = @PortalId) OR @PortalId is null)
		AND    ((PortalDesktopModules.DesktopModuleId = @DesktopModuleId) OR @DesktopModuleId is null)
	ORDER BY PortalDesktopModules.PortalId, PortalDesktopModules.DesktopModuleId
GO
/****** Object:  StoredProcedure [dbo].[GetPortalGroups]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPortalGroups]

AS 
	SELECT * FROM dbo.PortalGroups
GO
/****** Object:  StoredProcedure [dbo].[GetPortalRoles]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPortalRoles]
    @PortalId     Int -- Null: Host Roles
AS
BEGIN
    SELECT R.*,
          (SELECT COUNT(*) FROM dbo.[UserRoles] U WHERE U.RoleID = R.RoleID) AS UserCount
     FROM dbo.[Roles] R
    WHERE (R.PortalId = @PortalId OR R.PortalId is null)
      AND (R.RoleId >= 0) -- DNN-4288: hide system role atm to prevent duplicates. Might be removed, after API has been adopt
    ORDER BY R.RoleName
	OPTION (OPTIMIZE FOR (@PortalId UNKNOWN))
END
GO
/****** Object:  StoredProcedure [dbo].[GetPortals]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPortals]
    @CultureCode	nvarchar(50)
AS

SELECT * 
FROM   dbo.[vw_Portals]
WHERE CultureCode = 
	CASE 
		WHEN IsNull(@CultureCode, '') = '' THEN DefaultLanguage
		WHEN @CultureCode = 'en-US' THEN DefaultLanguage
		ELSE @CultureCode 
	END 
ORDER BY PortalName;
GO
/****** Object:  StoredProcedure [dbo].[GetPortalsByName]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPortalsByName]

    @NameToMatch	nvarchar(256),
    @PageIndex			int,
    @PageSize			int
AS
	BEGIN
		-- Set the page bounds
		DECLARE @PageLowerBound INT
		DECLARE @PageUpperBound INT
		SET @PageLowerBound = @PageSize * @PageIndex
		SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

		-- Create a temp table TO store the select results
		CREATE TABLE #PageIndexForPortals
		(
			IndexId int IDENTITY (0, 1) NOT NULL,
			PortalId int
		)

		-- Insert into our temp table
		INSERT INTO #PageIndexForPortals (PortalId)
			SELECT PortalId FROM	dbo.vw_PortalsDefaultLanguage
			WHERE  PortalName LIKE @NameToMatch
			ORDER BY PortalName

		SELECT  *
		FROM	dbo.vw_PortalsDefaultLanguage p, 
				#PageIndexForPortals i
		WHERE  p.PortalId = i.PortalId
				AND i.IndexId >= @PageLowerBound AND i.IndexId <= @PageUpperBound
		ORDER BY p.PortalName

		SELECT  TotalRecords = COUNT(*)
		FROM    #PageIndexForPortals
	END
GO
/****** Object:  StoredProcedure [dbo].[GetPortalsByUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPortalsByUser]
	@userID		int 
AS

	SELECT     dbo.vw_Portals.*
FROM         dbo.UserPortals INNER JOIN
                      dbo.vw_Portals ON 
					  dbo.UserPortals.PortalId = dbo.vw_Portals.PortalID
WHERE     (dbo.UserPortals.UserId = @userID)
		AND (dbo.vw_Portals.DefaultLanguage = dbo.vw_Portals.CultureCode)
GO
/****** Object:  StoredProcedure [dbo].[GetPortalSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPortalSetting]
    @PortalID    Int,		    -- Not Null
    @SettingName nVarChar(50),	-- Not Null
    @CultureCode nVarChar(50)	-- Null|-1 for neutral language
AS
BEGIN
	SELECT TOP (1)
		SettingName,
		CASE WHEN Lower(SettingValue) Like 'fileid=%'
		 THEN dbo.[FilePath](SettingValue)
		 ELSE SettingValue 
		END   AS SettingValue,
		CreatedByUserID,
		CreatedOnDate,
		LastModifiedByUserID,
		LastModifiedOnDate,
		CultureCode
	 FROM  dbo.[PortalSettings]
	 WHERE PortalID    = @PortalID
	   AND SettingName = @SettingName
	   AND COALESCE(CultureCode, @CultureCode,'') = IsNull(@CultureCode,'')
	 ORDER BY IsNull(CultureCode,'') DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetPortalSettings]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPortalSettings]
    @PortalId    Int,            -- not Null!
    @CultureCode nVarChar(20)    -- Null|'' for neutral language
AS
BEGIN
	DECLARE @DefaultLanguage nVarChar(20) = '';

	IF EXISTS (SELECT * FROM dbo.[PortalLocalization] L
					JOIN dbo.[Portals] P ON L.PortalID = P.PortalID AND L.CultureCode = P.DefaultLanguage
					WHERE P.PortalID = @PortalID)
		SELECT @DefaultLanguage = DefaultLanguage 
		FROM dbo.[Portals] 
		WHERE PortalID = @PortalID

	SELECT
		PS.SettingName,
		CASE WHEN Lower(PS.SettingValue) LIKE 'fileid=%'
			THEN dbo.FilePath(PS.SettingValue)
			ELSE PS.SettingValue END   AS SettingValue,
		PS.CreatedByUserID,
		PS.CreatedOnDate,
		PS.LastModifiedByUserID,
		PS.LastModifiedOnDate,
		PS.CultureCode
		FROM dbo.[PortalSettings] PS
	WHERE 
		PortalID = @PortalId  AND 
		COALESCE(CultureCode, @CultureCode, @DefaultLanguage) = IsNull(@CultureCode, @DefaultLanguage)
END
GO
/****** Object:  StoredProcedure [dbo].[GetPortalSpaceUsed]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPortalSpaceUsed]
	@PortalId INT     -- Null|-1: Host files
AS
	BEGIN
		SELECT SUM(CAST(Size as bigint)) AS SpaceUsed
		FROM dbo.Files
		WHERE (IsNull(PortalID, -1) = IsNull(@PortalId, -1))
	END
GO
/****** Object:  StoredProcedure [dbo].[GetProfile]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetProfile]

@UserID    int, 
@PortalID  int

as

select *
from   dbo.Profile
where  UserId = @UserID 
and    PortalId = @PortalID
GO
/****** Object:  StoredProcedure [dbo].[GetPropertyDefinition]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPropertyDefinition]

	@PropertyDefinitionID	int

AS
SELECT	dbo.ProfilePropertyDefinition.*
FROM	dbo.ProfilePropertyDefinition
WHERE PropertyDefinitionID = @PropertyDefinitionID
	AND Deleted = 0
GO
/****** Object:  StoredProcedure [dbo].[GetPropertyDefinitionByName]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPropertyDefinitionByName]
	@PortalID	int,
	@Name		nvarchar(50)

AS
SELECT	*
	FROM	dbo.ProfilePropertyDefinition
	WHERE  (PortalId = @PortalID OR (PortalId IS NULL AND @PortalID IS NULL))
		AND PropertyName = @Name
	ORDER BY ViewOrder
GO
/****** Object:  StoredProcedure [dbo].[GetPropertyDefinitionsByCategory]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPropertyDefinitionsByCategory]
	@PortalID	int,
	@Category	nvarchar(50)

AS
SELECT	*
	FROM	dbo.ProfilePropertyDefinition
	WHERE  (PortalId = @PortalID OR (PortalId IS NULL AND @PortalID IS NULL))
		AND PropertyCategory = @Category
	ORDER BY ViewOrder
GO
/****** Object:  StoredProcedure [dbo].[GetPropertyDefinitionsByPortal]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPropertyDefinitionsByPortal]

	@PortalID	int

AS
SELECT	dbo.ProfilePropertyDefinition.*
	FROM	dbo.ProfilePropertyDefinition
	WHERE  (PortalId = @PortalID OR (PortalId IS NULL AND @PortalID IS NULL))		
	ORDER BY ViewOrder
GO
/****** Object:  StoredProcedure [dbo].[GetRelationship]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRelationship] @RelationshipID INT
AS 
    SELECT  RelationshipID,
            RelationshipTypeID,            
            Name,            
            Description,
            UserID,
            PortalID,
            DefaultResponse,
            CreatedByUserID ,
            CreatedOnDate ,
            LastModifiedByUserID ,
            LastModifiedOnDate
    FROM    dbo.Relationships    
	WHERE RelationshipID = @RelationshipID
	ORDER BY RelationshipID ASC
GO
/****** Object:  StoredProcedure [dbo].[GetRelationshipsByPortalID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRelationshipsByPortalID] @PortalID INT
AS 
    SELECT  RelationshipID,
			RelationshipTypeID,            
            Name,            
            Description,
			UserID,
			PortalID,
			DefaultResponse,
            CreatedByUserID ,
            CreatedOnDate ,
            LastModifiedByUserID ,
            LastModifiedOnDate
    FROM    dbo.Relationships    
	WHERE PortalID = @PortalID AND UserID IS NULL
	ORDER BY RelationshipID ASC
GO
/****** Object:  StoredProcedure [dbo].[GetRelationshipsByUserID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRelationshipsByUserID] @UserID INT
AS 
    SELECT  RelationshipID,
			RelationshipTypeID,            
            Name,            
            Description,
			UserID,
			PortalID,
			DefaultResponse,
            CreatedByUserID ,
            CreatedOnDate ,
            LastModifiedByUserID ,
            LastModifiedOnDate
    FROM    dbo.Relationships    
	WHERE UserID = @UserID
	ORDER BY RelationshipID ASC
GO
/****** Object:  StoredProcedure [dbo].[GetRelationshipType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRelationshipType] @RelationshipTypeID INT
AS 
    SELECT  RelationshipTypeID,
            Direction,
            Name ,            
            Description,
            CreatedByUserID ,
            CreatedOnDate ,
            LastModifiedByUserID ,
            LastModifiedOnDate
    FROM    dbo.RelationshipTypes    
	WHERE RelationshipTypeID = @RelationshipTypeID
	ORDER BY RelationshipTypeID ASC
GO
/****** Object:  StoredProcedure [dbo].[GetRoleGroup]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRoleGroup]
	@PortalID		int,
	@RoleGroupId    int
AS
	SELECT *
		FROM dbo.RoleGroups
		WHERE  (RoleGroupId = @RoleGroupId OR RoleGroupId IS NULL AND @RoleGroupId IS NULL)
			AND    PortalId = @PortalID
GO
/****** Object:  StoredProcedure [dbo].[GetRoleGroupByName]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRoleGroupByName]
	@PortalID		int,
	@RoleGroupName	nvarchar(50)
AS
	SELECT *
		FROM dbo.RoleGroups
		WHERE  PortalId = @PortalID 
			AND RoleGroupName = @RoleGroupName
GO
/****** Object:  StoredProcedure [dbo].[GetRoleGroups]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRoleGroups]
	@PortalID		int
AS
	SELECT *
		FROM dbo.RoleGroups
		WHERE  PortalId = @PortalID
		ORDER BY RoleGroupName
GO
/****** Object:  StoredProcedure [dbo].[GetRoles]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRoles]
AS
BEGIN
    SELECT R.*,
          (SELECT COUNT(*) FROM dbo.[UserRoles] U WHERE U.RoleID = R.RoleID) AS UserCount
     FROM dbo.[Roles] AS R
     WHERE RoleID >= 0 -- ignore virtual roles. Note: might be removed, after controller has been adjusted
END
GO
/****** Object:  StoredProcedure [dbo].[GetRolesBasicSearch]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRolesBasicSearch]
    @PortalID           Int,                    -- might be null for all portals
    @PageIndex          Int,                    -- page number starting at 0
    @PageSize           Int,                    -- number of items per page
    @FilterBy           nVarChar(100)           -- pattern for role name, do not use preceding or trailing wildcards
AS
BEGIN
    IF IsNull(@FilterBy, '') <> '' BEGIN
        IF Substring(@FilterBy, 1, 1) = '%'
            SET @FilterBy = Substring(@FilterBy, 2, Len(@FilterBy) - 1)
        IF Substring(@FilterBy, Len(@FilterBy), 1) = '%'
            SET @FilterBy = Substring(@FilterBy, 1, Len(@FilterBy) - 1)
     END;

	IF IsNull(@PageIndex,-1) >= 0 AND IsNull(@PageSize, 0) > 0 AND IsNull(@PageSize, 0) < Cast(0x7fffffff AS Int)
		WITH OrderedRoles AS (
			SELECT RoleID, PortalID, RoleName, [Description], ServiceFee, BillingFrequency, TrialPeriod, TrialFrequency, BillingPeriod, TrialFee,
				   IsPublic, AutoAssignment, RoleGroupID, RSVPCode, dbo.FilePath(IconFile) AS IconFile, Status, SecurityMode,
				   CreatedByUserID,CreatedOnDate,LastModifiedByUserID,LastModifiedOnDate,
				   ROW_NUMBER() OVER (ORDER BY RoleName ASC, PortalID DESC) AS RowNum
			 FROM dbo.[Roles]
			 WHERE (RoleName LIKE '%' + @FilterBy + '%' OR IsNull(@FilterBy,'') = '')
			   AND (PortalID = @PortalID OR IsNull(@PortalID, -1)  = -1)
			   AND (RoleId  > 0) -- DNN-4288: ignore virtual roles
			)
		SELECT * FROM OrderedRoles WHERE RowNum >= dbo.PageLowerBound(@PageIndex, @Pagesize)
									 AND RowNum <= dbo.PageUpperBound(@PageIndex, @Pagesize) ORDER BY RowNum
		 OPTION (OPTIMIZE FOR (@PortalId UNKNOWN));
	ELSE -- no paging
        SELECT RoleID, PortalID, RoleName, [Description], ServiceFee, BillingFrequency, TrialPeriod, TrialFrequency, BillingPeriod, TrialFee,
               IsPublic, AutoAssignment, RoleGroupID, RSVPCode, dbo.FilePath(IconFile) AS IconFile, Status, SecurityMode,
               CreatedByUserID,CreatedOnDate,LastModifiedByUserID,LastModifiedOnDate,
               ROW_NUMBER() OVER (ORDER BY RoleName ASC, PortalID DESC) AS RowNum
         FROM dbo.[Roles]
         WHERE (RoleName LIKE '%' + @FilterBy + '%' OR IsNull(@FilterBy,'') = '')
           AND (PortalID = @PortalID OR IsNull(@PortalID, -1)  = -1)
           AND (RoleId  > 0) -- DNN-4288: ignore virtual roles
		 OPTION (OPTIMIZE FOR (@PortalId UNKNOWN))
END
GO
/****** Object:  StoredProcedure [dbo].[GetRoleSettings]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRoleSettings]
	@RoleId     int

AS
	SELECT *
	FROM dbo.RoleSettings
	WHERE  RoleID = @RoleId
GO
/****** Object:  StoredProcedure [dbo].[GetSchedule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSchedule]
 @Server varchar(150)
AS
BEGIN
SELECT
  S.*
  , (SELECT max(S1.NextStart)
   FROM dbo.ScheduleHistory S1
   WHERE S1.ScheduleID = S.ScheduleID) as NextStart
 FROM dbo.Schedule S
 WHERE
  (@Server IS NULL OR S.Servers LIKE '%,' + @Server + ',%' OR S.Servers IS NULL)
  ORDER BY FriendlyName ASC
END
GO
/****** Object:  StoredProcedure [dbo].[GetScheduleByEvent]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetScheduleByEvent]
	@EventName	varchar(50),
	@Server		varchar(150)
AS
    SELECT S.*
	FROM dbo.[Schedule] S
	WHERE S.AttachToEvent = @EventName
		AND (@Server IS NULL OR ISNULL(s.Servers, '') = '' OR ',' + s.Servers + ',' LIKE '%,' + @Server + ',%')
GO
/****** Object:  StoredProcedure [dbo].[GetScheduleByScheduleID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetScheduleByScheduleID]
@ScheduleID int
AS
SELECT S.*
FROM dbo.Schedule S
WHERE S.ScheduleID = @ScheduleID
GO
/****** Object:  StoredProcedure [dbo].[GetScheduleByTypeFullName]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetScheduleByTypeFullName]
	@TypeFullName	varchar(200),
	@Server			varchar(150)
AS
    SELECT S.*
	FROM dbo.[Schedule] S
	WHERE S.TypeFullName = @TypeFullName 
		AND (@Server IS NULL OR ISNULL(s.Servers, '') = '' OR ',' + s.Servers + ',' LIKE '%,' + @Server + ',%')
GO
/****** Object:  StoredProcedure [dbo].[GetScheduleHistory]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetScheduleHistory] @ScheduleID INT
AS 
    SELECT  S.* ,
            SH.*
    FROM    dbo.Schedule S
            INNER JOIN dbo.ScheduleHistory SH ON S.ScheduleID = SH.ScheduleID
    WHERE   S.ScheduleID = @ScheduleID
            OR @ScheduleID = -1
    ORDER BY SH.StartDate DESC
GO
/****** Object:  StoredProcedure [dbo].[GetScheduleItemSettings]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetScheduleItemSettings] 
@ScheduleID int
AS
SELECT *
FROM dbo.ScheduleItemSettings
WHERE ScheduleID = @ScheduleID
GO
/****** Object:  StoredProcedure [dbo].[GetScheduleNextTask]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetScheduleNextTask]
	@Server varchar(150)
AS
SELECT TOP 1
        S.[ScheduleID] ,
        S.[TypeFullName] ,
        S.[TimeLapse] ,
        S.[TimeLapseMeasurement] ,
        S.[RetryTimeLapse] ,
        S.[RetryTimeLapseMeasurement] ,
        S.[RetainHistoryNum] ,
        S.[AttachToEvent] ,
        S.[CatchUpEnabled] ,
        S.[Enabled] ,
        S.[ObjectDependencies] ,
        S.[Servers] ,
        S.[CreatedByUserID] ,
        S.[CreatedOnDate] ,
        S.[LastModifiedByUserID] ,
        S.[LastModifiedOnDate] ,
        S.[FriendlyName] ,
        H.[NextStart]
FROM    dbo.[Schedule] S
        CROSS APPLY ( SELECT TOP 1
                                [NextStart]
                      FROM      dbo.[ScheduleHistory]
                      WHERE     ( [ScheduleID] = S.[ScheduleID] )
                      ORDER BY  [NextStart] DESC
                    ) AS H ( [NextStart] )
WHERE   ( S.[Enabled] = 1 )
        AND ( ( S.[Servers] LIKE ( ',%' + @Server + '%,' ) )
              OR ( S.[Servers] IS NULL )
            )
ORDER BY H.[NextStart] ASC
GO
/****** Object:  StoredProcedure [dbo].[GetScopeTypes]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetScopeTypes] 
AS
	SELECT *
	FROM dbo.Taxonomy_ScopeTypes
GO
/****** Object:  StoredProcedure [dbo].[GetSearchCommonWordByID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSearchCommonWordByID]
	@CommonWordID int
	
AS

SELECT
	[CommonWordID],
	[CommonWord],
	[Locale]
FROM
	dbo.SearchCommonWords
WHERE
	[CommonWordID] = @CommonWordID
GO
/****** Object:  StoredProcedure [dbo].[GetSearchCommonWordsByLocale]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSearchCommonWordsByLocale]
	@Locale nvarchar(10)
	
AS

SELECT
	[CommonWordID],
	[CommonWord],
	[Locale]
FROM
	dbo.SearchCommonWords
WHERE
	[Locale] = @Locale
GO
/****** Object:  StoredProcedure [dbo].[GetSearchIndexers]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetSearchIndexers]

as

select dbo.SearchIndexer.*
from dbo.SearchIndexer
GO
/****** Object:  StoredProcedure [dbo].[GetSearchModules]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSearchModules]

@PortalID int

AS
	SELECT *
	FROM dbo.vw_Modules M
		INNER JOIN dbo.Tabs T ON T.TabId = M.TabId
	WHERE  M.IsDeleted = 0  
		AND T.IsDeleted = 0  
		AND M.IsAdmin = 0
		AND (M.SupportedFeatures & 2 = 2)
		AND (T.EndDate > GETDATE() or T.EndDate IS NULL) 
		AND (T.StartDate <= GETDATE() or T.StartDate IS NULL) 
		AND (M.StartDate <= GETDATE() or M.StartDate IS NULL) 
		AND (M.EndDate > GETDATE() or M.EndDate IS NULL) 
		AND (NOT (M.BusinessControllerClass IS NULL))
		AND (T.PortalID = @PortalID OR (T.PortalID IS NULL AND @PortalID Is NULL))
	ORDER BY ModuleOrder
GO
/****** Object:  StoredProcedure [dbo].[GetSearchResultModules]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetSearchResultModules]

@PortalID int

AS

SELECT     
		TM.TabID, 
		T.TabName  AS SearchTabName
FROM	dbo.Modules M
INNER JOIN	dbo.ModuleDefinitions MD ON MD.ModuleDefID = M.ModuleDefID 
INNER JOIN	dbo.TabModules TM ON TM.ModuleID = M.ModuleID 
INNER JOIN	dbo.Tabs T ON T.TabID = TM.TabID
WHERE	MD.FriendlyName = N'Search Results'
	AND T.PortalID = @PortalID
	AND T.IsDeleted = 0
GO
/****** Object:  StoredProcedure [dbo].[GetSearchSettings]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSearchSettings]

	@ModuleID	int

AS
	SELECT     	settings.SettingName, 
				settings.SettingValue
	FROM	dbo.Modules m 
		INNER JOIN dbo.Portals p ON m.PortalID = p.PortalID 
		INNER JOIN dbo.PortalSettings settings ON p.PortalID = settings.PortalID
	WHERE   m.ModuleID = @ModuleID
		AND settings.SettingName LIKE 'Search%'
GO
/****** Object:  StoredProcedure [dbo].[GetSearchStopWords]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSearchStopWords]
	@PortalID int,
	@CultureCode nvarchar(50)
AS
BEGIN
	SELECT   
	  [StopWordsID],  
	  [StopWords],  
	  [CreatedByUserID],  
	  [CreatedOnDate],  
	  [LastModifiedByUserID],  
	  [LastModifiedOnDate],
	  [PortalID],
	  [CultureCode]
	FROM dbo.SearchStopWords 
	WHERE [PortalID] = @PortalID AND [CultureCode] = @CultureCode
END
GO
/****** Object:  StoredProcedure [dbo].[GetServers]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetServers] 
AS
	SELECT *
	FROM dbo.WebServers
	ORDER BY ServerName, IISAppName
GO
/****** Object:  StoredProcedure [dbo].[GetServices]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetServices]
    @PortalId  Int, -- pass Null for roles of all sites
    @UserId    Int  -- not null!
AS
BEGIN
    SELECT
        R.*,
        UR.IsOwner,
        UR.UserRoleID,
        UR.UserID,
        UR.ExpiryDate,
        UR.IsTrialUsed,
        UR.EffectiveDate,
        U.DisplayName,
        U.Email
    FROM         dbo.[Users]      U
     INNER JOIN  dbo.[UserRoles] UR ON UR.UserID = U.UserID
     RIGHT JOIN  dbo.[Roles]      R ON UR.RoleID = R.RoleID  AND UR.UserID = @UserId
    WHERE (R.PortalId = @PortalId OR IsNull(@PortalId, -1) = -1)
      AND  R.IsPublic = 1
      AND  R.RoleId  >= 0
	  AND U.UserID = @UserId
    ORDER BY R.RoleName
	OPTION (OPTIMIZE FOR (@PortalId UNKNOWN))
END
GO
/****** Object:  StoredProcedure [dbo].[GetSharedModulesByPortal]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSharedModulesByPortal]
	@Portald int
AS
	SELECT * FROM dbo.vw_TabModules tb		
	WHERE tb.PortalID != tb.OwnerPortalID	
	AND tb.OwnerPortalID = @Portald
GO
/****** Object:  StoredProcedure [dbo].[GetSharedModulesWithPortal]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSharedModulesWithPortal]
	@Portald int
AS
	SELECT * FROM dbo.vw_TabModules tb		
	WHERE tb.PortalID != tb.OwnerPortalID	
	AND tb.PortalID = @Portald
GO
/****** Object:  StoredProcedure [dbo].[GetSingleUserByEmail]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSingleUserByEmail]
    @PortalId INT,
	@Email nvarchar(255)
AS 
	SELECT ISNULL((SELECT TOP 1 U.UserId from dbo.[Users] U Inner Join dbo.[UserPortals] UP on UP.[UserId] = U.[UserId] Where U.Email = @Email and UP.[PortalId] = @PortalId), -1)
GO
/****** Object:  StoredProcedure [dbo].[GetSiteLog1]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSiteLog1]
	@PortalID 	 Int,			-- not Null
	@PortalAlias nVarChar(50),  -- ignored
	@StartDate   DateTime,      -- Not Null
	@EndDate 	 DateTime		-- Not Null
AS
	BEGIN
		SELECT Convert(VarChar, DateTime, 102)   AS 'Date',
			   Count(*) 						 AS 'Views',
			   Count(Distinct L.UserHostAddress) AS 'Visitors',
			   Count(Distinct L.UserId)          AS 'Users'
		FROM dbo.SiteLog L
		WHERE PortalId = @PortalID
		  AND L.DateTime BETWEEN @StartDate AND @EndDate
		GROUP BY Convert(VarChar, DateTime, 102)
		ORDER BY Date DESC
	END
GO
/****** Object:  StoredProcedure [dbo].[GetSiteLog12]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSiteLog12]
	@PortalId 	 Int,			-- not Null
	@PortalAlias nVarChar(50),  -- ignored
	@StartDate   DateTime,      -- Not Null
	@EndDate 	 DateTime		-- Not Null
AS
BEGIN
	SELECT AffiliateId,
		Count(*) 		AS 'Requests',
		Max(DateTime) 	AS 'LastReferral'
	FROM dbo.SiteLog L
	WHERE L.PortalId = @PortalId
	  AND L.DateTime BETWEEN @StartDate AND @EndDate
	  AND AffiliateId Is NOT Null
	GROUP BY AffiliateId
	ORDER BY Requests DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetSiteLog2]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSiteLog2]
	@PortalId 	 Int,			-- not Null
	@PortalAlias nVarChar(50),  -- Portal Alias to be eliminated FROM Referrer
	@StartDate   DateTime,      -- Not Null
	@EndDate 	 DateTime		-- Not Null
AS
	BEGIN
		SELECT L.DateTime, 
		U.DisplayName AS 'Name',
		dbo.[AdjustedReferrer](L.Referrer, @PortalAlias) AS 'Referrer', 
		dbo.[BrowserFromUserAgent](L.UserAgent) AS 'UserAgent',
		L.UserHostAddress,
		T.TabName
		FROM      dbo.SiteLog L
		LEFT JOIN dbo.Users   U ON L.UserId = U.UserId 
		LEFT JOIN dbo.Tabs    T ON L.TabId  = T.TabId 
		WHERE L.PortalId = @PortalId
		  AND L.DateTime BETWEEN @StartDate AND @EndDate
		ORDER BY L.DateTime DESC
	END
GO
/****** Object:  StoredProcedure [dbo].[GetSiteLog3]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSiteLog3]
	@PortalId 	 Int,			-- not Null
	@PortalAlias nVarChar(50),  -- ignored
	@StartDate   DateTime,      -- Not Null
	@EndDate 	 DateTime		-- Not Null
AS
BEGIN
	SELECT U.DisplayName AS 'Name',
           count(*)      AS 'Requests',
           Max(DateTime) AS 'LastRequest'
	FROM       dbo.SiteLog L
	INNER JOIN dbo.Users   U on L.UserId = U.UserId
	WHERE L.PortalId = @PortalId
	  AND L.DateTime BETWEEN @StartDate AND @EndDate
	GROUP BY U.DisplayName
	ORDER BY Requests DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetSiteLog4]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSiteLog4]
	@PortalId 	 Int,			-- not Null
	@PortalAlias nVarChar(50),  -- Portal Alias to be eliminated FROM Referrer
	@StartDate   DateTime,      -- Not Null
	@EndDate 	 DateTime		-- Not Null
AS
BEGIN
	SELECT Referrer,
	Count(*)      AS 'Requests',
	Max(DateTime) AS 'LastRequest'
	FROM dbo.SiteLog L
	WHERE L.PortalId = @PortalID
	  AND L.DateTime BETWEEN @StartDate AND @EndDate
	  AND L.Referrer IS Not Null
	  AND L.Referrer Not Like '%' + @PortalAlias + '%'
	GROUP BY Referrer
	ORDER BY Requests DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetSiteLog5]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSiteLog5]
	@PortalId 	 Int,			-- not Null
	@PortalAlias nVarChar(50),  -- ignored
	@StartDate   DateTime,      -- Not Null
	@EndDate 	 DateTime		-- Not Null
AS
BEGIN
	SELECT dbo.[BrowserFromUserAgent](L.UserAgent) AS 'UserAgent',
		   Count(*)      AS 'Requests',
		   Max(DateTime) AS 'LastRequest'
	FROM dbo.SiteLog L
	WHERE PortalId = @PortalId
	  AND L.DateTime BETWEEN @StartDate AND @EndDate
	GROUP BY dbo.[BrowserFromUserAgent](L.UserAgent)
	ORDER BY Requests DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetSiteLog6]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSiteLog6]
	@PortalId 	 Int,			-- not Null
	@PortalAlias nVarChar(50),  -- ignored
	@StartDate   DateTime,      -- Not Null
	@EndDate 	 DateTime		-- Not Null
AS
BEGIN
	SELECT
		DatePart(Hour, DateTime)          AS 'Hour',
		Count(*)                          AS 'Views',
		Count(Distinct L.UserHostAddress) AS 'Visitors',
		Count(Distinct L.UserId) 		  AS 'Users'
	FROM dbo.SiteLog L
	WHERE PortalId = @PortalId
	  AND L.DateTime BETWEEN @StartDate AND @EndDate
	GROUP BY DatePart(Hour, DateTime)
	ORDER BY Hour
END
GO
/****** Object:  StoredProcedure [dbo].[GetSiteLog7]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSiteLog7]
	@PortalId 	 Int,			-- not Null
	@PortalAlias nVarChar(50),  -- ignored
	@StartDate   DateTime,      -- Not Null
	@EndDate 	 DateTime		-- Not Null
AS
BEGIN
	SELECT 
		DatePart(weekday, DateTime) 	  AS 'WeekDay',
		Count(*)                          AS 'Views',
		Count(Distinct L.UserHostAddress) AS 'Visitors',
		Count(Distinct L.UserId) 		  AS 'Users'
	FROM dbo.SiteLog L
	WHERE PortalId = @PortalId
	  AND L.DateTime BETWEEN @StartDate AND @EndDate
	GROUP BY DatePart(weekday, DateTime)
	ORDER BY WeekDay
END
GO
/****** Object:  StoredProcedure [dbo].[GetSiteLog8]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSiteLog8]
	@PortalId 	 Int,			-- not Null
	@PortalAlias nVarChar(50),  -- ignored
	@StartDate   DateTime,      -- Not Null
	@EndDate 	 DateTime		-- Not Null
AS	
BEGIN
	SELECT 
		DatePart(month, DateTime) 		  AS 'Month',
		Count(*)                          AS 'Views',
		Count(Distinct L.UserHostAddress) AS 'Visitors',
		Count(Distinct L.UserId) 		  AS 'Users'
	FROM dbo.SiteLog L
	WHERE PortalId = @PortalId
	  AND L.DateTime BETWEEN @StartDate AND @EndDate
	GROUP BY datepart(Month, L.DateTime)
	ORDER BY Month
END
GO
/****** Object:  StoredProcedure [dbo].[GetSiteLog9]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSiteLog9]
	@PortalId 	 Int,			-- not Null
	@PortalAlias nVarChar(50),  -- ignored
	@StartDate   DateTime,      -- Not Null
	@EndDate 	 DateTime		-- Not Null
AS	
BEGIN
	SELECT 
		T.TabName     AS 'Page',
		Count(*)      AS 'Requests',
		Max(DateTime) AS 'LastRequest'
	FROM       dbo.SiteLog L
	INNER JOIN dbo.Tabs    T ON L.TabId = T.TabId
	WHERE L.PortalId = @PortalId
	  AND L.DateTime BETWEEN @StartDate AND @EndDate
	GROUP BY T.TabName
	ORDER BY Requests DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetSkinControl]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSkinControl]
	@SkinControlID	int
AS
    SELECT *
    FROM   dbo.SkinControls
	WHERE SkinControlID = @SkinControlID
GO
/****** Object:  StoredProcedure [dbo].[GetSkinControlByKey]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSkinControlByKey]
	@ControlKey	nvarchar(50)
AS
    SELECT *
    FROM   dbo.SkinControls
	WHERE ControlKey = @ControlKey
GO
/****** Object:  StoredProcedure [dbo].[GetSkinControlByPackageID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSkinControlByPackageID]
	@PackageID	int
AS
    SELECT *
    FROM   dbo.SkinControls
	WHERE PackageID = @PackageID
GO
/****** Object:  StoredProcedure [dbo].[GetSkinControls]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSkinControls]
AS
    SELECT *
    FROM   dbo.SkinControls
	ORDER BY  ControlKey
GO
/****** Object:  StoredProcedure [dbo].[GetSkinPackage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSkinPackage]
	@PortalID   int,
	@SkinName   nvarchar(50),
	@SkinType   nvarchar(50)

AS
	SELECT *
		FROM  dbo.SkinPackages
		WHERE (PortalID = @PortalID OR @PortalID IS NULL Or PortalID IS Null)
			AND SkinName = @SkinName
			AND SkinType = @SkinType
GO
/****** Object:  StoredProcedure [dbo].[GetSkinPackageByPackageID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSkinPackageByPackageID]
	@PackageID int	
AS
BEGIN
 SELECT SP.*
  FROM  dbo.SkinPackages SP
  WHERE SP.PackageID = @PackageID

 SELECT I.*
  FROM  dbo.Skins I
 INNER JOIN dbo.SkinPackages S ON S.SkinPackageID = I.SkinPackageID
 WHERE S.PackageID = @PackageID
END
GO
/****** Object:  StoredProcedure [dbo].[GetSystemMessage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSystemMessage]
 @PortalID     int,
 @MessageName  nvarchar(50)
AS
BEGIN
 if @PortalID is null
 begin
  select MessageValue
  from   dbo.SystemMessages
  where  PortalID is null and MessageName = @MessageName
 end else begin
  select MessageValue
  from   dbo.SystemMessages
  where  PortalID = @PortalID and MessageName = @MessageName
 end
END
GO
/****** Object:  StoredProcedure [dbo].[GetSystemMessages]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetSystemMessages]

as

select MessageName
from   dbo.SystemMessages
where  PortalID is null
GO
/****** Object:  StoredProcedure [dbo].[GetTab]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTab]

@TabId    int

AS
SELECT *
FROM   dbo.vw_Tabs
WHERE  TabId = @TabId
GO
/****** Object:  StoredProcedure [dbo].[GetTabAliasSkins]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabAliasSkins] 
(
	 @PortalID		int 
)
AS
	SELECT 
		t.TabId, 
		pa.PortalAliasId, 
		pa.HttpAlias, 
		t.SkinSrc, 
		t.CreatedByUserId, 
		t.CreatedOnDate, 
		t.LastModifiedByUserId, 
		t.LastModifiedOnDate
	FROM dbo.TabAliasSkins t
		INNER JOIN dbo.PortalAlias pa ON t.PortalAliasId = pa.PortalAliasId
	WHERE pa.PortalID = @PortalID OR @PortalID = -1
GO
/****** Object:  StoredProcedure [dbo].[GetTabByUniqueID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabByUniqueID]
    @UniqueID   uniqueidentifier
AS
	SELECT	* 
	FROM	dbo.vw_Tabs
	WHERE	UniqueID = @UniqueID
GO
/****** Object:  StoredProcedure [dbo].[GetTabCustomAliases]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabCustomAliases] 
(
	 @PortalID		int 
)
AS
	SELECT 
		t.TabId, 
		Coalesce(trp.CultureCode, '') as CultureCode, 
		pa.HttpAlias
	FROM dbo.Tabs t
		INNER JOIN dbo.TabUrls trp ON trp.TabId = t.ParentId	
		INNER JOIN dbo.PortalAlias pa ON trp.PortalAliasId = pa.PortalAliasId
		WHERE trp.PortalAliasUsage = 1 /* child tabs inherit */
		  AND (@portalId = t.PortalId OR @portalId = -1)
		  AND NOT EXISTS (SELECT tr2.TabId 
							FROM dbo.TabUrls tr2 
							WHERE tr2.TabId = t.TabId 
								AND tr2.CultureCode = trp.CultureCode
							)
GO
/****** Object:  StoredProcedure [dbo].[GetTabModule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabModule]
    @TabModuleID	int
AS
    SELECT *
	FROM dbo.vw_TabModules        
    WHERE  TabModuleID = @TabModuleID
GO
/****** Object:  StoredProcedure [dbo].[GetTabModuleOrder]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabModuleOrder]
	@TabId    int, 			-- Not Null
	@PaneName nvarchar(50)  -- Not Null
AS
BEGIN
	SELECT *
	FROM TabModules 
	WHERE TabId    = @TabId 
	  AND PaneName = @PaneName
	ORDER BY TabId, PaneName, ModuleOrder -- optimized for index used
END
GO
/****** Object:  StoredProcedure [dbo].[GetTabModules]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabModules]
	@TabId int -- not null!
AS
BEGIN
	SELECT	* 
	FROM dbo.vw_TabModules
	WHERE  TabId = @TabId
	ORDER BY TabId, PaneName, ModuleOrder -- optimized for index used
END
GO
/****** Object:  StoredProcedure [dbo].[GetTabModuleSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabModuleSetting]
    @TabModuleId   Int,              -- not null!
    @SettingName   nVarChar(50)      -- not null or empty!
AS
	BEGIN
		SELECT
			TMS.SettingName,
			CASE WHEN TMS.SettingValue LIKE 'fileid%'
				 THEN dbo.FilePath(TMS.SettingValue)
				 ELSE TMS.SettingValue  END AS SettingValue
		FROM dbo.[TabModuleSettings] TMS
		WHERE  TabModuleID = @TabModuleId AND SettingName = @SettingName
	END
GO
/****** Object:  StoredProcedure [dbo].[GetTabModuleSettings]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabModuleSettings]
    @TabModuleId Int -- Null: all tabmodules
AS
	BEGIN
		SELECT
			TMS.SettingName,
			CASE WHEN Lower(TMS.SettingValue) LIKE 'fileid=%'
				 THEN dbo.FilePath(TMS.SettingValue)
				 ELSE TMS.SettingValue END           AS SettingValue
		FROM   dbo.[TabModuleSettings] TMS
		WHERE  TabModuleID = @TabModuleId OR IsNull(@TabModuleId, -1) = -1
		OPTION (OPTIMIZE FOR (@TabModuleId UNKNOWN))
	END
GO
/****** Object:  StoredProcedure [dbo].[GetTabModuleSettingsByTab]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabModuleSettingsByTab]
    @TabId Int
AS
	BEGIN
		SELECT
			TMS.TabModuleID,
			TMS.SettingName,
			CASE WHEN Lower(TMS.SettingValue) LIKE 'fileid=%'
				 THEN dbo.FilePath(TMS.SettingValue)
				 ELSE TMS.SettingValue END           
				 AS SettingValue
		FROM   dbo.[TabModuleSettings] TMS
			INNER JOIN dbo.[TabModules] TM ON TMS.TabModuleID = TM.TabModuleID
		WHERE  TM.TabID = @TabId
		ORDER BY TMS.TabModuleID
	END
GO
/****** Object:  StoredProcedure [dbo].[GetTabPanes]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetTabPanes]

@TabId    int

as

select distinct(PaneName) as PaneName
from   dbo.TabModules
where  TabId = @TabId
order by PaneName
GO
/****** Object:  StoredProcedure [dbo].[GetTabPaths]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabPaths] 
	@PortalID		int,
	@CultureCode	nvarchar(10)
AS
	SELECT
		TabID, 
		PortalID, 
		TabPath
	FROM dbo.vw_Tabs
	WHERE (PortalID = @PortalID AND (CultureCode = @CultureCode OR CultureCode Is Null))
		OR @PortalID Is NULL
GO
/****** Object:  StoredProcedure [dbo].[GetTabPermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabPermission]

	@TabPermissionID int

AS
SELECT *
FROM dbo.vw_TabPermissions
WHERE TabPermissionID = @TabPermissionID
GO
/****** Object:  StoredProcedure [dbo].[GetTabPermissionsByPortal]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetTabPermissionsByPortal]
	
	@PortalID int

AS

	IF @portalid is not null
		BEGIN 
			SELECT *
				FROM dbo.vw_TabPermissions
				WHERE PortalID = @PortalID
		END
	ELSE
		BEGIN
			SELECT *
				FROM dbo.vw_TabPermissions
				WHERE PortalID IS NULL 
		END
GO
/****** Object:  StoredProcedure [dbo].[GetTabPermissionsByTabID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabPermissionsByTabID]
	@TabID int, 
	@PermissionID int
AS

	SELECT  *
	FROM    dbo.vw_TabPermissions
	WHERE   (TabID = @TabID OR (TabID IS NULL AND PermissionCode = 'SYSTEM_TAB'))
		AND	(PermissionID = @PermissionID OR @PermissionID = -1)
GO
/****** Object:  StoredProcedure [dbo].[GetTabs]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabs]
	@PortalID Int  -- Null|-1 for host pages
AS
	SELECT *
	FROM   dbo.[vw_Tabs]
	WHERE  IsNull(PortalId, -1) = IsNull(@PortalID, -1)
	ORDER BY PortalId, [Level], ParentID, TabOrder -- PortalId added for query optimization
GO
/****** Object:  StoredProcedure [dbo].[GetTabsByModuleID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabsByModuleID]
	@ModuleID Int -- NOT Null
AS
BEGIN
	SELECT * FROM dbo.[vw_Tabs] T
	WHERE IsDeleted = 0
	  AND TabID IN (SELECT TabID FROM dbo.[TabModules]
					WHERE ModuleID = @ModuleID AND IsDeleted = 0)
	ORDER BY PortalId, Level, ParentID, TabOrder -- PortalId added for query optimization
END
GO
/****** Object:  StoredProcedure [dbo].[GetTabsByPackageID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabsByPackageID]
    @PortalId  Int, -- Null for Host menu items
    @PackageId Int, -- Not Null!
    @ForHost   Bit  -- 0: Get pages for a specific portal (or host pages only)
                    -- 1: Get all host pages and portal pages
AS
BEGIN
    SELECT * FROM dbo.[vw_Tabs]
     WHERE (IsNull(PortalId, -1) = IsNull(@PortalId, -1) Or @ForHost = 1)
       AND IsDeleted = 0
       AND TabId IN (SELECT TabId FROM dbo.[vw_Modules] M
                      INNER JOIN dbo.[DesktopModules] DM ON M.DesktopModuleID = DM.DesktopModuleID
                      WHERE DM.PackageID = @PackageId AND M.IsDeleted = 0)
    ORDER BY PortalID, TabName
	OPTION (OPTIMIZE FOR (@PortalId UNKNOWN, @PackageId UNKNOWN, @ForHost UNKNOWN));
END
GO
/****** Object:  StoredProcedure [dbo].[GetTabsByTabModuleID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabsByTabModuleID]
	@TabModuleID Int -- NOT Null
AS
	BEGIN
		SELECT * FROM dbo.[vw_Tabs] T
		WHERE IsDeleted = 0
		  AND TabID IN (SELECT TabID FROM dbo.[TabModules]
						WHERE TabModuleID = @TabModuleID AND IsDeleted = 0)
		ORDER BY PortalId, Level, ParentID, TabOrder -- PortalId added for query optimization
	END
GO
/****** Object:  StoredProcedure [dbo].[GetTabSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabSetting]

    @TabId         Int,         -- not null!
    @SettingName   nVarChar(50) -- not null or empty!

AS
	BEGIN
		SELECT
			TS.SettingName,
			CASE WHEN TS.SettingValue LIKE 'fileid%'
				 THEN dbo.FilePath(TS.SettingValue)
				 ELSE TS.SettingValue  END AS SettingValue
		FROM dbo.[TabSettings] TS
		WHERE  TabID = @TabId AND SettingName = @SettingName
	END
GO
/****** Object:  StoredProcedure [dbo].[GetTabSettings]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabSettings]
    @PortalId Int
AS
	BEGIN
		SELECT
			TS.TabID,
			TS.SettingName,
			CASE WHEN Lower(TS.SettingValue) LIKE 'fileid=%'
				 THEN dbo.FilePath(TS.SettingValue)
				 ELSE TS.SettingValue END           
				 AS SettingValue
		FROM   dbo.[TabSettings] TS
			INNER JOIN dbo.[Tabs] T ON t.TabID = TS.TabID
		WHERE  (PortalId = @PortalId)
		ORDER BY TS.TabID
	END
GO
/****** Object:  StoredProcedure [dbo].[GetTabUrls]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabUrls] 
(
	 @PortalId		int 
)
AS
	SELECT 
		tu.TabId,	
		tu.SeqNum,	
		tu.Url,	
		tu.QueryString,
		tu.HttpStatus,	
		tu.CultureCode,
		tu.IsSystem,
		case when parentTu.PortalAliasUsage = 1 /* parent is set to 'child pages inherit' so get parent portal alias id */
			then 
				case when Coalesce(tu.PortalAliasId, 0) < 1 /* if this page has no specific alias id, then use parent*/
					then parentTu.PortalAliasId 
					else tu.PortalAliasId 
				END /* otherwise, use this page alias id */
			else tu.PortalALiasId 
		END as PortalAliasId,

		case when Coalesce(tu.PortalAliasUsage,0) = 0 and coalesce(tu.PortalALiasId,0) < 1 /* default value and no specific alias */
			then /* check for inheritance from parent */
				case when Coalesce(parentTu.PortalALiasUsage,0) = 1 and Coalesce(parentTu.PortalAliasId, 0) > 0 /* parent specifies an alias */
					then 3 /* inherited from parent */
					else 0 
				END /* default value */
			when Coalesce(tu.PortalAliasId,0) > 0 /*specific alias for this tab */
			then 
				case when coalesce(tu.PortalALiasUsage,0) < 1 
					then 1 /* if not set, default to 'child pages inherit'*/
					else tu.PortalAliasUsage 
				END
			else 
				0 /* default - fall through value */
		END as PortalAliasUsage 
	FROM dbo.TabUrls tu
		INNER JOIN dbo.Tabs t on t.TabId = tu.TabId
		LEFT JOIN dbo.TabUrls parentTu on t.ParentId = parentTu.TabId
			AND parentTu.CultureCode = tu.CultureCode
			and parentTu.PortalAliasUsage > 0	   
	WHERE (@portalId = PortalId OR @portalId = -1)
	ORDER BY PortalId, TabOrder, tu.SeqNum
GO
/****** Object:  StoredProcedure [dbo].[GetTabVersionDetails]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabVersionDetails]
	@TabVersionId INT
AS
BEGIN
	SELECT   
		[TabVersionDetailId] ,
        [TabVersionId] ,
		[ModuleId] ,
		[ModuleVersion] ,
		[PaneName] ,
		[ModuleOrder] ,
		[Action],
	    [CreatedByUserID] ,
		[CreatedOnDate],
		[LastModifiedByUserID],
		[LastModifiedOnDate]
	FROM dbo.[TabVersionDetails]
	WHERE [TabVersionId] = @TabVersionId
END
GO
/****** Object:  StoredProcedure [dbo].[GetTabVersionDetailsHistory]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabVersionDetailsHistory]
	@TabID iNT,
    @Version INT
AS
BEGIN    
	SELECT tvd.[TabVersionDetailId]
		  ,tvd.[TabVersionId]
		  ,tvd.[ModuleId]
		  ,tvd.[ModuleVersion]
		  ,tvd.[PaneName]
		  ,tvd.[ModuleOrder]
		  ,tvd.[Action]
		  ,tvd.[CreatedByUserID]
		  ,tvd.[CreatedOnDate]
		  ,tvd.[LastModifiedByUserID]
		  ,tvd.[LastModifiedOnDate]
	FROM dbo.[TabVersionDetails] tvd
	INNER JOIN dbo.[TabVersions] tv ON tvd.TabVersionId = tv.TabVersionId
	WHERE tv.Version <= @Version
		AND tv.TabId = @TabID
	ORDER BY tvd.CreatedOnDate 
END
GO
/****** Object:  StoredProcedure [dbo].[GetTabVersions]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTabVersions]
	@TabId INT
AS
BEGIN
	SELECT   
		[TabVersionId],
		[TabId],
		[Version],
		[TimeStamp],
		[IsPublished],
	    [CreatedByUserID],
		[CreatedOnDate],
		[LastModifiedByUserID],
		[LastModifiedOnDate]
	FROM dbo.[TabVersions]
	WHERE [TabId] = @TabId
END
GO
/****** Object:  StoredProcedure [dbo].[GetTerm]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTerm] 
	@TermId			int
AS
	SELECT TT.*,
		(SELECT    COUNT(CI.ContentItemID)
			  FROM      dbo.[ContentItems_Tags] T
			  INNER JOIN dbo.[ContentItems] CI ON CI.ContentItemID = T.ContentItemID
			  WHERE     T.TermID = TT.TermID
			) AS TotalTermUsage ,
		(SELECT    COUNT(CI.ContentItemID)
			  FROM      dbo.[ContentItems_Tags] T
			  INNER JOIN dbo.[ContentItems] CI ON CI.ContentItemID = T.ContentItemID
			  WHERE     T.TermID = TT.TermID
			  AND	    CI.CreatedOnDate > DATEADD(day, -30, GETDATE())
		) AS MonthTermUsage ,
		(SELECT    COUNT(CI.ContentItemID)
			  FROM      dbo.[ContentItems_Tags] T
			  INNER JOIN dbo.[ContentItems] CI ON CI.ContentItemID = T.ContentItemID
			  WHERE     T.TermID = TT.TermID
			  AND	    CI.CreatedOnDate > DATEADD(day, -7, GETDATE())
		) AS WeekTermUsage ,
		(SELECT    COUNT(CI.ContentItemID)
			  FROM      dbo.[ContentItems_Tags] T
			  INNER JOIN dbo.[ContentItems] CI ON CI.ContentItemID = T.ContentItemID
			  WHERE     T.TermID = TT.TermID
			  AND	    CI.CreatedOnDate > DATEADD(day, -1, GETDATE())
		) AS DayTermUsage
	FROM dbo.Taxonomy_Terms TT
	WHERE TT.TermId = @TermId
GO
/****** Object:  StoredProcedure [dbo].[GetTermsByContent]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTermsByContent] 
	@ContentItemID			int
AS
	SELECT TT.*
	FROM dbo.ContentItems_Tags TG
		INNER JOIN dbo.Taxonomy_Terms TT ON TG.TermID = TT.TermID
	WHERE TG.ContentItemID = @ContentItemID
GO
/****** Object:  StoredProcedure [dbo].[GetTermsByVocabulary]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTermsByVocabulary] 
	@VocabularyID			int
AS
	SELECT TT.*
	FROM dbo.Taxonomy_Terms TT
	WHERE VocabularyID = @VocabularyID
	ORDER BY TT.TermLeft Asc, TT.Weight Asc, TT.Name Asc
GO
/****** Object:  StoredProcedure [dbo].[GetTermUsage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTermUsage] 
	@TermId int
AS
	SELECT
		(SELECT    COUNT(CI.ContentItemID)
			  FROM      dbo.[ContentItems_Tags] T
			  INNER JOIN dbo.[ContentItems] CI ON CI.ContentItemID = T.ContentItemID
			  WHERE     T.TermID = @TermId
			) AS TotalTermUsage ,
		(SELECT    COUNT(CI.ContentItemID)
			  FROM      dbo.[ContentItems_Tags] T
			  INNER JOIN dbo.[ContentItems] CI ON CI.ContentItemID = T.ContentItemID
			  WHERE     T.TermID = @TermId
			  AND	    CI.CreatedOnDate > DATEADD(day, -30, GETDATE())
		) AS MonthTermUsage ,
		(SELECT    COUNT(CI.ContentItemID)
			  FROM      dbo.[ContentItems_Tags] T
			  INNER JOIN dbo.[ContentItems] CI ON CI.ContentItemID = T.ContentItemID
			  WHERE     T.TermID = @TermId
			  AND	    CI.CreatedOnDate > DATEADD(day, -7, GETDATE())
		) AS WeekTermUsage ,
		(SELECT    COUNT(CI.ContentItemID)
			  FROM      dbo.[ContentItems_Tags] T
			  INNER JOIN dbo.[ContentItems] CI ON CI.ContentItemID = T.ContentItemID
			  WHERE     T.TermID = @TermId
			  AND	    CI.CreatedOnDate > DATEADD(day, -1, GETDATE())
		) AS DayTermUsage
	FROM dbo.Taxonomy_Terms TT
	WHERE TermID = @TermId
GO
/****** Object:  StoredProcedure [dbo].[GetTopHtmlText]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetTopHtmlText]

@ModuleID    int,
@IsPublished bit

as

select top 1 dbo.HtmlText.*,
       dbo.WorkflowStates.*,
       dbo.Workflow.WorkflowName,
       dbo.Users.DisplayName,
       dbo.Modules.PortalID
from   dbo.HtmlText
inner join dbo.Modules on dbo.Modules.ModuleID = dbo.HtmlText.ModuleID
inner join dbo.WorkflowStates on dbo.WorkflowStates.StateID = dbo.HtmlText.StateID
inner join dbo.Workflow on dbo.WorkflowStates.WorkflowID = dbo.Workflow.WorkflowID
left outer join dbo.Users on dbo.HtmlText.LastModifiedByUserID = dbo.Users.UserID
where  dbo.HtmlText.ModuleID = @ModuleID
and    (IsPublished = @IsPublished or @IsPublished = 0)
order by dbo.HtmlText.LastModifiedOnDate desc
GO
/****** Object:  StoredProcedure [dbo].[GetUnAuthorizedUsers]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUnAuthorizedUsers]
	@PortalID       int,
	@IncludeDeleted bit,
	@SuperUsersOnly bit		
AS
	SELECT  *
	FROM	dbo.vw_Users
	WHERE  PortalId = @PortalID
		AND Authorised = 0
		AND IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
		--less than equal done to cover IsDeleted in (1,0) for IncludeDeleted...else just IsDeleted = 0
		AND IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
	ORDER BY UserName
GO
/****** Object:  StoredProcedure [dbo].[GetUnIndexedContentItems]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUnIndexedContentItems] 
AS
	SELECT *
	FROM dbo.ContentItems
	WHERE Indexed = 0
GO
/****** Object:  StoredProcedure [dbo].[GetUrl]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetUrl]

@PortalID     int,
@Url          nvarchar(255)

as

select *
from   dbo.Urls
where  PortalID = @PortalID
and    Url = @Url
GO
/****** Object:  StoredProcedure [dbo].[GetUrlLog]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUrlLog]
	@URLTrackingID Int,
	@StartDate DateTime,
	@EndDate DateTime
AS
	BEGIN
		SELECT 
			L.*,
			dbo.[UserDisplayname](L.UserId) AS 'FullName'
		FROM dbo.UrlLog L
			INNER JOIN dbo. UrlTracking T ON L.UrlTrackingId = T.UrlTrackingId
		WHERE L.UrlTrackingID = @UrlTrackingID
			AND ((ClickDate >= @StartDate) OR @StartDate Is Null)
			AND ((ClickDate <= @EndDate ) OR @EndDate Is Null)
		ORDER BY ClickDate
	END
GO
/****** Object:  StoredProcedure [dbo].[GetUrls]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetUrls]

@PortalID     int

as

select *
from   dbo.Urls
where  PortalID = @PortalID
order by Url
GO
/****** Object:  StoredProcedure [dbo].[GetUrlTracking]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetUrlTracking]

@PortalID     int,
@Url          nvarchar(255),
@ModuleId     int

as

select *
from   dbo.UrlTracking
where  PortalID = @PortalID
and    Url = @Url
and    ((ModuleId = @ModuleId) or (ModuleId is null and @ModuleId is null))
GO
/****** Object:  StoredProcedure [dbo].[GetUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUser]

	@PortalID int,
	@UserID int

AS
SELECT * FROM dbo.vw_Users U
WHERE  UserId = @UserID
	AND    (PortalId = @PortalID or IsSuperUser = 1)
GO
/****** Object:  StoredProcedure [dbo].[GetUserAuthentication]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserAuthentication]
  @UserID          int

AS
  select * from dbo.UserAuthentication
     where UserId = @UserID
GO
/****** Object:  StoredProcedure [dbo].[GetUserByAuthToken]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserByAuthToken]

	@PortalId	int,
	@UserToken	nvarchar(1000),
	@AuthType	nvarchar(100)

AS
	SELECT u.* 
		FROM dbo.vw_Users u
			INNER JOIN dbo.UserAuthentication ua ON u.UserID = ua.UserID
	WHERE  ua.AuthenticationToken = @UserToken
		AND ua.AuthenticationType = @AuthType
		AND    (PortalId = @PortalId OR IsSuperUser = 1 OR @PortalId is null)
GO
/****** Object:  StoredProcedure [dbo].[GetUserByDisplayName]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserByDisplayName]

	@PortalID int,
	@DisplayName nvarchar(128)

AS
	SELECT * FROM dbo.vw_Users
	WHERE  DisplayName = @DisplayName
		AND  ((@PortalId IS NULL) OR (PortalId = @PortalID) OR IsSuperUser = 1)
GO
/****** Object:  StoredProcedure [dbo].[GetUserByUsername]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserByUsername]

	@PortalID int,
	@Username nvarchar(100)

AS
	SELECT * FROM dbo.vw_Users
	WHERE  Username = @Username
		AND  ((@PortalId IS NULL) OR (PortalId = @PortalID) OR IsSuperUser = 1)
GO
/****** Object:  StoredProcedure [dbo].[GetUserByVanityUrl]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserByVanityUrl]

	@PortalID int,
	@VanityUrl nvarchar(100)

AS
	SELECT * FROM dbo.vw_Users
	WHERE  VanityUrl = @VanityUrl
		AND  ((@PortalId IS NULL) OR (PortalId = @PortalID) OR IsSuperUser = 1)
GO
/****** Object:  StoredProcedure [dbo].[GetUserCountByPortal]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserCountByPortal]
 @PortalId int
AS
begin
 SELECT count(*)
 FROM dbo.UserPortals AS UP
 WHERE UP.IsDeleted = 0 AND UP.PortalID = @PortalID
end
GO
/****** Object:  StoredProcedure [dbo].[GetUserProfile]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetUserProfile] 
	@UserID int
AS
	SELECT
		ProfileID,
		UserID,
		PropertyDefinitionID,
		CASE WHEN (PropertyValue Is Null) THEN PropertyText ELSE PropertyValue END AS 'PropertyValue',
		Visibility,
		ExtendedVisibility,
		LastUpdatedDate
	FROM	dbo.UserProfile
	WHERE   UserId = @UserID
GO
/****** Object:  StoredProcedure [dbo].[GetUserRelationship]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserRelationship] @UserRelationshipID INT
AS 
    SELECT  UserRelationshipID,
			UserID,
			RelatedUserID,
			RelationshipID,            
			Status,            
            CreatedByUserID ,
            CreatedOnDate ,
            LastModifiedByUserID ,
            LastModifiedOnDate
    FROM    dbo.UserRelationships    
	WHERE UserRelationshipID = @UserRelationshipID
	ORDER BY UserRelationshipID ASC
GO
/****** Object:  StoredProcedure [dbo].[GetUserRelationshipPreference]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserRelationshipPreference] 
	@UserID INT,
	@RelationshipID INT
AS 
    SELECT  PreferenceID,
			UserID,
			RelationshipID,            
			DefaultResponse,            
            CreatedByUserID ,
            CreatedOnDate ,
            LastModifiedByUserID ,
            LastModifiedOnDate
    FROM    dbo.UserRelationshipPreferences    
	WHERE UserID = @UserID
	  AND RelationshipID = @RelationshipID
	ORDER BY UserID ASC, RelationshipID ASC
GO
/****** Object:  StoredProcedure [dbo].[GetUserRelationshipPreferenceByID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserRelationshipPreferenceByID] 
	@PreferenceID INT	
AS 
    SELECT  PreferenceID,
			UserID,
			RelationshipID,            
			DefaultResponse,            
            CreatedByUserID ,
            CreatedOnDate ,
            LastModifiedByUserID ,
            LastModifiedOnDate
    FROM    dbo.UserRelationshipPreferences    
	WHERE @PreferenceID = @PreferenceID	  
	ORDER BY PreferenceID ASC
GO
/****** Object:  StoredProcedure [dbo].[GetUserRelationships]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserRelationships]
	@UserID INT
AS 
	SELECT  UserRelationshipID,
			UserID,
			RelatedUserID,
			RelationshipID,            
			Status,            
			CreatedByUserID ,
			CreatedOnDate ,
			LastModifiedByUserID ,
			LastModifiedOnDate
	FROM    dbo.UserRelationships    		
	WHERE UserID = @UserID OR RelatedUserID = @UserID
GO
/****** Object:  StoredProcedure [dbo].[GetUserRelationshipsByMultipleIDs]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserRelationshipsByMultipleIDs] 
	@UserID INT,
	@RelatedUserID INT,
	@RelationshipID INT,
	@Direction INT
AS 
	IF ( @Direction = 1 ) --OneWay
	  BEGIN
		SELECT  UserRelationshipID,
				UserID,
				RelatedUserID,
				RelationshipID,            
				Status,            
				CreatedByUserID ,
				CreatedOnDate ,
				LastModifiedByUserID ,
				LastModifiedOnDate
		FROM    dbo.UserRelationships    
		WHERE UserID = @UserID
		AND   RelatedUserID = @RelatedUserID
		AND   RelationshipID = @RelationshipID
		ORDER BY UserRelationshipID ASC    
	  END
	  ELSE IF ( @Direction = 2 ) --TwoWay
	  BEGIN
		SELECT  UserRelationshipID,
				UserID,
				RelatedUserID,
				RelationshipID,            
				Status,            
				CreatedByUserID ,
				CreatedOnDate ,
				LastModifiedByUserID ,
				LastModifiedOnDate
		FROM    dbo.UserRelationships    		
		WHERE (  (UserID = @UserID AND RelatedUserID = @RelatedUserID) 
			  OR (RelatedUserID = @UserID AND UserID = @RelatedUserID) --swap userids and check
			  )
		AND   RelationshipID = @RelationshipID
		ORDER BY UserRelationshipID ASC    
	  END
GO
/****** Object:  StoredProcedure [dbo].[GetUserRole]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserRole]

	@PortalID int, 
	@UserID int, 
	@RoleId int

AS
	SELECT	*
	    FROM	dbo.vw_UserRoles
	    WHERE   UserId = @UserID
		    AND  PortalId = @PortalID
		    AND  RoleId = @RoleId
GO
/****** Object:  StoredProcedure [dbo].[GetUserRoles]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserRoles]
	@PortalId  int,
	@UserId    int
AS
	SELECT *
		FROM dbo.vw_UserRoles
		WHERE UserID = @UserId AND PortalID = @PortalId
GO
/****** Object:  StoredProcedure [dbo].[GetUserRolesByUsername]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserRolesByUsername]
	@PortalID int, 
	@Username nvarchar(100), 
	@Rolename nvarchar(50)
AS
	IF @UserName Is Null
		BEGIN
			SELECT	*
				FROM dbo.vw_UserRoles
				WHERE PortalId = @PortalID AND (Rolename = @Rolename or @RoleName is NULL)
		END
	ELSE
		BEGIN
			IF @RoleName Is NULL
				BEGIN
					SELECT	*
						FROM dbo.vw_UserRoles
						WHERE PortalId = @PortalID AND (Username = @Username or @Username is NULL)
				END
			ELSE
				BEGIN
					SELECT	*
						FROM dbo.vw_UserRoles
						WHERE PortalId = @PortalID
							AND (Rolename = @Rolename or @RoleName is NULL)
							AND (Username = @Username or @Username is NULL)
				END
		END
GO
/****** Object:  StoredProcedure [dbo].[GetUsersAdvancedSearch]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUsersAdvancedSearch] 
(
    @PortalID int,                          -- portal                
    @UserId int,                            -- for determining correct visibility permissions
    @FilterUserId int,                      -- for filtering relationships on    
    @FilterRoleId int,                      -- for filtering by roles
    @RelationshipTypeId int,                -- for filtering by relationships
    @IsAdmin bit,                           -- determines visibility
    @PageSize int,                          -- page size
    @PageIndex int,                         -- 0 based page index
    @SortBy nvarchar(100),                  -- sort field
    @SortAscending bit,                     -- sort flag indicating whether sort is asc or desc
    @PropertyNames nvarchar(max),           -- list of property names to filter
    @PropertyValues nvarchar(max)           -- list of property values to filter
)
AS
    -- Setup Top XX
    DECLARE @topSql nvarchar(20) SET @topSql = ''
    IF @PageSize > -1 BEGIN SET @topSql = ' TOP ' + CONVERT(nvarchar(20), @PageSize) END
                
    -- Setup Specific Page
    DECLARE @minRowNumberSql nvarchar(20) SET @minRowNumberSql =  CONVERT(nvarchar(20), ((@PageIndex * @PageSize) + 1))
    -- Setup Pivot Field List
    DECLARE @pivotSql nvarchar(max) SELECT @pivotSql = dbo.GetProfileFieldSql(@PortalID, '')

    -- Get User specific columns
    DECLARE @UserColumns TABLE(ColumnName NVARCHAR(100))
    INSERT INTO @UserColumns SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'vw_Users'

    -- Lists Filters names and values into tables
    DECLARE @PropertyNamesTable TABLE (RowNumber INT, RowValue nvarchar(MAX))
    DECLARE @PropertyValuesTable TABLE (RowNumber INT, RowValue nvarchar(MAX))
    INSERT INTO @PropertyNamesTable SELECT * FROM dbo.ConvertListToTable(',', @PropertyNames)                      
    INSERT INTO @PropertyValuesTable SELECT * FROM dbo.ConvertListToTable(',', @PropertyValues)
                
    -- Gets filters that are on the User rather than Profile Properties
    DECLARE @UserFiltersTable TABLE (RowNumber Int, RowValue NVARCHAR(MAX))
    INSERT INTO @UserFiltersTable SELECT * FROM dbo.ConvertListToTable(',',@PropertyNames) WHERE RowValue IN (SELECT * FROM @UserColumns)


    DECLARE @sql nvarchar(max) SET @sql = ''
    DECLARE @filterSql nvarchar(max)SET @filterSql = ''

    -- ///////////////////////////////////////////////////
    -- FILTERING by PROFILE PROPERTY or USER PROPERTY
    -- ///////////////////////////////////////////////////
    --IF @PropertyNames IS NOT NULL AND @PropertyNames <> ''
    IF ((SELECT COUNT(*) FROM @PropertyNamesTable) > 0) AND ((SELECT COUNT(*) FROM @PropertyValuesTable)> 0) 
	    BEGIN
            DECLARE @propertyFilter nvarchar(max)
            DECLARE @userFilter nvarchar(max)
            DECLARE @userFilterJoin nvarchar(max) SET @userFilterJoin = ''
            DECLARE @profilePropertyCount INT
            DECLARE @userFilterCount INT
            DECLARE @propertyAndUserFilter nvarchar(10) SET @propertyAndUserFilter = ''
            DECLARE @groupBy NVARCHAR(300)

            -- Filters on Profile Properties    
            ;WITH CTE_PropertyNames(RowNumber, RowValue) AS
            (              SELECT * FROM @PropertyNamesTable
                            WHERE RowValue NOT IN (SELECT ColumnName FROM @UserColumns)),
            CTE_PropertyValues(RowNumber, RowValue) AS
            (              SELECT * FROM @PropertyValuesTable
                            WHERE RowValue NOT IN (SELECT ColumnName FROM @UserColumns))

            SELECT @propertyFilter = COALESCE(@propertyFilter + ' OR ' , ' ') 
                                        + ' (PropertyName=''' + N.RowValue 
                                        + ''' AND ((PropertyValue LIKE ''' + V.RowValue +'%'') OR (PropertyValue LIKE ''% ' + V.RowValue +'%'')))'
            FROM CTE_PropertyNames AS N INNER JOIN CTE_PropertyValues AS V ON N.RowNumber = V.RowNumber
                                
            -- Filters on User Property                           
            SELECT @userFilter = COALESCE(@userFilter + ' AND ', ' ')  
										+ ' ((u.' + N.RowValue + ' LIKE ''' + V.RowValue +'%'') OR (u.' + N.RowValue + ' LIKE ''% ' + V.RowValue +'%'')) '
            FROM @UserFiltersTable AS N  INNER JOIN @PropertyValuesTable AS V ON N.RowNumber = V.RowNumber
                                
            SELECT @userFilterCount = COUNT(*) FROM @UserFiltersTable
            IF @userFilterCount > 0 BEGIN SET @userFilterJoin = ' INNER JOIN vw_Users u ON u.UserId = p.UserId ' END

            -- Determining the Group By Clause -- dependant on types of filters used
            SELECT @profilePropertyCount = COUNT(*) FROM dbo.ConvertListToTable(',', @PropertyNames)
            WHERE RowValue IN (SELECT PropertyName FROM ProfilePropertyDefinition WHERE PortalID = @PortalId)
            AND RowValue NOT IN (SELECT ColumnName FROM @UserColumns)

            IF @profilePropertyCount > 0
                BEGIN SET @groupBy = ' GROUP BY p.UserId HAVING COUNT(*) = ' + CONVERT(nvarchar(20),@profilePropertyCount ) END
            ELSE
                BEGIN SET @groupBy = ' GROUP BY p.UserId HAVING COUNT(*) > 0 '     END

            IF ( @profilePropertyCount > 0 AND @userFilterCount > 0)
            BEGIN SET @propertyAndUserFilter = ' AND ' END

            -- CREATE FINAL FILTER
            SET @filterSql = ' DECLARE @MatchingUsers TABLE (UserID INT, Occurrances INT) INSERT INTO @MatchingUsers SELECT p.UserID, COUNT(*) AS occurances ' 
                                        + ' FROM dbo.vw_profile p ' + @userFilterJoin
                                        + ' WHERE ' + COALESCE(' ( ' + @propertyFilter + ') ', ' ') + @propertyAndUserFilter + COALESCE(@userFilter, ' ') 
										+ ' AND ((Visibility = 0) OR (Visibility = 1 AND ' + CONVERT(nvarchar(20), @UserId) + ' > 0) OR (Visibility = 2 AND ' + CONVERT(nvarchar(20), @IsAdmin) + ' = 1))' 
                                        + @groupBy
		END

        -- ///////////////////////////////////////////////////      
        -- SETUP ROLE AND RELATIONSHIP FILTERS
        -- ///////////////////////////////////////////////////
        DECLARE @roleAndRelationshipFilter nvarchar(1000)
        DECLARE @roleFilter nvarchar(100) SET @roleFilter = ''
        DECLARE @relationshipFilter nvarchar(1000) SET @relationshipFilter = ''
        DECLARE @roleAndRelationshipFlag bit SET @roleAndRelationshipFlag  = 0
        DECLARE @RoleAndRelationshipSelect nvarchar(100) SET @RoleAndRelationshipSelect = ''
                                
        -- Filter by Role
        IF @FilterRoleId <> -1 
            BEGIN
                SET @roleAndRelationshipFlag = 1
                SET @roleFilter = ' JOIN UserRoles UR ON U.UserID = UR.UserID AND UR.RoleID = ' + CONVERT(nvarchar(20), @FilterRoleId)
            END

        -- Filter by Relationship
        IF @RelationshipTypeId <> -1  
            BEGIN
                SET @roleAndRelationshipFlag = 1
                SET @relationshipFilter = ' JOIN Relationships REL ON REL.PortalID = ' + CONVERT(nvarchar(20), @PortalID)
                                            + ' AND RelationshipTypeID = ' + CONVERT(nvarchar(20), @RelationshipTypeId) 
                                            + ' JOIN UserRelationships UREL ON REL.RelationshipID = UREL.RelationshipID AND
                                            ((UREL.UserID = ' + CONVERT(nvarchar(20), @FilterUserId) + ' AND UREL.RelatedUserID = U.UserID) OR
                                            (UREL.UserID = U.UserID AND UREL.RelatedUserID = ' + CONVERT(nvarchar(20), @FilterUserId) + '))'
                                            + ' WHERE UREL.Status = 2'
            END 

        IF @roleAndRelationshipFlag = 1 BEGIN SET @RoleAndRelationshipSelect = ' AND s.UserId IN (SELECT userID FROM  RoleAndRelationUsers) ' END

        SET @roleAndRelationshipFilter =  ', RoleAndRelationUsers AS ( SELECT U.userId FROM vw_Users U ' + @roleFilter + @relationshipFilter + ' )' 

        -- ///////////////////////////////////////////////////  
        -- SET UP SORT
        -- ///////////////////////////////////////////////////
        DECLARE @sortSql nvarchar(1000) SET @sortSql = ''
        DECLARE @propertySort nvarchar(1000) SET @propertySort = ''
        DECLARE @filterJoin nvarchar(100) SET @filterJoin = ''
        DECLARE @filterSortSql nvarchar(1000) SET @filterSortSql = ''
        DECLARE @sortByUserProperty BIT         
        SELECT @sortByUserProperty = COUNT(*) FROM @UserColumns WHERE ColumnName = @SortBy

        IF ( @profilePropertyCount > 0 OR @userFilterCount > 0)
	        BEGIN SET @filterJoin = ' INNER JOIN @MatchingUsers m ON m.UserID = s.UserID ' END

        -- Determine the Type of Sort
        IF (@SortBy IS NOT NULL AND @SortBy <> '') AND @sortByUserProperty <> 1
	        BEGIN -- Sort By Profile Property
                SET @sortSql = dbo.GetSortSql(@SortBy,@SortAscending,'UserID')
                SET @propertySort = dbo.GetSortSql('PropertyValue',@SortAscending,'UserID')
                SET @filterSortSql = ' ;WITH SortedUsers AS ( SELECT ROW_NUMBER() OVER( ' + @propertySort + ' ) AS RowNumber, *  ' 
                                                + ' FROM vw_Profile WHERE PortalId = ' + CONVERT(nvarchar(20), @PortalID) + ' AND PropertyName = ''' + @SortBy + ''' )'
                                                + ' , MatchingSorted AS ( SELECT ROW_NUMBER() OVER(ORDER BY [RowNumber]) AS RowNumber, s.UserId FROM SortedUsers s '
                                                + @filterJoin + ' ) '
	        END
        ELSE
		    BEGIN   
                -- Sort By User Property
                IF @sortByUserProperty = 1 BEGIN SET @sortSql = dbo.GetSortSql(@SortBy,@SortAscending,'UserID')END
                                
                -- Default: Sort By UserID
                ELSE BEGIN SET @sortSql = dbo.GetSortSql('UserID',@SortAscending,'UserID') END                        
                SET @filterSortSql = ' ;WITH SortedUsers AS ( SELECT ROW_NUMBER() OVER( ' + @sortSql + ' ) AS RowNumber, * '
                                                + ' FROM vw_Users WHERE (PortalID = ' + CONVERT(nvarchar(20), @PortalID) + ' OR PortalID Is NULL) AND IsDeleted = 0)'
                                                + ' , MatchingSorted AS ( SELECT ROW_NUMBER() OVER(ORDER BY [RowNumber]) AS RowNumber, s.UserId FROM SortedUsers s '
                                                + @filterJoin + ' ) '
	        END

		-- Check if any Profile Property Definitions exist for this portal
		IF @pivotSql is not null
			BEGIN
				-- SELECT with PIVOT
				SET @pivotSql = 'SELECT * FROM (SELECT * FROM PivotedUsers PIVOT (MAX(PropertyValue) for PropertyName in (' + @pivotSql + ') ) as pivotTable) T '
			END
		ELSE
			BEGIN
				-- SELECT with DISTINCT
				SET @pivotSql = 'SELECT distinct UserID, PortalID, Username, Email, DisplayName, IsSuperUser, IsDeleted, AffiliateID, UpdatePassword, Authorised FROM PivotedUsers '
			END

        -- ///////////////////////////////////////////////////
        -- CREATE FINAL QUERY
        -- ///////////////////////////////////////////////////
        SET @sql = @filterSql
                + ' DECLARE @TempUsers TABLE (SortOrder INT, UserID INT) '
                + @filterSortSql
                + @roleAndRelationshipFilter
                + ' INSERT INTO @TempUsers SELECT ' + @topSql + ' * FROM (SELECT '
                + ' ROW_NUMBER() OVER ( ORDER BY [RowNumber] ) AS RowNumber, s.UserId FROM MatchingSorted s ' 
                + ' WHERE 1=1 ' + @roleAndRelationshipSelect
				+ ') t WHERE RowNumber >= '+ @minRowNumberSql
                + ' ;WITH PivotedUsers AS ( SELECT U.UserID, U.PortalID, U.Username, U.Email, U.DisplayName, U.IsSuperUser, U.IsDeleted, U.CreatedOnDate,        
                                                U.AffiliateID, U.UpdatePassword, U.Authorised, Prop.PropertyName,
                                                CASE
                                                    WHEN (P.Visibility = 0) THEN P.PropertyValue
                                                    WHEN (P.Visibility = 1 AND ' + CONVERT(nvarchar(20), @IsAdmin) + ' = 1) THEN P.PropertyValue
                                                    WHEN (P.Visibility = 1 AND ' + CONVERT(nvarchar(20), @IsAdmin) + ' = 0 AND ' + CONVERT(nvarchar(20), @UserId) + ' > 0) THEN P.PropertyValue
                                                    WHEN U.UserID = ' + CONVERT(nvarchar(20), @UserId) + ' OR (P.Visibility = 2 AND ' + CONVERT(nvarchar(20), @IsAdmin) + ' = 1) THEN P.PropertyValue
                                                    ELSE NULL
                                                END AS PropertyValue
                                            FROM   vw_Users AS U
                                                INNER JOIN UserProfile AS P ON U.UserID = P.UserID
                                                LEFT OUTER JOIN ProfilePropertyDefinition AS Prop ON 
                                                (Prop.PropertyDefinitionID = P.PropertyDefinitionID and Prop.Deleted = 0 and Prop.PortalID = ' + CONVERT(nvarchar(20), @PortalID) + ')
                                            WHERE U.UserId IN (SELECT UserId FROM @TempUsers) AND (U.PortalId = ' + CONVERT(nvarchar(20), @PortalID) + ' OR U.PortalId IS NULL)
                                            )' +
                @pivotSql + @sortSql            

        EXEC(@sql)
GO
/****** Object:  StoredProcedure [dbo].[GetUsersBasicSearch]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUsersBasicSearch] 
(
	@PortalID int,					-- portal
	@PageSize int,					-- page size
	@PageIndex int,					-- 0 based page index
	@SortBy nvarchar(100),			-- sort field
	@SortAscending bit,				-- sort flag indicating whether sort is asc or desc
	@PropertyName nvarchar(256),    -- property to filter by (username, diaplayname, email)
	@PropertyValue nvarchar(256)	-- value of property
)
AS
	-- Set up Top XX
	DECLARE @topSql nvarchar(20)
	SET @topSql = CONVERT(nvarchar(20), @PageSize)
	
	--Set up Count
	DECLARE @minRowNumberSql nvarchar(20)
	SET @minRowNumberSql =  CONVERT(nvarchar(20), ((@PageIndex * @PageSize) + 1))
	
	-- Set up Sort
	DECLARE @sortSql nvarchar(1000)
	SET @sortSql = dbo.GetSortSql(@SortBy, @SortAscending, 'UserID')

	-- Setup Pivot Field List
	DECLARE @pivotSql nvarchar(max)
	SELECT @pivotSql = dbo.GetProfileFieldSql(@PortalID, '')

	-- Setup FieldName Field List for temporary table
	DECLARE @fieldNames nvarchar(max)
	SELECT @fieldNames = dbo.GetProfileFieldSql(@PortalID, ' nvarchar(max)')
	
	DECLARE @sql nvarchar(max)
	SELECT @sql=
				'
					DECLARE @pivotedUsers TABLE
					(
						RowNumber int,
						UserID int,
						PortalID int,
						Username nvarchar(100),
						Email nvarchar(256),
						DisplayName nvarchar(128),
						IsSuperUser bit,
						IsDeleted bit,
						AffiliateID int,
						UpdatePassword bit,
						Authorised bit,
						' + @fieldNames + '
					);

					WITH TempUsers
					AS
					(
						SELECT TOP ' + @topSql + ' * FROM (
							SELECT 	
								ROW_NUMBER() OVER(' + @sortSql + ') AS RowNumber,
								U.UserID,
								U.PortalID,
								U.Username,
								U.Email,
								U.DisplayName,
								U.IsSuperUser,
								U.IsDeleted,
								U.AffiliateID,
								U.UpdatePassword,
								U.Authorised
								FROM dbo.vw_Users AS U
							WHERE (U.PortalID = ' + CONVERT(nvarchar(20), @PortalID) + ' OR U.PortalID Is NULL )
								AND ((U.' + @PropertyName + ' LIKE ''' + @PropertyValue + '%'')
									OR (U.' + @PropertyName + ' LIKE ''% ' + @PropertyValue + '%''))
								AND U.IsDeleted = 0
						) AS U
						WHERE RowNumber >= ' + @minRowNumberSql + ' 
					),
					TempUsersWithProfile
					AS
					(
						SELECT 
							U.UserID,
							U.PortalID,
							U.Username,
							U.Email,
							U.DisplayName,
							U.IsSuperUser,
							U.IsDeleted,
							U.AffiliateID,
							U.UpdatePassword,
							U.Authorised,
							P.PropertyName,
							P.PropertyValue
						FROM TempUsers U
							INNER JOIN dbo.vw_Profile P ON P.UserID = U.UserID
					)
				    SELECT  * FROM (				
					    SELECT  * FROM TempUsersWithProfile
					    PIVOT 
					    (
						    MAX(PropertyValue) for PropertyName in (' + @pivotSql + ')
					    ) as pivotTable
                    ) T
					' + @sortSql
	EXEC(@sql)
GO
/****** Object:  StoredProcedure [dbo].[GetUsersByDisplayName]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUsersByDisplayName]
    @PortalID		int,
    @NameToMatch	nvarchar(256),
    @PageIndex		int,
    @PageSize		INT,
    @IncludeDeleted     bit,
    @SuperUsersOnly     bit		
AS
	BEGIN
		-- Set the page bounds
		DECLARE @PageLowerBound INT
		DECLARE @PageUpperBound INT
		SET @PageLowerBound = @PageSize * @PageIndex
		SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

		-- Create a temp table TO store the select results
		CREATE TABLE #PageIndexForUsers
		(
			IndexId int IDENTITY (0, 1) NOT NULL,
			UserId int
		)

		-- Insert into our temp table
		INSERT INTO #PageIndexForUsers (UserId)
			SELECT UserId FROM	dbo.vw_Users 
			WHERE  DisplayName LIKE @NameToMatch
				AND (IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
							--less than equal done to cover IsDeleted in (1,0) for IncludeDeleted...else just IsDeleted = 0
				     OR IsDeleted Is NULL)
			        AND IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
				AND ( PortalId = @PortalID OR (@PortalID is null ))
			ORDER BY DisplayName

		SELECT  *
		FROM	dbo.vw_Users u, 
				#PageIndexForUsers p
		WHERE  u.UserId = p.UserId
				AND (IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
							--less than equal done to cover IsDeleted in (1,0) for IncludeDeleted...else just IsDeleted = 0
				     OR IsDeleted Is NULL)
			        AND IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
				AND ( PortalId = @PortalID OR (@PortalID is null ))
				AND p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
		ORDER BY u.DisplayName

		SELECT  TotalRecords = COUNT(*)
		FROM    #PageIndexForUsers
	END
GO
/****** Object:  StoredProcedure [dbo].[GetUsersByEmail]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUsersByEmail]
	@PortalID  int,
	@EmailToMatch   nvarchar(256),
	@PageIndex      int,
	@PageSize       INT,
	@IncludeDeleted bit,
	@SuperUsersOnly bit		
AS
BEGIN
		-- Set the page bounds
		DECLARE 
			@PageLowerBound INT, 
			@PageUpperBound INT, 
			@RowsToReturn int, 
			@TotalRecords int

		exec dbo.CalculatePagingInformation @PageIndex, @PageSize, @RowsToReturn output, @PageLowerBound output, @PageUpperBound output

		declare @tblPageIndex table (
			IndexId int IDENTITY (0, 1) NOT NULL primary key,
			UserId int
		 )

		if @PortalId is null and @EmailToMatch IS NULL
			begin
				with [UsersByEmail] as (
					SELECT U.*, ROW_NUMBER() OVER (ORDER BY Email ASC) AS ROWID
						FROM    dbo.vw_Users U
						WHERE U.IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
							--less than equal done to cover IsDeleted in (1,0) for IncludeDeleted...else just IsDeleted = 0
							AND U.IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
				)
				select *, ROWID - 1 AS IndexID, UserID 
					from [UsersByEmail]
					where ROWID > @PageLowerBound AND ROWID < @PageUpperBound
			end
		else if @PortalId is null and @EmailToMatch IS NOT NULL 
			begin
				with [UsersByEmail] as (
					SELECT U.*, ROW_NUMBER() OVER (ORDER BY Email ASC) AS ROWID
						FROM    dbo.vw_Users U
						WHERE LOWER(U.Email) LIKE LOWER(@EmailToMatch)
							AND U.IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
							AND U.IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
					)
					select *, ROWID - 1 AS IndexID, UserID 
						from [UsersByEmail]
						where ROWID > @PageLowerBound AND ROWID < @PageUpperBound
			end
		else if @EmailToMatch IS NULL 
			begin
				with [UsersByEmail] as (
					SELECT U.*, ROW_NUMBER() OVER (ORDER BY Email ASC) AS ROWID
						FROM    dbo.vw_Users U
						WHERE U.PortalId = @PortalID
							AND U.IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
							AND U.IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
				)
				select *, ROWID - 1 AS IndexID, UserID 
					from [UsersByEmail]
					where ROWID > @PageLowerBound AND ROWID < @PageUpperBound
		  end
		else
			begin
				with [UsersByEmail] as (
					SELECT U.*, ROW_NUMBER() OVER (ORDER BY Email ASC) AS ROWID
						FROM    dbo.vw_Users U
						WHERE U.PortalId = @PortalID
							AND LOWER(U.Email) LIKE LOWER(@EmailToMatch)
							AND U.IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
							AND U.IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
				)
				select *, ROWID - 1 AS IndexID, UserID 
					from [UsersByEmail]
					where ROWID > @PageLowerBound AND ROWID < @PageUpperBound
			end
	 
		if @PortalId is null and @EmailToMatch IS NULL
			begin
				SELECT count(*) as TotalRecords
					FROM    dbo.vw_Users U
					WHERE U.IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
						AND U.IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
			end 
		else if @PortalId is null and @EmailToMatch IS NOT NULL 
			begin
				SELECT count(*) as TotalRecords
					FROM    dbo.vw_Users U
					WHERE LOWER(U.Email) LIKE LOWER(@EmailToMatch)
						AND U.IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
						AND U.IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
			end 
		else if @EmailToMatch IS NULL 
			begin
				SELECT count(*) as TotalRecords
					FROM    dbo.vw_Users U
					WHERE U.PortalId = @PortalID
						AND U.IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
						AND U.IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
			end 
		else 
			begin
				SELECT count(*) as TotalRecords
					FROM    dbo.vw_Users U
					WHERE U.PortalId = @PortalID
						AND LOWER(U.Email) LIKE LOWER(@EmailToMatch)
						AND U.IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
						AND U.IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
		end
	END
GO
/****** Object:  StoredProcedure [dbo].[GetUsersByProfileProperty]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUsersByProfileProperty]
     @PortalID		int,
    @PropertyName   nvarchar(256),
    @PropertyValue  nvarchar(256),
    @PageIndex      int,
    @PageSize       INT,
    @IncludeDeleted bit,
    @SuperUsersOnly bit	
AS
	BEGIN
		-- Set the page bounds
		DECLARE @PageLowerBound INT
		DECLARE @PageUpperBound INT
		SET @PageLowerBound = @PageSize * @PageIndex
		SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

		-- Create a temp table TO store the select results
		CREATE TABLE #PageIndexForUsers
		(
			IndexId int IDENTITY (0, 1) NOT NULL,
			UserId int,
			DisplayName varchar(512)
		)

		-- Insert into our temp table
		INSERT INTO #PageIndexForUsers (UserId,DisplayName)
			SELECT DISTINCT U.UserId, U.DisplayName 
			FROM   dbo.ProfilePropertyDefinition P
				INNER JOIN dbo.UserProfile UP ON P.PropertyDefinitionID = UP.PropertyDefinitionID 
				INNER JOIN dbo.vw_Users U ON UP.UserID = U.UserID
				INNER JOIN dbo.Lists dt ON dt.EntryID = P.DataType
				LEFT JOIN dbo.Lists L ON L.ListName = @PropertyName AND L.Value = UP.PropertyValue AND L.Text LIKE @PropertyValue
			WHERE (PropertyName = @PropertyName) AND (PropertyValue LIKE @PropertyValue OR PropertyText LIKE @PropertyValue OR (dt.Value = 'List' AND L.EntryID IS NOT NULL ))
				AND (IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
							--less than equal done to cover IsDeleted in (1,0) for IncludeDeleted...else just IsDeleted = 0
				     OR IsDeleted Is NULL)
				AND IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
				AND (P.Portalid = @PortalID OR (@PortalID is null ))
			ORDER BY U.DisplayName

		SELECT  *
		FROM	dbo.vw_Users u, 
				#PageIndexForUsers p
		WHERE  u.UserId = p.UserId
				AND (IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
							--less than equal done to cover IsDeleted in (1,0) for IncludeDeleted...else just IsDeleted = 0
				     OR IsDeleted Is NULL)
				AND IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
				AND ( PortalId = @PortalID OR (@PortalID is null ))
				AND p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
			ORDER BY U.DisplayName

		SELECT  TotalRecords = COUNT(*)
		FROM    #PageIndexForUsers
	END
GO
/****** Object:  StoredProcedure [dbo].[GetUsersByRolename]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUsersByRolename]
	@PortalID	INT,
	@Rolename	NVARCHAR(50)
AS
	DECLARE @UserPortalId INT
	DECLARE @PortalGroupId INT
	SELECT @PortalGroupId = PortalGroupId FROM dbo.[Portals] WHERE PortalID = @PortalID
	IF EXISTS(SELECT PortalGroupID FROM dbo.[PortalGroups] WHERE PortalGroupID = @PortalGroupId)
	BEGIN
		SELECT @UserPortalId = MasterPortalID FROM dbo.[PortalGroups] WHERE PortalGroupID = @PortalGroupId
	END
	ELSE
	BEGIN
		SELECT @UserPortalId = @PortalID
	END
	SELECT     
		U.*, 
		UP.PortalId, 
		UP.Authorised, 
		UP.IsDeleted,
		UP.RefreshRoles,
		UP.VanityUrl
	FROM dbo.UserPortals AS UP 
			RIGHT OUTER JOIN dbo.UserRoles  UR 
			INNER JOIN dbo.Roles R ON UR.RoleID = R.RoleID 
			RIGHT OUTER JOIN dbo.Users AS U ON UR.UserID = U.UserID 
		ON UP.UserId = U.UserID	
	WHERE ( UP.PortalId = @UserPortalId OR @UserPortalId IS Null )
		AND (UP.IsDeleted = 0 OR UP.IsDeleted Is NULL)
		AND (R.RoleName = @Rolename)
		AND (R.PortalId = @PortalID OR @PortalID IS Null )
	ORDER BY U.FirstName + ' ' + U.LastName
GO
/****** Object:  StoredProcedure [dbo].[GetUsersByUserName]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUsersByUserName]
    @PortalID		int,
    @UserNameToMatch	nvarchar(256),
    @PageIndex		int,
    @PageSize		INT,
    @IncludeDeleted     bit,
    @SuperUsersOnly     bit		
AS
	BEGIN
		-- Set the page bounds
		DECLARE @PageLowerBound INT
		DECLARE @PageUpperBound INT
		SET @PageLowerBound = @PageSize * @PageIndex
		SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

		-- Create a temp table TO store the select results
		CREATE TABLE #PageIndexForUsers
		(
			IndexId int IDENTITY (0, 1) NOT NULL,
			UserId int
		)

		-- Insert into our temp table
		INSERT INTO #PageIndexForUsers (UserId)
			SELECT UserId FROM	dbo.vw_Users 
			WHERE  Username LIKE @UserNameToMatch
				AND (IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
							--less than equal done to cover IsDeleted in (1,0) for IncludeDeleted...else just IsDeleted = 0
				     OR IsDeleted Is NULL)
			        AND IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
				AND ( PortalId = @PortalID OR (@PortalID is null ))
			ORDER BY UserName

		SELECT  *
		FROM	dbo.vw_Users u, 
				#PageIndexForUsers p
		WHERE  u.UserId = p.UserId
				AND (IsDeleted <= CASE @IncludeDeleted WHEN 0 THEN 0 ELSE 1 END
							--less than equal done to cover IsDeleted in (1,0) for IncludeDeleted...else just IsDeleted = 0
				     OR IsDeleted Is NULL)
			        AND IsSuperUser >= CASE @SuperUsersOnly WHEN 1 THEN 1 ELSE 0 END
				AND ( PortalId = @PortalID OR (@PortalID is null ))
				AND p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
		ORDER BY u.UserName

		SELECT  TotalRecords = COUNT(*)
		FROM    #PageIndexForUsers
	END
GO
/****** Object:  StoredProcedure [dbo].[GetVendor]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetVendor]

@VendorId int,
@PortalId int

as

select dbo.Vendors.VendorName, 
       dbo.Vendors.Unit, 
       dbo.Vendors.Street, 
       dbo.Vendors.City, 
       dbo.Vendors.Region, 
       dbo.Vendors.Country, 
       dbo.Vendors.PostalCode, 
       dbo.Vendors.Telephone,
       dbo.Vendors.Fax,
       dbo.Vendors.Cell,
       dbo.Vendors.Email,
       dbo.Vendors.Website,
       dbo.Vendors.FirstName,
       dbo.Vendors.LastName,
       dbo.Vendors.ClickThroughs,
       dbo.Vendors.Views,
       dbo.Users.FirstName + ' ' + dbo.Users.LastName As CreatedByUser,
       Vendors.CreatedDate,
       case when dbo.Files.FileName is null then dbo.Vendors.LogoFile else Folders.FolderPath + Files.FileName end as LogoFile,
       dbo.Vendors.KeyWords,
       dbo.Vendors.Authorized,
       dbo.Vendors.PortalId
from dbo.Folders 
INNER JOIN dbo.Files ON dbo.Folders.FolderID = dbo.Files.FolderID RIGHT OUTER JOIN
dbo.Vendors LEFT OUTER JOIN
dbo.Users ON dbo.Vendors.CreatedByUser = dbo.Users.UserID ON 'fileid=' + CONVERT(varchar, dbo.Files.FileId) = dbo.Vendors.LogoFile
where  VendorId = @VendorId
and    ((Vendors.PortalId = @PortalId) or (Vendors.PortalId is null and @PortalId is null))
GO
/****** Object:  StoredProcedure [dbo].[GetVendorClassifications]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetVendorClassifications]
    @VendorId  INT
AS
    SELECT ClassificationId,
           ClassificationName,
           CASE WHEN EXISTS ( SELECT 1 FROM dbo.VendorClassification vc WHERE vc.VendorId = @VendorId AND vc.ClassificationId = Classification.ClassificationId ) THEN 1 ELSE 0 END AS 'IsAssociated'
    FROM dbo.Classification
GO
/****** Object:  StoredProcedure [dbo].[GetVendors]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetVendors]
	@PortalID int,
	@UnAuthorized bit,
	@PageSize int,
	@PageIndex int
AS

	DECLARE @PageLowerBound int
	DECLARE @PageUpperBound int
	-- Set the page bounds
	SET @PageLowerBound = @PageSize * @PageIndex
	SET @PageUpperBound = @PageLowerBound + @PageSize + 1

	CREATE TABLE #PageIndex 
	(
		IndexID		int IDENTITY (1, 1) NOT NULL,
		VendorId	int
	)

	INSERT INTO #PageIndex (VendorId)
	SELECT VendorId
	FROM Vendors
	WHERE ( ((Authorized = 0 AND @UnAuthorized = 1) OR @UnAuthorized = 0 ) AND ((PortalId = @PortalID) or (@PortalID is null and PortalId is null)) )
	ORDER BY VendorId DESC


	SELECT COUNT(*) as TotalRecords
	FROM #PageIndex


	SELECT dbo.Vendors.*,
       		( select count(*) from dbo.Banners where dbo.Banners.VendorId = dbo.Vendors.VendorId ) AS 'Banners'
	FROM dbo.Vendors
	INNER JOIN #PageIndex PageIndex
		ON dbo.Vendors.VendorId = PageIndex.VendorId
	WHERE ( (PageIndex.IndexID > @PageLowerBound) OR @PageLowerBound is null )	
		AND ( (PageIndex.IndexID < @PageUpperBound) OR @PageUpperBound is null )	
	ORDER BY
		PageIndex.IndexID
GO
/****** Object:  StoredProcedure [dbo].[GetVendorsByEmail]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetVendorsByEmail]
	@Filter nvarchar(50),
	@PortalID int,
	@PageSize int,
	@PageIndex int
AS

	DECLARE @PageLowerBound int
	DECLARE @PageUpperBound int
	-- Set the page bounds
	SET @PageLowerBound = @PageSize * @PageIndex
	SET @PageUpperBound = @PageLowerBound + @PageSize + 1

	CREATE TABLE #PageIndex 
	(
		IndexID		int IDENTITY (1, 1) NOT NULL,
		VendorId	int
	)

	INSERT INTO #PageIndex (VendorId)
	SELECT VendorId
	FROM dbo.Vendors
	WHERE ( (Email like @Filter + '%') AND ((PortalId = @PortalID) or (@PortalID is null and PortalId is null)) )
	ORDER BY VendorId DESC


	SELECT COUNT(*) as TotalRecords
	FROM #PageIndex


	SELECT dbo.Vendors.*,
       		( select count(*) from dbo.Banners where dbo.Banners.VendorId = dbo.Vendors.VendorId ) AS 'Banners'
	FROM dbo.Vendors
	INNER JOIN #PageIndex PageIndex
		ON dbo.Vendors.VendorId = PageIndex.VendorId
	WHERE ( (PageIndex.IndexID > @PageLowerBound) OR @PageLowerBound is null )	
		AND ( (PageIndex.IndexID < @PageUpperBound) OR @PageUpperBound is null )	
	ORDER BY
		PageIndex.IndexID
GO
/****** Object:  StoredProcedure [dbo].[GetVendorsByName]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetVendorsByName]
	@Filter nvarchar(50),
	@PortalID int,
	@PageSize int,
	@PageIndex int
AS

	DECLARE @PageLowerBound int
	DECLARE @PageUpperBound int
	-- Set the page bounds
	SET @PageLowerBound = @PageSize * @PageIndex
	SET @PageUpperBound = @PageLowerBound + @PageSize + 1

	CREATE TABLE #PageIndex 
	(
		IndexID		int IDENTITY (1, 1) NOT NULL,
		VendorId	int
	)

	INSERT INTO #PageIndex (VendorId)
	SELECT VendorId
	FROM dbo.Vendors
	WHERE ( (VendorName like @Filter + '%') AND ((PortalId = @PortalID) or (@PortalID is null and PortalId is null)) )
	ORDER BY VendorId DESC


	SELECT COUNT(*) as TotalRecords
	FROM #PageIndex


	SELECT dbo.Vendors.*,
       		( select count(*) from dbo.Banners where dbo.Banners.VendorId = Vendors.VendorId ) AS 'Banners'
	FROM dbo.Vendors
	INNER JOIN #PageIndex PageIndex
		ON dbo.Vendors.VendorId = PageIndex.VendorId
	WHERE ( (PageIndex.IndexID > @PageLowerBound) OR @PageLowerBound is null )	
		AND ( (PageIndex.IndexID < @PageUpperBound) OR @PageUpperBound is null )	
	ORDER BY
		PageIndex.IndexID
GO
/****** Object:  StoredProcedure [dbo].[GetVocabularies]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetVocabularies] 
AS
	SELECT *
		FROM dbo.Taxonomy_Vocabularies
GO
/****** Object:  StoredProcedure [dbo].[GetWorkflows]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetWorkflows]
	@PortalID int
as
	select *
	from   dbo.Workflow
	where (PortalID = @PortalID or PortalID is null)
	order by WorkflowName
GO
/****** Object:  StoredProcedure [dbo].[GetWorkflowStates]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetWorkflowStates]
	@WorkflowID int

as

select *
from   dbo.WorkflowStates
inner join dbo.Workflow on dbo.WorkflowStates.WorkflowID = dbo.Workflow.WorkflowID
where dbo.WorkflowStates.WorkflowID = @WorkflowID
order by [Order]
GO
/****** Object:  StoredProcedure [dbo].[ImportDocumentLibraryCategories]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportDocumentLibraryCategories]
	@VocabularyID 				int
AS
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.[dlfp_Category]') AND type in (N'U'))
	BEGIN
		INSERT INTO dbo.Taxonomy_Terms([Name],[VocabularyID])
		SELECT DISTINCT CategoryName,VID=@VocabularyID
		FROM         dbo.dlfp_Category where CategoryName NOT IN (SELECT [name] from dbo.Taxonomy_Terms)
	END
GO
/****** Object:  StoredProcedure [dbo].[ImportDocumentLibraryCategoryAssoc]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportDocumentLibraryCategoryAssoc]
AS
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.[dlfp_Category]') AND type in (N'U'))
	BEGIN
	SELECT     dlc.CategoryName, dbo.Files.FileId
	FROM         dbo.dlfp_Category AS dlc INNER JOIN
                      dbo.dlfp_DocumentCategoryAssoc AS dlca ON dlc.CategoryID = dlca.CategoryID INNER JOIN
                      dbo.dlfp_Document AS dld ON dlca.DocumentID = dld.ID INNER JOIN
                      dbo.Files ON dld.ID = dbo.Files.FileId
	END
GO
/****** Object:  StoredProcedure [dbo].[InsertPortalLocalization]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertPortalLocalization]
@PortalID           int,
@CultureCode nvarchar(10),
	@PortalName         nvarchar(128),
	@LogoFile           nvarchar(50),
	@FooterText         nvarchar(100),
	@Description        nvarchar(500),
	@KeyWords           nvarchar(500),
	@BackgroundFile     nvarchar(50),
	@HomeTabId          int,
	@LoginTabId         int,
	@UserTabId          int,
	@AdminTabid			int,
	@SplashTabId          int,
@CreatedByUserID  int
AS
INSERT INTO dbo.[PortalLocalization]
           ([PortalID]
           ,[CultureCode]
           ,[PortalName]
           ,[LogoFile]
           ,[FooterText]
           ,[Description]
           ,[KeyWords]
           ,[BackgroundFile]
           ,[HomeTabId]
           ,[LoginTabId]
           ,[UserTabId]
           ,[AdminTabId]
           ,[SplashTabId]
           ,[CreatedByUserID]
           ,[CreatedOnDate]
           ,[LastModifiedByUserID]
           ,[LastModifiedOnDate])
     VALUES
     (
     @PortalID,
     @CultureCode,
     @PortalName,
	@LogoFile, 
	@FooterText,
	@Description,
	@KeyWords,
	@BackgroundFile,
	@HomeTabId ,
	@LoginTabId ,
	@UserTabId,
	@AdminTabid,
	@SplashTabId  ,
-1,
		getdate(),
		-1,
		getdate()
		)
GO
/****** Object:  StoredProcedure [dbo].[InsertSearchStopWords]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertSearchStopWords]
	@StopWords 			nvarchar(MAX),
	@CreatedByUserID 		int,
	@PortalID				int,
	@CultureCode		nvarchar(50)
AS
BEGIN	
	INSERT INTO dbo.[SearchStopWords](
		[StopWords],  
		[CreatedByUserID],  
		[CreatedOnDate],  
		[LastModifiedByUserID],  
		[LastModifiedOnDate],
		[PortalID],
		[CultureCode]
	) VALUES (
		@StopWords,
		@CreatedByUserID,
	    GETUTCDATE(),
		@CreatedByUserID,
		GETUTCDATE(),
		@PortalID,
		@CultureCode
	)	

	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[IsUserInRole]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[IsUserInRole]
    
@UserID        int,
@RoleId        int,
@PortalID      int

as

select dbo.UserRoles.UserId,
       dbo.UserRoles.RoleId
from dbo.UserRoles
inner join dbo.Roles on dbo.UserRoles.RoleId = dbo.Roles.RoleId
where  dbo.UserRoles.UserId = @UserID
and    dbo.UserRoles.RoleId = @RoleId
and    dbo.Roles.PortalId = @PortalID
and    (dbo.UserRoles.ExpiryDate >= getdate() or dbo.UserRoles.ExpiryDate is null)
GO
/****** Object:  StoredProcedure [dbo].[Journal_Comment_Delete]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Comment_Delete]
@JournalId int,
@CommentId int
AS
DELETE FROM dbo.[Journal_Comments] 
	WHERE 
		(JournalId = @JournalId AND CommentId = @CommentId)
		OR
		(JournalId = @JournalId AND CommentId = -1)
GO
/****** Object:  StoredProcedure [dbo].[Journal_Comment_Get]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Comment_Get]
@CommentId int
AS
SELECT jc.*, u.* FROM dbo.[Journal_Comments] as jc 
	INNER JOIN dbo.[Users] as u ON jc.UserId = u.UserId
WHERE jc.CommentId = @CommentId
GO
/****** Object:  StoredProcedure [dbo].[Journal_Comment_Like]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Comment_Like]
		@JournalId int,
		@CommentId int,
		@UserId int,
		@UserName nvarchar(50)
	AS
	DECLARE @cxml xml
	SET @cxml = (SELECT CommentXML FROM dbo.Journal_Comments WHERE CommentId = @CommentId AND JournalId = @JournalId)
	IF @cxml IS NULL OR @cxml.exist('/root') = 0
		BEGIN
		DECLARE @x xml
			SET @x = '<root></root>';
			UPDATE dbo.Journal_Comments
				SET CommentXML = @x
				WHERE JournalId = @JournalId AND CommentId = @CommentId
		END
	IF EXISTS(SELECT CommentId
				FROM dbo.Journal_Comments
				WHERE JournalId = @JournalId AND CommentId = @CommentId
				AND CommentXML.exist('/root/likes/u[@uid=sql:variable("@userid")]') = 1)
		BEGIN
			UPDATE dbo.Journal_Comments
				SET CommentXML.modify('delete (/root/likes/u[@uid=sql:variable("@UserId")])')
				WHERE JournalId = @JournalId AND CommentId = @CommentId
				AND CommentXML.exist('/root/likes/u[@uid=sql:variable("@UserId")]') = 1
		END
	ELSE
		BEGIN
			BEGIN
				IF NOT EXISTS(SELECT CommentId FROM dbo.Journal_Comments
								WHERE JournalId = @JournalId AND CommentId = @CommentID
								AND CommentXML.exist('/root/likes') = 1)
					BEGIN
						UPDATE dbo.Journal_Comments
						SET CommentXML.modify('insert <likes /> as last into (/root)[1]') 
						WHERE JournalId = @JournalId AND CommentId = @CommentId AND CommentXML.exist('/root') = 1
					END
			END
			BEGIN
				UPDATE dbo.Journal_Comments
				SET CommentXML.modify('insert <u uid="{xs:string(sql:variable("@UserId"))}" un="{xs:string(sql:variable("@UserName"))}" /> as last into (/root/likes)[1]')
				WHERE JournalId = @JournalId AND CommentId = @CommentId AND CommentXML.exist('/root/likes') = 1
			END
		END
GO
/****** Object:  StoredProcedure [dbo].[Journal_Comment_List]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Comment_List]
@JournalId int
AS
SELECT jc.*, u.* FROM dbo.[Journal_Comments] as jc 
	INNER JOIN dbo.[Users] as u ON jc.UserId = u.UserId
WHERE jc.JournalId = @JournalId
ORDER BY jc.CommentId
GO
/****** Object:  StoredProcedure [dbo].[Journal_Comment_ListByJournalIds]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Comment_ListByJournalIds]
@JounalIds nvarchar(max) = ''
AS
SELECT jc.*, u.* FROM dbo.[Journal_Comments] as jc 
	INNER JOIN dbo.[Users] as u ON jc.UserId = u.UserId
	INNER JOIN dbo.[Journal_Split](@JounalIds,';') as j ON j.id = jc.JournalId
ORDER BY jc.CommentId ASC
GO
/****** Object:  StoredProcedure [dbo].[Journal_Comment_Save]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Comment_Save]
	@JournalId int,
	@CommentId int,
	@UserId int,
	@Comment nvarchar(max),
	@CommentXML xml,
	@DateUpdated datetime
AS

DECLARE @cxml xml
DECLARE @xml xml
DECLARE @cdataComment nvarchar(max)

IF EXISTS(SELECT * FROM dbo.[Journal_Comments] WHERE JournalId = @JournalId AND CommentId = @CommentId)
BEGIN
	IF (LEN(@Comment) < 2000)
	BEGIN
		UPDATE dbo.[Journal_Comments]
		SET Comment = @Comment,
			CommentXML = @CommentXML,
			DateUpdated = IsNull(@DateUpdated, GETUTCDATE())
		WHERE JournalId = @JournalId AND CommentId = @CommentId
	END
	ELSE
	BEGIN		
		SET @cxml = (SELECT CommentXML FROM dbo.[Journal_Comments] WHERE CommentId = @CommentId AND JournalId = @JournalId)
		IF @cxml IS NULL 
		BEGIN
			SET @xml = '<root></root>';
			UPDATE dbo.[Journal_Comments]
			SET CommentXML = @xml
			WHERE JournalId = @JournalId AND CommentId = @CommentId
		END

		IF NOT EXISTS(SELECT CommentId FROM dbo.[Journal_Comments] WHERE JournalId = @JournalId AND CommentId = @CommentID AND CommentXML.exist('/root/comment') = 1)
		BEGIN
			UPDATE dbo.[Journal_Comments]
			SET CommentXML.modify('insert <comment>NULL</comment> as last into (/root)[1]') 
			WHERE JournalId = @JournalId AND CommentId = @CommentId AND CommentXML.exist('/root') = 1
		END
		
		SET @cdataComment = '<![CDATA[' + @Comment + ']]>'
		UPDATE dbo.[Journal_Comments]
		SET CommentXML.modify('replace value of (/root/comment[1]/text())[1] with sql:variable("@cdataComment")'),
			Comment = NULL,
			DateUpdated = IsNull(@DateUpdated, GETUTCDATE())
		WHERE JournalId = @JournalId AND CommentId = @CommentId AND CommentXML.exist('/root/comment') = 1
	END
END
ELSE
BEGIN
	IF (LEN(@Comment) < 2000)
	BEGIN
		INSERT INTO dbo.[Journal_Comments]
			(JournalId, UserId, Comment, CommentXML, DateCreated, DateUpdated)
			VALUES
			(@JournalId, @UserId, @Comment, @CommentXML, GETUTCDATE(), GETUTCDATE())
		SET @CommentId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		INSERT INTO dbo.[Journal_Comments]
			(JournalId, UserId, Comment, CommentXML, DateCreated, DateUpdated)
			VALUES
			(@JournalId, @UserId, NULL, NULL, GETUTCDATE(), GETUTCDATE())
		SET @CommentId = SCOPE_IDENTITY()		
		
		SET @cxml = (SELECT CommentXML FROM dbo.[Journal_Comments] WHERE CommentId = @CommentId AND JournalId = @JournalId)
		IF @cxml IS NULL 
		BEGIN			
			SET @xml = '<root></root>';
			UPDATE dbo.[Journal_Comments]
			SET CommentXML = @xml
			WHERE JournalId = @JournalId AND CommentId = @CommentId
		END

		IF NOT EXISTS(SELECT CommentId FROM dbo.[Journal_Comments] WHERE JournalId = @JournalId AND CommentId = @CommentID AND CommentXML.exist('/root/comment') = 1)
		BEGIN
			UPDATE dbo.[Journal_Comments]
			SET CommentXML.modify('insert <comment>NULL</comment> as last into (/root)[1]') 
			WHERE JournalId = @JournalId AND CommentId = @CommentId AND CommentXML.exist('/root') = 1
		END
		
		SET @cdataComment = '<![CDATA[' + @Comment + ']]>'
		UPDATE dbo.[Journal_Comments]
		SET CommentXML.modify('replace value of (/root/comment[1]/text())[1] with sql:variable("@cdataComment")'),
			Comment = NULL
		WHERE JournalId = @JournalId AND CommentId = @CommentId AND CommentXML.exist('/root/comment') = 1
	END		
END
SELECT @CommentId
GO
/****** Object:  StoredProcedure [dbo].[Journal_Comments_ToggleDisable]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Comments_ToggleDisable]
@PortalId int,
@JournalId int,
@Disabled bit
AS
UPDATE dbo.[Journal]
	SET CommentsDisabled = @Disabled
	WHERE PortalId = @PortalId AND JournalId = @JournalId
GO
/****** Object:  StoredProcedure [dbo].[Journal_Comments_ToggleHidden]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Comments_ToggleHidden]
@PortalId int,
@JournalId int,
@Hidden bit
AS
UPDATE dbo.[Journal]
	SET CommentsHidden = @Hidden
	WHERE PortalId = @PortalId AND JournalId = @JournalId
GO
/****** Object:  StoredProcedure [dbo].[Journal_Delete]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Delete]
	@JournalId int,
	@SoftDelete int = 0
	AS

	-- Hard Delete
	IF @SoftDelete <> 1 
	BEGIN
		DELETE FROM dbo.[Journal_Security] WHERE JournalId = @JournalId
		DELETE FROM dbo.[Journal_Comments] WHERE JournalId = @JournalId
		DELETE FROM dbo.[Journal] WHERE JournalId = @JournalId
	END

	-- Soft Delete
	IF @SoftDelete = 1 
	BEGIN
		UPDATE dbo.[Journal] SET IsDeleted = 1 WHERE JournalId = @JournalId
	END
GO
/****** Object:  StoredProcedure [dbo].[Journal_DeleteByGroupId]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_DeleteByGroupId]
	@PortalId int,
	@GroupId int,
	@SoftDelete int = 0
	AS

	-- Hard Delete
	IF @SoftDelete <> 1 
	BEGIN
		DELETE dbo.[Journal_Security] 
		FROM dbo.[Journal_Security] as js  INNER JOIN dbo.[Journal] as j 
		   ON js.JournalId = j.JournalId
		WHERE j.PortalId = @PortalId AND j.GroupId = @GroupId AND @GroupId > 0 AND j.GroupId IS NOT NULL

		DELETE dbo.[Journal_Comments] 
		FROM dbo.[Journal_Comments] as jc  INNER JOIN dbo.[Journal] as j 
		   ON jc.JournalId = j.JournalId
		WHERE j.PortalId = @PortalId AND j.GroupId = @GroupId AND @GroupId > 0 AND j.GroupId IS NOT NULL

		DELETE FROM dbo.[Journal] WHERE PortalId = @PortalId AND GroupId = @GroupId AND @GroupId > 0 AND GroupId IS NOT NULL
	END

	-- Soft Delete
	IF @SoftDelete = 1 
	BEGIN
		UPDATE dbo.[Journal] SET IsDeleted = 1 WHERE PortalId = @PortalId AND GroupId = @GroupId AND @GroupId > 0 AND GroupId IS NOT NULL
	END
GO
/****** Object:  StoredProcedure [dbo].[Journal_DeleteByKey]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_DeleteByKey]
	@PortalId int,
	@ObjectKey nvarchar(255),
	@SoftDelete int = 0
	AS
	DECLARE @JournalId int
	SET @JournalId = (SELECT JournalId FROM dbo.[Journal] WHERE PortalId = @PortalId AND ObjectKey = @ObjectKey AND @ObjectKey <> '' AND ObjectKey IS NOT NULL)

	-- Hard Delete
	IF @JournalId > 0 AND @SoftDelete <> 1 
	BEGIN
		DELETE FROM dbo.[Journal_Security] WHERE JournalId = @JournalId
		DELETE FROM dbo.[Journal_Comments] WHERE JournalId = @JournalId
		DELETE FROM dbo.[Journal] WHERE JournalId = @JournalId
	END

	-- Soft Delete
	IF @JournalId > 0 AND @SoftDelete = 1 
	BEGIN
		UPDATE dbo.[Journal] SET IsDeleted = 1 WHERE JournalId = @JournalId
	END
GO
/****** Object:  StoredProcedure [dbo].[Journal_Get]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Get]
    @PortalId INT,
    @CurrentUserId INT,
    @JournalId INT,
    @IncludeAllItems INT = 0,
    @IsDeleted INT = 0,
    @SecurityCheck BIT = 0
    AS
    SELECT     j.JournalId, j.JournalTypeId, j.Title, j.Summary, j.UserId, j.DateCreated, j.DateUpdated, j.PortalId,
                j.ProfileId, j.GroupId, j.ObjectKey, j.AccessKey,
                "JournalOwner" = '<entity><id>' + CAST(p.UserId as nvarchar(150)) + '</id><name><![CDATA[' + p.DisplayName + ']]></name></entity>',
                "JournalAuthor" = CASE WHEN ISNULL(a.UserId,-1) >0 THEN '<entity><id>' + CAST(a.UserId as nvarchar(150)) + '</id><name><![CDATA[' + a.DisplayName + ']]></name></entity>' ELSE '' END,
                "JournalOwnerId" = ISNULL(j.ProfileId,j.UserId),
                 jt.Icon, jt.JournalType,
                "Profile" = CASE WHEN j.ProfileId > 0 THEN '<entity><id>' + CAST(p.UserID as nvarchar(150)) + '</id><name><![CDATA[' + p.DisplayName + ']]></name><vanity></vanity></entity>' ELSE '' END,
				"SimilarCount" = (SELECT COUNT(JournalId) FROM dbo.Journal WHERE ContentItemId = j.ContentItemId AND JournalTypeId = j.JournalTypeId),
                jd.JournalXML, ContentItemId, j.ItemData, j.IsDeleted, j.CommentsDisabled, j.CommentsHidden
    FROM        dbo.[Journal] AS j
                INNER JOIN dbo.[Journal_Types] as jt ON jt.JournalTypeId = j.JournalTypeId
                INNER JOIN dbo.[Journal_Security] AS js ON js.JournalId = j.JournalId
                INNER JOIN dbo.[Journal_User_Permissions](@PortalId,@CurrentUserId ,1) as t ON t.seckey = js.SecurityKey OR @SecurityCheck = 0
                LEFT OUTER JOIN dbo.[Journal_Data] as jd on jd.JournalId = j.JournalId 
                LEFT OUTER JOIN dbo.[Users] AS p ON j.ProfileId = p.UserID 
                LEFT OUTER JOIN dbo.[Users] AS a ON j.UserId = a.UserID
    WHERE       ((@IncludeAllItems = 0) AND (j.JournalId = @JournalId AND j.IsDeleted = @IsDeleted)) 
                OR 
                ((@IncludeAllItems = 1) AND (j.JournalId = @JournalId))
GO
/****** Object:  StoredProcedure [dbo].[Journal_GetByKey]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_GetByKey]
	@PortalId INT,
	@ObjectKey NVARCHAR(255),
	@IncludeAllItems INT = 0,
	@IsDeleted INT = 0
	AS
	SELECT     j.JournalId, j.JournalTypeId, j.Title, j.Summary, j.UserId, j.DateCreated, j.DateUpdated, j.PortalId,
				j.ProfileId, j.GroupId, j.ObjectKey, j.AccessKey,
				"JournalOwner" = '<entity><id>' + CAST(p.UserId as nvarchar(150)) + '</id><name><![CDATA[' + p.DisplayName + ']]></name></entity>',
				"JournalAuthor" = CASE WHEN ISNULL(a.UserId,-1) >0 THEN '<entity><id>' + CAST(a.UserId as nvarchar(150)) + '</id><name><![CDATA[' + a.DisplayName + ']]></name></entity>' ELSE '' END,
				"JournalOwnerId" = ISNULL(j.ProfileId,j.UserId),
				 jt.Icon, jt.JournalType,
				"Profile" = CASE WHEN j.ProfileId > 0 THEN '<entity><id>' + CAST(p.UserID as nvarchar(150)) + '</id><name><![CDATA[' + p.DisplayName + ']]></name><vanity></vanity></entity>' ELSE '' END,
				"SimilarCount" = (SELECT COUNT(JournalId) FROM dbo.Journal WHERE ContentItemId = j.ContentItemId AND JournalTypeId = j.JournalTypeId),
				jd.JournalXML, ContentItemId, j.ItemData, j.IsDeleted, j.CommentsDisabled, j.CommentsHidden
	FROM       	dbo.[Journal] AS j INNER JOIN
				dbo.[Journal_Types] as jt ON jt.JournalTypeId = j.JournalTypeId LEFT OUTER JOIN
				dbo.[Journal_Data] as jd on jd.JournalId = j.JournalId LEFT OUTER JOIN
				dbo.[Users] AS p ON j.ProfileId = p.UserID LEFT OUTER JOIN
				dbo.[Users] AS a ON j.UserId = a.UserID
	WHERE		((@IncludeAllItems = 0) AND (j.ObjectKey = @ObjectKey AND j.ObjectKey IS NOT NULL AND @ObjectKey <> '' AND j.IsDeleted = @IsDeleted)) 
				OR 
				((@IncludeAllItems = 1) AND (j.ObjectKey = @ObjectKey AND j.ObjectKey IS NOT NULL AND @ObjectKey <> ''))
GO
/****** Object:  StoredProcedure [dbo].[Journal_GetSearchItems]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_GetSearchItems]
	@PortalId INT,
	@ModuleId INT,
	@StartDate DATETIME,
	@StartJournalId INT,
	@NumbersOfResult INT = 500
AS
	WITH ValidJournals AS (
	SELECT	JournalId
			FROM (
					SELECT *, ROW_NUMBER() OVER (ORDER BY JournalId) rownumber FROM (
						SELECT  DISTINCT(j.JournalId)
								
						 FROM dbo.Journal j
						INNER JOIN dbo.Journal_Security js ON js.JournalId = j.JournalId
						INNER JOIN dbo.Users u ON u.UserID = j.UserId
						INNER JOIN dbo.ContentItems ci ON ci.ContentItemID = j.ContentItemId
                        LEFT JOIN dbo.Journal_Comments jc ON jc.JournalId = j.JournalId
						WHERE ci.ModuleID = @ModuleId
						AND (j.DateUpdated > @StartDate OR jc.DateUpdated > @StartDate) --check the update time both for journal item and journal comment
						AND j.JournalId > @StartJournalId
                        AND j.JournalTypeId IN (1,2,3,4)) AS T
				 ) AS T WHERE rownumber <= @NumbersOfResult )

				 SELECT  j.JournalId,
								JournalTypeId,
								j.UserId,
								DateUpdated,
								ProfileId,
								GroupId,
								u.DisplayName AS Title,
								Summary,
								js.SecurityKey,
                                ci.TabID,
								ci.ModuleID
						 FROM dbo.Journal j
						INNER JOIN dbo.Journal_Security js ON js.JournalId = j.JournalId
						INNER JOIN ValidJournals vj ON vj.JournalId = j.JournalId
						INNER JOIN dbo.Users u ON u.UserID = j.UserId
                        INNER JOIN dbo.ContentItems ci ON ci.ContentItemID = j.ContentItemId
GO
/****** Object:  StoredProcedure [dbo].[Journal_GetStatsForGroup]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_GetStatsForGroup]
	@PortalId INT,
	@GroupId INT
AS
SELECT Count(j.JournalTypeId) as JournalTypeCount, 
	   jt.JournalType 
	   FROM dbo.[Journal] AS j 
	   INNER JOIN dbo.[Journal_Types] AS jt ON jt.JournalTypeId = j.JournalTypeId
	WHERE j.GroupId = @GroupId AND j.PortalId = @PortalId AND j.IsDeleted = 0
	Group BY j.JournalTypeId, jt.JournalType
GO
/****** Object:  StoredProcedure [dbo].[Journal_Like]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Like]
@JournalId int,
@UserId int,
@UserName nvarchar(50)
AS 
IF NOT EXISTS (SELECT JournalId from dbo.[Journal_Data] WHERE JournalId = @JournalId)
	BEGIN
		DECLARE @x xml
		SET @x = '<items><item /></items>';
		INSERT INTO dbo.[Journal_Data] 
			(JournalId, JournalXML)
			VALUES
			(@JournalId, @x)
	END
IF EXISTS(SELECT j.JournalId 
			FROM dbo.Journal as j INNER JOIN
				dbo.Journal_Data as jx ON j.JournalId = jx.JournalId 
			WHERE j.JournalId = @JournalId 
				AND 
				jx.journalxml.exist('/items/likes/u[@uid=sql:variable("@userid")]') = 1)
BEGIN
UPDATE dbo.Journal_Data
SET JournalXML.modify('delete (/items/likes/u[@uid=sql:variable("@UserId")])')
WHERE JournalId = @JournalId 
	AND journalxml.exist('/items/likes/u[@uid=sql:variable("@UserId")]') = 1
END
ELSE
	BEGIN
		BEGIN
			IF NOT EXISTS(SELECT JournalId FROM dbo.Journal_Data
							WHERE JournalId = @JournalId 
									AND
								journalxml.exist('/items/likes') = 1)
				BEGIN
					UPDATE dbo.Journal_Data
					SET JournalXML.modify('insert <likes /> as last into (/items)[1]') 
					WHERE JournalId = @JournalId AND journalxml.exist('/items') = 1
				END
		END
		BEGIN
			UPDATE dbo.Journal_Data
			SET JournalXML.modify('insert <u uid="{xs:string(sql:variable("@UserId"))}" un="{xs:string(sql:variable("@UserName"))}" /> as last into (/items/likes)[1]')
			Where JournalId = @JournalId AND journalxml.exist('/items/likes') = 1
		END
	END
GO
/****** Object:  StoredProcedure [dbo].[Journal_LikeList]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_LikeList]
@PortalId int,
@JournalId int
AS
DECLARE @xdoc xml
set @xdoc = (SELECT journalxml.query('//likes') 
				from dbo.[Journal_Data] as jd
				INNER JOIN dbo.[Journal] as j ON j.JournalId = jd.JournalId
				 WHERE j.JournalId = @JournalId AND j.PortalId = @PortalId)
Select u.UserId, u.DisplayName,u.FirstName,u.LastName,u.Email,u.Username 
	FROM @xdoc.nodes('/likes//u') as e(x) 
CROSS APPLY dbo.[Users] as u
WHERE u.UserID = x.value('@uid[1]','int')
GO
/****** Object:  StoredProcedure [dbo].[Journal_ListForGroup]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_ListForGroup]
	@PortalId int,
	@ModuleId int,
	@CurrentUserId int,
	@GroupId int,
	@RowIndex int,
	@MaxRows int,
	@IncludeAllItems int = 0,
	@IsDeleted int = 0
	AS
	DECLARE @EndRow int
	SET @EndRow = @RowIndex + @MaxRows;
		DECLARE @j TABLE(id int IDENTITY, journalid int, datecreated datetime)
	IF EXISTS(SELECT * from dbo.[Journal_TypeFilters] WHERE ModuleId = @ModuleId)
	INSERT INTO @j 
		SELECT j.journalid, jt.datecreated from (
			SELECT DISTINCT js.JournalId from dbo.[Journal] as j
					INNER JOIN dbo.[Journal_Security] as js ON js.JournalId = j.JournalId
				INNER JOIN dbo.[Journal_User_Permissions](@PortalId,@CurrentUserId ,1) as t 
					ON t.seckey = js.SecurityKey AND (js.SecurityKey = 'R' + CAST(@GroupId as nvarchar(100)) OR js.SecurityKey = 'E')
					WHERE j.PortalId = @PortalId
			) as j INNER JOIN dbo.[Journal] jt ON jt.JournalId = j.JournalId AND jt.PortalId = @PortalId AND jt.GroupId = @GroupId
			INNER JOIN dbo.[Journal_TypeFilters] as jf ON jf.JournalTypeId = jt.JournalTypeId AND jf.ModuleId = @ModuleId
			ORDER BY jt.DateCreated DESC, jt.JournalId DESC;
	ELSE
	INSERT INTO @j 
		SELECT j.journalid, jt.datecreated from (
			SELECT DISTINCT js.JournalId from dbo.[Journal] as j
				INNER JOIN dbo.[Journal_Security] as js ON js.JournalId = j.JournalId
				INNER JOIN dbo.[Journal_User_Permissions](@PortalId,@CurrentUserId ,1) as t 
					ON t.seckey = js.SecurityKey AND (js.SecurityKey = 'R' + CAST(@GroupId as nvarchar(100)) OR js.SecurityKey = 'E')
					WHERE j.PortalId = @PortalId
			) as j INNER JOIN dbo.[Journal] jt ON jt.JournalId = j.JournalId AND jt.PortalId = @PortalId AND jt.GroupId = @GroupId
			ORDER BY jt.DateCreated DESC, jt.JournalId DESC;
	WITH journalItems  AS
	(
		SELECT	j.JournalId,
				ROW_NUMBER() OVER (ORDER BY j.JournalId DESC) AS RowNumber
		FROM	dbo.[Journal] as j INNER JOIN @j as jtmp ON jtmp.JournalId = j.JournalId
		WHERE j.PortalId = @PortalId
	)
	SELECT	j.JournalId, j.JournalTypeId, j.Title, j.Summary, j.UserId, j.DateCreated, j.DateUpdated, j.PortalId,
				j.ProfileId, j.GroupId, j.ObjectKey, j.AccessKey,
				"JournalOwner" = '<entity><id>' + CAST(r.RoleId as nvarchar(150)) + '</id><name><![CDATA[' + r.RoleName + ']]></name></entity>',
				"JournalAuthor" = CASE WHEN ISNULL(a.UserId,-1) >0 THEN '<entity><id>' + CAST(a.UserId as nvarchar(150)) + '</id><name><![CDATA[' + a.DisplayName + ']]></name></entity>' ELSE '' END,
				"JournalOwnerId" = ISNULL(j.ProfileId,j.UserId),
				 jt.Icon, jt.JournalType,
				"Profile" = CASE WHEN j.ProfileId > 0 THEN '<entity><id>' + CAST(p.UserID as nvarchar(150)) + '</id><name><![CDATA[' + p.DisplayName + ']]></name><vanity></vanity></entity>' ELSE '' END,
				"SimilarCount" = (SELECT COUNT(JournalId) FROM dbo.Journal WHERE ContentItemId = j.ContentItemId AND JournalTypeId = j.JournalTypeId),
				jd.JournalXML, j.ContentItemId, j.ItemData, RowNumber, j.IsDeleted, j.CommentsDisabled, j.CommentsHidden
	FROM	journalItems as ji INNER JOIN 
		dbo.[Journal] as j ON j.JournalId = ji.JournalId INNER JOIN
		dbo.[Journal_Types] as jt ON jt.JournalTypeId = j.JournalTypeId INNER JOIN
		dbo.[Roles] as r ON j.GroupId = r.RoleId LEFT OUTER JOIN
				dbo.[Journal_Data] as jd on jd.JournalId = j.JournalId LEFT OUTER JOIN
				dbo.[Users] AS p ON j.ProfileId = p.UserID LEFT OUTER JOIN
				dbo.[Users] AS a ON j.UserId = a.UserID
	WHERE		((@IncludeAllItems = 0) AND (RowNumber BETWEEN @RowIndex AND @EndRow AND j.IsDeleted = @IsDeleted)) 
				OR 
				((@IncludeAllItems = 1) AND (RowNumber BETWEEN @RowIndex AND @EndRow))
	ORDER BY RowNumber ASC;
GO
/****** Object:  StoredProcedure [dbo].[Journal_ListForProfile]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_ListForProfile]
	@PortalId int,
	@ModuleId int,
	@CurrentUserId int,
	@ProfileId int,
	@RowIndex int,
	@MaxRows int,
	@IncludeAllItems int = 0,
	@IsDeleted int = 0
	AS
	DECLARE @EndRow int
	SET @EndRow = @RowIndex + @MaxRows;
	DECLARE @j TABLE(id int IDENTITY, journalid int, datecreated datetime)
	IF EXISTS(SELECT * from dbo.[Journal_TypeFilters] WHERE ModuleId = @ModuleId)
	INSERT INTO @j 
		SELECT j.journalid, jt.datecreated from (
			SELECT DISTINCT js.JournalId from dbo.[Journal] as j
				INNER JOIN dbo.[Journal_Security] as js ON js.JournalId = j.JournalId
				INNER JOIN dbo.[Journal_User_Permissions](@PortalId,@CurrentUserId ,1) as t ON t.seckey = js.SecurityKey
				WHERE j.ProfileId = @ProfileId AND j.PortalId = @PortalId
			) as j INNER JOIN dbo.[Journal] jt ON jt.JournalId = j.JournalId AND jt.PortalId = @PortalId
			INNER JOIN dbo.[Journal_TypeFilters] as jf ON jf.JournalTypeId = jt.JournalTypeId AND jf.ModuleId = @ModuleId
			ORDER BY jt.DateCreated DESC, jt.JournalId DESC;
	ELSE
	INSERT INTO @j 
		SELECT j.journalid, jt.datecreated from (
			SELECT DISTINCT js.JournalId from dbo.[Journal] as j
				INNER JOIN dbo.[Journal_Security] as js ON js.JournalId = j.JournalId
				INNER JOIN dbo.[Journal_User_Permissions](@PortalId,@CurrentUserId ,1) as t ON t.seckey = js.SecurityKey
				WHERE j.ProfileId = @ProfileId AND j.PortalId = @PortalId
			) as j INNER JOIN dbo.[Journal] jt ON jt.JournalId = j.JournalId AND jt.PortalId = @PortalId
			ORDER BY jt.DateCreated DESC, jt.JournalId DESC;
	WITH journalItems  AS
	(
		SELECT	j.JournalId,
				ROW_NUMBER() OVER (ORDER BY j.JournalId DESC) AS RowNumber
		FROM	dbo.[Journal] as j INNER JOIN @j as jtmp ON jtmp.JournalId = j.JournalId
		WHERE j.PortalId = @PortalId AND j.ProfileId = @ProfileId
	)
	SELECT	j.JournalId, j.JournalTypeId, j.Title, j.Summary, j.UserId, j.DateCreated, j.DateUpdated, j.PortalId,
				j.ProfileId, j.GroupId, j.ObjectKey, j.AccessKey,
				"JournalOwner" = '<entity><id>' + CAST(p.UserId as nvarchar(150)) + '</id><name><![CDATA[' + p.DisplayName + ']]></name></entity>',
				"JournalAuthor" = CASE WHEN ISNULL(a.UserId,-1) >0 THEN '<entity><id>' + CAST(a.UserId as nvarchar(150)) + '</id><name><![CDATA[' + a.DisplayName + ']]></name></entity>' ELSE '' END,
				"JournalOwnerId" = ISNULL(j.ProfileId,j.UserId),
				 jt.Icon, jt.JournalType,
				"Profile" = CASE WHEN j.ProfileId > 0 THEN '<entity><id>' + CAST(p.UserID as nvarchar(150)) + '</id><name><![CDATA[' + p.DisplayName + ']]></name><vanity></vanity></entity>' ELSE '' END,
				"SimilarCount" = (SELECT COUNT(JournalId) FROM dbo.Journal WHERE ContentItemId = j.ContentItemId AND JournalTypeId = j.JournalTypeId),
				jd.JournalXML, j.ContentItemId, j.ItemData, RowNumber, j.IsDeleted, j.CommentsDisabled, j.CommentsHidden
	FROM	journalItems as ji INNER JOIN 
		dbo.[Journal] as j ON j.JournalId = ji.JournalId INNER JOIN
	dbo.[Journal_Types] as jt ON jt.JournalTypeId = j.JournalTypeId LEFT OUTER JOIN
				dbo.[Journal_Data] as jd on jd.JournalId = j.JournalId LEFT OUTER JOIN
				dbo.[Users] AS p ON j.ProfileId = p.UserID LEFT OUTER JOIN
				dbo.[Users] AS a ON j.UserId = a.UserID
	WHERE	((@IncludeAllItems = 0) AND (RowNumber BETWEEN @RowIndex AND @EndRow AND j.IsDeleted = @IsDeleted)) 
			OR 
			((@IncludeAllItems = 1) AND (RowNumber BETWEEN @RowIndex AND @EndRow))	
	ORDER BY RowNumber ASC;
GO
/****** Object:  StoredProcedure [dbo].[Journal_ListForSummary]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_ListForSummary]
	@PortalId int,
	@ModuleId int,
	@CurrentUserId int,
	@RowIndex int,
	@MaxRows int,
	@IncludeAllItems int = 0,
	@IsDeleted int = 0	
	AS
	IF @RowIndex = 0
	BEGIN
		SET @RowIndex = 1
	END
	DECLARE @EndRow int
	SET @EndRow = @RowIndex + @MaxRows - 1;
	DECLARE @j TABLE(id int IDENTITY, journalid int, datecreated datetime)
	IF EXISTS(SELECT * from dbo.[Journal_TypeFilters] WHERE ModuleId = @ModuleId)
	INSERT INTO @j 
		SELECT j.journalid, jt.datecreated from (
			SELECT DISTINCT js.JournalId from dbo.[Journal] as j
				INNER JOIN dbo.[Journal_Security] as js ON js.JournalId = j.JournalId
				INNER JOIN dbo.[Journal_User_Permissions](@PortalId,@CurrentUserId ,1) as t ON t.seckey = js.SecurityKey
				WHERE j.PortalId = @PortalId
			) as j INNER JOIN dbo.[Journal] jt ON jt.JournalId = j.JournalId AND jt.PortalId = @PortalId
			INNER JOIN dbo.[Journal_TypeFilters] as jf ON jf.JournalTypeId = jt.JournalTypeId AND jf.ModuleId = @ModuleId
			ORDER BY jt.DateCreated DESC, jt.JournalId DESC;
	ELSE
	INSERT INTO @j 
		SELECT j.journalid, jt.datecreated from (
			SELECT DISTINCT js.JournalId from dbo.[Journal] as j
				INNER JOIN dbo.[Journal_Security] as js ON js.JournalId = j.JournalId
				INNER JOIN dbo.[Journal_User_Permissions](@PortalId,@CurrentUserId ,1) as t ON t.seckey = js.SecurityKey
				WHERE j.PortalId = @PortalId
			) as j INNER JOIN dbo.[Journal] jt ON jt.JournalId = j.JournalId AND jt.PortalId = @PortalId
			ORDER BY jt.DateCreated DESC, jt.JournalId DESC;
	WITH journalItems  AS
	(
		SELECT	j.JournalId,
				ROW_NUMBER() OVER (ORDER BY j.JournalId DESC) AS RowNumber
		FROM	dbo.[Journal] as j INNER JOIN @j as jtmp ON jtmp.JournalId = j.JournalId
		WHERE j.PortalId = @PortalId
	)
	SELECT	j.JournalId, j.JournalTypeId, j.Title, j.Summary, j.UserId, j.DateCreated, j.DateUpdated, j.PortalId,
				j.ProfileId, j.GroupId, j.ObjectKey, j.AccessKey,
				"JournalOwner" = '<entity><id>' + CAST(p.UserId as nvarchar(150)) + '</id><name><![CDATA[' + p.DisplayName + ']]></name></entity>',
				"JournalAuthor" = CASE WHEN ISNULL(a.UserId,-1) >0 THEN '<entity><id>' + CAST(a.UserId as nvarchar(150)) + '</id><name><![CDATA[' + a.DisplayName + ']]></name></entity>' ELSE '' END,
				"JournalOwnerId" = ISNULL(j.ProfileId,j.UserId),
				 jt.Icon, jt.JournalType,
				"Profile" = CASE WHEN j.ProfileId > 0 THEN '<entity><id>' + CAST(p.UserID as nvarchar(150)) + '</id><name><![CDATA[' + p.DisplayName + ']]></name><vanity></vanity></entity>' ELSE '' END,
				"SimilarCount" = (SELECT COUNT(JournalId) FROM dbo.Journal WHERE ContentItemId = j.ContentItemId AND JournalTypeId = j.JournalTypeId),
				jd.JournalXML, j.ContentItemId, j.ItemData, RowNumber, j.IsDeleted, j.CommentsDisabled, j.CommentsHidden
	FROM	journalItems as ji INNER JOIN 
		dbo.[Journal] as j ON j.JournalId = ji.JournalId INNER JOIN
	dbo.[Journal_Types] as jt ON jt.JournalTypeId = j.JournalTypeId LEFT OUTER JOIN
				dbo.[Journal_Data] as jd on jd.JournalId = j.JournalId LEFT OUTER JOIN
				dbo.[Users] AS p ON j.ProfileId = p.UserID LEFT OUTER JOIN
				dbo.[Users] AS a ON j.UserId = a.UserID
	WHERE	((@IncludeAllItems = 0) AND (RowNumber BETWEEN @RowIndex AND @EndRow AND j.IsDeleted = @IsDeleted)) 
			OR 
			((@IncludeAllItems = 1) AND (RowNumber BETWEEN @RowIndex AND @EndRow ))
	ORDER BY RowNumber ASC;
GO
/****** Object:  StoredProcedure [dbo].[Journal_Save]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Save]
@PortalId int,
@JournalId int,
@JournalTypeId int,
@UserId int,
@ProfileId int,
@GroupId int,
@Title nvarchar(255),
@Summary nvarchar(2000),
@ItemData nvarchar(2000),
@JournalXML xml,
@ObjectKey nvarchar(255),
@AccessKey uniqueidentifier,
@SecuritySet nvarchar(2000),
@CommentsDisabled bit,
@CommentsHidden bit
AS
INSERT INTO dbo.[Journal]
	(JournalTypeId, UserId, DateCreated, DateUpdated, PortalId, ProfileId, GroupId,Title,Summary, ObjectKey, AccessKey, ItemData, CommentsHidden, CommentsDisabled)
	VALUES
	(@JournalTypeId, @UserId, GETUTCDATE(), GETUTCDATE(), @PortalId, @ProfileId, @GroupId, @Title, @Summary, @ObjectKey, @AccessKey, @ItemData, @CommentsHidden, @CommentsDisabled)
SET @JournalId = SCOPE_IDENTITY()
BEGIN
INSERT INTO dbo.[Journal_Security]
	(JournalId, SecurityKey) 
	SELECT @JournalId, string from dbo.[Journal_SplitText](@SecuritySet,',')
END
IF @JournalXML IS NOT NULL
BEGIN
INSERT INTO dbo.[Journal_Data]
	(JournalId, JournalXML)
	VALUES
	(@JournalId, @JournalXML)
END
SELECT @JournalId
GO
/****** Object:  StoredProcedure [dbo].[Journal_TypeFilters_Delete]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_TypeFilters_Delete]
@PortalId int,
@ModuleId int
AS
DELETE FROM dbo.[Journal_TypeFilters] WHERE PortalId = @PortalId AND ModuleId=@ModuleId
GO
/****** Object:  StoredProcedure [dbo].[Journal_TypeFilters_List]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_TypeFilters_List]
@PortalId int,
@ModuleId int
AS
SELECT jt.JournalTypeId, jt.JournalType from dbo.[Journal_Types] as jt INNER JOIN
	dbo.[Journal_TypeFilters] as jf ON jf.JournalTypeId = jt.JournalTypeId
WHERE jt.PortalId = @PortalId AND jf.ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[Journal_TypeFilters_Save]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_TypeFilters_Save]
@PortalId int,
@ModuleId int,
@JournalTypeId int
AS
INSERT INTO dbo.[Journal_TypeFilters] 
	(PortalId, ModuleId, JournalTypeId)
	VALUES
	(@PortalId, @ModuleId, @JournalTypeId)
GO
/****** Object:  StoredProcedure [dbo].[Journal_Types_Delete]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Types_Delete]
@JournalTypeId int,
@PortalId int
AS
IF @JournalTypeId > 200
	BEGIN
		DELETE FROM dbo.[Journal_Security]
		WHERE JournalId IN (SELECT JournalId FROM dbo.[Journal] WHERE JournalTypeId=@JournalTypeId AND PortalId=@PortalId)
		DELETE FROM dbo.[Journal]
		WHERE 
			JournalTypeId = @JournalTypeId 
			AND 
			PortalId = @PortalId
		DELETE FROM dbo.[Journal_TypeFilters]
		WHERE
			JournalTypeId = @JournalTypeId
			AND 
			PortalId = @PortalId
		DELETE FROM dbo.[Journal_Types]
		WHERE 
			JournalTypeId = @JournalTypeId
			AND
			PortalId = @PortalId
	END
GO
/****** Object:  StoredProcedure [dbo].[Journal_Types_Get]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Types_Get]
@JournalType nvarchar(25)
AS
SELECT * from dbo.[Journal_Types] WHERE JournalType = @JournalType
GO
/****** Object:  StoredProcedure [dbo].[Journal_Types_GetById]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Types_GetById]
@JournalTypeId int
AS
SELECT * from dbo.[Journal_Types] WHERE JournalTypeId = @JournalTypeId
GO
/****** Object:  StoredProcedure [dbo].[Journal_Types_List]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Types_List]
@PortalId int
AS
SELECT * 
FROM dbo.[Journal_Types]
WHERE (PortalId = -1 OR PortalId = @PortalId)
GO
/****** Object:  StoredProcedure [dbo].[Journal_Types_Save]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Types_Save]
@JournalTypeId int,
@JournalType nvarchar(25),
@icon nvarchar(25),
@PortalId int,
@IsEnabled bit,
@AppliesToProfile bit,
@AppliesToGroup bit,
@AppliesToStream bit,
@options nvarchar(max),
@SupportsNotify bit
AS
IF EXISTS(SELECT JournalTypeId from dbo.[Journal_Types] WHERE JournalTypeId=@JournalTypeId AND PortalId = @PortalId)
	BEGIN
		UPDATE dbo.[Journal_Types]
			SET
				JournalType=@JournalType,
				icon=@icon,
				IsEnabled = @IsEnabled,
				AppliesToProfile = @AppliesToProfile,
				AppliesToGroup = @AppliesToGroup,
				AppliesToStream = @AppliesToStream,
				Options = @options,
				SupportsNotify = @SupportsNotify
			WHERE
				PortalId = @PortalId AND JournalTypeId = @JournalTypeId
	END
ELSE
	BEGIN
		SET @JournalTypeId = (SELECT MAX(JournalTypeId)+1 FROM dbo.[Journal_Types])
		INSERT INTO dbo.[Journal_Types]
			(JournalTypeId, JournalType, icon, PortalId, IsEnabled, AppliesToProfile, AppliesToGroup, AppliesToStream, Options, SupportsNotify)
			VALUES
			(@JournalTypeId, @JournalType, @icon, @PortalId, @IsEnabled, @AppliesToProfile, @AppliesToGroup, @AppliesToStream, @options, @SupportsNotify)
	END
SELECT @JournalTypeId
GO
/****** Object:  StoredProcedure [dbo].[Journal_Update]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_Update]
@PortalId int,
@JournalId int,
@JournalTypeId int,
@UserId int,
@ProfileId int,
@GroupId int,
@Title nvarchar(255),
@Summary nvarchar(2000),
@ItemData nvarchar(2000),
@JournalXML xml,
@ObjectKey nvarchar(255),
@AccessKey uniqueidentifier,
@SecuritySet nvarchar(2000),
@CommentsDisabled bit,
@CommentsHidden bit
AS
UPDATE dbo.[Journal]
	SET 
		JournalTypeId = @JournalTypeId,
		UserId = @UserId,
		DateUpdated = GETUTCDATE(),
		PortalId = @PortalId,
		ProfileId = @ProfileId,
		GroupId = @GroupId,
		Title = @Title,
		Summary = @Summary,
		ObjectKey = @ObjectKey,
		AccessKey = @AccessKey,
		ItemData = @ItemData,
		CommentsHidden = @CommentsHidden,
		CommentsDisabled = @CommentsDisabled
	WHERE JournalId = @JournalId
IF @SecuritySet IS NOT NULL AND @SecuritySet <> ''
BEGIN
DELETE FROM dbo.[Journal_Security] WHERE JournalId = @JournalId
INSERT INTO dbo.[Journal_Security]
	(JournalId, SecurityKey) 
	SELECT @JournalId, string from dbo.[Journal_SplitText](@SecuritySet,',')
END
SELECT @JournalId
GO
/****** Object:  StoredProcedure [dbo].[Journal_UpdateContentItemId]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Journal_UpdateContentItemId]
@JournalId int,
@ContentItemId int
AS
UPDATE dbo.[Journal]
	SET ContentItemId = @ContentItemId
WHERE JournalId = @JournalId
GO
/****** Object:  StoredProcedure [dbo].[LocalizeTab]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LocalizeTab] 
	@TabId					int,
	@CultureCode			nvarchar(10),
	@LastModifiedByUserID	int
AS
	BEGIN
		UPDATE dbo.Tabs
			SET 
				CultureCode				= @CultureCode,
				LastModifiedByUserID	= @LastModifiedByUserID,
				LastModifiedOnDate		= getdate()					
			WHERE TabID = @TabId
			
		UPDATE dbo.TabModules
			SET 
				CultureCode				= @CultureCode,
				LastModifiedByUserID	= @LastModifiedByUserID,
				LastModifiedOnDate		= getdate()					
			WHERE TabID = @TabId
	END
GO
/****** Object:  StoredProcedure [dbo].[Messaging_GetInbox]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Messaging_GetInbox]
	@PortalID int,
	@UserID int,
	@PageNumber int,
	@PageSize int
AS
	-- Set the page bounds
	DECLARE 
		@PageLowerBound INT, 
		@PageUpperBound INT, 
		@RowsToReturn int, 
		@PageIndex int

		/* this is 1-based rather than 0-based indexing. Accomodating so that we are consistent with paging */
		SET @PageIndex = @PageNumber - 1

		exec dbo.[CalculatePagingInformation] @PageIndex, @PageSize, @RowsToReturn output, @PageLowerBound output, @PageUpperBound output

		begin 
			with UserInbox as (
				select * , ROW_NUMBER() over (order by Date desc) as RowNumber
					from dbo.Messaging_Messages 
					where (ToUserID = @UserID AND Status IN (1,2) AND SkipPortal = '0') 
						OR (FromUserID = @UserID AND Status = 0)
			)
			select * from UserInbox
				where RowNumber > @PageLowerBound AND RowNumber < @PageUpperBound
				order by RowNumber
		end
GO
/****** Object:  StoredProcedure [dbo].[Messaging_GetInboxCount]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Messaging_GetInboxCount] 
	@PortalID int,
	@UserID int
AS

	SELECT COUNT (*)[Body]
	FROM dbo.Messaging_Messages
	WHERE (ToUserID= @UserID AND Status in (1,2) AND SkipPortal = '0') 
		OR (FromUserID = @UserID AND Status = 0)
GO
/****** Object:  StoredProcedure [dbo].[Messaging_GetMessage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Messaging_GetMessage] 
	@MessageID bigint
AS
	SELECT * FROM Messaging_Messages WHERE MessageID = @MessageID
GO
/****** Object:  StoredProcedure [dbo].[Messaging_GetNewMessageCount]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Messaging_GetNewMessageCount] 
	@PortalID int,
	@UserID int
AS
	SELECT count(*) FROM Messaging_Messages WHERE ToUserID = @UserID AND Status = 1
GO
/****** Object:  StoredProcedure [dbo].[Messaging_GetNextMessageForDispatch]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Messaging_GetNextMessageForDispatch] 
	@SchedulerInstance uniqueidentifier
AS
	Declare  @target_messageID int

	SELECT @target_messageID =  MessageID FROM Messaging_Messages WHERE EmailSent = 0  AND  
	(EmailSchedulerInstance is NULL or EmailSchedulerInstance= '00000000-0000-0000-0000-000000000000') 
	AND status not in  (0,3) ORDER BY Date DESC

Update Messaging_Messages set EmailSchedulerInstance = @SchedulerInstance  where MessageID = @target_messageID
select * from Messaging_Messages where MessageID = @target_messageID
GO
/****** Object:  StoredProcedure [dbo].[Messaging_MarkMessageAsDispatched]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Messaging_MarkMessageAsDispatched]
	@MessageId int
AS
BEGIN
	Update Messaging_Messages set EmailSent = 1, EmailSentDate =GETDATE()   where MessageID =@MessageId
END
GO
/****** Object:  StoredProcedure [dbo].[Messaging_Save_Message]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Messaging_Save_Message] 
   @PortalID int,
   @FromUserID int,
   @ToUserID int,
   @ToRoleID int,
   @Status int,
   @Subject nvarchar(max),
   @Body nvarchar(max),
   @Date datetime,
   @Conversation uniqueidentifier,
   @ReplyTo bigint,
   @AllowReply bit,
   @SkipPortal bit

AS
	BEGIN
		INSERT INTO dbo.Messaging_Messages
       ([PortalID]
       ,[FromUserID]
	   ,[FromUserName]
       ,[ToUserID]
       ,[ToRoleID]
	   ,[ToUserName]
       ,[Status]
       ,[Subject]
       ,[Body]
       ,[Date]
       ,[Conversation]
       ,[ReplyTo]
       ,[AllowReply]
       ,[SkipPortal]
		,[EmailSent])
 SELECT
       @PortalID,
       @FromUserID,
	   (SELECT UserName FROM Users WHERE UserID = @FromUserID) as FromUserName,
       @ToUserID,
       @ToRoleID,
	   (SELECT UserName FROM Users WHERE UserID = @ToUserID) as ToUserName, 
       @Status,
       @Subject, 
       @Body,
       @Date, 
       @Conversation,
       @ReplyTo,
       @AllowReply, 
       @SkipPortal,
	   '0'
			
		SELECT SCOPE_IDENTITY()						
	END
GO
/****** Object:  StoredProcedure [dbo].[Messaging_UpdateMessage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Messaging_UpdateMessage] 
   @MessageID bigint,
   @ToUserID int,
   @ToRoleID int,
   @Status int,
   @Subject nvarchar(max),
   @Body nvarchar(max),
   @Date datetime,
   @ReplyTo bigint,
   @AllowReply bit,
   @SkipPortal bit
AS
	UPDATE dbo.Messaging_Messages
	SET ToUserID=@ToUserID, 
		ToRoleID=@ToRoleID, 
		Status=@Status, 
		Subject=@Subject, 
		Body=@Body, 
		Date= @Date,
		ReplyTo= @ReplyTo,
		AllowReply = @AllowReply,
		SkipPortal = @SkipPortal
	WHERE MessageID=@MessageID
GO
/****** Object:  StoredProcedure [dbo].[Mobile_DeletePreviewProfile]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Mobile_DeletePreviewProfile] @Id INT
AS 
		
    DELETE  FROM dbo.Mobile_PreviewProfiles
    WHERE   Id = @Id
GO
/****** Object:  StoredProcedure [dbo].[Mobile_DeleteRedirection]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Mobile_DeleteRedirection] @Id INT
AS 
    DELETE  FROM dbo.Mobile_RedirectionRules
    WHERE   RedirectionId = @id
		
    DELETE  FROM dbo.Mobile_Redirections
    WHERE   Id = @Id
GO
/****** Object:  StoredProcedure [dbo].[Mobile_DeleteRedirectionRule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Mobile_DeleteRedirectionRule] @Id INT
AS 
    DELETE  FROM dbo.Mobile_RedirectionRules
    WHERE   Id = @id
GO
/****** Object:  StoredProcedure [dbo].[Mobile_GetAllRedirections]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Mobile_GetAllRedirections]
AS 
    SELECT  Id ,
            PortalId ,
            Name ,
            [Type] ,
            SortOrder ,
            SourceTabId ,
			IncludeChildTabs ,
            TargetType ,
            TargetValue ,
			Enabled ,
            CreatedByUserID ,
            CreatedOnDate ,
            LastModifiedByUserID ,
            LastModifiedOnDate
    FROM    dbo.Mobile_Redirections    
	ORDER BY PortalId ASC, SortOrder ASC
GO
/****** Object:  StoredProcedure [dbo].[Mobile_GetPreviewProfiles]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Mobile_GetPreviewProfiles] @PortalId INT
AS 
    SELECT  Id, PortalId, Name, Width, Height, UserAgent, SortOrder, CreatedByUserID, CreatedOnDate, LastModifiedByUserID, LastModifiedOnDate
    FROM    dbo.Mobile_PreviewProfiles
    WHERE   PortalId = @PortalId
	ORDER BY SortOrder ASC
GO
/****** Object:  StoredProcedure [dbo].[Mobile_GetRedirectionRules]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Mobile_GetRedirectionRules] @RedirectionId INT
AS 
    SELECT  Id ,
            RedirectionId ,
            Capability ,
            Expression
    FROM    Mobile_RedirectionRules
    WHERE RedirectionId = @RedirectionId
GO
/****** Object:  StoredProcedure [dbo].[Mobile_GetRedirections]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Mobile_GetRedirections] @PortalId INT
AS 
    SELECT  Id ,
            PortalId ,
            Name ,
            [Type] ,
            SortOrder ,
            SourceTabId ,
			IncludeChildTabs ,
            TargetType ,
            TargetValue ,
			Enabled ,
            CreatedByUserID ,
            CreatedOnDate ,
            LastModifiedByUserID ,
            LastModifiedOnDate
    FROM    dbo.Mobile_Redirections
    WHERE   PortalId = @PortalId
	ORDER BY SortOrder ASC
GO
/****** Object:  StoredProcedure [dbo].[Mobile_SavePreviewProfile]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Mobile_SavePreviewProfile]
    @Id INT ,
    @PortalId INT ,
    @Name NVARCHAR(50) ,
    @Width INT ,
    @Height INT ,
	@UserAgent NVARCHAR(260) ,
	@SortOrder INT ,
    @UserId INT
AS 
    IF ( @Id = -1 ) 
        BEGIN
            INSERT  dbo.Mobile_PreviewProfiles
                    ( PortalId ,
                      Name ,
                      Width ,
                      Height ,
					  UserAgent ,
					  SortOrder ,
                      CreatedByUserID ,
                      CreatedOnDate ,
                      LastModifiedByUserID ,
                      LastModifiedOnDate
			        
                    )
            VALUES  ( @PortalId , -- PortalId - int
                      @Name , -- Name - nvarchar(50)
                      @Width , -- Width - int
                      @Height , -- Height - int
					  @UserAgent ,
					  @SortOrder ,
                      @UserId , -- CreatedBy - int
                      GETDATE() , -- CreatedOn - datetime
                      @UserId , -- LastModifiedBy - int
                      GETDATE() -- LastModifiedOn - datetime
			        
                    )
                    
            SELECT  @Id = SCOPE_IDENTITY()
        END
    ELSE 
        BEGIN
            UPDATE  dbo.Mobile_PreviewProfiles
            SET     Name = @Name ,
                    Width = @Width ,
                    Height = @Height ,
					UserAgent = @UserAgent ,
					SortOrder = @SortOrder ,
                    LastModifiedByUserID = @UserId ,
                    LastModifiedOnDate = GETDATE()
            WHERE   Id = @Id
        END
        
    SELECT  @Id
GO
/****** Object:  StoredProcedure [dbo].[Mobile_SaveRedirection]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Mobile_SaveRedirection]
    @Id INT ,
    @PortalId INT ,
    @Name NVARCHAR(50) ,
    @Type INT ,
    @SortOrder INT ,
    @SourceTabId INT ,
	@IncludeChildTabs BIT ,
    @TargetType INT ,
    @TargetValue NVARCHAR(260) ,
	@Enabled BIT,
    @UserId INT
AS 
    IF ( @Id = -1 ) 
        BEGIN
            INSERT  dbo.Mobile_Redirections
                    ( PortalId ,
                      Name ,
                      Type ,
                      SortOrder ,
                      SourceTabId ,
					  IncludeChildTabs ,
                      TargetType ,
                      TargetValue ,
					  Enabled ,
                      CreatedByUserID ,
                      CreatedOnDate ,
                      LastModifiedByUserID ,
                      LastModifiedOnDate
			        
                    )
            VALUES  ( @PortalId , -- PortalId - int
                      @Name , -- Name - nvarchar(50)
                      @Type , -- Type - int
                      @SortOrder , -- SortOrder - int
                      @SourceTabId , -- SourceTabId - int
					  @IncludeChildTabs ,
                      @TargetType ,
                      @TargetValue ,
					  @Enabled ,
                      @UserId , -- CreatedBy - int
                      GETDATE() , -- CreatedOn - datetime
                      @UserId , -- LastModifiedBy - int
                      GETDATE() -- LastModifiedOn - datetime
			        
                    )
		SELECT  SCOPE_IDENTITY()
        END
    ELSE 
        BEGIN
            UPDATE  dbo.Mobile_Redirections
            SET     Name = @Name ,
                    [Type] = @Type ,
                    SortOrder = @SortOrder ,
                    SourceTabId = @SourceTabId ,
					IncludeChildTabs = @IncludeChildTabs ,
                    TargetType = @TargetType ,
                    TargetValue = @TargetValue ,
					Enabled = @Enabled ,
                    LastModifiedByUserID = @UserId ,
                    LastModifiedOnDate = GETDATE()
            WHERE   Id = @Id
			SELECT @Id
        END
GO
/****** Object:  StoredProcedure [dbo].[Mobile_SaveRedirectionRule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Mobile_SaveRedirectionRule]
    @Id INT ,
    @RedirectionId INT ,
    @Capbility NVARCHAR(50) ,
    @Expression NVARCHAR(50)
AS 
    IF @Id = -1 
        BEGIN
            INSERT  INTO dbo.Mobile_RedirectionRules
                    ( RedirectionId ,
                      Capability ,
                      Expression
		        )
            VALUES  ( @RedirectionId , -- RedirectionId - int
                      @Capbility , -- Capability - nvarchar(50)
                      @Expression  -- Expression - nvarchar(50)
		        )
        END
    ELSE 
        BEGIN
            UPDATE  dbo.Mobile_RedirectionRules
            SET     Capability = @Capbility ,
                    Expression = @Expression
            WHERE   Id = @Id
        END
GO
/****** Object:  StoredProcedure [dbo].[MoveTabAfter]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MoveTabAfter] 
	@TabId					int,
	@AfterTabId				int,
	@LastModifiedByUserID	int
AS
	BEGIN
		DECLARE @OldParentId int
		DECLARE @NewParentId int
		DECLARE @PortalId int
		
		SET @OldParentId = (SELECT ParentId FROM dbo.Tabs WHERE TabID = @TabId)
		SET @NewParentId = (SELECT ParentId FROM dbo.Tabs WHERE TabID = @AfterTabId)
		SET @PortalId = (SELECT PortalId FROM dbo.Tabs WHERE TabID = @TabId)

		DECLARE @TabOrder int
		SET @TabOrder = (SELECT TabOrder FROM dbo.Tabs WHERE TabID = @TabId)
		
		IF (@OldParentId <> @NewParentId OR NOT (@OldParentId IS NULL AND @NewParentId IS NULL))
			-- Parent has changed
			BEGIN
				-- update TabOrder of Tabs with same original Parent
				UPDATE dbo.Tabs
					SET TabOrder = TabOrder - 2
					WHERE (ParentId = @OldParentId OR (ParentId IS NULL AND @OldParentId IS NULL)) 
						AND TabOrder > @TabOrder
						AND (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))

				-- Get TabOrder of AfterTab
				SET @TabOrder = (SELECT TabOrder FROM dbo.Tabs WHERE TabID = @AfterTabId)
						
				-- update TabOrder of Tabs with same new Parent
				UPDATE dbo.Tabs
					SET TabOrder = TabOrder + 2
					WHERE (ParentId = @NewParentId OR (ParentId IS NULL AND @NewParentId IS NULL)) 
						AND TabOrder > @TabOrder
						AND (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))

				-- Update Tab with new TabOrder
				UPDATE dbo.Tabs
					SET 
						ParentId				= @NewParentId,
						TabOrder				= @TabOrder + 2,
						LastModifiedByUserID	= @LastModifiedByUserID,
						LastModifiedOnDate		= GETDATE()					
					WHERE TabID = @TabId
				EXEC dbo.BuildTabLevelAndPath @TabId, 1
			END
		ELSE
			-- Parent has not changed
			BEGIN
				-- Remove Tab from TabOrder
				UPDATE dbo.Tabs
					SET TabOrder = -1
					WHERE TabID = @TabId
					
				-- Reorder
				UPDATE dbo.Tabs
					SET TabOrder = TabOrder - 2
					WHERE (ParentId = @OldParentId OR (ParentId IS NULL AND @OldParentId IS NULL)) 
						AND TabOrder > @TabOrder
						AND TabId <> @TabId
						AND (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
						
				-- Get TabOrder of AfterTab
				SET @TabOrder = (SELECT TabOrder FROM dbo.Tabs WHERE TabID = @AfterTabId)
										
				-- Reorder					
				UPDATE dbo.Tabs
					SET TabOrder = TabOrder + 2
					WHERE (ParentId = @OldParentId OR (ParentId IS NULL AND @OldParentId IS NULL)) 
						AND TabOrder > @TabOrder
						AND (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))

				-- Update Tab with new TabOrder
				UPDATE dbo.Tabs
					SET 
						TabOrder				= @TabOrder + 2,
						LastModifiedByUserID	= @LastModifiedByUserID,
						LastModifiedOnDate		= GETDATE()					
					WHERE TabID = @TabId
				EXEC dbo.BuildTabLevelAndPath @TabId
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[MoveTabBefore]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MoveTabBefore] 
	@TabId					int,
	@BeforeTabId			int,
	@LastModifiedByUserID	int
AS
	BEGIN
		DECLARE @OldParentId int
		DECLARE @NewParentId int
		DECLARE @PortalId int
		
		SET @OldParentId = (SELECT ParentId FROM dbo.Tabs WHERE TabID = @TabId)
		SET @NewParentId = (SELECT ParentId FROM dbo.Tabs WHERE TabID = @BeforeTabId)
		SET @PortalId = (SELECT PortalId FROM dbo.Tabs WHERE TabID = @TabId)
		
		DECLARE @TabOrder int
		SET @TabOrder = (SELECT TabOrder FROM dbo.Tabs WHERE TabID = @TabId)
		
		IF (@OldParentId <> @NewParentId OR NOT (@OldParentId IS NULL AND @NewParentId IS NULL))
			-- Parent has changed
			BEGIN
				-- update TabOrder of Tabs with same original Parent
				UPDATE dbo.Tabs
					SET TabOrder = TabOrder - 2
					WHERE (ParentId = @OldParentId OR (ParentId IS NULL AND @OldParentId IS NULL)) 
						AND TabOrder > @TabOrder
						AND (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))

				-- Get TabOrder of AfterTab
				SET @TabOrder = (SELECT TabOrder FROM dbo.Tabs WHERE TabID = @BeforeTabId)
						
				-- update TabOrder of Tabs with same new Parent
				UPDATE dbo.Tabs
					SET TabOrder = TabOrder + 2
					WHERE (ParentId = @NewParentId OR (ParentId IS NULL AND @NewParentId IS NULL)) 
						AND TabOrder >= @TabOrder
						AND (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))

				-- Update Tab with new TabOrder
				UPDATE dbo.Tabs
					SET 
						ParentId				= @NewParentId,
						TabOrder				= @TabOrder,
						LastModifiedByUserID	= @LastModifiedByUserID,
						LastModifiedOnDate		= GETDATE()					
					WHERE TabID = @TabId
				EXEC dbo.BuildTabLevelAndPath @TabId, 1
			END
		ELSE
			-- Parent has not changed
			BEGIN
				-- Remove Tab from TabOrder
				UPDATE dbo.Tabs
					SET TabOrder = -1
					WHERE TabID = @TabId
					
				-- Reorder
				UPDATE dbo.Tabs
					SET TabOrder = TabOrder - 2
					WHERE (ParentId = @OldParentId OR (ParentId IS NULL AND @OldParentId IS NULL)) 
						AND TabOrder > @TabOrder
						AND TabId <> @TabId
						AND (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
						
				-- Get TabOrder of BeforeTab
				SET @TabOrder = (SELECT TabOrder FROM dbo.Tabs WHERE TabID = @BeforeTabId)
										
				-- Reorder					
				UPDATE dbo.Tabs
					SET TabOrder = TabOrder + 2
					WHERE (ParentId = @OldParentId OR (ParentId IS NULL AND @OldParentId IS NULL)) 
						AND TabOrder >= @TabOrder
						AND (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))

				-- Update Tab with new TabOrder
				UPDATE dbo.Tabs
					SET 
						TabOrder				= @TabOrder,
						LastModifiedByUserID	= @LastModifiedByUserID,
						LastModifiedOnDate		= GETDATE()					
					WHERE TabID = @TabId
				EXEC dbo.BuildTabLevelAndPath @TabId
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[MoveTabModule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MoveTabModule]
	@FromTabId				int,
	@ModuleId				int,
	@ToTabId				int,
	@PaneName				nvarchar(50),
	@LastModifiedByUserID	int

AS
	UPDATE dbo.TabModules
		SET 
			TabId = @ToTabId,   
			ModuleOrder = -1,
			PaneName = @PaneName,
			LastModifiedByUserID = @LastModifiedByUserID,
			LastModifiedOnDate = getdate()
		WHERE  TabId = @FromTabId
		AND    ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[MoveTabToParent]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MoveTabToParent] 
	@TabId					int,
	@NewParentId			int,
	@LastModifiedByUserID	int
AS
	BEGIN
		DECLARE @PortalId int
		SET @PortalId = (SELECT PortalId FROM dbo.Tabs WHERE TabID = @TabId)

		DECLARE @OldParentId int
		SET @OldParentId = (SELECT ParentId FROM dbo.Tabs WHERE TabID = @TabId)
		
		DECLARE @TabOrder int
		SET @TabOrder = (SELECT TabOrder FROM dbo.Tabs WHERE TabID = @TabId)
		
		-- Get New TabOrder
		DECLARE @NewTabOrder int
		SET @NewTabOrder = (SELECT MAX(TabOrder) FROM dbo.Tabs 
						 WHERE (PortalId = @PortalID OR (PortalId IS NULL AND @PortalID IS NULL)) AND
							   (ParentId = @NewParentId OR (ParentId IS NULL AND @NewParentId IS NULL))
						)
		IF @NewTabOrder IS NULL 
			SET @NewTabOrder = 1
		ELSE
			SET @NewTabOrder = @NewTabOrder + 2			
				
		BEGIN
			-- update TabOrder of Tabs with same original Parent
			UPDATE dbo.Tabs
				SET TabOrder = TabOrder - 2
				WHERE (ParentId = @OldParentId OR (ParentId IS NULL AND @OldParentId IS NULL)) 
					AND TabOrder > @TabOrder
					AND (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))

			-- Update Tab with new TabOrder
			UPDATE dbo.Tabs
				SET 
					ParentId				= @NewParentId,
					TabOrder				= @NewTabOrder,
					LastModifiedByUserID	= @LastModifiedByUserID,
					LastModifiedOnDate		= GETDATE()					
				WHERE TabID = @TabId
		END
		IF (@OldParentId <> @NewParentId) OR (@OldParentId IS NULL AND @NewParentId IS NOT NULL) OR (@OldParentId IS NOT NULL AND @NewParentId IS NULL)
			BEGIN
				EXEC dbo.BuildTabLevelAndPath @TabId, 1
			END
		ELSE
			BEGIN
				EXEC dbo.BuildTabLevelAndPath @TabId
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[PublishTab]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PublishTab]
	@TabID INT
AS
BEGIN 
        UPDATE dbo.[Tabs] SET            
            [HasBeenPublished] = 1
        WHERE TabID = @TabID
END
GO
/****** Object:  StoredProcedure [dbo].[PurgeEventLog]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PurgeEventLog]

AS
	;WITH logcounts AS
	(  
	  SELECT 
		LogEventID, 
		LogConfigID, 
		ROW_NUMBER() OVER(PARTITION BY LogConfigID ORDER BY LogCreateDate DESC) AS logEventSequence
	  FROM dbo.EventLog
	)
	DELETE dbo.EventLog 
	FROM dbo.EventLog el 
		JOIN logcounts lc ON el.LogEventID = lc.LogEventID
		INNER JOIN dbo.EventLogConfig elc ON elc.ID = lc.LogConfigID
	WHERE elc.KeepMostRecent <> -1
		AND lc.logEventSequence > elc.KeepMostRecent
GO
/****** Object:  StoredProcedure [dbo].[PurgeScheduleHistory]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PurgeScheduleHistory]
AS
delete from dbo.schedulehistory where schedulehistoryid in (
	select top 50000 ScheduleHistoryID from dbo.ScheduleHistory sh 
		inner join dbo.schedule s on s.ScheduleID = sh.ScheduleID and s.Enabled = 1
	where 
		(select count(*) from dbo.ScheduleHistory sh where sh.ScheduleID = s.ScheduleID) > s.RetainHistoryNum
		AND s.RetainHistoryNum <> -1
		AND s.ScheduleID = sh.ScheduleID
	order by ScheduleHistoryID
)
GO
/****** Object:  StoredProcedure [dbo].[RegisterAssembly]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[RegisterAssembly]
	@PackageID      int,
	@AssemblyName   nvarchar(250),
	@Version		nvarchar(20)
As
	DECLARE @AssemblyID int
	DECLARE @CurrentVersion nvarchar(20)
	/*	@ReturnCode Values
		0 - Assembly Does not Exist
		1 - Older Version of Assembly Exists
		2 - Assembly Already Registered - Version = CurrentVersion
		3 - Assembly Already Registered - Version < CurrentVersion
	*/
	DECLARE @CompareVersion int

	-- First check if this assembly is registered to this package
	SET @AssemblyID = (SELECT AssemblyID 
							FROM dbo.Assemblies
							WHERE PackageID = @PAckageID
								AND AssemblyName = @AssemblyName)

	IF @AssemblyID IS NULL
		BEGIN
			-- AssemblyID is null (not registered) 
			-- but assembly may be registerd by other packages so check for Max unstalled version
			SET @CurrentVersion  = (SELECT Max(Version )
										FROM dbo.Assemblies
										WHERE AssemblyName = @AssemblyName)

			SET @CompareVersion = dbo.fn_CompareVersion(@Version, @CurrentVersion)
			
			-- Add an assembly regsitration for this package
			INSERT INTO dbo.Assemblies (
				PackageID,
				AssemblyName,
				Version
			)
			VALUES (
				@PackageID,
				@AssemblyName,
				@Version
			)
		END
	ELSE
		BEGIN
			-- AssemblyID is not null - Assembly is registered - test for version
			SET @CurrentVersion  = (SELECT Version 
										FROM dbo.Assemblies
										WHERE AssemblyID = @AssemblyID)
			
			SET @CompareVersion = dbo.fn_CompareVersion(@Version, @CurrentVersion)
			
			IF @CompareVersion = 1
				BEGIN
					-- Newer version - Update Assembly registration
					UPDATE dbo.Assemblies
					SET    Version = @Version
					WHERE  AssemblyID = @AssemblyID
				END
		END

	SELECT @CompareVersion
GO
/****** Object:  StoredProcedure [dbo].[RemovePortalLocalization]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RemovePortalLocalization]
    @PortalId INT ,
    @CultureCode NVARCHAR(10)
AS 
    BEGIN
        SET NOCOUNT ON;

        DELETE  FROM dbo.PortalLocalization
        WHERE   PortalID = @PortalId
                AND CultureCode = @CultureCode

    END
GO
/****** Object:  StoredProcedure [dbo].[RemoveTermsFromContent]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RemoveTermsFromContent] 
	@ContentItemID	int
AS
	DELETE dbo.ContentItems_Tags 
	WHERE ContentItemID = @ContentItemID
GO
/****** Object:  StoredProcedure [dbo].[RemoveUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RemoveUser]
	@UserID		int,
	@PortalID   int
AS
	IF @PortalID IS NULL
		BEGIN
			-- Delete SuperUser
			DELETE FROM dbo.Users
				WHERE  UserId = @UserID
		END
	ELSE
		BEGIN
			-- Remove User from Portal			
			DELETE FROM dbo.UserPortals
				WHERE  UserId = @UserID
                 AND PortalId = @PortalID
			IF NOT EXISTS (SELECT 1 FROM dbo.UserPortals WHERE  UserId = @UserID) 
				-- Delete User (but not if SuperUser)
				BEGIN
					DELETE FROM dbo.Users
						WHERE  UserId = @UserID
							AND IsSuperUser = 0
					DELETE FROM dbo.UserRoles
						WHERE  UserID = @UserID
				END								
		END
GO
/****** Object:  StoredProcedure [dbo].[ResetFilePublishedVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ResetFilePublishedVersion] 
@FileId int
AS
BEGIN
	UPDATE dbo.Files
		SET PublishedVersion = 1
		WHERE FileId = @FileId
END
GO
/****** Object:  StoredProcedure [dbo].[RestoreTabModule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RestoreTabModule]
	@TabId      int,
	@ModuleId   int
AS
	UPDATE dbo.TabModules
		SET IsDeleted = 0,
			VersionGuid = newId()
	WHERE  TabId = @TabId
		AND    ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[RestoreUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RestoreUser]
	@UserID		int,
	@PortalID   int
AS
	IF @PortalID IS NULL
		BEGIN
			UPDATE dbo.Users
				SET	IsDeleted = 0
				WHERE  UserId = @UserID
		END
	ELSE
		BEGIN
			UPDATE dbo.UserPortals
				SET IsDeleted = 0
				WHERE  UserId = @UserID
					AND PortalId = @PortalID
	END
GO
/****** Object:  StoredProcedure [dbo].[SaveCoreAuditTypes]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveCoreAuditTypes]
	@LogTypeKey nvarchar(35),  
	@LogTypeFriendlyName nvarchar(50),  
	@LogTypeOwner nvarchar(100),  
	@LogTypeCSSClass nvarchar(40) ,
	@LoggingIsActive bit,  
	@KeepMostRecent int,  
	@EmailNotificationIsActive bit  

AS  
 IF NOT EXISTS (SELECT * FROM dbo.EventLogTypes WHERE LogTypeKey = @LogTypeKey)  
	BEGIN  
		-- Add new Event Type  
		EXEC dbo.AddEventLogType @LogTypeKey, @LogTypeFriendlyName, N'', @LogTypeOwner, @LogTypeCSSClass  

		-- Add new Event Type Config  
		EXEC dbo.AddEventLogConfig @LogTypeKey, NULL, @LoggingIsActive, @KeepMostRecent, @EmailNotificationIsActive, 1, 1, 1, N'', N''  
		  
		-- exit  
		Return
	END
  ELSE

		UPDATE dbo.EventLogTypes SET LogTypeFriendlyName = @LogTypeFriendlyName WHERE LogTypeKey = @LogTypeKey  

		UPDATE dbo.EventLogConfig
		SET LoggingIsActive=@LoggingIsActive,
		KeepMostRecent=@KeepMostRecent,
		EmailNotificationIsActive=@EmailNotificationIsActive
		WHERE LogTypeKey = @LogTypeKey
GO
/****** Object:  StoredProcedure [dbo].[SaveExtensionUrlProviderSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveExtensionUrlProviderSetting] 
	@ExtensionUrlProviderID		int,
	@PortalId					int,
	@SettingName				nvarchar(100),
	@SettingValue				nvarchar(2000)
AS

	IF (SELECT COUNT(*) 
			FROM dbo.ExtensionUrlProviderSetting 
			WHERE ExtensionUrlProviderID = @ExtensionUrlProviderID
				AND PortalID = @PortalId
				AND SettingName = @SettingName) = 0
		BEGIN
			--ADD
			INSERT INTO dbo.ExtensionUrlProviderSetting
			        ( ExtensionUrlProviderID ,
			          PortalID ,
			          SettingName ,
			          SettingValue
			        )
			VALUES  ( @ExtensionUrlProviderID , -- ExtensionUrlProviderID - int
			          @PortalId , -- PortalID - int
			          @SettingName , -- SettingName - nvarchar(100)
			          @SettingValue  -- SettingValue - nvarchar(2000)
			        )
		END
	ELSE
		BEGIN
			UPDATE dbo.ExtensionUrlProviderSetting	
				SET 
					SettingValue = @SettingValue
				WHERE ExtensionUrlProviderID = @ExtensionUrlProviderID
					AND PortalID = @PortalId
					AND SettingName = @SettingName
		END
GO
/****** Object:  StoredProcedure [dbo].[SaveJavaScriptLibrary]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveJavaScriptLibrary]
	@JavaScriptLibraryID INT,
	@PackageID INT,
	@LibraryName NVARCHAR(200),
	@Version NVARCHAR(10),
	@FileName NVARCHAR(100),
	@ObjectName NVARCHAR(100),
	@PreferredScriptLocation int,
	@CDNPath NVARCHAR(250)
AS

	IF EXISTS (SELECT JavaScriptLibraryID FROM JavaScriptLibraries WHERE JavaScriptLibraryID = @JavaScriptLibraryID)
		BEGIN
			UPDATE dbo.[JavaScriptLibraries]
			   SET [PackageID] = @PackageID,
					[LibraryName] = @LibraryName,
					[Version] = @Version,
					[FileName] = @FileName,
					[ObjectName] = @ObjectName,
					[PreferredScriptLocation] = @PreferredScriptLocation,
					[CDNPath] = @CDNPath
			 WHERE JavaScriptLibraryID = @JavaScriptLibraryID
	 	END
	ELSE
		BEGIN
			INSERT INTO dbo.[JavaScriptLibraries] (
				[PackageID],
				[LibraryName],
				[Version],
				[FileName],
				[ObjectName],
				[PreferredScriptLocation],
				[CDNPath]
			)
			VALUES (
				@PackageID,
				@LibraryName,
				@Version,
				@FileName,
				@ObjectName,
				@PreferredScriptLocation,
				@CDNPath
			)
			SET @JavaScriptLibraryID = (SELECT @@IDENTITY)
		END
		
	SELECT @JavaScriptLibraryID
GO
/****** Object:  StoredProcedure [dbo].[SavePackageDependency]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SavePackageDependency]
	@PackageDependencyID INT,
	@PackageID INT,
	@PackageName NVARCHAR(128),
	@Version NVARCHAR(10)
AS
	IF EXISTS (SELECT PackageDependencyID FROM PackageDependencies WHERE PackageID = @PackageID AND PackageName = @PackageName AND Version = @Version)
		BEGIN
			UPDATE dbo.[PackageDependencies]
			   SET [PackageID] = @PackageID,
					[PackageName] = @PackageName,
					[Version] = @Version
			 WHERE PackageDependencyID = @PackageDependencyID
		END
	ELSE
		BEGIN
			INSERT INTO dbo.[PackageDependencies] (
				[PackageID],
				[PackageName],
				[Version]
			)
			VALUES (
				@PackageID,
				@PackageName,
				@Version
			)
			SET @PackageDependencyID = (SELECT @@IDENTITY)
		END

	SELECT @PackageDependencyID
GO
/****** Object:  StoredProcedure [dbo].[SaveRelationship]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveRelationship]
    @RelationshipID INT,
    @RelationshipTypeID INT,    
    @Name NVARCHAR(50),
    @Description NVARCHAR(500),
	@UserID INT,
	@PortalID INT,
	@DefaultResponse INT,
	@CreateUpdateUserID INT
    
AS 
    IF ( @RelationshipID = -1 ) 
        BEGIN
            INSERT  dbo.Relationships
                    ( RelationshipTypeID,
                      Name ,            
                      Description,					
					  UserID,
					  PortalID,		
					  DefaultResponse,			
                      CreatedByUserID ,
                      CreatedOnDate ,
                      LastModifiedByUserID ,
                      LastModifiedOnDate
			        
                    )
            VALUES  ( @RelationshipTypeID , -- @RelationshipTypeID INT
                      @Name , -- Name - nvarchar(50)
                      @Description , -- @Description NVARCHAR(500)
					  @UserID , -- @UserID int
					  @PortalID , -- @PortalID int
					  @DefaultResponse, -- @DefaultResponse int
                      @CreateUpdateUserID , -- CreatedBy - int
                      GETDATE() , -- CreatedOn - datetime
                      @CreateUpdateUserID , -- LastModifiedBy - int
                      GETDATE() -- LastModifiedOn - datetime
			        
                    )
                    
            SELECT  @RelationshipID = SCOPE_IDENTITY()
        END
    ELSE 
        BEGIN
            UPDATE  dbo.Relationships
            SET     Name = @Name ,                    
                    Description = @Description,
					RelationshipTypeID = @RelationshipTypeID,
					UserID = @UserID,
					PortalID = @PortalID,
					DefaultResponse = @DefaultResponse,
                    LastModifiedByUserID = @CreateUpdateUserID,
                    LastModifiedOnDate = GETDATE()
            WHERE   RelationshipID = @RelationshipID
        END
        
    SELECT  @RelationshipID
GO
/****** Object:  StoredProcedure [dbo].[SaveRelationshipType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveRelationshipType]
    @RelationshipTypeID INT ,
    @Direction INT ,
    @Name NVARCHAR(50) ,
    @Description NVARCHAR(500) ,
    @UserID INT
AS 
    IF ( @RelationshipTypeID = -1 ) 
        BEGIN
            INSERT  dbo.RelationshipTypes
                    ( Direction,
                      Name ,            
                      Description,					
                      CreatedByUserID ,
                      CreatedOnDate ,
                      LastModifiedByUserID ,
                      LastModifiedOnDate
			        
                    )
            VALUES  ( @Direction , --  @Direction INT 
                      @Name , -- Name - nvarchar(50)
                      @Description , -- @Description NVARCHAR(500)
                      @UserID , -- CreatedBy - int
                      GETDATE() , -- CreatedOn - datetime
                      @UserID , -- LastModifiedBy - int
                      GETDATE() -- LastModifiedOn - datetime
			        
                    )
                    
            SELECT  @RelationshipTypeID = SCOPE_IDENTITY()
        END
    ELSE 
        BEGIN
            UPDATE  dbo.RelationshipTypes
            SET     Name = @Name ,
                    Direction = @Direction ,
                    Description = @Description ,
                    LastModifiedByUserID = @UserID ,
                    LastModifiedOnDate = GETDATE()
            WHERE   RelationshipTypeID = @RelationshipTypeID
        END
        
    SELECT  @RelationshipTypeID
GO
/****** Object:  StoredProcedure [dbo].[SaveTabUrl]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveTabUrl] 
	@TabID				int,
	@SeqNum				int,
	@PortalAliasID		int,
	@PortalAliasUsage	int,
	@Url				nvarchar(200),
	@QueryString		nvarchar(200),
	@CultureCode		nvarchar(50),
	@HttpStatus			nvarchar(50),
	@IsSystem			bit,
	@ModifiedByUserID	int
AS
	IF @HttpStatus = '200'
		BEGIN
			UPDATE dbo.TabUrls
				SET HttpStatus = '301',
				[LastModifiedByUserID]= @ModifiedByUserID,
				[LastModifiedOnDate]= getdate()
				WHERE TabID = @TabID
					AND CultureCode = @CultureCode
					AND (@PortalAliasID = @PortalAliasID OR (PortalAliasId IS NULL AND @PortalAliasID IS NULL))
					AND HttpStatus = '200'
		END  
	IF EXISTS (SELECT * FROM dbo.TabUrls WHERE TabId = @TabID AND SeqNum = @SeqNum)
		BEGIN
			UPDATE dbo.TabUrls
				SET 
					PortalAliasId = @PortalAliasID,
					PortalAliasUsage = @PortalAliasUsage,
					Url = @Url,
					QueryString = @QueryString,
					CultureCode = @CultureCode,
					HttpStatus = @HttpStatus,
					IsSystem = @IsSystem,
					[LastModifiedByUserID]= @ModifiedByUserID,
					[LastModifiedOnDate]= getdate()
			WHERE TabId = @TabID AND SeqNum = @SeqNum 
		END
	ELSE
		BEGIN
			INSERT INTO dbo.TabUrls
					( TabId ,
					  SeqNum ,
					  Url ,
					  QueryString ,
					  HttpStatus ,
					  CultureCode ,
					  IsSystem,
					  PortalAliasId ,
					  PortalAliasUsage,
					  [CreatedByUserID],
					  [CreatedOnDate],
				  	  [LastModifiedByUserID],
					  [LastModifiedOnDate]
					)
			VALUES  ( @TabID ,
					  @SeqNum ,
					  @Url ,
					  @QueryString ,
					  @HttpStatus ,
					  @CultureCode ,
					  @IsSystem,
					  @PortalAliasID ,
					  0,
					  @ModifiedByUserID,
					  getdate(),
					  @ModifiedByUserID,
					  getdate()
					)
		END
GO
/****** Object:  StoredProcedure [dbo].[SaveTabVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveTabVersion]
    @Id INT,
    @TabId INT,
    @TimeStamp DATETIME,
    @Version INT,
	@IsPublished BIT,
    @CreatedByUserID [INT] = -1,
	@LastModifiedByUserID [INT] = -1
AS
BEGIN
    IF ISNULL(@Id, 0) = 0
    BEGIN
        INSERT INTO dbo.[TabVersions](            
            [TabId],
            [TimeStamp],
            [Version],
			[IsPublished],
            [CreatedByUserID],
            [CreatedOnDate],
            [LastModifiedByUserID],
            [LastModifiedOnDate]
        ) VALUES (
            @TabId,
            @TimeStamp,
            @Version,      
			@IsPublished,      
            @CreatedByUserID,
            GETDATE(),
            @LastModifiedByUserID,
            GETDATE()
        )

        SELECT @Id = SCOPE_IDENTITY()
    END
    ELSE
    BEGIN
        UPDATE dbo.[TabVersions] SET            
            [TabId] = @TabId,
            [Version] = @Version,
            [TimeStamp] = @TimeStamp,
			[IsPublished] = @IsPublished,
            [LastModifiedByUserID] = @LastModifiedByUserID,
            [LastModifiedOnDate] = GETDATE()
        WHERE TabVersionId = @Id
    END
	SELECT @Id
END
GO
/****** Object:  StoredProcedure [dbo].[SaveTabVersionDetail]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveTabVersionDetail]
    @Id INT,
    @TabVersionId INT,
    @ModuleId INT,
    @ModuleVersion INT,
	@PaneName NVARCHAR(50),
	@ModuleOrder INT,
	@Action INT,
    @CreatedByUserID [INT] = -1,
	@LastModifiedByUserID [INT] = -1
AS
BEGIN
    IF ISNULL(@Id, 0) = 0
    BEGIN
        INSERT INTO dbo.[TabVersionDetails](
            [TabVersionId],
            [ModuleId],
            [ModuleVersion],
			[PaneName],
            [ModuleOrder],
			[Action],
            [CreatedByUserID],
            [CreatedOnDate],
            [LastModifiedByUserID],
            [LastModifiedOnDate]
        ) VALUES (
            @TabVersionId,
			@ModuleId,            
            @ModuleVersion,            
			@PaneName,
			@ModuleOrder,
			@Action,
            @CreatedByUserID,
            GETDATE(),
            @LastModifiedByUserID,
            GETDATE()
        )

        SELECT @Id = SCOPE_IDENTITY()
    END
    ELSE
    BEGIN
        UPDATE dbo.[TabVersionDetails] SET            
            [TabVersionId] = @TabVersionId,
			[ModuleId] = @ModuleId,
            [ModuleVersion] = @ModuleVersion,            
            [PaneName] = @PaneName,
			[ModuleOrder] = @ModuleOrder,
			[Action] = @Action,
            [LastModifiedByUserID] = @LastModifiedByUserID,
            [LastModifiedOnDate] = GETDATE()
        WHERE TabVersionDetailId = @Id
    END
	SELECT @Id
END
GO
/****** Object:  StoredProcedure [dbo].[SaveUserRelationship]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveUserRelationship]
    @UserRelationshipID INT,
	@UserID INT,
	@RelatedUserID INT,
	@RelationshipID INT,
	@Status INT,
	@CreateUpdateUserID INT
    
AS 
    IF ( @UserRelationshipID = -1 ) 
        BEGIN
            INSERT  dbo.UserRelationships
                    ( UserID,
					  RelatedUserID,					
					  RelationshipID,
					  Status,
                      CreatedByUserID ,
                      CreatedOnDate ,
                      LastModifiedByUserID ,
                      LastModifiedOnDate
			        
                    )
            VALUES  ( @UserID , -- @UserID int
					  @RelatedUserID , -- @RelatedUserlID int
					  @RelationshipID, -- @RelationshipID int
					  @Status , -- @Status int
                      @CreateUpdateUserID , -- CreatedBy - int
                      GETDATE() , -- CreatedOn - datetime
                      @CreateUpdateUserID , -- LastModifiedBy - int
                      GETDATE() -- LastModifiedOn - datetime
			        
                    )
                    
            SELECT  @UserRelationshipID = SCOPE_IDENTITY()
        END
    ELSE 
        BEGIN
            UPDATE  dbo.UserRelationships
            SET     UserID = @UserID,
					RelatedUserID = @RelatedUserID,
					RelationshipID = @RelationshipID,
					Status = @Status,
                    LastModifiedByUserID = @CreateUpdateUserID,
                    LastModifiedOnDate = GETDATE()
            WHERE   UserRelationshipID = @UserRelationshipID
        END
        
    SELECT  @UserRelationshipID
GO
/****** Object:  StoredProcedure [dbo].[SaveUserRelationshipPreference]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveUserRelationshipPreference]
    @PreferenceID INT,
	@UserID INT,	
	@RelationshipID INT,
	@DefaultResponse INT,
	@CreateUpdateUserID INT
    
AS 
    IF ( @PreferenceID = -1 ) 
        BEGIN
            INSERT  dbo.UserRelationshipPreferences
                    ( UserID,					  
					  RelationshipID,
					  DefaultResponse,
                      CreatedByUserID ,
                      CreatedOnDate ,
                      LastModifiedByUserID ,
                      LastModifiedOnDate
			        
                    )
            VALUES  ( @UserID , -- @UserID int					  
					  @RelationshipID, -- @RelationshipID int
					  @DefaultResponse , -- @DefaultResponse int
                      @CreateUpdateUserID , -- CreatedBy - int
                      GETDATE() , -- CreatedOn - datetime
                      @CreateUpdateUserID , -- LastModifiedBy - int
                      GETDATE() -- LastModifiedOn - datetime
			        
                    )
                    
            SELECT  @PreferenceID = SCOPE_IDENTITY()
        END
    ELSE 
        BEGIN
            UPDATE  dbo.UserRelationshipPreferences
            SET     UserID = @UserID,					
					RelationshipID = @RelationshipID,
					DefaultResponse = @DefaultResponse,
                    LastModifiedByUserID = @CreateUpdateUserID,
                    LastModifiedOnDate = GETDATE()
            WHERE   PreferenceID = @PreferenceID
        END
        
    SELECT  @PreferenceID
GO
/****** Object:  StoredProcedure [dbo].[SearchDeletedItems_Add]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchDeletedItems_Add]
	@document nvarchar(max)
AS
BEGIN
	INSERT INTO dbo.SearchDeletedItems
		   (  document )
	VALUES ( @document )
END
GO
/****** Object:  StoredProcedure [dbo].[SearchDeletedItems_DeleteProcessed]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchDeletedItems_DeleteProcessed]
    @CutoffTime	DATETIME
AS
BEGIN
	DELETE FROM dbo.SearchDeletedItems
	WHERE [DateCreated] < @CutoffTime
END
GO
/****** Object:  StoredProcedure [dbo].[SearchDeletedItems_Select]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchDeletedItems_Select]
    @CutoffTime	DATETIME
AS
BEGIN
	SELECT document
	FROM dbo.SearchDeletedItems
	WHERE [DateCreated] < @CutoffTime
	ORDER BY [DateCreated]
END
GO
/****** Object:  StoredProcedure [dbo].[SearchTypes_GetAll]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchTypes_GetAll]
AS
    SELECT *
	FROM dbo.[SearchTypes]
GO
/****** Object:  StoredProcedure [dbo].[SetEventMessageComplete]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetEventMessageComplete]
	
	@EventMessageID int

AS
	UPDATE dbo.EventQueue
		SET IsComplete = 1
	WHERE EventMessageID = @EventMessageID
GO
/****** Object:  StoredProcedure [dbo].[SetPublishedVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetPublishedVersion] 
	@FileId					int,
	@NewPublishedVersion	int
AS
BEGIN

	-- Insert a new record in the FileVersions table for the old published version
	INSERT dbo.[FileVersions]
				([FileId]
				,[Version]
				,[FileName]
				,[Extension]
				,[Size]
				,[Width]
				,[Height]
				,[ContentType]
				,[Content]
				,[CreatedByUserID]
				,[CreatedOnDate]
				,[LastModifiedByUserID]
				,[LastModifiedOnDate]
				,[SHA1Hash])
	SELECT		[FileId]
				,[PublishedVersion]  [Version]				
				,CONVERT(nvarchar, [FileId]) + '_' + CONVERT(nvarchar, [PublishedVersion]) +'.v.resources' 
				,[Extension]
				,[Size]
				,[Width]
				,[Height]
				,[ContentType]
				,[Content]
				,[CreatedByUserID]
				,[CreatedOnDate]
				,[LastModifiedByUserID]
				,[LastModifiedOnDate]
				,[SHA1Hash]					
	FROM Files
	WHERE FileId = @FileId

	-- Change Files.PublishedVersion to the new version number
	UPDATE dbo.[Files]
	SET	 [PublishedVersion] = @NewPublishedVersion		
		,[Extension] =v.[Extension]
		,[Size] = v.[Size]
		,[Width] = v.[Width]
		,[Height] = v.[Height]
		,[ContentType] = v.[ContentType]
		,[Content] = v.[Content]
		,[CreatedByUserID] = v.[CreatedByUserID]
		,[CreatedOnDate] = v.[CreatedOnDate]
		,[LastModifiedByUserID] = v.[LastModifiedByUserID]
		,[LastModifiedOnDate] = v.[LastModifiedOnDate]
		,[SHA1Hash] = v.[SHA1Hash]
	FROM dbo.[Files] f
		JOIN dbo.[FileVersions] v ON f.FileId = v.FileId
	WHERE f.FileId = @FileId
		AND v.Version = @NewPublishedVersion

    -- Delete the FileVersions entry of the version being published
	DELETE dbo.[FileVersions]
	WHERE FileId = @FileId AND Version = @NewPublishedVersion
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_AddItemsForSale]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_AddItemsForSale]
(
	@item_id INTEGER,
	@number_of_items INTEGER,
	@itemList ItemsType READONLY
)
AS
BEGIN
	DECLARE @regCode AS VARCHAR(12)
	DECLARE @warehouseID INTEGER
	DECLARE @itp INTEGER
	
	INSERT INTO SMS_ITEMS_BARCODE_DATA (item_id, barcode_data) SELECT @item_id, barcode_data FROM @itemList

	SELECT @regCode = reg_code FROM SMS_REGISTERED_ITEMS WHERE item_id = @item_id	

	UPDATE SMS_SALES_BOXES SET items_per_box -= @number_of_items WHERE reg_code = @regCode

	SELECT @itp = items_per_box FROM SMS_SALES_BOXES WHERE reg_code = @regCode

	IF(@itp = 0)
	BEGIN
		SELECT @warehouseID = warehouse_id FROM SMS_REGISTERED_BOXES WHERE reg_code = @regCode

		UPDATE SMS_WAREHOUSE_PRODUCTS SET quantity -= 1 WHERE warehouse_id = @warehouseID
	END

	SELECT 100
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_AddNotification]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_AddNotification]
AS
BEGIN
	INSERT INTO SMS_INVENTORY_NOTIFICATION (warehouse_id, product_id, category_id, quantity, supplier_id)
	SELECT wp.warehouse_id, wp.product_id, p.category_id, wp.quantity, p.supplier_id FROM 
	SMS_WAREHOUSE_PRODUCTS wp INNER JOIN SMS_PRODUCTS p ON wp.product_id = p.product_id WHERE wp.quantity = 4
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_AddProduct]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_AddProduct]
(
	@product_name VARCHAR(50),
	@category INTEGER,
	@supplier INTEGER,
	@quantity_supplied INTEGER,
	@price_per_box DECIMAL(19, 2),
	@item_per_box INTEGER,
	@unit_price DECIMAL(19, 2),
	@dos VARCHAR(12),
	@tos VARCHAR(12),
	@product_thumbNail VARCHAR(MAX),
	@barcode VARCHAR(MAX),
	@barcode_data VARCHAR(14),
	@warehouse_id INTEGER
)
AS
BEGIN
	DECLARE @lastID INTEGER
	DECLARE @id INTEGER

	IF EXISTS(SELECT * FROM SMS_PRODUCTS WHERE [dbo].[SMS_RemoveAllSpaces](product_name) = [dbo].[SMS_RemoveAllSpaces](@product_name))
	BEGIN
		SELECT @id = product_id FROM SMS_PRODUCTS WHERE [dbo].[SMS_RemoveAllSpaces](product_name) = [dbo].[SMS_RemoveAllSpaces](@product_name)
		
		INSERT INTO SMS_WAREHOUSE_PRODUCTS (product_id, warehouse_id, quantity, notified) VALUES (@id, @warehouse_id, @quantity_supplied, 0) 
	END
	ELSE
	BEGIN
		INSERT INTO SMS_PRODUCTS (product_name, category_id, supplier_id, product_thumbnail, 
								barcode, barcode_data) VALUES (@product_name, @category, @supplier, 
								@product_thumbNail, @barcode, @barcode_data)

		SELECT @lastID = IDENT_CURRENT('SMS_PRODUCTS')

		INSERT INTO SMS_SUPPLIED_PRODUCTS (product_id, supplier_id, warehouse_id, dos, tod, quantity_supplied, 
											box_price, unit_price, item_per_box) VALUES (@lastID, @supplier, @warehouse_id, 
											@dos, @tos, @quantity_supplied, @price_per_box, @unit_price, @item_per_box)

		INSERT INTO SMS_WAREHOUSE_PRODUCTS (product_id, warehouse_id, quantity, notified) VALUES (@lastID, @warehouse_id, @quantity_supplied, 0)
	END

	SELECT 100
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_AdminLogin]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_AdminLogin]
(
	@username VARCHAR(7),
	@password VARCHAR(50)
)
AS
BEGIN
	IF EXISTS(SELECT * FROM SMS_STAFF WHERE username = @username AND password = @password AND role = 'Sales Manager')
	BEGIN
		SELECT 100
	END
	ELSE
	BEGIN
		SELECT -100
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_DeleteNotification]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_DeleteNotification]
(
	@notification_id INTEGER,
	@product_id INTEGER,
	@warehouse_id INTEGER
)
AS
BEGIN
	DELETE FROM SMS_INVENTORY_NOTIFICATION WHERE notification_id = @notification_id
	UPDATE SMS_WAREHOUSE_PRODUCTS SET notified = 1 WHERE product_id = @product_id AND warehouse_id = @warehouse_id
	SELECT 100
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_DeleteProduct]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_DeleteProduct]
(
	@product_id INTEGER,
	@warehouse_id INTEGER
)
AS
BEGIN
	DECLARE @product_name VARCHAR(25)

	SELECT @product_name = product_name FROM SMS_PRODUCTS WHERE product_id = @product_id

	IF EXISTS(SELECT * FROM SMS_REGISTERED_BOXES WHERE [dbo].[SMS_RemoveAllSpaces](reg_product_name) = [dbo].[SMS_RemoveAllSpaces](@product_name) AND warehouse_id = @warehouse_id)
	BEGIN
		SELECT -100
	END
	ELSE
	BEGIN
		DELETE wp FROM SMS_WAREHOUSE_PRODUCTS wp WHERE wp.product_id = @product_id AND wp.warehouse_id = @warehouse_id
		SELECT 200
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_FetchTransactionDetails]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_FetchTransactionDetails]
(
	@transaction_id INTEGER
)
AS
BEGIN
	SELECT ri.item_name, pt.quantity, pt.unit_price, pt.sub_total FROM SMS_PRODUCT_TRANSACTION pt
	INNER JOIN SMS_REGISTERED_ITEMS ri ON pt.item_id = ri.item_id WHERE pt.transaction_id = @transaction_id
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_FetchTransactionHistory]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SMS_FetchTransactionHistory]
(
	@transactionID INTEGER
)
AS
BEGIN
	SELECT tb.barcode_data, ib.item_id, ri.item_name, ri.item_price AS unit_price, t.transaction_date FROM 
	SMS_TRANSACTION_BARCODE_DATA tb INNER JOIN SMS_ITEMS_BARCODE_DATA ib ON tb.barcode_data = ib.barcode_data
	INNER JOIN SMS_REGISTERED_ITEMS ri ON ib.item_id = ri.item_id INNER JOIN 
	SMS_TRANSACTION t ON tb.transaction_id = t.transaction_id WHERE tb.transaction_id = @transactionID
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_GetItemDetails]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_GetItemDetails]
(
	@barcode_data VARCHAR(14)
)
AS
BEGIN
	DECLARE @itemID INTEGER
	
	SELECT @itemID = item_id FROM SMS_ITEMS_BARCODE_DATA WHERE barcode_data = @barcode_data

	SELECT item_id, item_name, item_price as unit_price FROM SMS_REGISTERED_ITEMS WHERE item_id = @itemID
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_GetProductBySupplier]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SMS_GetProductBySupplier]
(
	@supplier_id INTEGER
)
AS
BEGIN
	SELECT sp_id, s_product_name FROM SMS_SUPPLIER_PRODUCTS WHERE supplier_id = @supplier_id
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_GetProductDetails]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_GetProductDetails]
(
	@product_id INTEGER
)
AS
BEGIN
	SELECT item_per_box, unit_price FROM SMS_SUPPLIED_PRODUCTS WHERE product_id = @product_id
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_GetWarehouseID]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_GetWarehouseID]
(
	@username VARCHAR(7)
)
AS
BEGIN
	SELECT warehouse_id FROM SMS_STAFF WHERE username = @username
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_InventoryLogin]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_InventoryLogin]
(
	@username VARCHAR(7),
	@password VARCHAR(50)
)
AS
BEGIN
	IF EXISTS(SELECT * FROM SMS_STAFF WHERE username = @username AND password = @password AND role = 'Inventory Manager')
	BEGIN
		SELECT warehouse_id FROM SMS_STAFF WHERE username = @username AND [password] = @password
	END
	ELSE
	BEGIN
		SELECT -100
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_LoadBoxes]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_LoadBoxes]
(
	@warehouse_id INTEGER
)
AS
BEGIN
	SELECT s.reg_code, s.reg_product_name, s.reg_category, s.items_per_box, i.item_id, i.item_name, i.item_price
	FROM SMS_SALES_BOXES s INNER JOIN SMS_REGISTERED_ITEMS i ON s.reg_code = i.reg_code INNER JOIN SMS_REGISTERED_BOXES r
	ON s.reg_code = r.reg_code WHERE r.warehouse_id = @warehouse_id
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_LoadCategories]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_LoadCategories]
AS
BEGIN
	SELECT * FROM SMS_CATEGORIES
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_LoadNotifications]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_LoadNotifications]
(
	@warehouse_id INTEGER
)
AS
BEGIN
	SELECT i.notification_id, p.product_id, p.product_name, c.category_name, i.quantity, s.supplier_name, s.supplier_email
	FROM SMS_INVENTORY_NOTIFICATION i INNER JOIN SMS_PRODUCTS p ON i.product_id = p.product_id INNER JOIN SMS_CATEGORIES c
	ON p.category_id = c.category_id INNER JOIN SMS_SUPPLIERS s ON i.supplier_id = s.supplier_id WHERE i.warehouse_id = @warehouse_id
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_LoadProducts]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_LoadProducts]
(
	@warehouse_id INTEGER
)
AS
BEGIN
	SELECT pdt.product_id as product_id, product_thumbnail, product_name, category_id, quantity, 
	box_price as price, unit_price FROM SMS_PRODUCTS pdt INNER JOIN SMS_SUPPLIED_PRODUCTS 
	s_pdt ON pdt.product_id = s_pdt.product_id INNER JOIN SMS_WAREHOUSE_PRODUCTS w_pdt ON pdt.product_id = w_pdt.product_id
	WHERE w_pdt.warehouse_id = @warehouse_id
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_LoadProductsByCategory]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_LoadProductsByCategory]
(
	@category_id INTEGER,
	@warehouse_id INTEGER	
)
AS
BEGIN
	SELECT p.product_id, p.product_name FROM SMS_PRODUCTS p INNER JOIN SMS_WAREHOUSE_PRODUCTS wp ON p.product_id = wp.product_id
	WHERE wp.warehouse_id = @warehouse_id AND p.category_id = @category_id
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_LoadRestockedProducts]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_LoadRestockedProducts]
(
	@warehouse_id INTEGER
)
AS
BEGIN
	SELECT p.product_name, re.restock_quantity, re.dor, re.tor FROM SMS_RESTOCKED_PRODUCTS re
	INNER JOIN SMS_PRODUCTS p ON p.product_id = re.product_id WHERE re.warehouse_id = @warehouse_id ORDER BY re.dor DESC
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_LoadSalesRecord]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_LoadSalesRecord]
(
	@startDate VARCHAR(12),
	@endDate VARCHAR(12),
	@warehouse_id INTEGER
)
AS
BEGIN
	DECLARE @selectClause AS VARCHAR(MAX)
	DECLARE @caseClause AS VARCHAR(MAX)
	DECLARE @cases AS VARCHAR(MAX)
	DECLARE @fromClause AS VARCHAR(MAX)
	DECLARE @whereClause AS VARCHAR(MAX)
	DECLARE @columnHead AS VARCHAR(10)
	DECLARE @start_date AS DATE
	DECLARE @end_date AS DATE
	DECLARE @weeks AS INTEGER
	DECLARE @i AS INTEGER

	SET @i = 0
	SET @start_date = @startDate
	SET @end_date = @endDate
	SET @weeks = DATEDIFF(week, @start_date, @end_date)
	SET @cases = ''

	--set the case clause based on the number of weeks in a while loop
	WHILE(@i < @weeks)
	BEGIN
		SET @caseClause = ', SUM(CASE 
			   WHEN t.transaction_date >= CONVERT(DATE, ''' + CAST(DATEADD(dd, (@i * 7), @start_date) AS VARCHAR(12)) + 
			   ''') AND t.transaction_date < CONVERT(DATE, ''' + CAST(DATEADD(dd, ((@i + 1) * 7), @start_date) AS VARCHAR(12)) + ''')
				 THEN pt.sub_total
			   ELSE 0
			 END)'

		SET @columnHead = '[week_' + CONVERT(VARCHAR(2), (@i + 1)) + ']'
		SET @cases = @cases + '
			 ' + @caseClause + ' AS ' + @columnHead

		SET @i = @i + 1
	END	

	--set the select clause
	SET @selectClause = 'SELECT ca.category_name' + @cases

	--set the from clause
	SET @fromClause = '
		FROM SMS_CATEGORIES ca INNER JOIN SMS_REGISTERED_BOXES rb ON ca.category_name = rb.reg_category
		INNER JOIN SMS_REGISTERED_ITEMS ri ON rb.reg_code = ri.reg_code
		INNER JOIN SMS_PRODUCT_TRANSACTION pt ON ri.item_id = pt.item_id 
		INNER JOIN SMS_TRANSACTION t ON t.transaction_id = pt.transaction_id'

	--set the where clause
	SET @whereClause = ' WHERE (t.transaction_date >= CONVERT(DATE, ''' + CAST(@start_date AS VARCHAR(12)) + ''') AND t.transaction_date < CONVERT(DATE, ''' + CAST(@end_date AS VARCHAR(12)) + ''')  AND t.[warehouse_id] = ''' + CAST(@warehouse_id AS VARCHAR(100)) + ''') GROUP BY ca.category_name'

	EXEC(@selectClause + @fromClause + @whereClause)
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_LoadSalesRegister]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_LoadSalesRegister]
(
	@warehouse_id INTEGER
)
AS
BEGIN
	SELECT reg_code, reg_product_name, reg_category, items_per_box, dor, tor FROM SMS_REGISTERED_BOXES
	WHERE warehouse_id = @warehouse_id
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_LoadSuppliedProducts]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_LoadSuppliedProducts]
(
	@warehouse_id INTEGER
)
AS
BEGIN
	SELECT pdt.product_id, s_pdt.supplier_id as supplier_id, product_thumbnail, product_name, category_id, quantity_supplied, 
	box_price as price, unit_price, dos, tod FROM SMS_PRODUCTS pdt INNER JOIN SMS_SUPPLIED_PRODUCTS 
	s_pdt ON pdt.product_id = s_pdt.product_id WHERE s_pdt.warehouse_id = @warehouse_id
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_LoadSuppliers]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_LoadSuppliers]
AS
BEGIN
	SELECT supplier_id, supplier_name FROM SMS_SUPPLIERS
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_LoadTransactions]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_LoadTransactions]
(
	@warehouse_id INTEGER
)
AS
BEGIN
	SELECT transaction_id, transaction_date, transaction_time, staff_username FROM SMS_TRANSACTION WHERE [warehouse_id] = @warehouse_id
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_ProcessTransaction]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_ProcessTransaction]
(
	@dot VARCHAR(12),
	@tot VARCHAR(12),
	@warehouse_id INTEGER,
	@username VARCHAR(7),
	@transactionItems SalesType READONLY,
	@codeDataCollection ItemsType READONLY
)
AS
BEGIN
	DECLARE @transactionID INTEGER

	INSERT INTO SMS_TRANSACTION (transaction_date, transaction_time, staff_username, [warehouse_id]) 
	VALUES (@dot, @tot, @username, @warehouse_id)

	SET @transactionID = IDENT_CURRENT('SMS_TRANSACTION')

	INSERT INTO SMS_PRODUCT_TRANSACTION (transaction_id, item_id, unit_price, quantity, sub_total)
	SELECT @transactionID, item_id, unit_price, quantity_sold, total_price FROM @transactionItems

	INSERT INTO SMS_TRANSACTION_BARCODE_DATA (transaction_id, barcode_data) SELECT 
	@transactionID, barcode_data FROM @codeDataCollection

	DELETE FROM SMS_ITEMS_BARCODE_DATA WHERE barcode_data IN (SELECT barcode_data FROM @codeDataCollection)

	SELECT 100
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_RegisterItemsForSale]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_RegisterItemsForSale]
(
	@reg_code NVARCHAR(8),
	@product_name VARCHAR(50),
	@category VARCHAR(12),
	@items_per_box INTEGER,
	@item_name VARCHAR(50),
	@item_price DECIMAL(19,2),
	@number_of_items INTEGER,
	@dor VARCHAR(12),
	@tor VARCHAR(12),
	@warehouse_id INTEGER,
	@itemList ItemsType READONLY
)
AS
BEGIN
	DECLARE @itemID AS INTEGER;
	
	INSERT INTO SMS_REGISTERED_BOXES (reg_code, reg_product_name, reg_category, items_per_box, dor, tor, warehouse_id) 
	VALUES (@reg_code, @product_name, @category, @items_per_box, @dor, @tor, @warehouse_id)

	INSERT INTO SMS_REGISTERED_ITEMS (reg_code, item_name, item_price) VALUES (@reg_code, @item_name, @item_price)

	SET @itemID = IDENT_CURRENT('SMS_REGISTERED_ITEMS')

	INSERT INTO SMS_ITEMS_BARCODE_DATA (item_id, barcode_data) SELECT @itemID, barcode_data FROM @itemList

	INSERT INTO SMS_SALES_BOXES (reg_code, reg_product_name, reg_category, items_per_box) 
	VALUES (@reg_code, @product_name, @category, (@items_per_box - @number_of_items))

	SELECT 100
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_ReturnItems]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SMS_ReturnItems]
(
	@barcode_data VARCHAR(14),
	@transaction_id INTEGER,
	@item_id INTEGER,
	@username VARCHAR(50),
	@warehouse_id INTEGER
)
AS
BEGIN
	DELETE FROM SMS_TRANSACTION_BARCODE_DATA WHERE transaction_id = @transaction_id AND barcode_data = @barcode_data

	UPDATE SMS_PRODUCT_TRANSACTION SET quantity -= 1 WHERE transaction_id = @transaction_id AND item_id = @item_id

	DELETE FROM SMS_PRODUCT_TRANSACTION WHERE quantity = 0

	INSERT INTO SMS_RETURNED_ITEMS (item_id, barcode_data, date_returned, time_returned, username, warehouse_id) 
	VALUES (@item_id, @barcode_data, CONVERT(VARCHAR(10), GETDATE(), 103), 
	SUBSTRING(CONVERT(VARCHAR(20), GETDATE(), 9), 13, 5) + ' ' + SUBSTRING(CONVERT(VARCHAR(30), GETDATE(), 9), 25, 2),
	@username, @warehouse_id)

	SELECT 100
END
GO
/****** Object:  StoredProcedure [dbo].[SMS_UpdateProduct]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SMS_UpdateProduct]
(
	@product_id INTEGER,
	@quantity INTEGER,
	@warehouse_id INTEGER
)
AS
BEGIN
	UPDATE SMS_WAREHOUSE_PRODUCTS SET quantity += @quantity, notified = 0 WHERE product_id = @product_id AND warehouse_id = @warehouse_id

	INSERT INTO SMS_RESTOCKED_PRODUCTS (product_id, restock_quantity, dor, tor, warehouse_id) 
	VALUES (@product_id, @quantity, CONVERT(VARCHAR(12), GETDATE(), 103), RIGHT(CONVERT(CHAR(19),GETDATE(),100),7), @warehouse_id)

	SELECT 100
END
GO
/****** Object:  StoredProcedure [dbo].[UnRegisterAssembly]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UnRegisterAssembly]
	@PackageID     INT,
	@AssemblyName   NVARCHAR(250)
AS
	DECLARE @ReturnCode BIT
	SET @ReturnCode = 1 -- 1 = Can Delete Assembly, 0 = Cannot Delete Assembly

	-- First remove the Assembly Reference for this Package
	DELETE FROM dbo.Assemblies
		WHERE PackageID = @PackageID
			AND AssemblyName = @AssemblyName

	IF EXISTS(SELECT TOP 1 PackageID FROM dbo.Assemblies WHERE AssemblyName = @AssemblyName)
		-- Set ReturnCode = 0, so assembly is not deleted
		SET @ReturnCode = 0

	SELECT @ReturnCode
GO
/****** Object:  StoredProcedure [dbo].[UpdateAffiliate]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UpdateAffiliate]

@AffiliateId int,
@StartDate         datetime,
@EndDate           datetime,
@CPC               float,
@CPA               float

as

update dbo.Affiliates
set    StartDate   = @StartDate,
       EndDate     = @EndDate,
       CPC         = @CPC,
       CPA         = @CPA
where  AffiliateId = @AffiliateId
GO
/****** Object:  StoredProcedure [dbo].[UpdateAffiliateStats]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateAffiliateStats]
	@AffiliateId  int,
	@Clicks       int,
	@Acquisitions int
AS
	UPDATE dbo.Affiliates
		SET	Clicks = Clicks + @Clicks,
			Acquisitions = Acquisitions + @Acquisitions
		WHERE  AffiliateId = @AffiliateId 
			AND    ( StartDate < getdate() OR StartDate IS NULL ) 
			AND    ( EndDate > getdate() OR EndDate IS NULL )
GO
/****** Object:  StoredProcedure [dbo].[UpdateAnonymousUser]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateAnonymousUser]
    @UserID  char(36),
    @PortalID  int,
    @TabID   int,
    @LastActiveDate datetime 
as
begin
 update dbo.AnonymousUsers set 
  TabID = @TabID,
  LastActiveDate = @LastActiveDate
 where
  UserID = @UserID
  and PortalID = @PortalID

 if @@ROWCOUNT = 0
 begin
  insert into dbo.AnonymousUsers
   (UserID, PortalID, TabID, CreationDate, LastActiveDate) 
  VALUES
   (@UserID, @PortalID, @TabID, GetDate(), @LastActiveDate)
 end
end
GO
/****** Object:  StoredProcedure [dbo].[UpdateAuthentication]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateAuthentication]
	@AuthenticationID       int,
	@PackageID				int,
	@AuthenticationType     nvarchar(100),
	@IsEnabled				bit,
	@SettingsControlSrc     nvarchar(250),
	@LoginControlSrc		nvarchar(250),
	@LogoffControlSrc		nvarchar(250),
	@LastModifiedByUserID	int
AS
	UPDATE dbo.Authentication
	SET    PackageID = @PackageID,
		   AuthenticationType = @AuthenticationType,
		   IsEnabled = @IsEnabled,
		   SettingsControlSrc = @SettingsControlSrc,
		   LoginControlSrc = @LoginControlSrc,
		   LogoffControlSrc = @LogoffControlSrc,
		   [LastModifiedByUserID] = @LastModifiedByUserID,	
		   [LastModifiedOnDate] = getdate()
	WHERE  AuthenticationID = @AuthenticationID
GO
/****** Object:  StoredProcedure [dbo].[UpdateBanner]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UpdateBanner]

@BannerId     int,
@BannerName   nvarchar(100),
@ImageFile    nvarchar(100),
@URL          nvarchar(255),
@Impressions  int,
@CPM          float,
@StartDate    datetime,
@EndDate      datetime,
@UserName     nvarchar(100),
@BannerTypeId int,
@Description  nvarchar(2000),
@GroupName    nvarchar(100),
@Criteria     bit,
@Width        int,
@Height       int

as

update dbo.Banners
set    ImageFile     = @ImageFile,
       BannerName    = @BannerName,
       URL           = @URL,
       Impressions   = @Impressions,
       CPM           = @CPM,
       StartDate     = @StartDate,
       EndDate       = @EndDate,
       CreatedByUser = @UserName,
       CreatedDate   = getdate(),
       BannerTypeId  = @BannerTypeId,
       Description   = @Description,
       GroupName     = @GroupName,
       Criteria      = @Criteria,
       Width         = @Width,
       Height        = @Height
where  BannerId = @BannerId
GO
/****** Object:  StoredProcedure [dbo].[UpdateBannerClickThrough]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UpdateBannerClickThrough]

@BannerId int,
@VendorId int

as

update dbo.Banners
set    ClickThroughs = ClickThroughs + 1
where  BannerId = @BannerId
and    VendorId = @VendorId
GO
/****** Object:  StoredProcedure [dbo].[UpdateBannerViews]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UpdateBannerViews]

@BannerId  int, 
@StartDate datetime, 
@EndDate   datetime

as

update dbo.Banners
set    Views = Views + 1,
       StartDate = @StartDate,
       EndDate = @EndDate
where  BannerId = @BannerId
GO
/****** Object:  StoredProcedure [dbo].[UpdateContentItem]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateContentItem] 
	@ContentItemID			int,
	@Content				nvarchar(max),
	@ContentTypeID			int,
	@TabID					int,
	@ModuleID				int, 
	@ContentKey				nvarchar(250),
	@Indexed				bit,
	@LastModifiedByUserID	int,
	@StateID				int = NULL
AS
	UPDATE dbo.[ContentItems] 
		SET 
			Content = @Content,
			ContentTypeID = @ContentTypeID,
			TabID = @TabID,
			ModuleID = @ModuleID,
			ContentKey = @ContentKey,
			Indexed = @Indexed,
			LastModifiedByUserID = @LastModifiedByUserID,
			LastModifiedOnDate = getdate(),
			StateID = @StateID
	WHERE ContentItemId = @ContentItemId
GO
/****** Object:  StoredProcedure [dbo].[UpdateContentType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateContentType] 
	@ContentTypeId		int,
	@ContentType		nvarchar(250)
AS
	UPDATE dbo.ContentTypes 
		SET 
			ContentType = @ContentType
	WHERE ContentTypeId = @ContentTypeId
GO
/****** Object:  StoredProcedure [dbo].[UpdateContentWorkflow]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateContentWorkflow]
@WorkflowID int,
@WorkflowName nvarchar(40),
@Description nvarchar(256),
@IsDeleted bit,
@StartAfterCreating bit,
@StartAfterEditing bit,
@DispositionEnabled bit
AS

UPDATE dbo.ContentWorkflows
SET    WorkflowName = @WorkflowName,
       Description = @Description,
       IsDeleted = @IsDeleted,
	   StartAfterCreating = @StartAfterCreating,
	   StartAfterEditing = @StartAfterEditing,
	   DispositionEnabled = @DispositionEnabled
WHERE  WorkflowID = @WorkflowID
GO
/****** Object:  StoredProcedure [dbo].[UpdateContentWorkflowState]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateContentWorkflowState]
	@StateID int,
	@StateName nvarchar(40),
	@Order int,
	@IsActive bit,
	@SendEmail bit,
	@SendMessage bit,
	@IsDisposalState bit,
	@OnCompleteMessageSubject nvarchar(256),
	@OnCompleteMessageBody nvarchar(1024),
	@OnDiscardMessageSubject nvarchar(256),
	@OnDiscardMessageBody nvarchar(1024)
AS

UPDATE dbo.ContentWorkflowStates
SET [StateName] = @StateName,
	[Order] = @Order,
	[IsActive] = @IsActive,
	[SendEmail] = @SendEmail,
	[SendMessage] = @SendMessage,
	[IsDisposalState] = @IsDisposalState,
	[OnCompleteMessageSubject] = @OnCompleteMessageSubject,
	[OnCompleteMessageBody] = @OnCompleteMessageBody,
	[OnDiscardMessageSubject] = @OnDiscardMessageSubject,
	[OnDiscardMessageBody] = @OnDiscardMessageBody
WHERE  [StateID] = @StateID
GO
/****** Object:  StoredProcedure [dbo].[UpdateContentWorkflowStatePermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateContentWorkflowStatePermission]
	@WorkflowStatePermissionID int, 
	@StateID int, 
	@PermissionID int, 
	@RoleID int ,
	@AllowAccess bit,
    @UserID int,
	@LastModifiedByUserID	int
AS
    UPDATE dbo.ContentWorkflowStatePermission 
    SET     
	    [StateID] = @StateID,
	    [PermissionID] = @PermissionID,
	    [RoleID] = @RoleID,
	    [AllowAccess] = @AllowAccess,
        [UserID] = @UserID,
        [LastModifiedByUserID] = @LastModifiedByUserID,
	    [LastModifiedOnDate] = getdate()
    WHERE
		[WorkflowStatePermissionID] = @WorkflowStatePermissionID
GO
/****** Object:  StoredProcedure [dbo].[UpdateDatabaseVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UpdateDatabaseVersion]

@Major  int,
@Minor  int,
@Build  int

as

insert into dbo.Version (
  Major,
  Minor,
  Build,
  CreatedDate
)
values (
  @Major,
  @Minor,
  @Build,
  getdate()
)
GO
/****** Object:  StoredProcedure [dbo].[UpdateDatabaseVersionAndName]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UpdateDatabaseVersionAndName]

	@Major  int,
	@Minor  int,
	@Build  int,
	@Name	nvarchar(50)

AS

	INSERT INTO dbo.Version (
		Major,
		Minor,
		Build,
		[Name],
		CreatedDate
	)
		VALUES (
			@Major,
			@Minor,
			@Build,
			@Name,
			getdate()
		)
GO
/****** Object:  StoredProcedure [dbo].[UpdateDesktopModule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDesktopModule]
	@DesktopModuleId		int,    
	@PackageID			int,
	@ModuleName			nvarchar(128),
	@FolderName			nvarchar(128),
	@FriendlyName			nvarchar(128),
	@Description			nvarchar(2000),
	@Version			nvarchar(8),
	@IsPremium			bit,
	@IsAdmin			bit,
	@BusinessController		nvarchar(200),
	@SupportedFeatures		int,
	@Shareable			int,
	@CompatibleVersions		nvarchar(500),
	@Dependencies			nvarchar(400),
	@Permissions			nvarchar(400),
	@ContentItemId			int,
	@LastModifiedByUserID		int

AS
		UPDATE dbo.DesktopModules
		SET    	
			PackageID = @PackageID,
			ModuleName = @ModuleName,
			FolderName = @FolderName,
			FriendlyName = @FriendlyName,
			Description = @Description,
			Version = @Version,
			IsPremium = @IsPremium,
			IsAdmin = @IsAdmin,
			BusinessControllerClass = @BusinessController,
			SupportedFeatures = @SupportedFeatures,
			Shareable = @Shareable,
			CompatibleVersions = @CompatibleVersions,
			Dependencies = @Dependencies,
			Permissions = @Permissions,
			ContentItemId = @ContentItemId,
			LastModifiedByUserID = @LastModifiedByUserID,
			LastModifiedOnDate = getdate()
	WHERE  DesktopModuleId = @DesktopModuleId
GO
/****** Object:  StoredProcedure [dbo].[UpdateDesktopModulePermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDesktopModulePermission]
    @DesktopModulePermissionId Int, -- not null!
    @PortalDesktopModuleId     Int, -- not null!
    @PermissionId              Int, -- not null!
    @RoleId                    Int, -- might be negative for virtual roles
    @AllowAccess               Bit, -- false: deny, true: grant
    @UserId                    Int, -- -1 is replaced by Null
    @LastModifiedByUserId      Int  -- -1 is replaced by Null
AS
    UPDATE dbo.[DesktopModulePermission]
    SET
        [PortalDesktopModuleId] = @PortalDesktopModuleId,
        [PermissionId]          = @PermissionId,
        [RoleId]                = @RoleId,
        [AllowAccess]           = @AllowAccess,
        [UserId]                = CASE WHEN @UserId = -1 THEN Null ELSE @UserId  END,
        [LastModifiedByUserId]  = CASE WHEN @LastModifiedByUserId = -1 THEN Null ELSE @LastModifiedByUserId  END,
        [LastModifiedOnDate]    = GetDate()
    WHERE [DesktopModulePermissionId] = @DesktopModulePermissionId
GO
/****** Object:  StoredProcedure [dbo].[UpdateEventLogConfig]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateEventLogConfig]
	@ID int,
	@LogTypeKey nvarchar(35),
	@LogTypePortalID int,
	@LoggingIsActive bit,
	@KeepMostRecent int,
	@EmailNotificationIsActive bit,
	@NotificationThreshold int,
	@NotificationThresholdTime int,
	@NotificationThresholdTimeType int,
	@MailFromAddress nvarchar(50),
	@MailToAddress nvarchar(50)
AS
UPDATE dbo.EventLogConfig
SET 	LogTypeKey = @LogTypeKey,
	LogTypePortalID = @LogTypePortalID,
	LoggingIsActive = @LoggingIsActive,
	KeepMostRecent = @KeepMostRecent,
	EmailNotificationIsActive = @EmailNotificationIsActive,
	NotificationThreshold = @NotificationThreshold,
	NotificationThresholdTime = @NotificationThresholdTime,
	NotificationThresholdTimeType = @NotificationThresholdTimeType,
	MailFromAddress = @MailFromAddress,
	MailToAddress = @MailToAddress
WHERE	ID = @ID
GO
/****** Object:  StoredProcedure [dbo].[UpdateEventLogPendingNotif]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateEventLogPendingNotif]
	@LogConfigID int
AS
UPDATE dbo.EventLog
SET LogNotificationPending = 0
WHERE LogNotificationPending = 1
AND LogConfigID = @LogConfigID
GO
/****** Object:  StoredProcedure [dbo].[UpdateEventLogType]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateEventLogType]
	@LogTypeKey nvarchar(35),
	@LogTypeFriendlyName nvarchar(50),
	@LogTypeDescription nvarchar(128),
	@LogTypeOwner nvarchar(100),
	@LogTypeCSSClass nvarchar(40)
AS
UPDATE dbo.EventLogTypes
	SET LogTypeFriendlyName = @LogTypeFriendlyName,
	LogTypeDescription = @LogTypeDescription,
	LogTypeOwner = @LogTypeOwner,
	LogTypeCSSClass = @LogTypeCSSClass
WHERE	LogTypeKey = @LogTypeKey
GO
/****** Object:  StoredProcedure [dbo].[UpdateExtensionUrlProvider]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateExtensionUrlProvider] 
	@ExtensionUrlProviderID		int,
	@IsActive					bit
AS
	UPDATE dbo.ExtensionUrlProviders
		SET IsActive = @IsActive
		WHERE ExtensionUrlProviderID = @ExtensionUrlProviderID
GO
/****** Object:  StoredProcedure [dbo].[UpdateFile]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateFile]
    @FileId					INT,
    @VersionGuid			UNIQUEIDENTIFIER,	
    @FileName				NVARCHAR(246),
    @Extension				NVARCHAR(100),
    @Size					INT,
    @Width					INT,
    @Height					INT,
    @ContentType			NVARCHAR(200),	
    @FolderID				INT,
    @LastModifiedByUserID  	INT,
    @Hash					VARCHAR(40),
    @LastModificationTime	DATETIME,
    @Title					NVARCHAR(256),
    @EnablePublishPeriod	BIT,
    @StartDate				DATETIME,
    @EndDate				DATETIME,	
    @ContentItemID			INT
AS
    UPDATE dbo.Files
        SET    FileName = @FileName,
               VersionGuid = @VersionGuid,
               Extension = @Extension,
               Size = @Size,
               Width = @Width,
               Height = @Height,
               ContentType = @ContentType,
               FolderID = @FolderID,
               LastModifiedByUserID = @LastModifiedByUserID,
               LastModifiedOnDate = getdate(),
			   SHA1Hash = @Hash,
			   LastModificationTime = @LastModificationTime,
			   Title = @Title,
			   EnablePublishPeriod = @EnablePublishPeriod,
			   StartDate = @StartDate,
			   EndDate = @EndDate,
			   ContentItemID = @ContentItemID
    WHERE  FileId = @FileId
GO
/****** Object:  StoredProcedure [dbo].[UpdateFileContent]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[UpdateFileContent]

@FileId      int,
@Content     image

as

update dbo.Files
set    Content = @Content
where  FileId = @FileId
GO
/****** Object:  StoredProcedure [dbo].[UpdateFileHashCode]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateFileHashCode]
	@FileId				  Int, 		-- Not Null
	@HashCode VARCHAR(40)  -- Not NULL
AS
BEGIN
    UPDATE dbo.[Files]
    SET    SHA1Hash = @HashCode
    WHERE  FileId = @FileId
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateFileLastModificationTime]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateFileLastModificationTime]
	@FileId				  Int, 		-- Not Null
	@LastModificationTime DateTime  -- Null: Now
AS
BEGIN
    UPDATE dbo.[Files]
    SET    LastModificationTime = IsNull(@LastModificationTime, GetDate())
    WHERE  FileId = @FileId
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateFileVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateFileVersion]
	@FileID			int,
    @VersionGuid	uniqueidentifier
AS
    UPDATE dbo.Files
        SET    VersionGuid = @VersionGuid
    WHERE  FileID = @FileID
GO
/****** Object:  StoredProcedure [dbo].[UpdateFolder]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateFolder]
	@PortalID 				int,
	@VersionGuid 			uniqueidentifier,	
	@FolderID 				int,
	@FolderPath 			nvarchar(300),
	@MappedPath 			nvarchar(300),
	@StorageLocation 		int,
	@IsProtected 			bit,
	@IsCached 				bit,
	@LastUpdated 			datetime,
	@LastModifiedByUserID  	int,
	@FolderMappingID		int,
	@IsVersioned			bit = 0,
	@WorkflowID				int = NULL,
	@ParentID				int = NULL
AS
BEGIN
	UPDATE dbo.[Folders]
	SET
		FolderPath = @FolderPath,
		MappedPath = @MappedPath,
		VersionGuid = @VersionGuid,
		StorageLocation = @StorageLocation,
		IsProtected = @IsProtected,
		IsCached = @IsCached,
		LastUpdated = @LastUpdated,
		LastModifiedByUserID = @LastModifiedByUserID,
		LastModifiedOnDate = getdate(),
		FolderMappingID = @FolderMappingID,
		IsVersioned = @IsVersioned,
		WorkflowID = @WorkflowID,
		ParentID = @ParentID
	WHERE FolderID = @FolderID
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateFolderMapping]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateFolderMapping]
	@FolderMappingID int,
	@MappingName nvarchar(50),
	@Priority int,
	@LastModifiedByUserID int
AS
BEGIN
	UPDATE dbo.[FolderMappings]
	SET
		MappingName = @MappingName,
		Priority = @Priority,
		LastModifiedByUserID = @LastModifiedByUserID,
		LastModifiedOnDate = GETDATE()
	WHERE FolderMappingID = @FolderMappingID
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateFolderMappingsSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateFolderMappingsSetting]
	@FolderMappingID int,
	@SettingName nvarchar(50),
	@SettingValue nvarchar(2000),
	@LastModifiedByUserID int
AS
BEGIN
	UPDATE dbo.[FolderMappingsSettings]
	SET
		SettingValue = @SettingValue,
		LastModifiedByUserID = @LastModifiedByUserID,
		LastModifiedOnDate = GETDATE()
	WHERE FolderMappingID = @FolderMappingID AND SettingName = @SettingName
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateFolderPermission]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateFolderPermission]
    @FolderPermissionID     Int, -- not null!
    @FolderID               Int, -- not null!
    @PermissionId           Int, -- not null!
    @RoleId                 Int, -- might be negative for virtual roles
    @AllowAccess            Bit, -- false: deny, true: grant
    @UserId                 Int, -- -1 is replaced by Null
    @LastModifiedByUserId   Int  -- -1 is replaced by Null
AS
    UPDATE dbo.[FolderPermission] SET
        [FolderID]             = @FolderID,
        [PermissionID]         = @PermissionID,
        [RoleId]               = @RoleId,
        [AllowAccess]          = @AllowAccess,
        [UserId]               = CASE WHEN @UserId = -1 THEN Null ELSE @UserId  END,
        [LastModifiedByUserId] = CASE WHEN @LastModifiedByUserId = -1 THEN Null ELSE @LastModifiedByUserId  END,
        [LastModifiedOnDate]   = GetDate()
    WHERE
        [FolderPermissionID]   = @FolderPermissionID
GO
/****** Object:  StoredProcedure [dbo].[UpdateFolderVersion]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateFolderVersion]
	@FolderID		int,
    @VersionGuid	uniqueidentifier
AS
    UPDATE dbo.Folders
        SET    VersionGuid = @VersionGuid
    WHERE  FolderID = @FolderID
GO
/****** Object:  StoredProcedure [dbo].[UpdateHeirarchicalTerm]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateHeirarchicalTerm] 
	@TermID					int, 
	@VocabularyID			int,
	@ParentTermID			int,
	@Name					nvarchar(250),
	@Description			nvarchar(2500),
	@Weight					int,
	@LastModifiedByUserID	int
AS

	DECLARE @Left				int
	DECLARE @Right				int
	DECLARE @Width				int
	
	SET @Left = (SELECT TermLeft FROM dbo.Taxonomy_Terms WHERE TermID = @TermID)
	SET @Right = (SELECT TermRight FROM dbo.Taxonomy_Terms WHERE TermID = @TermID)
	SET @Width = @Right - @Left + 1
	
	BEGIN TRANSACTION
		BEGIN
			-- Temporarily remove term from heirarchy - but retain information about term and children 
			-- (these should now be -n, ...,-2,-1 etc)
			UPDATE dbo.Taxonomy_Terms 
				SET TermLeft = TermLeft - @Right - 1,
					TermRight = TermRight - @Right - 1
				WHERE TermLeft >= @Left
					AND TermRight <= @Right
					AND VocabularyID = @VocabularyID
			
			IF @@ERROR = 0
				BEGIN
					-- Update Left values for all items that are after the original term
					UPDATE dbo.Taxonomy_Terms 
						SET TermLeft = TermLeft - @Width 
						WHERE TermLeft >= @Left + @Width
							AND VocabularyID = @VocabularyID

					IF @@ERROR = 0
						BEGIN
						-- Update Right values for all items that are after the original term
							UPDATE dbo.Taxonomy_Terms 
								SET TermRight = TermRight - @Width 
								WHERE TermRight >= @Right
									AND VocabularyID = @VocabularyID

							IF @@ERROR = 0
								BEGIN
									-- Get Left value of Sibling that we are inserting before
									SET @Left = (SELECT TOP 1 TermLeft FROM dbo.Taxonomy_Terms 
														WHERE VocabularyID = @VocabularyID 
															AND ParentTermID = @ParentTermID
															AND Name > @Name
														ORDER BY Name)
														
									-- Term is to be inserted at end of sibling list so get the Right value of the parent, which will become our new left value						
									IF @Left IS NULL
										SET @Left = (SELECT TermRight FROM dbo.Taxonomy_Terms 
															WHERE VocabularyID = @VocabularyID 
																AND TermID = @ParentTermID)

									-- Left is still null means this is the first term in this vocabulary - set the Left to 1
									IF @Left IS NULL
										SET @Left = 1
							
									SET @Right = @Left + @Width - 1
																	
									-- Update Left values for all items that are after the updated term
									UPDATE dbo.Taxonomy_Terms 
										SET TermLeft = TermLeft + @Width 
										WHERE TermLeft >= @Left
											AND VocabularyID = @VocabularyID

									IF @@ERROR = 0
										BEGIN
										-- Update Right values for all items that are after the term
											UPDATE dbo.Taxonomy_Terms 
												SET TermRight = TermRight + @Width 
												WHERE TermRight >= @Left
													AND VocabularyID = @VocabularyID

											IF @@ERROR = 0
												BEGIN
													-- Update Left/Right values for all items temporarily removed from heirarchy
													UPDATE dbo.Taxonomy_Terms 
														SET TermLeft = TermLeft + @Left + @Width,
															TermRight = TermRight + @Left + @Width
														WHERE TermLeft < 0
															AND TermRight < 0
															AND VocabularyID = @VocabularyID

													IF @@ERROR = 0
														BEGIN
															-- Update Term
															UPDATE dbo.Taxonomy_Terms
																SET 
																	VocabularyID = @VocabularyID,
																	ParentTermID = @ParentTermID,
																	[Name] = @Name,
																	Description = @Description,
																	Weight = @Weight,
																	LastModifiedByUserID = @LastModifiedByUserID,
																	LastModifiedOnDate = getdate()
															WHERE TermID = @TermID

															IF @@ERROR = 0
																BEGIN
																	COMMIT TRANSACTION
																END
															ELSE
																BEGIN
																	-- Rollback the transaction
																	ROLLBACK TRANSACTION		
																END
															END
													ELSE
														BEGIN
															-- Rollback the transaction
															ROLLBACK TRANSACTION
														END
													END
											ELSE
												BEGIN
													-- Rollback the transaction
													ROLLBACK TRANSACTION
												END
											END
									ELSE
										BEGIN
											-- Rollback the transaction
											ROLLBACK TRANSACTION
										END
									END
								ELSE
									BEGIN
										-- Rollback the transaction
										ROLLBACK TRANSACTION		
									END
							END
					ELSE
						BEGIN
							-- Rollback the transaction
							ROLLBACK TRANSACTION
						END
				END
			ELSE
				BEGIN
					-- Rollback the transaction
					ROLLBACK TRANSACTION		
				END
		END
GO
/****** Object:  StoredProcedure [dbo].[UpdateHostSetting]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateHostSetting]
	@SettingName			nvarchar(50),
	@SettingValue			nvarchar(256),
	@SettingIsSecure		bit,
	@LastModifiedByUserID	int
AS
	UPDATE HostSettings
		SET    
			SettingValue = @SettingValue, 
			SettingIsSecure = @SettingIsSecure,
			[LastModifiedByUserID] = @LastModifiedByUserID,	
			[LastModifiedOnDate] = getdate()
	WHERE  SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[UpdateHtmlText]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UpdateHtmlText]

@ItemID          int,
@Content         ntext,
@Summary		 ntext,
@StateID         int,
@IsPublished     bit,
@UserID          int

as

update dbo.HtmlText
set    Content              = @Content,
	   Summary				= @Summary,
       StateID              = @StateID,
       IsPublished          = @IsPublished,
       LastModifiedByUserID = @UserID,
       LastModifiedOnDate   = getdate()
where  ItemID = @ItemID
GO
/****** Object:  StoredProcedure [dbo].[UpdateIPFilter]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateIPFilter]
	@IPFilterID		int,
	@IPAddress		nvarchar(50),
	@SubnetMask		nvarchar(50),
	@RuleType		tinyint,
	@LastModifiedByUserID		int
AS 
	BEGIN
		UPDATE dbo.IPFilter 
			SET 
				IPAddress = @IPAddress,
				SubnetMask = @SubnetMask,
				RuleType = @RuleType,
				LastModifiedByUserID = @LastModifiedByUserID,
				LastModifiedOnDate = getdate()
			WHERE IPFilterID = @IPFilterID
	END
GO
/****** Object:  StoredProcedure [dbo].[UpdateLanguage]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateLanguage]

	@LanguageID			    int,
	@CultureCode		    nvarchar(50),
	@CultureName            nvarchar(200),
	@FallbackCulture        nvarchar(50),
	@LastModifiedByUserID	int

AS
	UPDATE dbo.Languages
		SET
			CultureCode = @CultureCode,
			CultureName = @CultureName,
			FallbackCulture = @FallbackCulture,
			[LastModifiedByUserID] = @LastModifiedByUserID,	
			[LastModifiedOnDate] = getdate()
	WHERE LanguageID = @LanguageID
GO
/****** Object:  StoredProcedure [dbo].[UpdateLanguagePack]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateLanguagePack]
	@LanguagePackID			int,
	@PackageID			    int,
	@LanguageID			    int,
	@DependentPackageID		int,
	@LastModifiedByUserID	int

AS
	UPDATE dbo.LanguagePacks
		SET
			PackageID = @PackageID,
			LanguageID = @LanguageID,
			DependentPackageID = @DependentPackageID,
			[LastModifiedByUserID] = @LastModifiedByUserID,	
			[LastModifiedOnDate] = GETDATE()
	WHERE LanguagePackID = @LanguagePackID

	SELECT @LanguagePackID
GO
/****** Object:  StoredProcedure [dbo].[UpdateLegacyFolders]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateLegacyFolders]
AS
	UPDATE TOP (500) dbo.Folders
		SET ParentID = (COALESCE(	
				(SELECT TOP 1
					F2.FolderID 
					FROM dbo.Folders AS F2
					WHERE SUBSTRING (F1.FolderPath, 1, LEN(F1.FolderPath) - 
						(CASE 
							WHEN CHARINDEX ('/', REVERSE(SUBSTRING(F1.FolderPath, 0, LEN(F1.FolderPath)))) != 0 
							THEN CHARINDEX ('/', REVERSE(SUBSTRING(F1.FolderPath, 0, LEN(F1.FolderPath)))) 
							ELSE LEN(F1.FolderPath) END
						 )) = F2.FolderPath
						AND (F2.PortalID = F1.PortalID OR (F1.PortalID IS NULL AND F2.PortalID IS NULL))
						AND LEN(F1.FolderPath) > LEN(F2.FolderPath)
					ORDER BY LEN(F2.FolderPath) DESC
					), -1))
	FROM dbo.Folders AS F1
	WHERE F1.ParentID IS NULL AND FolderPath <> ''
GO
/****** Object:  StoredProcedure [dbo].[UpdateListEntry]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[UpdateListEntry]
	
	@EntryID int, 
	@Value nvarchar(100), 
	@Text nvarchar(150), 
	@Description nvarchar(500),
	@LastModifiedByUserID	int

AS
	UPDATE dbo.Lists
		SET	
			[Value] = @Value,
			[Text] = @Text,	
			[Description] = @Description,
			[LastModifiedByUserID] = @LastModifiedByUserID,	
			[LastModifiedOnDate] = getdate()
		WHERE 	[EntryID] = @EntryID
GO
/****** Object:  StoredProcedure [dbo].[UpdateListSortOrder]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateListSortOrder]
(
	@EntryID	int, 
	@MoveUp		bit
)
AS
	DECLARE @EntryListName nvarchar(50)
	DECLARE @ParentID int
	DECLARE @CurrentSortValue int
	DECLARE @ReplaceSortValue int
	-- Get the current sort order
	SELECT @CurrentSortValue = [SortOrder], @EntryListName = [ListName], @ParentID = [ParentID] 
		FROM dbo.Lists WITH (nolock) 
		WHERE [EntryID] = @EntryID
	-- Move the item up or down?
	IF (@MoveUp = 1)
	  BEGIN
		IF (@CurrentSortValue != 1) -- we rearrange sort order only if list enable sort order - sortorder >= 1
		  BEGIN
			SET @ReplaceSortValue = @CurrentSortValue - 1
			UPDATE dbo.Lists 
				SET [SortOrder] = @CurrentSortValue 
				WHERE [SortOrder] = @ReplaceSortValue And [ListName] = @EntryListName And [ParentID] = @ParentID
			UPDATE dbo.Lists 
				SET [SortOrder] = @ReplaceSortValue 
				WHERE [EntryID] = @EntryID
		  END
	  END
	ELSE
	  BEGIN
		IF (@CurrentSortValue < (SELECT MAX([SortOrder]) FROM dbo.Lists))
		BEGIN
		  SET @ReplaceSortValue = @CurrentSortValue + 1
		  UPDATE dbo.Lists 
			SET [SortOrder] = @CurrentSortValue 
			WHERE SortOrder = @ReplaceSortValue And [ListName] = @EntryListName  And [ParentID] = @ParentID
		  UPDATE dbo.Lists 
			SET [SortOrder] = @ReplaceSortValue 
			WHERE EntryID = @EntryID
		END
	  END
GO
/****** Object:  StoredProcedure [dbo].[UpdateModule]    Script Date: 31/03/2016 05:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateModule]
	@ModuleId					int,
    @ModuleDefId                int,
	@ContentItemID				int,
	@AllTabs					bit, 
	@StartDate					datetime,
	@EndDate					datetime,
	@InheritViewPermissions		bit,
	@IsShareable				bit,
	@IsShareableViewOnly		bit,
	@IsDeleted					bit,
	@LastModifiedByUserID  		int
	
AS
	UPDATE	dbo.Modules
		SET		
			ModuleDefId = @ModuleDefId,
            ContentItemID = @ContentItemID,
			AllTabs = @AllTabs,
			StartDate = @StartDate,
			EndDate = @EndDate,
			InheritViewPermissions = @InheritViewPermissions,
			IsShareable = @IsShareable,
			IsShareableViewOnly = @IsShareableViewOnly,
			IsDeleted = @IsDeleted,
			LastModifiedByUserID = @LastModifiedByUserID,
			LastModifiedOnDate = getdate()
	WHERE  ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[UpdateModuleControl]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateModuleControl]
	@ModuleControlId				int,
	@ModuleDefID					int,
	@ControlKey						nvarchar(50),
	@ControlTitle					nvarchar(50),
	@ControlSrc						nvarchar(256),
	@IconFile						nvarchar(100),
	@ControlType					int,
	@ViewOrder						int,
	@HelpUrl						nvarchar(200),
	@SupportsPartialRendering		bit,
	@SupportsPopUps					bit,
	@LastModifiedByUserID  			int

AS
	UPDATE dbo.ModuleControls
	SET    
		ModuleDefId = @ModuleDefId,
		ControlKey = @ControlKey,
		ControlTitle = @ControlTitle,
		ControlSrc = @ControlSrc,
		IconFile = @IconFile,
		ControlType = @ControlType,
		ViewOrder = ViewOrder,
		HelpUrl = @HelpUrl,
		SupportsPartialRendering = @SupportsPartialRendering,
		SupportsPopUps = @SupportsPopUps,
		LastModifiedByUserID = @LastModifiedByUserID,
		LastModifiedOnDate = getdate()
	WHERE  ModuleControlId = @ModuleControlId
GO
/****** Object:  StoredProcedure [dbo].[UpdateModuleDefinition]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateModuleDefinition]

	@ModuleDefId			int,    
	@FriendlyName			nvarchar(128),
	@DefinitionName			nvarchar(128),
	@DefaultCacheTime		int,
	@LastModifiedByUserID	int

as

update dbo.ModuleDefinitions 
	SET FriendlyName = @FriendlyName,
		DefinitionName = @DefinitionName,
		DefaultCacheTime = @DefaultCacheTime,
		LastModifiedByUserID = @LastModifiedByUserID,
		LastModifiedOnDate = getdate()
	WHERE ModuleDefId = @ModuleDefId
GO
/****** Object:  StoredProcedure [dbo].[UpdateModuleLastContentModifiedOnDate]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateModuleLastContentModifiedOnDate]
    @ModuleID	int
AS
    UPDATE dbo.Modules
        SET    LastContentModifiedOnDate = GETDATE()
    WHERE  ModuleID = @ModuleID
GO
/****** Object:  StoredProcedure [dbo].[UpdateModuleOrder]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateModuleOrder]
	@TabId              int,
	@ModuleId           int,
	@ModuleOrder        int,
	@PaneName           nvarchar(50)
AS
	UPDATE dbo.TabModules
		SET	ModuleOrder = @ModuleOrder,
			PaneName = @PaneName,
			VersionGuid = newId()
	WHERE TabId = @TabId
		AND ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[UpdateModulePermission]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateModulePermission]
    @ModulePermissionId     Int, -- not null!
    @PortalId               Int, -- not null!
    @ModuleId               Int, -- not null!
    @PermissionId           Int, -- not null!
    @RoleId                 Int, -- might be negative for virtual roles
    @AllowAccess            Bit, -- false: deny, true: grant
    @UserId                 Int, -- -1 is replaced by Null
    @LastModifiedByUserId   Int  -- -1 is replaced by Null
AS
    UPDATE dbo.[ModulePermission] SET
        [ModuleId]             = @ModuleId,
        [PortalId]             = @PortalId,
        [PermissionId]         = @PermissionId,
        [RoleId]               = @RoleId,
        [AllowAccess]          = @AllowAccess,
        [UserId]               = CASE WHEN @UserId = -1 THEN Null ELSE @UserId  END,
        [LastModifiedByUserId] = CASE WHEN @LastModifiedByUserId = -1 THEN Null ELSE @LastModifiedByUserId  END,
        [LastModifiedOnDate]   = GetDate()
    WHERE
        [ModulePermissionID]   = @ModulePermissionID
GO
/****** Object:  StoredProcedure [dbo].[UpdateModuleSetting]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateModuleSetting]
	@ModuleId				int,
	@SettingName			nvarchar(50),
	@SettingValue			nvarchar(max),
	@LastModifiedByUserID  	int
AS
	UPDATE 	dbo.ModuleSettings
		SET 	SettingValue = @SettingValue,
				LastModifiedByUserID = @LastModifiedByUserID,
				LastModifiedOnDate = getdate()
		WHERE ModuleId = @ModuleId
		AND SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[UpdateOnlineUser]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateOnlineUser]
@UserID 	INT,
@PortalID 	INT,
@TabID 		INT,
@LastActiveDate DATETIME 
AS
BEGIN
	IF EXISTS (SELECT UserID FROM dbo.Users WHERE UserID = @UserID)
	BEGIN
		IF EXISTS (SELECT UserID FROM dbo.UsersOnline WHERE UserID = @UserID and PortalID = @PortalID)
			UPDATE 
				dbo.UsersOnline
			SET 
				TabID = @TabID,
				LastActiveDate = @LastActiveDate
			WHERE
				UserID = @UserID
				and 
				PortalID = @PortalID
		ELSE
			INSERT INTO
				dbo.UsersOnline
				(UserID, PortalID, TabID, CreationDate, LastActiveDate) 
			VALUES
				(@UserID, @PortalID, @TabID, GetDate(), @LastActiveDate)
	END

END
GO
/****** Object:  StoredProcedure [dbo].[UpdatePackage]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdatePackage]
	@PackageID			int,
	@PortalID			int,
	@FriendlyName	    nvarchar(250),
	@Description	    nvarchar(2000),
	@PackageType	    nvarchar(50),
	@Version		    nvarchar(50),
	@License		    ntext,
	@Manifest		    ntext,
	@Owner				nvarchar(100),
	@Organization		nvarchar(100),
	@Url				nvarchar(250),
	@Email				nvarchar(100),
	@ReleaseNotes	    ntext,
	@IsSystemPackage    bit,
	@LastModifiedByUserID	int,
	@FolderName			nvarchar(128),
	@IconFile			nvarchar(100)
AS
	UPDATE dbo.Packages
		SET	
			PortalID = @PortalID,
			FriendlyName = @FriendlyName,
			[Description] = @Description,
			PackageType = @PackageType,
			Version = @Version,
			License = @License,
			Manifest = @Manifest,
			[Owner] = @Owner,
			Organization = @Organization,
			Url = @Url,
			Email = @Email,
			ReleaseNotes = @ReleaseNotes,
			IsSystemPackage = @IsSystemPackage,
			[LastModifiedByUserID] = @LastModifiedByUserID,	[LastModifiedOnDate] = getdate(),
			FolderName = @FolderName,
			IconFile = @IconFile
		WHERE  PackageID = @PackageID
GO
/****** Object:  StoredProcedure [dbo].[UpdatePermission]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdatePermission]
	@PermissionID			int, 
	@PermissionCode			varchar(50),
	@ModuleDefID			int, 
	@PermissionKey			varchar(50), 
	@PermissionName			varchar(50),
	@LastModifiedByUserID	int
AS

UPDATE dbo.Permission SET
	[ModuleDefID] = @ModuleDefID,
	[PermissionCode] = @PermissionCode,
	[PermissionKey] = @PermissionKey,
	[PermissionName] = @PermissionName,
	[LastModifiedByUserID] = @LastModifiedByUserID,
	[LastModifiedOnDate] = getdate()
WHERE
	[PermissionID] = @PermissionID
GO
/****** Object:  StoredProcedure [dbo].[UpdatePortalAlias]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdatePortalAlias]
	@PortalAliasID		int,
	@PortalID 			int,
	@HTTPAlias 			nvarchar(200),
	@CultureCode		nvarchar(10),
	@Skin				nvarchar(100),
	@BrowserType		nvarchar(10),
	@IsPrimary			bit,
	@LastModifiedByUserID	int

AS

	IF @IsPrimary = 1
		BEGIN
			UPDATE dbo.PortalAlias
				SET IsPrimary = 0
				WHERE (CultureCode = @CultureCode OR (CultureCode IS NULL AND @CultureCode IS NULL))
					AND (BrowserType = @BrowserType OR (BrowserType IS NULL AND @BrowserType IS NULL))
					AND (PortalID = @PortalID)
		END

	UPDATE dbo.PortalAlias
		SET 
			HTTPAlias = @HTTPAlias,
			CultureCode = @CultureCode,
			Skin = @Skin,
			BrowserType = @BrowserType,
			IsPrimary = @IsPrimary,
			LastModifiedByUserID = @LastModifiedByUserID,
			LastModifiedOnDate = getdate()
		WHERE PortalID = @PortalID
		AND	  PortalAliasID = @PortalAliasID
GO
/****** Object:  StoredProcedure [dbo].[UpdatePortalAliasOnInstall]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdatePortalAliasOnInstall]
	@PortalAlias			nvarchar(200),
	@LastModifiedByUserID	int
AS
	UPDATE dbo.PortalAlias 
		SET HTTPAlias = @PortalAlias,
			LastModifiedByUserID = @LastModifiedByUserID,
			LastModifiedOnDate = getdate()
	WHERE  HTTPAlias = '_default'
GO
/****** Object:  StoredProcedure [dbo].[UpdatePortalDefaultLanguage]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdatePortalDefaultLanguage]

	@PortalId            int,
	@CultureCode   nvarchar(50)
AS
	UPDATE dbo.Portals
		SET defaultlanguage=@CultureCode
		where portalid=@PortalId
GO
/****** Object:  StoredProcedure [dbo].[UpdatePortalGroup]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdatePortalGroup]
	@PortalGroupID				int,
	@PortalGroupName			nvarchar(100),
	@PortalGroupDescription		nvarchar(2000),
	@AuthenticationDomain		nvarchar(200),
	@LastModifiedByUserID		int
AS 
	BEGIN
		UPDATE dbo.PortalGroups 
			SET 
				PortalGroupName = @PortalGroupName,
				PortalGroupDescription = @PortalGroupDescription,
				AuthenticationDomain = @AuthenticationDomain,
				LastModifiedByUserID = @LastModifiedByUserID,
				LastModifiedOnDate = getdate()
			WHERE PortalGroupID = @PortalGroupID
	END
GO
/****** Object:  StoredProcedure [dbo].[UpdatePortalInfo]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdatePortalInfo]
	@PortalID				INT,
	@PortalGroupID			INT,
	@PortalName				NVARCHAR(128),
	@LogoFile				NVARCHAR(50),
	@FooterText				NVARCHAR(100),
	@ExpiryDate				DATETIME,
	@UserRegistration		INT,
	@BannerAdvertising		INT,
	@Currency				CHAR(3),
	@AdministratorId		INT,
	@HostFee				MONEY,
	@HostSpace				INT,
	@PageQuota				INT,
	@UserQuota				INT,
	@PaymentProcessor		NVARCHAR(50),
	@ProcessorUserId		NVARCHAR(50),
	@ProcessorPassword		NVARCHAR(50),
	@Description			NVARCHAR(500),
	@KeyWords				NVARCHAR(500),
	@BackgroundFile			NVARCHAR(50),
	@SiteLogHistory			INT,
	@SplashTabId			INT,
	@HomeTabId				INT,
	@LoginTabId				INT,
	@RegisterTabId			INT,
	@UserTabId				INT,
	@SearchTabId			INT,
    @Custom404TabId			INT,
    @Custom500TabId			INT,
	@DefaultLanguage		NVARCHAR(10),
	@HomeDirectory			VARCHAR(100),
	@LastModifiedByUserID	INT,
	@CultureCode			NVARCHAR(50)

AS

	UPDATE dbo.Portals
		SET    
		   PortalGroupID		= @PortalGroupID,
		   ExpiryDate			= @ExpiryDate,
		   UserRegistration		= @UserRegistration,
		   BannerAdvertising	= @BannerAdvertising,
		   Currency				= @Currency,
		   AdministratorId		= @AdministratorId,
		   HostFee				= @HostFee,
		   HostSpace			= @HostSpace,
		   PageQuota			= @PageQuota,
		   UserQuota			= @UserQuota,
		   PaymentProcessor		= @PaymentProcessor,
		   ProcessorUserId		= @ProcessorUserId,
		   ProcessorPassword	= @ProcessorPassword,
		   SiteLogHistory		= @SiteLogHistory,
		   DefaultLanguage		= @DefaultLanguage,
		   HomeDirectory		= @HomeDirectory,
		   LastModifiedByUserID = @LastModifiedByUserID,
		   LastModifiedOnDate	= GETDATE()
	WHERE  PortalId = @PortalID

    IF EXISTS (SELECT * FROM dbo.PortalLocalization WHERE PortalId = @PortalID AND CultureCode = @CultureCode)
	BEGIN 
		UPDATE dbo.PortalLocalization
			SET
				PortalName				= @PortalName,
				LogoFile				= @LogoFile,
				FooterText				= @FooterText,
				Description				= @Description,
				KeyWords				= @KeyWords,
				BackgroundFile			= @BackgroundFile,
				HomeTabId				= @HomeTabId,
				LoginTabId				= @LoginTabId,
				RegisterTabId			= @RegisterTabId,
				UserTabId				= @UserTabId,
				SplashTabId				= @SplashTabId,
				SearchTabId				= @SearchTabId,
                Custom404TabId			= @Custom404TabId,
                Custom500TabId			= @Custom500TabId,
				LastModifiedByUserID	= @LastModifiedByUserID,
				LastModifiedOnDate		= GETDATE()
		WHERE	PortalId = @PortalID 
			AND CultureCode = @CultureCode
	END 
ELSE
	BEGIN 
		DECLARE @AdminTabId int
		SET @AdminTabId = (SELECT AdminTabId 
								FROM dbo.PortalLocalization 
								WHERE PortalID = @PortalID AND CultureCode='en-US')

		INSERT INTO dbo.PortalLocalization (
			[PortalID],
			[CultureCode],
			[PortalName],
			[LogoFile],
			[FooterText],
			[Description],
			[KeyWords],
			[BackgroundFile],
			[HomeTabId],
			[LoginTabId],
			[UserTabId],
			[AdminTabId],
			[SplashTabId],
			[SearchTabId],
            [Custom404TabId],
            [Custom500TabId],
			[CreatedByUserID],
			[CreatedOnDate],
			[LastModifiedByUserID],
			[LastModifiedOnDate]
		)
		VALUES (
			@PortalID,
			@CultureCode,
			@PortalName,
			@LogoFile, 
			@FooterText,
			@Description,
			@KeyWords,
			@BackgroundFile,
			@HomeTabId ,
			@LoginTabId ,
			@UserTabId,
			@AdminTabid,
			@SplashTabId,
			@SearchTabId,
            @Custom404TabId,
            @Custom500TabId,
			-1,
			GETDATE(),
			-1,
			GETDATE()
		)
	END
GO
/****** Object:  StoredProcedure [dbo].[UpdatePortalLanguage]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdatePortalLanguage]
    @PortalId				int,
    @LanguageId				int,
    @IsPublished			bit,
    @LastModifiedByUserID  	int

AS
    UPDATE dbo.PortalLanguages 
        SET		
            IsPublished				= @IsPublished,
            LastModifiedByUserID	= @LastModifiedByUserID,
            LastModifiedOnDate		= getdate()
    WHERE PortalId = @PortalId
        AND LanguageId = @LanguageId
GO
/****** Object:  StoredProcedure [dbo].[UpdatePortalSetting]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdatePortalSetting]
	@PortalID       Int,			-- Key, Not Null
	@SettingName    nVarChar(  50), -- Key, not Null or Empty
	@SettingValue   nVarChar(2000), -- Not Null
	@UserID			Int,			-- Not Null (editing user)
	@CultureCode    nVarChar(  10)  -- Key, Null|'' for neutral language 
AS
BEGIN
	IF IsNull(@SettingValue, '') = ''
		DELETE FROM dbo.PortalSettings 
		 WHERE PortalID    = @PortalID
		   AND SettingName = @SettingName 
		   AND IsNull(CultureCode, '') = IsNull(@CultureCode, '')
	ELSE IF EXISTS (SELECT * FROM dbo.PortalSettings 
	                    WHERE PortalID    = @PortalID
						  AND SettingName = @SettingName 
						  AND IsNull(CultureCode, '') = IsNull(@CultureCode, '')) 
		UPDATE dbo.PortalSettings
		 SET   [SettingValue]         = @SettingValue,
			   [LastModifiedByUserID] = @UserID,
			   [LastModifiedOnDate]   = GetDate()
		 WHERE [PortalID]              = @PortalID
		   AND [SettingName]           = @SettingName
		   AND IsNull(CultureCode, '') = IsNull(@CultureCode, '') 		   
	ELSE IF IsNull(@SettingName,'') != '' -- Add new record:
		INSERT INTO dbo.PortalSettings 
		           ( PortalID,  SettingName,  SettingValue, CreatedByUserID, CreatedOnDate, LastModifiedByUserID, LastModifiedOnDate, CultureCode) 
			VALUES (@PortalID, @SettingName, @SettingValue, @UserID,         GetDate(),     @UserID ,             GetDate(),          CASE WHEN @CultureCode = '' THEN Null ELSE @CultureCode END)
END
GO
/****** Object:  StoredProcedure [dbo].[UpdatePortalSetup]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdatePortalSetup]
	@PortalId				INT,
	@AdministratorId		INT,
	@AdministratorRoleId	INT,
	@RegisteredRoleId		INT,
	@SplashTabId			INT,
	@HomeTabId				INT,
	@LoginTabId				INT,
	@RegisterTabId			INT,
	@UserTabId				INT,
	@SearchTabId            INT,
    @Custom404TabId         INT,
    @Custom500TabId         INT,
	@AdminTabId				INT,
	@CultureCode			NVARCHAR(50)

AS
	UPDATE dbo.Portals
		SET    
			AdministratorId = @AdministratorId, 
			AdministratorRoleId = @AdministratorRoleId, 
			RegisteredRoleId = @RegisteredRoleId
	WHERE  PortalId = @PortalId

	UPDATE dbo.PortalLocalization
		SET 
			HomeTabId = @HomeTabId,
			LoginTabId = @LoginTabId,
			UserTabId = @UserTabId,
			RegisterTabId = @RegisterTabId,
			AdminTabId = @AdminTabId,
			SplashTabId = @SplashTabId,
			SearchTabId = @SearchTabId,
            Custom404TabId = @Custom404TabId,
            Custom500TabId = @Custom500TabId
      WHERE portalID = @PortalID
GO
/****** Object:  StoredProcedure [dbo].[UpdateProfile]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UpdateProfile]

@UserID        int, 
@PortalID      int,
@ProfileData   ntext

as

update dbo.Profile
set    ProfileData = @ProfileData,
       CreatedDate = getdate()
where  UserId = @UserID
and    PortalId = @PortalID
GO
/****** Object:  StoredProcedure [dbo].[UpdatePropertyDefinition]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdatePropertyDefinition]
	@PropertyDefinitionId int,
	@DataType int,
	@DefaultValue nvarchar(50),
	@PropertyCategory nvarchar(50),
	@PropertyName nvarchar(50),
	@ReadOnly bit,
	@Required bit,
	@ValidationExpression nvarchar(2000),
	@ViewOrder int,
	@Visible bit,
    @Length int,
    @DefaultVisibility int,
	@LastModifiedByUserID	int

AS
	UPDATE dbo.ProfilePropertyDefinition 
		SET DataType = @DataType,
			DefaultValue = @DefaultValue,
			PropertyCategory = @PropertyCategory,
			PropertyName = @PropertyName,
			ReadOnly = @ReadOnly,
			Required = @Required,
			ValidationExpression = @ValidationExpression,
			ViewOrder = @ViewOrder,
			Visible = @Visible,
			Length = @Length,
            DefaultVisibility = @DefaultVisibility,
			[LastModifiedByUserID] = @LastModifiedByUserID,	
			[LastModifiedOnDate] = getdate()
		WHERE PropertyDefinitionId = @PropertyDefinitionId
GO
/****** Object:  StoredProcedure [dbo].[UpdateRole]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateRole]
	@RoleId					int,
	@RoleGroupId			int,
	@RoleName				nvarchar(50),
	@Description			nvarchar(1000),
	@ServiceFee				money,
	@BillingPeriod			int,
	@BillingFrequency		char(1),
	@TrialFee				money,
	@TrialPeriod			int,
	@TrialFrequency			char(1),
	@IsPublic				bit,
	@AutoAssignment			bit,
	@RSVPCode				nvarchar(50),
	@IconFile				nvarchar(100),
	@LastModifiedByUserID	int,
	@Status					int,
	@SecurityMode			int,
	@IsSystemRole			bit
AS
	UPDATE dbo.Roles
	SET    RoleGroupId			= @RoleGroupId,
		   RoleName				= @RoleName,
		   Description			= @Description,
		   ServiceFee			= @ServiceFee,
		   BillingPeriod		= @BillingPeriod,
		   BillingFrequency		= @BillingFrequency,
		   TrialFee				= @TrialFee,
		   TrialPeriod			= @TrialPeriod,
		   TrialFrequency		= @TrialFrequency,
		   IsPublic				= @IsPublic,
		   AutoAssignment		= @AutoAssignment,
		   RSVPCode				= @RSVPCode,
		   IconFile				= @IconFile,
		   LastModifiedByUserID = @LastModifiedByUserID,
		   LastModifiedOnDate		= getdate(),
		   Status				= @Status,
		   SecurityMode			= @SecurityMode,
		   IsSystemRole			= @IsSystemRole
	WHERE  RoleId = @RoleId
GO
/****** Object:  StoredProcedure [dbo].[UpdateRoleGroup]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateRoleGroup] 
	@RoleGroupId		int,
	@RoleGroupName		nvarchar(50),
	@Description		nvarchar(1000),
	@LastModifiedUserID int
AS

	UPDATE dbo.RoleGroups
	SET    RoleGroupName		= @RoleGroupName,
		   Description			= @Description,
		   LastModifiedByUserID = @LastModifiedUserID,
		   LastModifiedOnDate		= getdate()
	WHERE  RoleGroupId = @RoleGroupId
GO
/****** Object:  StoredProcedure [dbo].[UpdateRoleSetting]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateRoleSetting]
	@RoleID				int,
	@SettingName		nvarchar(50),
	@SettingValue		nvarchar(2000),
	@UserID				int

AS
	IF (SELECT COUNT(*) FROM dbo.RoleSettings WHERE RoleID = @RoleID AND SettingName = @SettingName) > 0
		--Update
		UPDATE  dbo.RoleSettings
			SET SettingValue = @SettingValue,
				[LastModifiedByUserID]=@UserID,
				[LastModifiedOnDate]=getdate()
		WHERE RoleID = @RoleID
			AND SettingName = @SettingName
			
	ELSE
		--Add
		INSERT INTO dbo.RoleSettings 
		( 
			RoleID, 
			SettingName, 
			SettingValue, 
			CreatedByUserID, 
			CreatedOnDate, 
			LastModifiedByUserID, 
			LastModifiedOnDate
		) 
		VALUES 
		( 
			@RoleID, 
			@SettingName,
			@SettingValue ,
			@UserID ,
			getdate() ,
			@UserID,
			getdate()
		)
GO
/****** Object:  StoredProcedure [dbo].[UpdateSchedule]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateSchedule]
	@ScheduleID int
	,@TypeFullName varchar(200)
	,@TimeLapse int
	,@TimeLapseMeasurement varchar(2)
	,@RetryTimeLapse int
	,@RetryTimeLapseMeasurement varchar(2)
	,@RetainHistoryNum int
	,@AttachToEvent varchar(50)
	,@CatchUpEnabled bit
	,@Enabled bit
	,@ObjectDependencies varchar(300)
	,@Servers varchar(150)
	,@LastModifiedByUserID	int
	,@FriendlyName varchar(200)
	,@ScheduleStartDate datetime
AS
UPDATE dbo.Schedule
	SET 
	TypeFullName = @TypeFullName
	,FriendlyName = @FriendlyName
	,TimeLapse = @TimeLapse
	,TimeLapseMeasurement = @TimeLapseMeasurement
	,RetryTimeLapse = @RetryTimeLapse
	,RetryTimeLapseMeasurement = @RetryTimeLapseMeasurement
	,RetainHistoryNum = @RetainHistoryNum
	,AttachToEvent = @AttachToEvent
	,CatchUpEnabled = @CatchUpEnabled
	,Enabled = @Enabled
	,ObjectDependencies = @ObjectDependencies
	,Servers = @Servers,
	[LastModifiedByUserID] = @LastModifiedByUserID,	
	[LastModifiedOnDate] = getdate(),
	ScheduleStartDate = @ScheduleStartDate
	WHERE ScheduleID = @ScheduleID
GO
/****** Object:  StoredProcedure [dbo].[UpdateScheduleHistory]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateScheduleHistory]
@ScheduleHistoryID int,
@EndDate datetime,
@Succeeded bit,
@LogNotes ntext,
@NextStart datetime
AS
UPDATE dbo.ScheduleHistory
SET	EndDate = @EndDate,
	Succeeded = @Succeeded,
	LogNotes = @LogNotes,
	NextStart = @NextStart
WHERE ScheduleHistoryID = @ScheduleHistoryID
GO
/****** Object:  StoredProcedure [dbo].[UpdateScopeType]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateScopeType] 
	@ScopeTypeId				int,
	@ScopeType					nvarchar(250)
AS
	UPDATE dbo.Taxonomy_ScopeTypes 
		SET 
			ScopeType = @ScopeType
	WHERE ScopeTypeId = @ScopeTypeId
GO
/****** Object:  StoredProcedure [dbo].[UpdateSearchCommonWord]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateSearchCommonWord]
	@CommonWordID int, 
	@CommonWord nvarchar(255), 
	@Locale nvarchar(10) 
AS

UPDATE dbo.SearchCommonWords SET
	[CommonWord] = @CommonWord,
	[Locale] = @Locale
WHERE
	[CommonWordID] = @CommonWordID
GO
/****** Object:  StoredProcedure [dbo].[UpdateSearchStopWords]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateSearchStopWords]
	@StopWordsID		int,
	@StopWords 			nvarchar(MAX),
	@LastModifiedByUserID 	int
AS
BEGIN	
	UPDATE dbo.SearchStopWords
			SET				
				StopWords = @StopWords,
				LastModifiedByUserID = @LastModifiedByUserID,
				LastModifiedOnDate = GETUTCDATE()
			WHERE StopWordsID = @StopWordsID
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateServer]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateServer]
    @ServerID           INT,
    @URL                NVARCHAR(255),
    @UniqueId           NVARCHAR(200),
    @Enabled            BIT,
    @Group              NVARCHAR(200)
AS
    UPDATE dbo.WebServers
        SET 
            URL = @URL,
            UniqueId = @UniqueId,
            Enabled = @Enabled,
            ServerGroup = @Group
        WHERE  ServerID = @ServerID
GO
/****** Object:  StoredProcedure [dbo].[UpdateServerActivity]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateServerActivity]
    @ServerName			NVARCHAR(50),
    @IISAppName			NVARCHAR(200),
    @CreatedDate		DATETIME,
    @LastActivityDate	DATETIME,
    @PingFailureCount   INT,
    @Enabled            BIT
AS

	DECLARE @ServerID int
	SET @ServerID = (SELECT ServerID FROM dbo.WebServers WHERE ServerName = @ServerName AND IISAppName = @IISAppName)

	IF @ServerID IS NULL
		BEGIN
			-- Insert
			INSERT INTO dbo.WebServers (
				ServerName,
				IISAppName,
				CreatedDate,
				LastActivityDate,
                PingFailureCount,
				[Enabled]
			)
			VALUES (
				@ServerName,
				@IISAppName,
				@CreatedDate,
				@LastActivityDate,
                @PingFailureCount,
				@Enabled
			)

            SELECT @ServerID = SCOPE_IDENTITY()
		END
	ELSE
		BEGIN
			-- Update
			UPDATE dbo.WebServers 
				SET 
					LastActivityDate = @LastActivityDate, PingFailureCount = @PingFailureCount, [Enabled] = @Enabled
				WHERE  ServerName = @ServerName AND IISAppName = @IISAppName
		END

    SELECT @ServerID
GO
/****** Object:  StoredProcedure [dbo].[UpdateSimpleTerm]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateSimpleTerm] 
	@TermID					int,
	@VocabularyID			int,
	@Name					nvarchar(250),
	@Description			nvarchar(2500),
	@Weight					int,
	@LastModifiedByUserID	int
AS
	UPDATE dbo.Taxonomy_Terms
		SET 
			VocabularyID = @VocabularyID,
			[Name] = @Name,
			Description = @Description,
			Weight = @Weight,
			LastModifiedByUserID = @LastModifiedByUserID,
			LastModifiedOnDate = getdate()
	WHERE TermID = @TermID
GO
/****** Object:  StoredProcedure [dbo].[UpdateSkin]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateSkin]

	@SkinID   int,
	@SkinSrc  nvarchar(200)

AS
	UPDATE dbo.Skins
		SET
			SkinSrc = @SkinSrc
	WHERE SkinID = @SkinID
GO
/****** Object:  StoredProcedure [dbo].[UpdateSkinControl]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateSkinControl]
	
	@SkinControlID					int,
	@PackageID						int,
	@ControlKey						nvarchar(50),
	@ControlSrc						nvarchar(256),
	@SupportsPartialRendering		bit,
	@LastModifiedByUserID	int

AS
	UPDATE dbo.SkinControls
	SET    
		PackageID = @PackageID,
		ControlKey = @ControlKey,
		ControlSrc = @ControlSrc,
		SupportsPartialRendering = @SupportsPartialRendering,
 		[LastModifiedByUserID] = @LastModifiedByUserID,	
		[LastModifiedOnDate] = getdate()
	WHERE  SkinControlID = @SkinControlID
GO
/****** Object:  StoredProcedure [dbo].[UpdateSkinPackage]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateSkinPackage]
	@SkinPackageID  int,
	@PackageID      int,
	@PortalID       int,
	@SkinName       nvarchar(50),
	@SkinType       nvarchar(20),
	@LastModifiedByUserID	int
AS
	UPDATE dbo.SkinPackages
		SET
			PackageID = @PackageID,
			PortalID = @PortalID,
			SkinName = @SkinName,
			SkinType = @SkinType,
 			[LastModifiedByUserID] = @LastModifiedByUserID,	
			[LastModifiedOnDate] = getdate()
	WHERE SkinPackageID = @SkinPackageID
GO
/****** Object:  StoredProcedure [dbo].[UpdateSynonymsGroup]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateSynonymsGroup]
	@SynonymsGroupID		int,
	@SynonymsTags 			nvarchar(MAX),
	@LastModifiedByUserID 	int
AS
BEGIN	
	UPDATE dbo.SynonymsGroups
			SET				
				SynonymsTags = @SynonymsTags,
				LastModifiedByUserID = @LastModifiedByUserID,
				LastModifiedOnDate = GETUTCDATE()
			WHERE SynonymsGroupID = @SynonymsGroupID
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateSystemMessage]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UpdateSystemMessage]

@PortalID     int,
@MessageName  nvarchar(50),
@MessageValue ntext

as

update dbo.SystemMessages
set    MessageValue = @MessageValue
where  ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
and    MessageName = @MessageName
GO
/****** Object:  StoredProcedure [dbo].[UpdateTab]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTab] 
    @TabId					int,
    @ContentItemID			int,
    @PortalId				int,
    @VersionGuid			uniqueidentifier,
    @DefaultLanguageGuid	uniqueidentifier,
    @LocalizedVersionGuid	uniqueidentifier,
    @TabName				nvarchar(200),
    @IsVisible				bit,
    @DisableLink			bit,
    @ParentId				int,
    @IconFile				nvarchar(100),
    @IconFileLarge			nvarchar(100),
    @Title					nvarchar(200),
    @Description			nvarchar(500),
    @KeyWords				nvarchar(500),
    @IsDeleted				bit,
    @Url					nvarchar(255),
    @SkinSrc				nvarchar(200),
    @ContainerSrc			nvarchar(200),
    @StartDate				datetime,
    @EndDate				datetime,
    @RefreshInterval		int,
    @PageHeadText			nvarchar(max),
    @IsSecure				bit,
    @PermanentRedirect		bit,
    @SiteMapPriority		float,
    @LastModifiedByUserID	int,
    @CultureCode			nvarchar(50),
	@IsSystem				bit
AS
	BEGIN
		DECLARE @OldParentId int
		SET @OldParentId = (SELECT ParentId FROM dbo.[Tabs] WHERE TabID = @TabId)

		DECLARE @TabOrder int
		SET @TabOrder = (SELECT TabOrder FROM dbo.[Tabs] WHERE TabID = @TabId)
				
		-- Get New TabOrder
		DECLARE @NewTabOrder int
		SET @NewTabOrder = (SELECT MAX(TabOrder) FROM dbo.[Tabs] WHERE (ParentId = @ParentId OR (ParentId IS NULL AND @ParentId IS NULL)))
		IF @NewTabOrder IS NULL 
			SET @NewTabOrder = 1
		ELSE
			SET @NewTabOrder = @NewTabOrder + 2
		
		UPDATE dbo.[Tabs]
			SET
				ContentItemID			= @ContentItemID,
				PortalId				= @PortalId,
				VersionGuid				= @VersionGuid,
				DefaultLanguageGuid		= @DefaultLanguageGuid,
				LocalizedVersionGuid	= @LocalizedVersionGuid,
				TabName					= @TabName,
				IsVisible				= @IsVisible,
				DisableLink				= @DisableLink,
				ParentId				= @ParentId,
				IconFile				= @IconFile,
				IconFileLarge			= @IconFileLarge,
				Title					= @Title,
				Description				= @Description,
				KeyWords				= @KeyWords,
				IsDeleted				= @IsDeleted,
				Url						= @Url,
				SkinSrc					= @SkinSrc,
				ContainerSrc			= @ContainerSrc,
				StartDate				= @StartDate,
				EndDate					= @EndDate,
				RefreshInterval			= @RefreshInterval,
				PageHeadText			= @PageHeadText,
				IsSecure				= @IsSecure,
				PermanentRedirect		= @PermanentRedirect,
				SiteMapPriority			= @SiteMapPriority,
				LastModifiedByUserID	= @LastModifiedByUserID,
				LastModifiedOnDate		= getdate(),
				CultureCode				= @CultureCode,
				IsSystem				= @IsSystem
		WHERE  TabId = @TabId
		
		IF (@OldParentId <> @ParentId)
			BEGIN
				-- update TabOrder of Tabs with same original Parent
				UPDATE dbo.[Tabs]
					SET TabOrder = TabOrder - 2
					WHERE (ParentId = @OldParentId) 
						AND TabOrder > @TabOrder

				-- Update Tab with new TabOrder
				UPDATE dbo.[Tabs]
					SET 
						TabOrder = @NewTabOrder
					WHERE TabID = @TabId
			END
		
		EXEC dbo.BuildTabLevelAndPath @TabId, 1
    END
GO
/****** Object:  StoredProcedure [dbo].[UpdateTabModule]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTabModule]
    @TabModuleId            int,
    @TabId					int,
    @ModuleId				int,
	@ModuleTitle			nvarchar(256),
	@Header					ntext,
	@Footer					ntext,
    @ModuleOrder			int,
    @PaneName				nvarchar(50),
    @CacheTime				int,
    @CacheMethod			varchar(50),
    @Alignment				nvarchar(10),
    @Color					nvarchar(20),
    @Border					nvarchar(1),
    @IconFile				nvarchar(100),
    @Visibility				int,
    @ContainerSrc			nvarchar(200),
    @DisplayTitle			bit,
    @DisplayPrint			bit,
    @DisplaySyndicate		bit,
    @IsWebSlice				bit,
    @WebSliceTitle			nvarchar(256),
    @WebSliceExpiryDate		datetime,
    @WebSliceTTL			int,
    @VersionGuid			uniqueidentifier,
    @DefaultLanguageGuid	uniqueidentifier,
    @LocalizedVersionGuid	uniqueidentifier,
    @CultureCode			nvarchar(10),
    @LastModifiedByUserID	int

AS
    UPDATE dbo.TabModules
        SET    
            TabId = @TabId,
            ModuleId = @ModuleId,
			ModuleTitle = @ModuleTitle,
			Header = @Header,
			Footer = @Footer, 
            ModuleOrder = @ModuleOrder,
            PaneName = @PaneName,
            CacheTime = @CacheTime,
            CacheMethod = @CacheMethod,
            Alignment = @Alignment,
            Color = @Color,
            Border = @Border,
            IconFile = @IconFile,
            Visibility = @Visibility,
            ContainerSrc = @ContainerSrc,
            DisplayTitle = @DisplayTitle,
            DisplayPrint = @DisplayPrint,
            DisplaySyndicate = @DisplaySyndicate,
            IsWebSlice = @IsWebSlice,
            WebSliceTitle = @WebSliceTitle,
            WebSliceExpiryDate = @WebSliceExpiryDate,
            WebSliceTTL = @WebSliceTTL,
            VersionGuid = @VersionGuid,
            DefaultLanguageGuid = @DefaultLanguageGuid,
            LocalizedVersionGuid = @LocalizedVersionGuid,
            CultureCode= @CultureCode,
            LastModifiedByUserID = @LastModifiedByUserID,
            LastModifiedOnDate = getdate()
        WHERE  TabModuleId = @TabModuleId
GO
/****** Object:  StoredProcedure [dbo].[UpdateTabModuleSetting]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTabModuleSetting]
	@TabModuleId			int,
	@SettingName			nvarchar(50),
	@SettingValue			nvarchar(max),
	@LastModifiedByUserID	int

AS
	UPDATE dbo.TabModuleSettings
		SET    SettingValue = @SettingValue,
			   LastModifiedByUserID = @LastModifiedByUserID,
			   LastModifiedOnDate = getdate()
		WHERE  TabModuleId = @TabModuleId
		AND    SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[UpdateTabModuleTranslationStatus]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTabModuleTranslationStatus]
	@TabModuleId			int,
    @LocalizedVersionGuid	uniqueidentifier,
	@LastModifiedByUserID	int
AS
	UPDATE dbo.TabModules
		SET
		LocalizedVersionGuid	= @LocalizedVersionGuid,
		LastModifiedByUserID	= @LastModifiedByUserID,
		LastModifiedOnDate		= getdate()
	WHERE  TabModuleId = @TabModuleId
GO
/****** Object:  StoredProcedure [dbo].[UpdateTabModuleVersion]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTabModuleVersion]
    @TabModuleID	int,
    @VersionGuid	uniqueidentifier
AS
    UPDATE dbo.TabModules
        SET    VersionGuid = @VersionGuid
    WHERE  TabModuleID = @TabModuleID
GO
/****** Object:  StoredProcedure [dbo].[UpdateTabModuleVersionByModule]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTabModuleVersionByModule]
    @ModuleID	int
AS
    UPDATE dbo.TabModules
        SET    VersionGuid = NEWID()
    WHERE  ModuleID = @ModuleID
GO
/****** Object:  StoredProcedure [dbo].[UpdateTabOrder]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTabOrder] 
	@TabId					int,
	@TabOrder				int,
	@ParentId				int,
	@LastModifiedByUserID	int
AS
	DECLARE @OldParentId INT
	SELECT @OldParentId = ParentId FROM dbo.Tabs WHERE TabID = @TabId
	UPDATE Tabs
		SET
			TabOrder				= @TabOrder,
			ParentId				= @ParentId,
			LastModifiedByUserID	= @LastModifiedByUserID,
			LastModifiedOnDate		= GETDATE()
	WHERE  TabId = @TabId
	IF @OldParentId <> @ParentId
		BEGIN
			EXEC dbo.BuildTabLevelAndPath @TabId, 1
		END
	ELSE
		BEGIN
			EXEC dbo.BuildTabLevelAndPath @TabId
		END
GO
/****** Object:  StoredProcedure [dbo].[UpdateTabPermission]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTabPermission]
    @TabPermissionId        Int, -- not null!
    @TabId                  Int, -- not null!
    @PermissionId           Int, -- not null!
    @RoleId                 Int, -- might be negative for virtual roles
    @AllowAccess            Bit, -- false: deny, true: grant
    @UserId                 Int, -- -1 is replaced by Null
    @LastModifiedByUserId   Int  -- -1 is replaced by Null
AS
    UPDATE dbo.[TabPermission] SET
        [TabID]                = @TabId,
        [PermissionID]         = @PermissionId,
        [RoleID]               = @RoleId,
        [AllowAccess]          = @AllowAccess,
        [UserID]               = CASE WHEN @UserId = -1 THEN Null ELSE @UserId  END,
        [LastModifiedByUserId] = CASE WHEN @LastModifiedByUserId = -1 THEN Null ELSE @LastModifiedByUserId  END,
        [LastModifiedOnDate]   = GetDate()
    WHERE
        [TabPermissionID]      = @TabPermissionId
GO
/****** Object:  StoredProcedure [dbo].[UpdateTabSetting]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTabSetting]
	@TabID					INT,
	@SettingName			NVARCHAR(50),
	@SettingValue			NVARCHAR(2000),
	@LastModifiedByUserID  	INT
AS

	UPDATE 	dbo.TabSettings
	SET 	SettingValue = @SettingValue,
			LastModifiedByUserID = @LastModifiedByUserID,
			LastModifiedOnDate = GETDATE()
	WHERE TabID = @TabID
		AND SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[UpdateTabTranslationStatus]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTabTranslationStatus]
	@TabId					int,
    @LocalizedVersionGuid	uniqueidentifier,
	@LastModifiedByUserID	int
AS
	UPDATE dbo.Tabs
		SET
		LocalizedVersionGuid	= @LocalizedVersionGuid,
		LastModifiedByUserID	= @LastModifiedByUserID,
		LastModifiedOnDate		= getdate()
	WHERE  TabId = @TabId
GO
/****** Object:  StoredProcedure [dbo].[UpdateTabVersion]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTabVersion]
    @TabID			int,
    @VersionGuid	uniqueidentifier
AS
    UPDATE dbo.Tabs
        SET    VersionGuid = @VersionGuid
    WHERE  TabID = @TabID
GO
/****** Object:  StoredProcedure [dbo].[UpdateUrlTracking]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UpdateUrlTracking]

@PortalID     int,
@Url          nvarchar(255),
@LogActivity  bit,
@TrackClicks  bit,
@ModuleId     int,
@NewWindow    bit

as

update dbo.UrlTracking
set    LogActivity = @LogActivity,
       TrackClicks = @TrackClicks,
       NewWindow = @NewWindow
where  PortalID = @PortalID
and    Url = @Url
and    ((ModuleId = @ModuleId) or (ModuleId is null and @ModuleId is null))
GO
/****** Object:  StoredProcedure [dbo].[UpdateUrlTrackingStats]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UpdateUrlTrackingStats]

@PortalID     int,
@Url          nvarchar(255),
@ModuleId     int

as

update dbo.UrlTracking
set    Clicks = Clicks + 1,
       LastClick = getdate()
where  PortalID = @PortalID
and    Url = @Url
and    ((ModuleId = @ModuleId) or (ModuleId is null and @ModuleId is null))
GO
/****** Object:  StoredProcedure [dbo].[UpdateUser]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateUser]
	@UserID         int,
	@PortalID		int,
	@FirstName		nvarchar(50),
	@LastName		nvarchar(50),
	@IsSuperUser    bit,
	@Email          nvarchar(256),
	@DisplayName    nvarchar(100),
	@VanityUrl		nvarchar(100),
	@UpdatePassword	bit,
	@Authorised		bit,
	@RefreshRoles	bit,
	@LastIPAddress	nvarchar(50),
	@passwordResetToken uniqueidentifier,
	@passwordResetExpiration datetime,
	@IsDeleted		bit,
	@LastModifiedByUserID int
AS
	UPDATE dbo.Users
		SET
			FirstName = @FirstName,
			LastName = @LastName,
			IsSuperUser = @IsSuperUser,
			Email = @Email,
			DisplayName = @DisplayName,
			UpdatePassword = @UpdatePassword,
			PasswordResetToken=@passwordResetToken,
			PasswordResetExpiration=@passwordResetExpiration,
			LastIPAddress = @LastIPAddress,
			LastModifiedByUserID = @LastModifiedByUserID,
			LastModifiedOnDate = getdate()
		WHERE  UserId = @UserID
	
	IF @PortalID IS NULL
		BEGIN
			UPDATE dbo.Users
				SET
					IsDeleted = @IsDeleted
				WHERE  UserId = @UserID
		END
	ELSE
		BEGIN
			UPDATE dbo.UserPortals
				SET
					Authorised = @Authorised,
					RefreshRoles = @RefreshRoles,
					VanityUrl = @VanityUrl,
					IsDeleted = @IsDeleted
				WHERE  UserId = @UserID
					AND PortalId = @PortalID
		END
GO
/****** Object:  StoredProcedure [dbo].[UpdateUserProfileProperty]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateUserProfileProperty] 

	@ProfileID				int,
	@UserID					int,
	@PropertyDefinitionID	int,
	@PropertyValue			ntext,
	@Visibility				int,
	@ExtendedVisibility		varchar(400),
	@LastUpdatedDate		datetime

AS
	IF @ProfileID IS NULL OR @ProfileID = -1
		-- Try the UserID/PropertyDefinitionID to see if the Profile property exists
		SELECT @ProfileID = ProfileID
			FROM   dbo.UserProfile
			WHERE  UserID = @UserID AND PropertyDefinitionID = @PropertyDefinitionID
	 
	IF @ProfileID IS NOT NULL
		-- Update Property
		BEGIN
			UPDATE dbo.UserProfile
				SET PropertyValue = case when (DATALENGTH(@PropertyValue) > 7500) then NULL else @PropertyValue end,
					PropertyText = case when (DATALENGTH(@PropertyValue) > 7500) then @PropertyValue else NULL end,
					Visibility = @Visibility,
					ExtendedVisibility = @ExtendedVisibility,
					LastUpdatedDate = @LastUpdatedDate
				WHERE  ProfileID = @ProfileID
			SELECT @ProfileID
		END
	ELSE
		-- Insert New Property
		BEGIN
			INSERT INTO dbo.UserProfile (
				UserID,
				PropertyDefinitionID,
				PropertyValue,
				PropertyText,
				Visibility,
				ExtendedVisibility,
				LastUpdatedDate
			  )
			VALUES (
				@UserID,
				@PropertyDefinitionID,
				case when (DATALENGTH(@PropertyValue) > 7500) then NULL else @PropertyValue end,
				case when (DATALENGTH(@PropertyValue) > 7500) then @PropertyValue else NULL end,
				@Visibility,
				@ExtendedVisibility,
				@LastUpdatedDate
			  )

		SELECT SCOPE_IDENTITY()
	END
GO
/****** Object:  StoredProcedure [dbo].[UpdateUserRole]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateUserRole]
    @UserRoleId		int, 
	@Status			int,
	@IsOwner		bit,
	@EffectiveDate	datetime = null,
	@ExpiryDate		datetime = null,
	@LastModifiedByUserID			int
AS
	UPDATE dbo.UserRoles 
		SET 
			Status = @Status,
			IsOwner = @IsOwner,
			ExpiryDate = @ExpiryDate,
			EffectiveDate = @EffectiveDate,
			IsTrialUsed = 1,
			LastModifiedByUserID = @LastModifiedByUserID,
			LastModifiedOnDate = getdate()
		WHERE  UserRoleId = @UserRoleId
GO
/****** Object:  StoredProcedure [dbo].[UpdateVendor]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[UpdateVendor]

@VendorId	int,
@VendorName nvarchar(50),
@Unit	 	nvarchar(50),
@Street 	nvarchar(50),
@City		nvarchar(50),
@Region	    nvarchar(50),
@Country	nvarchar(50),
@PostalCode	nvarchar(50),
@Telephone	nvarchar(50),
@Fax		nvarchar(50),
@Cell		nvarchar(50),
@Email		nvarchar(50),
@Website	nvarchar(100),
@FirstName	nvarchar(50),
@LastName	nvarchar(50),
@UserName   nvarchar(100),
@LogoFile   nvarchar(100),
@KeyWords   text,
@Authorized bit

as

update dbo.Vendors
set    VendorName    = @VendorName,
       Unit          = @Unit,
       Street        = @Street,
       City          = @City,
       Region        = @Region,
       Country       = @Country,
       PostalCode    = @PostalCode,
       Telephone     = @Telephone,
       Fax           = @Fax,
       Cell          = @Cell,
       Email         = @Email,
       Website       = @Website,
       FirstName     = @FirstName,
       LastName      = @LastName,
       CreatedByUser = @UserName,
       CreatedDate   = getdate(),
       LogoFile      = @LogoFile,
       KeyWords      = @KeyWords,
       Authorized    = @Authorized
where  VendorId = @VendorId
GO
/****** Object:  StoredProcedure [dbo].[UpdateVocabulary]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateVocabulary] 
	@VocabularyID			int,
	@VocabularyTypeID		int,
	@Name					nvarchar(250),
	@Description			nvarchar(2500),
	@Weight					int,
	@ScopeID				int,
	@ScopeTypeID			int,
	@LastModifiedByUserID	int
AS
	UPDATE dbo.Taxonomy_Vocabularies
		SET 
			VocabularyTypeID = @VocabularyTypeID,
			[Name] = @Name,
			Description = @Description,
			Weight = @Weight,
			ScopeID = @ScopeID,
			ScopeTypeID = @ScopeTypeID,
			LastModifiedByUserID = @LastModifiedByUserID,
			LastModifiedOnDate = getdate()
	WHERE VocabularyId = @VocabularyId
GO
/****** Object:  UserDefinedFunction [dbo].[AdjustedReferrer]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[AdjustedReferrer](
	@Referrer 	 nVarChar(2000),
	@PortalAlias nVarChar( 255)
	)
RETURNS nVarChar(2000)
AS
BEGIN
	RETURN CASE 
		WHEN @Referrer LIKE '%' + @PortalAlias + '%' THEN Null 
		ELSE @Referrer
	END
END
GO
/****** Object:  UserDefinedFunction [dbo].[AdministratorRoleId]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- new function to return RoleID for Administrators of the Portal passed in as parameter
CREATE FUNCTION [dbo].[AdministratorRoleId](
    @PortalId	 		 Int -- Needs to be >= 0, otherwise false is returned
) 
	RETURNS 			 int
AS
	BEGIN
		DECLARE @adminRoleId int = 0
		SELECT  @adminRoleId = AdministratorRoleId FROM dbo.[Portals] WHERE PortalID = @PortalId
		RETURN  @adminRoleId
	END
GO
/****** Object:  UserDefinedFunction [dbo].[BrowserFromUserAgent]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[BrowserFromUserAgent]
	(@UserAgent nVarChar(2000))
RETURNS nVarChar(2000)
AS
BEGIN
	DECLARE @ident1		 nVarChar( 20) = '';
	DECLARE @ident2		 nVarChar( 20) = '';
	DECLARE @Browser     nVarChar(100) = '';
	DECLARE @Version	 nVarChar( 10) = '';
	DECLARE @Pos         Smallint = -1;
	DECLARE @End		 Smallint =  0;
	
	-- Detect Browser family (Name|Version Prefix):
	SET @Browser =	CASE
		WHEN @UserAgent LIKE '%Opera Mini/%'	THEN 'Opera Mini|Opera Mini/|Version/'
		WHEN @UserAgent LIKE '%Opera Mobi/%'	THEN 'Opera Mobile|Version/|Opera Mobi/'
		WHEN @UserAgent LIKE '%Opera/%'			THEN 'Opera|Version/|Opera/'
		WHEN @UserAgent LIKE '%Opera %'			THEN 'Opera|Opera '
		WHEN @UserAgent LIKE '%Opera'			THEN 'Opera|Opera'
		WHEN @UserAgent LIKE '%Firefox/%'		THEN 'Mozilla Firefox|Firefox/'
		WHEN @UserAgent LIKE '%Firebird/%'		THEN 'Mozilla Firebird|Firebird/'
		WHEN @UserAgent LIKE '%SeaMonkey/%'		THEN 'Mozilla SeaMonkey|SeaMonkey/'
		WHEN @UserAgent LIKE '%Kindle/%'		THEN 'Amazon Kindle|Kindle/'
		WHEN @UserAgent LIKE '%Kindle %'		THEN 'Amazon Kindle|Version/'
		WHEN @UserAgent LIKE '%Silk/%'			THEN 'Amazon Kindle|Version/'
		WHEN @UserAgent LIKE '%Chrome/%'		THEN 'Google Chrome|Chrome/'
		WHEN @UserAgent Like '%Blackberry'		THEN 'Blackberry|Mobile Safari/'
		WHEN @UserAgent LIKE '%Android%' 		THEN 'Android|Mobile Safari/'
		WHEN @UserAgent LIKE '%Safari/%'		THEN 'Apple Safari|Safari/'
		WHEN @UserAgent LIKE '%ChromePlus/%'	THEN 'ChromePlus|ChromePlus/'
		WHEN @UserAgent LIKE '%AOL %'			THEN 'AOL Browser|AOL '
		WHEN @USerAgent LIKE '%Crazy Browser %' THEN 'Crazy Browser|Crazy Browser '
		WHEN @USerAgent LIKE '%Maxthon/%'		THEN 'Maxthon|Maxthon/'
		WHEN @USerAgent LIKE '%IEMobile %'		THEN 'IE Mobile|IEMobile '
		WHEN @USerAgent LIKE '%IEMobile/%'		THEN 'IE Mobile|IEMobile/'
		WHEN @UserAgent LIKE '%MSIE %'      	THEN 'Internet Explorer|MSIE '
		WHEN @UserAgent LIKE '%(IE %'      		THEN 'Internet Explorer|(IE '
		WHEN @UserAgent LIKE '%Netscape/%' 		THEN 'Netscape Navigator|Netscape/'
		WHEN @UserAgent LIKE '%Navigator/%'		THEN 'Netscape Navigator|Navigator/'
		WHEN @UserAgent LIKE '%PLAYSTATION %' 	THEN 'Sony Playstation|PLAYSTATION '
		WHEN @UserAgent LIKE '%WGet/%'			THEN 'WGet|WGet/'
	END
	IF @Browser <> '' -- separate elements:
		SET @Pos = CharIndex('|', @Browser)
		IF @Pos > 0 BEGIN	
			SET @ident1  = SubString(@Browser, @Pos + 1, 100)
			SET @Browser = Left(@Browser, @Pos - 1)
			SET @Pos     = CharIndex('|', @ident1)
			IF  @Pos > 0 BEGIN
				SET @Ident2 = SubString(@Ident1, @Pos + 1, 100)
				SET @Ident1 = Left(@Ident1, @Pos - 1)
			END 
			-- get major version number from UserAgent string:
			SET @Pos = CharIndex(@ident1, @UserAgent) + Len(@ident1 + '|') - 1 -- correct to catch trailing space
			IF @Pos = 0 SET @Pos = CharIndex(@ident2, @UserAgent) + Len(@ident2 + '|') - 1 -- again
			IF @Pos > 0 BEGIN
				WHILE SubString(@UserAgent, @Pos + @End, 1) >= '0' AND SubString(@UserAgent, @Pos + @End, 1) <= 9
					SET @End = @End + 1
				IF @End > 0 SET @Version = SubString(@UserAgent, @Pos, @End)
			END
		END
	ELSE -- Search bots, ignore version
		SET @Browser = CASE 
		WHEN @UserAgent LIKE '%GoogleBot%'		THEN 'Google Bot'
		WHEN @UserAgent LIKE 'BingBot%'			THEN 'Bing Bot'
		WHEN @UserAgent LIKE 'MSNBot%'			THEN 'MSN Bot'
		WHEN @UserAgent LIKE '%BaiduSpider%'	THEN 'Baidu Spider'
		WHEN @UserAgent LIKE '%Arachmo%'		THEN 'Arachmo Bot'
		WHEN @UserAgent LIKE '%NewsGator%'		THEN 'NewsGator Bot'
		WHEN @UserAgent LIKE '%Seekbot%'		THEN 'SeekPort Bot'
		WHEN @UserAgent LIKE '%Yahoo%'			THEN 'Yahoo Bot'
		WHEN @UserAgent LIKE '%Yandex%'			THEN 'Yandex Bot'
		WHEN @UserAgent LIKE '%Bot%'			THEN 'Other Bot'
		ELSE 'Other'
	END
	RETURN RTRIM(@Browser + ' ' + @Version)
END
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertListToTable]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ConvertListToTable]
(  
	@Delimiter	nvarchar(5), 
    @List		nvarchar(max)
) 
RETURNS @TableOfValues TABLE 
(  
	RowNumber	smallint IDENTITY(1,1), 
    RowValue	nvarchar(50) 
) 
AS 
   BEGIN
      DECLARE @LenString int 
 
      WHILE len( @List ) > 0 
         BEGIN 
         
            SELECT @LenString = 
               (CASE charindex( @Delimiter, @List ) 
                   WHEN 0 THEN len( @List ) 
                   ELSE ( charindex( @Delimiter, @List ) -1 )
                END
               ) 
                                
            INSERT INTO @TableOfValues 
               SELECT substring( @List, 1, @LenString )
                
            SELECT @List = 
               (CASE ( len( @List ) - @LenString ) 
                   WHEN 0 THEN '' 
                   ELSE right( @List, len( @List ) - @LenString - 1 ) 
                END
               ) 
         END
      RETURN 
   END
GO
/****** Object:  UserDefinedFunction [dbo].[FilePath]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FilePath]
(
    @StrMayContainFileId nVarChar(255)
)
	RETURNS 			 nVarChar(500)
AS
	BEGIN
		DECLARE @Path AS nVarChar(500);

		IF ISNULL(@StrMayContainFileId,'') = ''
			SET @Path = ''
		 ELSE IF Lower(@StrMayContainFileId) LIKE 'fileid=%'
			SELECT @Path = IsNull(Folder, '') + FileName FROM dbo.[vw_Files]
			 WHERE fileid = CAST(SUBSTRING(@StrMayContainFileId, 8, 10) AS Int)
		 ELSE
			SET @Path = @StrMayContainFileId
		RETURN @Path -- never Null!
	END
GO
/****** Object:  UserDefinedFunction [dbo].[FitsExtendedPropertyPermission]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- new function to determine, whether a user may view content of another users property,
-- if extended permissions (per social group or relationship) are specified
CREATE FUNCTION [dbo].[FitsExtendedPropertyPermission](
    @viewingUserId 		 Int,
    @viewedUserID 		 Int,
    @extendedPermissions nVarChar(2000)
) 
	RETURNS 			 Bit
AS
	BEGIN
		DECLARE @rolesStr    nVarChar(2000) = ''
		DECLARE @reltnStr    nVarChar(2000) = ''
		DECLARE @gStartPos   Int
		DECLARE @rStartPos   Int
		DECLARE @recCount    Int = 0
		DECLARE @SQL         Int
		If (@viewedUserID > 0 and Len(IsNull(@extendedPermissions,'')) > 2) BEGIN
			SET @gStartPos = CHARINDEX('G:',@extendedPermissions) + 2
			SET @rStartPos = CHARINDEX('R:',@extendedPermissions) + 2
			if @gStartPos > @rStartPos BEGIN
				SET @rolesStr = SUBSTRING(@extendedPermissions, @gStartPos, Len(@extendedPermissions) - @gStartPos)
				if @rStartPos > 0 SET @reltnStr = SUBSTRING(@extendedPermissions, @rStartPos, @gStartPos - @rStartPos - 1)
			END
			If @gStartPos < @rStartPos BEGIN
				SET @reltnStr = SUBSTRING(@extendedPermissions, @rStartPos, Len(@extendedPermissions) - @rStartPos)
				if @gStartPos > 0 SET @rolesStr = SUBSTRING(@extendedPermissions, @gStartPos, @rStartPos - @gStartPos - 1)
			END
			If @rolesStr <> '' BEGIN
				SET @rolesStr = ',' + SUBSTRING(@rolesStr,1, Len(@rolesStr) - CASE WHEN RIGHT(@RolesStr,1) = ';' THEN 1 ELSE 0 END)
				SELECT @recCount = COUNT(1) FROM dbo.[UserRoles] WHERE UserID = @viewingUserId AND @rolesStr LIKE '%,' + Convert(nVarChar(10),RoleId) + ',%'
			END
			If @recCount = 0 AND @reltnStr <> '' BEGIN
				SET @reltnStr = ',' + SUBSTRING(@reltnStr,1, Len(@reltnStr) - CASE WHEN RIGHT(@reltnStr,1) = ';' THEN 1 ELSE 0 END)
				SELECT @recCount = COUNT(1) FROM dbo.[vw_RelatedUsers] WHERE UserID = @viewingUserId AND relatedUserID = @viewedUserId AND @reltnStr LIKE '%,' + Convert(nVarChar(10),RelationShipID) + ',%' AND Status = 2
			END
		END
		RETURN CASE WHEN IsNull(@RecCount, 0) > 0 THEN 1 ELSE 0 END
	END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CompareVersion]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_CompareVersion]
(
	@Version		nvarchar(20),
	@CurrentVersion nvarchar(20)
)
RETURNS int

AS
	BEGIN
	
		DECLARE @Pos int
		DECLARE @String nvarchar(20)
		DECLARE @MajorVersion int
		DECLARE @MajorCurrentVersion int
		DECLARE @MinorVersion int
		DECLARE @MinorCurrentVersion int
		DECLARE @BuildVersion int
		DECLARE @BuildCurrentVersion int

		SET @String = @Version
		SET @Pos = CHARINDEX('.' , @String)
		SET @MajorVersion = CONVERT(int, LEFT(@String, @Pos - 1))
		SET @String = STUFF(@String, 1, @Pos, '')
		SET @Pos = CHARINDEX('.' , @String)
		SET @MinorVersion = CONVERT(int, LEFT(@String, @Pos - 1))
		SET @String = STUFF(@String, 1, @Pos, '')
		SET @BuildVersion = CONVERT(int, @String)
		
		SET @String = @CurrentVersion
		SET @Pos = CHARINDEX('.' , @String)
		SET @MajorCurrentVersion = CONVERT(int, LEFT(@String, @Pos - 1))
		SET @String = STUFF(@String, 1, @Pos, '')
		SET @Pos = CHARINDEX('.' , @String)
		SET @MinorCurrentVersion = CONVERT(int, LEFT(@String, @Pos - 1))
		SET @String = STUFF(@String, 1, @Pos, '')
		SET @BuildCurrentVersion = CONVERT(int, @String)
		
		IF @CurrentVersion IS NULL
			-- Assembly Not Registered -  Set ReturnCode = 0, so assembly is copied
			RETURN 0
		ELSE
			IF @Version = @CurrentVersion
				-- Same Version - Set ReturnCode = 2, so assembly is only copied on repair
				RETURN 2
			ELSE
				-- Different Version
				-- Compare Major, Minor, Revision
				IF @MajorVersion > @MajorCurrentVersion
					OR (@MajorVersion = @MajorCurrentVersion AND @MinorVersion > @MinorCurrentVersion)
						OR (@MajorVersion = @MajorCurrentVersion AND @MinorVersion = @MinorCurrentVersion AND @BuildVersion > @BuildCurrentVersion)
					-- Newer version - at least on of Major, Minor, Revision is larger - Set ReturnCode = 1, so assembly is copied
					RETURN 1
				ELSE
					-- Older Version - Set ReturnCode = 3, so assembly is not copied
					RETURN 3

		RETURN 3
	END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetVersion]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GetVersion]
(
	@maj AS int,
	@min AS int,
	@bld AS int
)
RETURNS bit

AS
BEGIN
	IF Exists (SELECT * FROM dbo.Version
					WHERE Major = @maj
						AND Minor = @min
						AND Build = @bld
				)
		BEGIN
			RETURN 1
		END
	RETURN 0
END
GO
/****** Object:  UserDefinedFunction [dbo].[FormattedString]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- added for easier string handling
CREATE FUNCTION [dbo].[FormattedString]
(
    @InputStr nVarChar(2000), -- might be null or empty, in this case an empty string is returned (format ignored)!
    @Format   nVarChar(2000)  -- not null or empty, contains token @@@
)
	RETURNS   nVarChar(4000)  -- replaced string, e.g. FormattedString('World', 'Hello @0!') returns 'Hello World!' 
AS
BEGIN
	DECLARE @RetVal AS nVarChar(4000) = ''
	IF NOT IsNull(@InputStr,'') = ''
		SET @retVal = REPLACE(@Format, N'@0', @InputStr)
	RETURN @RetVal
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetElement]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetElement]
(
	@ord AS INT,
	@str AS VARCHAR(8000),
	@delim AS VARCHAR(1) 
)
RETURNS INT

AS

BEGIN
	-- If input is invalid, return null.
	IF  @str IS NULL
		OR LEN(@str) = 0
		OR @ord IS NULL
		OR @ord < 1
		-- @ord > [is the] expression that calculates the number of elements.
		OR @ord > LEN(@str) - LEN(REPLACE(@str, @delim, '')) + 1
		RETURN NULL
 
	DECLARE @pos AS INT, @curord AS INT
	SELECT @pos = 1, @curord = 1
	-- Find next element's start position and increment index.
	WHILE @curord < @ord
		SELECT
			@pos = CHARINDEX(@delim, @str, @pos) + 1,
			@curord = @curord + 1
	RETURN    CAST(SUBSTRING(@str, @pos, CHARINDEX(@delim, @str + @delim, @pos) - @pos) AS INT)
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetFileFolderFunc]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetFileFolderFunc](@FolderD INT)
RETURNS nvarchar(246) 
AS
BEGIN
    DECLARE @folderPath nvarchar(246)
    select @folderPath=folderpath from dbo.[Folders] where folderid=@FolderD
return @folderPath
  
END;
GO
/****** Object:  UserDefinedFunction [dbo].[GetListParentKey]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetListParentKey]
(
	@ParentID AS int,
	@ListName as nvarchar(500),
	@Type as nvarchar(50),
	@Count as int 
)
RETURNS nvarchar(2000)

AS
	BEGIN
		DECLARE @KeyValue nvarchar(2000)
		DECLARE @ListValue nvarchar(2000)
		DECLARE @TextValue nvarchar(2000)
		DECLARE @ReturnValue nvarchar(2000)
		DECLARE @Key nvarchar(2000)
		
		IF @ParentID = 0
			IF @Count = 0
				SET @ReturnValue = ''
			ELSE
				SET @ReturnValue = @ListName
		ELSE
			BEGIN
				SELECT	@KeyValue = ListName + '.' + [Value],
						@TextValue = ListName + '.' + [Text], 
						@ListValue = ListName, 
						@ParentID = ParentID  
					FROM dbo.Lists 
					WHERE EntryID = @ParentID
				If @Type = 'ParentKey' Or (@Type = 'ParentList' AND @Count > 0)
					SET @ReturnValue = @KeyValue
				ELSE 
					IF @Type = 'ParentList'
						SET @ReturnValue = @ListValue
					ELSE
						SET @ReturnValue = @TextValue
				IF @Count > 0
					If @Count = 1 AND @Type = 'ParentList'
						SET @ReturnValue = @ReturnValue + ':' + @ListName
					ELSE
						SET @ReturnValue = @ReturnValue + '.' + @ListName
				SET @ReturnValue = dbo.GetListParentKey(@ParentID, @ReturnValue, @Type, @Count+1)
			END

		RETURN    @ReturnValue
	END
GO
/****** Object:  UserDefinedFunction [dbo].[GetProfileElement]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetProfileElement]
(
	@fieldName AS NVARCHAR(100),
	@fields AS NVARCHAR(4000),
	@values AS NVARCHAR(4000)
)

RETURNS NVARCHAR(4000)

AS

BEGIN

	-- If input is invalid, return null.
	IF  @fieldName IS NULL
		OR LEN(@fieldName) = 0
		OR @fields IS NULL
		OR LEN(@fields) = 0
		OR @values IS NULL
		OR LEN(@values) = 0
		RETURN NULL

	-- locate FieldName in Fields
	DECLARE @fieldNameToken AS NVARCHAR(20)
	DECLARE @fieldNameStart AS INTEGER, @valueStart AS INTEGER, @valueLength AS INTEGER

	-- Only handle string type fields (:S:)
	SET @fieldNameStart = CHARINDEX(@fieldName + ':S',@Fields,0)

	-- If field is not found, return null
	IF @fieldNameStart = 0 RETURN NULL
	SET @fieldNameStart = @fieldNameStart + LEN(@fieldName) + 3

	-- Get the field token which I've defined as the start of the field offset to the end of the length
	SET @fieldNameToken =
	SUBSTRING(@Fields,@fieldNameStart,LEN(@Fields)-@fieldNameStart)

	-- Get the values for the offset and length
	SET @valueStart = dbo.getelement(1,@fieldNameToken,':')
	SET @valueLength = dbo.getelement(2,@fieldNameToken,':')

	-- Check for sane values, 0 length means the profile item was stored, just no data
	IF @valueLength = 0 RETURN ''

	-- Return the string
	RETURN SUBSTRING(@values, @valueStart+1, @valueLength)
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetProfileFieldSQL]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- results order added
CREATE FUNCTION [dbo].[GetProfileFieldSQL]
(
    @PortalID 	 Int,
    @TemplateSql nVarChar(max)
)
	RETURNS 	 nVarChar(max)
AS
	BEGIN
		DECLARE @sql nVarChar(max);

		SELECT @sql = COALESCE(@sql + ',','') + '[' + PropertyName + ']' + @TemplateSql
		 FROM dbo.[ProfilePropertyDefinition]
		 WHERE IsNull(PortalID, -1) = IsNull(@PortalID, -1)
		   AND Deleted = 0
		ORDER BY ViewOrder
		RETURN (@sql)
	END
GO
/****** Object:  UserDefinedFunction [dbo].[GetProfilePropertyDefinitionID]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- optimized
CREATE FUNCTION [dbo].[GetProfilePropertyDefinitionID]
(   @PortalID     Int,         -- might be 0
    @PropertyName nVarChar(50) -- required
)   
	RETURNS 	  Int
AS
	BEGIN
		DECLARE @DefinitionID Int = -1
		IF NOT IsNull(@PropertyName, '') = ''
			SELECT @DefinitionID = PropertyDefinitionID
			  FROM dbo.[ProfilePropertyDefinition]
			  WHERE IsNull(PortalID, -1) = IsNull(@PortalID, -1) AND PropertyName = @PropertyName
		RETURN @DefinitionID
	END
GO
/****** Object:  UserDefinedFunction [dbo].[GetSortSQL]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetSortSQL]
(   -- deprecated, please call SortFieldSQL and FormattedString instead
    @SortBy        nVarChar(100),
    @SortAscending Bit,
    @Default       nVarChar(100)
)
	RETURNS 	   nVarChar(120)
AS
	BEGIN
		RETURN dbo.[FormattedString](dbo.[SortFieldSQL](@SortBy, @SortAscending, @Default), N'ORDER BY @0')
	END
GO
/****** Object:  UserDefinedFunction [dbo].[HasChildTab]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[HasChildTab]
(
   @TabId   Int
) 
	RETURNS Bit
AS
BEGIN
    RETURN CASE WHEN EXISTS (SELECT 1 FROM dbo.Tabs WHERE ParentId = @TabId) THEN 1 ELSE 0 END
END
GO
/****** Object:  UserDefinedFunction [dbo].[Journal_Split]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Journal_Split](@text varchar(8000), @delimiter char(1))
RETURNS @words TABLE (objectid smallint primary key, id int)
AS
BEGIN
	DECLARE @pos smallint,
		@i smallint,
		@j smallint,
		@s varchar(255)

	SET @pos = 1

	WHILE @pos <= LEN(@text)
	BEGIN
		SET @i = CHARINDEX(' ', @text, @pos)
		SET @j = CHARINDEX(@delimiter, @text, @pos)

		IF @i > 0 OR @j > 0
		BEGIN
			IF @i = 0 OR (@j > 0 AND @j < @i)
				SET @i = @j

			IF @i > @pos
			BEGIN
				-- @i now holds the earliest delimiter in the string
				SET @s = SUBSTRING(@text, @pos, @i - @pos)
	
				INSERT INTO @words
				VALUES (@pos, @s)
			END

			SET @pos = @i + 1
			WHILE @pos < LEN(@text) AND SUBSTRING(@text, @pos, 1) IN (' ', ',')
				SET @pos = @pos + 1
		END
		ELSE
		BEGIN
			INSERT INTO @words
			VALUES (@pos, SUBSTRING(@text, @pos, LEN(@text) - @pos + 1))

			SET @pos = LEN(@text) + 1
		END
	END
	
	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[Journal_SplitText]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Journal_SplitText](@text varchar(8000), @delimiter char(1))
RETURNS @words TABLE (objectid smallint primary key, string varchar(1000), optionalid int)
AS
BEGIN
	DECLARE @pos smallint,
		@i smallint,
		@j smallint,
		@s varchar(255),
        @o int

	SET @pos = 1

	WHILE @pos <= LEN(@text)
	BEGIN
		SET @i = CHARINDEX(' ', @text, @pos)
		SET @j = CHARINDEX(@delimiter, @text, @pos)

		IF @i > 0 OR @j > 0
		BEGIN
			IF @i = 0 OR (@j > 0 AND @j < @i)
				SET @i = @j

			IF @i > @pos
			BEGIN
				-- @i now holds the earliest delimiter in the string
				SET @s = SUBSTRING(@text, @pos, @i - @pos)
				SET @o = 0
	            IF CHARINDEX('|',@s,0) > 0
					BEGIN
						SET @o = SUBSTRING(@s,0,CHARINDEX('|',@s,0))
						SET @s = SUBSTRING(@s,CHARINDEX('|',@s,0)+1,LEN(@s))

					END

				IF NOT EXISTS (SELECT 1 FROM @words WHERE [string]=@s)
				BEGIN
					INSERT INTO @words
					VALUES (@pos, @s, @o)
				END
			END

			SET @pos = @i + 1
			WHILE @pos < LEN(@text) AND SUBSTRING(@text, @pos, 1) IN (' ', ',')
				SET @pos = @pos + 1
		END
		ELSE
		BEGIN
			SET @s = SUBSTRING(@text, @pos, LEN(@text) - @pos + 1)
			IF CHARINDEX('|',@s,0) > 0
			BEGIN
				SET @o = SUBSTRING(@s,0,CHARINDEX('|',@s,0))
				SET @s = SUBSTRING(@s,CHARINDEX('|',@s,0)+1,LEN(@s))

			END

			IF NOT EXISTS (SELECT 1 FROM @words WHERE [string]=@s)
			BEGIN
				INSERT INTO @words
				VALUES (@pos, @s ,@o)
			END

			SET @pos = LEN(@text) + 1
		END
	END

	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[Journal_User_Permissions]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Journal_User_Permissions]
(
    @PortalId int,
    @UserId int,
    @RegisteredRoleId int
)
RETURNS 
@tmp TABLE (seckey nvarchar(200))

AS
BEGIN
IF @UserId > 0
        BEGIN
            IF @RegisteredRoleId = 1
                SELECT @RegisteredRoleId = RegisteredRoleId FROM dbo.[Portals] WHERE PortalID = @PortalId
            INSERT INTO @tmp (seckey) VALUES ('U' + Cast(@UserId as nvarchar(200)))
            INSERT INTO @tmp (seckey) VALUES ('P' + Cast(@UserId as nvarchar(200)))
            INSERT INTO @tmp (seckey) VALUES ('F' + Cast(@UserId as nvarchar(200)))
            IF EXISTS(SELECT RoleId FROM dbo.[UserRoles] WHERE UserID = @UserId AND RoleId = @RegisteredRoleId
                        AND    (EffectiveDate <= getdate() or EffectiveDate is null)
                        AND    (ExpiryDate >= getdate() or ExpiryDate is null))
                    INSERT INTO @tmp (seckey) VALUES ('C')
            
        END
        
    INSERT INTO @tmp (seckey) VALUES ('E')
    
    INSERT INTO @tmp (seckey)
    SELECT 'R' + CAST(ur.RoleId as nvarchar(200)) 
        FROM dbo.[UserRoles] as ur
            INNER JOIN dbo.[Users] as u on ur.UserId = u.UserId
            INNER JOIN dbo.[Roles] as r on ur.RoleId = r.RoleId
        WHERE  u.UserId = @UserId
            AND    r.PortalId = @PortalId
            AND    (EffectiveDate <= getdate() or EffectiveDate is null)
            AND    (ExpiryDate >= getdate() or ExpiryDate is null)
    INSERT INTO @tmp (seckey)
        SELECT (SELECT CASE WHEN @UserID = ur.UserId 
                        THEN 'F' + CAST(RelatedUserID as nvarchar(200))
                        ELSE 'F' + CAST(ur.UserId as nvarchar(200)) END) 
        FROM dbo.[UserRelationships] ur
        INNER JOIN dbo.[Relationships] r ON ur.RelationshipID = r.RelationshipID AND r.RelationshipTypeID = 1
        WHERE (ur.UserId = @UserId OR RelatedUserID = @UserId) AND Status = 2
    RETURN 
END
GO
/****** Object:  UserDefinedFunction [dbo].[MasterPortalId]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- new helper function
CREATE FUNCTION [dbo].[MasterPortalId]
(
    @PortalId Int  -- ID of the portal or Null for Host
) 
	RETURNS   Int
AS
	BEGIN
		DECLARE @MasterPortalId  Int = Null
		IF IsNull(@PortalId, -1) >= 0
			SELECT @MasterPortalId = MasterPortalId FROM dbo.[vw_MasterPortals] WHERE PortalId = @PortalId
		RETURN @MasterPortalId
	END
GO
/****** Object:  UserDefinedFunction [dbo].[PageLowerBound]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- new helperfunction for paging, replacing inefficient stored procedure
CREATE FUNCTION [dbo].[PageLowerBound]
(
    @PageIndex Int, -- Page number starting with 0 or Null for all
    @PageSize  Int  -- number of items per page or Null for all
) 
	RETURNS    Int
AS
BEGIN
    DECLARE @bound Int = 1
    IF IsNull(@PageSize, -1) > 0 AND IsNull(@PageIndex, -1) >= 0 AND IsNull(@PageIndex, 0) <= (Cast(0x7fffffff AS Int) / IsNull(@PageSize, 1) -1)
        SET @bound  = @PageSize * @PageIndex + 1
    RETURN @bound
END
GO
/****** Object:  UserDefinedFunction [dbo].[PageUpperBound]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- new helper function for paging, replacing inefficient stored procedure
CREATE FUNCTION [dbo].[PageUpperBound]
(
    @PageIndex Int, -- Page number starting with 0 or Null for all
    @PageSize  Int  -- number of items per page or Null for all
) 
	RETURNS    Int
AS
BEGIN
    DECLARE @bound Int = Cast(0x7fffffff AS Int)
    IF IsNull(@PageSize, -1) > 0 AND IsNull(@PageIndex, -1) >= 0 AND IsNull(@PageIndex, 0) <= (Cast(0x7fffffff AS Int) / IsNull(@PageSize, 1) -1)
        SET @Bound = @PageSize * (@PageIndex + 1)
    RETURN @Bound
END
GO
/****** Object:  UserDefinedFunction [dbo].[RemoveStringCharacters]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[RemoveStringCharacters]
(
		@string nvarchar(max), 
		@remove nvarchar(100)
)
RETURNS nvarchar(max)
AS
BEGIN
    WHILE @string LIKE '%[' + @remove + ']%'
    BEGIN
        SET @string = REPLACE(@string,SUBSTRING(@string,PATINDEX('%[' + @remove + ']%',@string),1),'')
    END

    RETURN @string
END
GO
/****** Object:  UserDefinedFunction [dbo].[SMS_RemoveAllSpaces]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SMS_RemoveAllSpaces]
(
	@product_name VARCHAR(8000)
)
RETURNS VARCHAR(8000)
BEGIN
	DECLARE @resultString VARCHAR(8000)
	SET @resultString = @product_name

	WHILE (CHARINDEX(' ', @resultString) > 0)
	BEGIN
		SET @resultString = REPLACE(@product_name, ' ', '')
	END

	RETURN @resultString
END
GO
/****** Object:  UserDefinedFunction [dbo].[SortFieldSQL]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- added, provides more flexibility, e.g. may be called again for multiple sort columns
CREATE FUNCTION [dbo].[SortFieldSQL]
(
    @SortBy        nVarChar(100), -- should be a field name
    @SortAscending Bit,			  -- ascending or descending?
    @Default       nVarChar(100)  -- name of field to be used if @sortby is empty
)
	RETURNS 	   nVarChar(110)
AS
	BEGIN
		DECLARE @sortSql nVarChar(110) =  ''
		IF IsNull(@SortBy, '') = ''
			SET @SortBy = IsNull(@Default, '')
		IF @SortBy <>  ''
			SET @sortSql = N'[' + @SortBy + CASE WHEN IsNull(@SortAscending, 1) = 0 THEN N'] DESC' ELSE N'] ASC' END
		RETURN @sortSql
	END
GO
/****** Object:  UserDefinedFunction [dbo].[SplitDelimitedIDs]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- new helper function to return a table with id's, passed as a single string with delimiter
CREATE FUNCTION [dbo].[SplitDelimitedIDs]
(
	@RecordIDList VarChar(2000),
	@Delimiter    VarChar(   2) = ','
)
RETURNS 
	@IntegerList Table (RecordID Int)
AS
	BEGIN
		DECLARE @RecordID VarChar(10)
		DECLARE @Start    Int        = 0
		DECLARE @Pos      Int        = 1

		SET @RecordIDList = @RecordIDList + @Delimiter
		SET @Pos = CHARINDEX(@Delimiter, @RecordIDList, 1)

		WHILE @Pos > 0 BEGIN
			SET @RecordID = LTRIM(RTRIM(SUBSTRING(@RecordIDList, @Start, @Pos - @Start)))
			IF @RecordID <> ''
				INSERT INTO @IntegerList (RecordID) VALUES (CAST(@RecordID AS Int)) -- use appropriate conversion
			SET @Start = @Pos + len(@Delimiter)
			SET @Pos = CHARINDEX(@Delimiter, @RecordIDList, @Start)
		END
		RETURN
	END
GO
/****** Object:  UserDefinedFunction [dbo].[SuperUserTabID]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SuperUserTabID]
() 
	RETURNS Int
AS
BEGIN
    DECLARE @HostTabId Int = Null
    SELECT  TOP (1) @HostTabId = TabID
		FROM  dbo.Tabs
		WHERE (PortalID IS NULL) AND (ParentId IS NULL)
		ORDER BY TabID
    RETURN @HostTabId
END
GO
/****** Object:  UserDefinedFunction [dbo].[TemplatedString]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- added for easier string handling
CREATE FUNCTION [dbo].[TemplatedString]
(
    @template nVarChar(3500), -- use tokens @1, @2, @3, @4, @5 to be replaced by param1 .. param5
    @param1   nVarChar( 100) = '', -- empty param values will just remove token!
	@param2	  nVarChar( 100) = '',
	@param3	  nVarChar( 100) = '',
	@param4	  nVarChar( 100) = '',
	@param5	  nVarChar( 100) = ''
)
	RETURNS   nVarChar(4000)
AS
BEGIN
    RETURN REPLACE(
			REPLACE(
			 REPLACE(
			  REPLACE(
			   REPLACE(IsNull(@template, ''), 
					   N'@1', IsNull(@param1,'')), 
					  N'@2', IsNull(@param2,'')), 
					 N'@3', IsNull(@param3,'')), 
					N'@4', IsNull(@param4,'')), 
				   N'@5', IsNull(@param5,''))
END
GO
/****** Object:  UserDefinedFunction [dbo].[UserDisplayName]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- new helper function, returning Displayname for a userid
CREATE FUNCTION [dbo].[UserDisplayName]
(
	@userId Int
)
RETURNS 
	nVarChar(255)
AS
	BEGIN
		DECLARE @DisplayName AS nVarChar(255)

		SELECT  @DisplayName = DisplayName FROM dbo.[Users] WHERE UserID = @UserId
		RETURN  @DisplayName
	END
GO
/****** Object:  UserDefinedFunction [dbo].[UserIsInRole]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- new helper function
CREATE FUNCTION [dbo].[UserIsInRole]
(
	@UserId Int,
	@RoleId Int
)
RETURNS 	Bit
AS
	BEGIN
		RETURN CASE WHEN EXISTS (SELECT * FROM dbo.[UserRoles] WHERE UserID = @UserId AND RoleID = @RoleId 
														   AND IsNull(EffectiveDate, GetDate()) >= GetDate() 
														   AND IsNull(ExpiryDate, GetDate())    <= GetDate()) THEN 1 ELSE 0 END
	END
GO
/****** Object:  Table [dbo].[Affiliates]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Affiliates](
	[AffiliateId] [int] IDENTITY(1,1) NOT NULL,
	[VendorId] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CPC] [float] NOT NULL,
	[Clicks] [int] NOT NULL,
	[CPA] [float] NOT NULL,
	[Acquisitions] [int] NOT NULL,
 CONSTRAINT [PK_Affiliates] PRIMARY KEY CLUSTERED 
(
	[AffiliateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AnonymousUsers]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AnonymousUsers](
	[UserID] [char](36) NOT NULL,
	[PortalID] [int] NOT NULL,
	[TabID] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[LastActiveDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AnonymousUsers] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[PortalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[aspnet_Applications]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Applications](
	[ApplicationName] [nvarchar](256) NOT NULL,
	[LoweredApplicationName] [nvarchar](256) NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](256) NULL,
PRIMARY KEY NONCLUSTERED 
(
	[ApplicationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[LoweredApplicationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ApplicationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[aspnet_Membership]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Membership](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[PasswordFormat] [int] NOT NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
	[MobilePIN] [nvarchar](16) NULL,
	[Email] [nvarchar](256) NULL,
	[LoweredEmail] [nvarchar](256) NULL,
	[PasswordQuestion] [nvarchar](256) NULL,
	[PasswordAnswer] [nvarchar](128) NULL,
	[IsApproved] [bit] NOT NULL,
	[IsLockedOut] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastLoginDate] [datetime] NOT NULL,
	[LastPasswordChangedDate] [datetime] NOT NULL,
	[LastLockoutDate] [datetime] NOT NULL,
	[FailedPasswordAttemptCount] [int] NOT NULL,
	[FailedPasswordAttemptWindowStart] [datetime] NOT NULL,
	[FailedPasswordAnswerAttemptCount] [int] NOT NULL,
	[FailedPasswordAnswerAttemptWindowStart] [datetime] NOT NULL,
	[Comment] [ntext] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[aspnet_SchemaVersions]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_SchemaVersions](
	[Feature] [nvarchar](128) NOT NULL,
	[CompatibleSchemaVersion] [nvarchar](128) NOT NULL,
	[IsCurrentVersion] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Feature] ASC,
	[CompatibleSchemaVersion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[aspnet_Users]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Users](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[LoweredUserName] [nvarchar](256) NOT NULL,
	[MobileAlias] [nvarchar](16) NULL,
	[IsAnonymous] [bit] NOT NULL,
	[LastActivityDate] [datetime] NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Assemblies]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Assemblies](
	[AssemblyID] [int] IDENTITY(1,1) NOT NULL,
	[PackageID] [int] NULL,
	[AssemblyName] [nvarchar](250) NOT NULL,
	[Version] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_PackageAssemblies] PRIMARY KEY CLUSTERED 
(
	[AssemblyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Authentication]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Authentication](
	[AuthenticationID] [int] IDENTITY(1,1) NOT NULL,
	[PackageID] [int] NOT NULL,
	[AuthenticationType] [nvarchar](100) NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[SettingsControlSrc] [nvarchar](250) NOT NULL,
	[LoginControlSrc] [nvarchar](250) NOT NULL,
	[LogoffControlSrc] [nvarchar](250) NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_Authentication] PRIMARY KEY CLUSTERED 
(
	[AuthenticationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Banners]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Banners](
	[BannerId] [int] IDENTITY(1,1) NOT NULL,
	[VendorId] [int] NOT NULL,
	[ImageFile] [nvarchar](100) NULL,
	[BannerName] [nvarchar](100) NOT NULL,
	[Impressions] [int] NOT NULL,
	[CPM] [float] NOT NULL,
	[Views] [int] NOT NULL,
	[ClickThroughs] [int] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreatedByUser] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[BannerTypeId] [int] NULL,
	[Description] [nvarchar](2000) NULL,
	[GroupName] [nvarchar](100) NULL,
	[Criteria] [bit] NOT NULL,
	[URL] [nvarchar](255) NULL,
	[Width] [int] NOT NULL,
	[Height] [int] NOT NULL,
 CONSTRAINT [PK_Banner] PRIMARY KEY CLUSTERED 
(
	[BannerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Classification]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Classification](
	[ClassificationId] [int] IDENTITY(1,1) NOT NULL,
	[ClassificationName] [nvarchar](200) NOT NULL,
	[ParentId] [int] NULL,
 CONSTRAINT [PK_VendorCategory] PRIMARY KEY CLUSTERED 
(
	[ClassificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContentItems]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContentItems](
	[ContentItemID] [int] IDENTITY(1,1) NOT NULL,
	[Content] [nvarchar](max) NULL,
	[ContentTypeID] [int] NOT NULL,
	[TabID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[ContentKey] [nvarchar](250) NULL,
	[Indexed] [bit] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[StateID] [int] NULL,
 CONSTRAINT [PK_ContentItems] PRIMARY KEY CLUSTERED 
(
	[ContentItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContentItems_MetaData]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContentItems_MetaData](
	[ContentItemMetaDataID] [int] IDENTITY(1,1) NOT NULL,
	[ContentItemID] [int] NOT NULL,
	[MetaDataID] [int] NOT NULL,
	[MetaDataValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_Content_MetaData] PRIMARY KEY CLUSTERED 
(
	[ContentItemMetaDataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContentItems_Tags]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContentItems_Tags](
	[ContentItemTagID] [int] IDENTITY(1,1) NOT NULL,
	[ContentItemID] [int] NOT NULL,
	[TermID] [int] NOT NULL,
 CONSTRAINT [PK_ContentItems_Tags] PRIMARY KEY CLUSTERED 
(
	[ContentItemTagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContentTypes]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContentTypes](
	[ContentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ContentType] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_ContentTypes] PRIMARY KEY CLUSTERED 
(
	[ContentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContentWorkflowActions]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContentWorkflowActions](
	[ActionId] [int] IDENTITY(1,1) NOT NULL,
	[ContentTypeId] [int] NOT NULL,
	[ActionType] [nvarchar](50) NOT NULL,
	[ActionSource] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_ContentWorkflowActions] PRIMARY KEY CLUSTERED 
(
	[ActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContentWorkflowLogs]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContentWorkflowLogs](
	[WorkflowLogID] [int] IDENTITY(1,1) NOT NULL,
	[Action] [nvarchar](40) NOT NULL,
	[Comment] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[User] [int] NOT NULL,
	[WorkflowID] [int] NOT NULL,
	[ContentItemID] [int] NOT NULL,
	[Type] [int] NOT NULL,
 CONSTRAINT [PK_ContentWorkflowLogs] PRIMARY KEY CLUSTERED 
(
	[WorkflowLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContentWorkflows]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContentWorkflows](
	[WorkflowID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[WorkflowName] [nvarchar](40) NOT NULL,
	[Description] [nvarchar](256) NULL,
	[IsDeleted] [bit] NOT NULL,
	[StartAfterCreating] [bit] NOT NULL,
	[StartAfterEditing] [bit] NOT NULL,
	[DispositionEnabled] [bit] NOT NULL,
	[IsSystem] [bit] NOT NULL,
	[WorkflowKey] [nvarchar](40) NOT NULL,
 CONSTRAINT [PK_ContentWorkflows] PRIMARY KEY CLUSTERED 
(
	[WorkflowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_ContentWorkflows] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[WorkflowName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContentWorkflowSources]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContentWorkflowSources](
	[SourceID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowID] [int] NOT NULL,
	[SourceName] [nvarchar](20) NOT NULL,
	[SourceType] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_ContentWorkflowSources] PRIMARY KEY CLUSTERED 
(
	[SourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_ContentWorkflowSources] UNIQUE NONCLUSTERED 
(
	[WorkflowID] ASC,
	[SourceName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContentWorkflowStatePermission]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContentWorkflowStatePermission](
	[WorkflowStatePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[StateID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
	[AllowAccess] [bit] NOT NULL,
	[RoleID] [int] NULL,
	[UserID] [int] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_ContentWorkflowStatePermission] PRIMARY KEY CLUSTERED 
(
	[WorkflowStatePermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_ContentWorkflowStatePermission] UNIQUE NONCLUSTERED 
(
	[StateID] ASC,
	[PermissionID] ASC,
	[RoleID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContentWorkflowStates]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContentWorkflowStates](
	[StateID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowID] [int] NOT NULL,
	[StateName] [nvarchar](40) NOT NULL,
	[Order] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[SendEmail] [bit] NOT NULL,
	[SendMessage] [bit] NOT NULL,
	[IsDisposalState] [bit] NOT NULL,
	[OnCompleteMessageSubject] [nvarchar](256) NOT NULL,
	[OnCompleteMessageBody] [nvarchar](1024) NOT NULL,
	[OnDiscardMessageSubject] [nvarchar](256) NOT NULL,
	[OnDiscardMessageBody] [nvarchar](1024) NOT NULL,
	[IsSystem] [bit] NOT NULL,
	[SendNotification] [bit] NOT NULL,
	[SendNotificationToAdministrators] [bit] NOT NULL,
 CONSTRAINT [PK_ContentWorkflowStates] PRIMARY KEY CLUSTERED 
(
	[StateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_ContentWorkflowStates] UNIQUE NONCLUSTERED 
(
	[WorkflowID] ASC,
	[StateName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CoreMessaging_MessageAttachments]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoreMessaging_MessageAttachments](
	[MessageAttachmentID] [int] IDENTITY(1,1) NOT NULL,
	[MessageID] [int] NOT NULL,
	[FileID] [int] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_CoreMessaging_MessageAttachments] PRIMARY KEY CLUSTERED 
(
	[MessageAttachmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CoreMessaging_MessageRecipients]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoreMessaging_MessageRecipients](
	[RecipientID] [int] IDENTITY(1,1) NOT NULL,
	[MessageID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Read] [bit] NOT NULL,
	[Archived] [bit] NOT NULL,
	[EmailSent] [bit] NOT NULL,
	[EmailSentDate] [datetime] NULL,
	[EmailSchedulerInstance] [uniqueidentifier] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[SendToast] [bit] NOT NULL,
 CONSTRAINT [PK_CoreMessaging_MessageRecipients] PRIMARY KEY CLUSTERED 
(
	[RecipientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CoreMessaging_Messages]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoreMessaging_Messages](
	[MessageID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[NotificationTypeID] [int] NULL,
	[To] [nvarchar](2000) NULL,
	[From] [nvarchar](200) NULL,
	[Subject] [nvarchar](400) NULL,
	[Body] [nvarchar](max) NULL,
	[ConversationID] [int] NULL,
	[ReplyAllAllowed] [bit] NULL,
	[SenderUserID] [int] NULL,
	[ExpirationDate] [datetime] NULL,
	[Context] [nvarchar](200) NULL,
	[IncludeDismissAction] [bit] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_CoreMessaging_Messages] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CoreMessaging_NotificationTypeActions]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoreMessaging_NotificationTypeActions](
	[NotificationTypeActionID] [int] IDENTITY(1,1) NOT NULL,
	[NotificationTypeID] [int] NOT NULL,
	[NameResourceKey] [nvarchar](100) NOT NULL,
	[DescriptionResourceKey] [nvarchar](100) NULL,
	[ConfirmResourceKey] [nvarchar](100) NULL,
	[Order] [int] NOT NULL,
	[APICall] [nvarchar](500) NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_CoreMessaging_NotificationTypeActions] PRIMARY KEY CLUSTERED 
(
	[NotificationTypeActionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CoreMessaging_NotificationTypes]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoreMessaging_NotificationTypes](
	[NotificationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](2000) NULL,
	[TTL] [int] NULL,
	[DesktopModuleID] [int] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[IsTask] [bit] NOT NULL,
 CONSTRAINT [PK_CoreMessaging_NotificationTypes] PRIMARY KEY CLUSTERED 
(
	[NotificationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CoreMessaging_Subscriptions]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoreMessaging_Subscriptions](
	[SubscriptionId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[PortalId] [int] NULL,
	[SubscriptionTypeId] [int] NOT NULL,
	[ObjectKey] [nvarchar](255) NULL,
	[ObjectData] [nvarchar](max) NULL,
	[Description] [nvarchar](255) NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
	[ModuleId] [int] NULL,
	[TabId] [int] NULL,
 CONSTRAINT [PK_CoreMessaging_Subscriptions] PRIMARY KEY CLUSTERED 
(
	[SubscriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CoreMessaging_SubscriptionTypes]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoreMessaging_SubscriptionTypes](
	[SubscriptionTypeId] [int] IDENTITY(1,1) NOT NULL,
	[SubscriptionName] [nvarchar](50) NOT NULL,
	[FriendlyName] [nvarchar](50) NOT NULL,
	[DesktopModuleId] [int] NULL,
 CONSTRAINT [PK_CoreMessaging_SubscriptionTypes] PRIMARY KEY CLUSTERED 
(
	[SubscriptionTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CoreMessaging_UserPreferences]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoreMessaging_UserPreferences](
	[UserPreferenceId] [int] IDENTITY(1,1) NOT NULL,
	[PortalId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[MessagesEmailFrequency] [int] NOT NULL,
	[NotificationsEmailFrequency] [int] NOT NULL,
 CONSTRAINT [PK_CoreMessaging_UserPreferences] PRIMARY KEY CLUSTERED 
(
	[UserPreferenceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Dashboard_Controls]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dashboard_Controls](
	[DashboardControlID] [int] IDENTITY(1,1) NOT NULL,
	[DashboardControlKey] [nvarchar](50) NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[DashboardControlSrc] [nvarchar](250) NOT NULL,
	[DashboardControlLocalResources] [nvarchar](250) NOT NULL,
	[ControllerClass] [nvarchar](250) NULL,
	[ViewOrder] [int] NOT NULL,
	[PackageID] [int] NOT NULL,
 CONSTRAINT [PK_Dashboard] PRIMARY KEY CLUSTERED 
(
	[DashboardControlID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DesktopModulePermission]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DesktopModulePermission](
	[DesktopModulePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[PortalDesktopModuleID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
	[AllowAccess] [bit] NOT NULL,
	[RoleID] [int] NULL,
	[UserID] [int] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_DesktopModulePermission] PRIMARY KEY CLUSTERED 
(
	[DesktopModulePermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DesktopModules]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DesktopModules](
	[DesktopModuleID] [int] IDENTITY(1,1) NOT NULL,
	[FriendlyName] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](2000) NULL,
	[Version] [nvarchar](8) NULL,
	[IsPremium] [bit] NOT NULL,
	[IsAdmin] [bit] NOT NULL,
	[BusinessControllerClass] [nvarchar](200) NULL,
	[FolderName] [nvarchar](128) NOT NULL,
	[ModuleName] [nvarchar](128) NOT NULL,
	[SupportedFeatures] [int] NOT NULL,
	[CompatibleVersions] [nvarchar](500) NULL,
	[Dependencies] [nvarchar](400) NULL,
	[Permissions] [nvarchar](400) NULL,
	[PackageID] [int] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[ContentItemId] [int] NOT NULL,
	[Shareable] [int] NOT NULL,
 CONSTRAINT [PK_DesktopModules] PRIMARY KEY CLUSTERED 
(
	[DesktopModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_DesktopModules_ModuleName] UNIQUE NONCLUSTERED 
(
	[ModuleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EventLog]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventLog](
	[LogGUID] [varchar](36) NOT NULL,
	[LogTypeKey] [nvarchar](35) NOT NULL,
	[LogConfigID] [int] NULL,
	[LogUserID] [int] NULL,
	[LogUserName] [nvarchar](50) NULL,
	[LogPortalID] [int] NULL,
	[LogPortalName] [nvarchar](100) NULL,
	[LogCreateDate] [datetime] NOT NULL,
	[LogServerName] [nvarchar](50) NOT NULL,
	[LogProperties] [xml] NULL,
	[LogNotificationPending] [bit] NULL,
	[LogEventID] [bigint] IDENTITY(1,1) NOT NULL,
	[ExceptionHash] [varchar](100) NULL,
 CONSTRAINT [PK_EventLogMaster] PRIMARY KEY CLUSTERED 
(
	[LogEventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EventLogConfig]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventLogConfig](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LogTypeKey] [nvarchar](35) NULL,
	[LogTypePortalID] [int] NULL,
	[LoggingIsActive] [bit] NOT NULL,
	[KeepMostRecent] [int] NOT NULL,
	[EmailNotificationIsActive] [bit] NOT NULL,
	[NotificationThreshold] [int] NULL,
	[NotificationThresholdTime] [int] NULL,
	[NotificationThresholdTimeType] [int] NULL,
	[MailFromAddress] [nvarchar](50) NOT NULL,
	[MailToAddress] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_EventLogConfig] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EventLogTypes]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventLogTypes](
	[LogTypeKey] [nvarchar](35) NOT NULL,
	[LogTypeFriendlyName] [nvarchar](50) NOT NULL,
	[LogTypeDescription] [nvarchar](128) NOT NULL,
	[LogTypeOwner] [nvarchar](100) NOT NULL,
	[LogTypeCSSClass] [nvarchar](40) NOT NULL,
 CONSTRAINT [PK_EventLogTypes] PRIMARY KEY CLUSTERED 
(
	[LogTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EventQueue]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventQueue](
	[EventMessageID] [int] IDENTITY(1,1) NOT NULL,
	[EventName] [nvarchar](100) NOT NULL,
	[Priority] [int] NOT NULL,
	[ProcessorType] [nvarchar](250) NOT NULL,
	[ProcessorCommand] [nvarchar](250) NOT NULL,
	[Body] [nvarchar](250) NOT NULL,
	[Sender] [nvarchar](250) NOT NULL,
	[Subscriber] [nvarchar](100) NOT NULL,
	[AuthorizedRoles] [nvarchar](250) NOT NULL,
	[ExceptionMessage] [nvarchar](250) NOT NULL,
	[SentDate] [datetime] NOT NULL,
	[ExpirationDate] [datetime] NOT NULL,
	[Attributes] [ntext] NOT NULL,
	[IsComplete] [bit] NOT NULL,
 CONSTRAINT [PK_EventQueue] PRIMARY KEY CLUSTERED 
(
	[EventMessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ExceptionEvents]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ExceptionEvents](
	[LogEventID] [bigint] NOT NULL,
	[AssemblyVersion] [varchar](20) NOT NULL,
	[PortalId] [int] NULL,
	[UserId] [int] NULL,
	[TabId] [int] NULL,
	[RawUrl] [nvarchar](260) NULL,
	[Referrer] [nvarchar](260) NULL,
	[UserAgent] [nvarchar](260) NULL,
 CONSTRAINT [PK_ExceptionEvents] PRIMARY KEY CLUSTERED 
(
	[LogEventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Exceptions]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Exceptions](
	[ExceptionHash] [varchar](100) NOT NULL,
	[Message] [nvarchar](500) NOT NULL,
	[StackTrace] [nvarchar](max) NULL,
	[InnerMessage] [nvarchar](500) NULL,
	[InnerStackTrace] [nvarchar](max) NULL,
	[Source] [nvarchar](500) NULL,
 CONSTRAINT [PK_Exceptions] PRIMARY KEY CLUSTERED 
(
	[ExceptionHash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ExtensionUrlProviderConfiguration]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExtensionUrlProviderConfiguration](
	[ExtensionUrlProviderID] [int] NOT NULL,
	[PortalID] [int] NOT NULL,
 CONSTRAINT [PK_ExtensionUrlProviderConfiguration] PRIMARY KEY CLUSTERED 
(
	[ExtensionUrlProviderID] ASC,
	[PortalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ExtensionUrlProviders]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExtensionUrlProviders](
	[ExtensionUrlProviderID] [int] IDENTITY(1,1) NOT NULL,
	[ProviderName] [nvarchar](150) NOT NULL,
	[ProviderType] [nvarchar](1000) NOT NULL,
	[SettingsControlSrc] [nvarchar](1000) NULL,
	[IsActive] [bit] NOT NULL,
	[RewriteAllUrls] [bit] NOT NULL,
	[RedirectAllUrls] [bit] NOT NULL,
	[ReplaceAllUrls] [bit] NOT NULL,
	[DesktopModuleId] [int] NULL,
 CONSTRAINT [PK_ExtensionUrlProviders] PRIMARY KEY CLUSTERED 
(
	[ExtensionUrlProviderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ExtensionUrlProviderSetting]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExtensionUrlProviderSetting](
	[ExtensionUrlProviderID] [int] NOT NULL,
	[PortalID] [int] NOT NULL,
	[SettingName] [nvarchar](100) NOT NULL,
	[SettingValue] [nvarchar](2000) NOT NULL,
 CONSTRAINT [PK_ExtensionUrlProviderSetting] PRIMARY KEY CLUSTERED 
(
	[ExtensionUrlProviderID] ASC,
	[PortalID] ASC,
	[SettingName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ExtensionUrlProviderTab]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExtensionUrlProviderTab](
	[ExtensionUrlProviderID] [int] NOT NULL,
	[PortalID] [int] NOT NULL,
	[TabID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_ExtensionUrlProviderTab] PRIMARY KEY CLUSTERED 
(
	[ExtensionUrlProviderID] ASC,
	[PortalID] ASC,
	[TabID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Files]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Files](
	[FileId] [int] IDENTITY(1,1) NOT NULL,
	[PortalId] [int] NULL,
	[FileName] [nvarchar](246) NOT NULL,
	[Extension] [nvarchar](100) NOT NULL,
	[Size] [int] NOT NULL,
	[Width] [int] NULL,
	[Height] [int] NULL,
	[ContentType] [nvarchar](200) NOT NULL,
	[FolderID] [int] NOT NULL,
	[Content] [image] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[UniqueId] [uniqueidentifier] NOT NULL,
	[VersionGuid] [uniqueidentifier] NOT NULL,
	[SHA1Hash] [varchar](40) NULL,
	[LastModificationTime] [datetime] NOT NULL,
	[Folder]  AS ([dbo].[GetFileFolderFunc]([FolderID])),
	[Title] [nvarchar](256) NULL,
	[StartDate] [date] NOT NULL,
	[EnablePublishPeriod] [bit] NOT NULL,
	[EndDate] [date] NULL,
	[PublishedVersion] [int] NOT NULL,
	[ContentItemID] [int] NULL,
 CONSTRAINT [PK_File] PRIMARY KEY CLUSTERED 
(
	[FileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Files_UniqueId] UNIQUE NONCLUSTERED 
(
	[UniqueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FileVersions]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FileVersions](
	[FileId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[FileName] [nvarchar](246) NOT NULL,
	[Extension] [nvarchar](100) NOT NULL,
	[Size] [int] NOT NULL,
	[Width] [int] NULL,
	[Height] [int] NULL,
	[ContentType] [nvarchar](200) NOT NULL,
	[Content] [image] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[SHA1Hash] [varchar](40) NULL,
 CONSTRAINT [PK_FileVersions] PRIMARY KEY CLUSTERED 
(
	[FileId] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FolderMappings]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FolderMappings](
	[FolderMappingID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[MappingName] [nvarchar](50) NOT NULL,
	[FolderProviderType] [nvarchar](50) NOT NULL,
	[Priority] [int] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_FolderMappings] PRIMARY KEY CLUSTERED 
(
	[FolderMappingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_FolderMappings] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[MappingName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FolderMappingsSettings]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FolderMappingsSettings](
	[FolderMappingID] [int] NOT NULL,
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](2000) NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_FolderMappingsSettings] PRIMARY KEY CLUSTERED 
(
	[FolderMappingID] ASC,
	[SettingName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FolderPermission]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FolderPermission](
	[FolderPermissionID] [int] IDENTITY(1,1) NOT NULL,
	[FolderID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
	[AllowAccess] [bit] NOT NULL,
	[RoleID] [int] NULL,
	[UserID] [int] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_FolderPermission] PRIMARY KEY CLUSTERED 
(
	[FolderPermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Folders]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Folders](
	[FolderID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[FolderPath] [nvarchar](300) NOT NULL,
	[StorageLocation] [int] NOT NULL,
	[IsProtected] [bit] NOT NULL,
	[IsCached] [bit] NOT NULL,
	[LastUpdated] [datetime] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[UniqueId] [uniqueidentifier] NOT NULL,
	[VersionGuid] [uniqueidentifier] NOT NULL,
	[FolderMappingID] [int] NOT NULL,
	[ParentID] [int] NULL,
	[IsVersioned] [bit] NOT NULL,
	[WorkflowID] [int] NULL,
	[MappedPath] [nvarchar](300) NULL,
 CONSTRAINT [PK_Folders] PRIMARY KEY CLUSTERED 
(
	[FolderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_FolderPath] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[FolderPath] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Folders_UniqueId] UNIQUE NONCLUSTERED 
(
	[UniqueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HostSettings]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HostSettings](
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](256) NOT NULL,
	[SettingIsSecure] [bit] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_HostSettings] PRIMARY KEY CLUSTERED 
(
	[SettingName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HtmlText]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HtmlText](
	[ModuleID] [int] NOT NULL,
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[Content] [ntext] NULL,
	[Version] [int] NULL,
	[StateID] [int] NULL,
	[IsPublished] [bit] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[Summary] [ntext] NULL,
 CONSTRAINT [PK_HtmlText] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HtmlTextLog]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HtmlTextLog](
	[HtmlTextLogID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[StateID] [int] NOT NULL,
	[Comment] [nvarchar](4000) NULL,
	[Approved] [bit] NOT NULL,
	[CreatedByUserID] [int] NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_HtmlTextLog] PRIMARY KEY CLUSTERED 
(
	[HtmlTextLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HtmlTextUsers]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HtmlTextUsers](
	[HtmlTextUserID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[StateID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[TabID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_HtmlTextUsers] PRIMARY KEY CLUSTERED 
(
	[HtmlTextUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[IPFilter]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IPFilter](
	[IPFilterID] [int] IDENTITY(1,1) NOT NULL,
	[IPAddress] [nvarchar](50) NULL,
	[SubnetMask] [nvarchar](50) NULL,
	[RuleType] [tinyint] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_IPFilter] PRIMARY KEY CLUSTERED 
(
	[IPFilterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JavaScriptLibraries]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JavaScriptLibraries](
	[JavaScriptLibraryID] [int] IDENTITY(1,1) NOT NULL,
	[PackageID] [int] NOT NULL,
	[LibraryName] [nvarchar](200) NOT NULL,
	[Version] [nvarchar](10) NOT NULL,
	[FileName] [nvarchar](100) NOT NULL,
	[ObjectName] [nvarchar](100) NOT NULL,
	[PreferredScriptLocation] [int] NOT NULL,
	[CDNPath] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_JavaScriptLIbraries] PRIMARY KEY CLUSTERED 
(
	[JavaScriptLibraryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Journal]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Journal](
	[JournalId] [int] IDENTITY(1,1) NOT NULL,
	[JournalTypeId] [int] NOT NULL,
	[UserId] [int] NULL,
	[DateCreated] [datetime] NULL,
	[DateUpdated] [datetime] NULL,
	[PortalId] [int] NULL,
	[ProfileId] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
	[Title] [nvarchar](255) NULL,
	[Summary] [nvarchar](2000) NULL,
	[ItemData] [nvarchar](2000) NULL,
	[ImageURL] [nvarchar](255) NULL,
	[ObjectKey] [nvarchar](255) NULL,
	[AccessKey] [uniqueidentifier] NULL,
	[ContentItemId] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[CommentsDisabled] [bit] NOT NULL,
	[CommentsHidden] [bit] NOT NULL,
 CONSTRAINT [PK_Journal] PRIMARY KEY CLUSTERED 
(
	[JournalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Journal_Access]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Journal_Access](
	[JournalAccessId] [int] IDENTITY(1,1) NOT NULL,
	[JournalTypeId] [int] NOT NULL,
	[PortalId] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[AccessKey] [uniqueidentifier] NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_Journal_Access] PRIMARY KEY CLUSTERED 
(
	[JournalAccessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Journal_Comments]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Journal_Comments](
	[CommentId] [int] IDENTITY(1,1) NOT NULL,
	[JournalId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[Comment] [nvarchar](2000) NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateUpdated] [datetime] NOT NULL,
	[CommentXML] [xml] NULL,
 CONSTRAINT [PK_Journal_Comments] PRIMARY KEY CLUSTERED 
(
	[CommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Journal_Data]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Journal_Data](
	[JournalDataId] [int] IDENTITY(1,1) NOT NULL,
	[JournalId] [int] NOT NULL,
	[JournalXML] [xml] NOT NULL,
 CONSTRAINT [PK_Journal_Data] PRIMARY KEY CLUSTERED 
(
	[JournalDataId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Journal_Security]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Journal_Security](
	[JournalSecurityId] [int] IDENTITY(1,1) NOT NULL,
	[JournalId] [int] NOT NULL,
	[SecurityKey] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Journal_Security] PRIMARY KEY CLUSTERED 
(
	[JournalSecurityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Journal_Security] UNIQUE NONCLUSTERED 
(
	[JournalId] DESC,
	[SecurityKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Journal_TypeFilters]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Journal_TypeFilters](
	[JournalTypeFilterId] [int] IDENTITY(1,1) NOT NULL,
	[PortalId] [int] NOT NULL,
	[ModuleId] [int] NOT NULL,
	[JournalTypeId] [int] NOT NULL,
 CONSTRAINT [PK_Journal_TypeFilters] PRIMARY KEY CLUSTERED 
(
	[JournalTypeFilterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Journal_Types]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Journal_Types](
	[JournalTypeId] [int] NOT NULL,
	[JournalType] [nvarchar](25) NULL,
	[icon] [nvarchar](25) NULL,
	[PortalId] [int] NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[AppliesToProfile] [bit] NOT NULL,
	[AppliesToGroup] [bit] NOT NULL,
	[AppliesToStream] [bit] NOT NULL,
	[Options] [nvarchar](max) NULL,
	[SupportsNotify] [bit] NOT NULL,
	[EnableComments] [bit] NOT NULL,
 CONSTRAINT [PK_JournalTypes] PRIMARY KEY CLUSTERED 
(
	[JournalTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LanguagePacks]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LanguagePacks](
	[LanguagePackID] [int] IDENTITY(1,1) NOT NULL,
	[PackageID] [int] NOT NULL,
	[DependentPackageID] [int] NOT NULL,
	[LanguageID] [int] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_LanguagePacks] PRIMARY KEY CLUSTERED 
(
	[LanguagePackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Languages]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Languages](
	[LanguageID] [int] IDENTITY(1,1) NOT NULL,
	[CultureCode] [nvarchar](50) NOT NULL,
	[CultureName] [nvarchar](200) NOT NULL,
	[FallbackCulture] [nvarchar](50) NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_Languages] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Lists]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lists](
	[EntryID] [int] IDENTITY(1,1) NOT NULL,
	[ListName] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](100) NOT NULL,
	[Text] [nvarchar](150) NOT NULL,
	[ParentID] [int] NOT NULL,
	[Level] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[DefinitionID] [int] NOT NULL,
	[Description] [nvarchar](500) NULL,
	[PortalID] [int] NOT NULL,
	[SystemList] [bit] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_Lists] PRIMARY KEY CLUSTERED 
(
	[EntryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Lists_ListName_Value_Text_ParentID] UNIQUE NONCLUSTERED 
(
	[ListName] ASC,
	[Value] ASC,
	[Text] ASC,
	[ParentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Messaging_Messages]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Messaging_Messages](
	[MessageID] [bigint] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[FromUserID] [int] NOT NULL,
	[ToUserName] [nvarchar](50) NULL,
	[FromUserName] [nvarchar](50) NULL,
	[ToUserID] [int] NULL,
	[ToRoleID] [int] NULL,
	[Status] [tinyint] NOT NULL,
	[Subject] [nvarchar](max) NULL,
	[Body] [nvarchar](max) NULL,
	[Date] [datetime] NOT NULL,
	[Conversation] [uniqueidentifier] NOT NULL,
	[ReplyTo] [bigint] NULL,
	[AllowReply] [bit] NOT NULL,
	[SkipPortal] [bit] NOT NULL,
	[EmailSent] [bit] NOT NULL,
	[EmailSentDate] [datetime] NULL,
	[EmailSchedulerInstance] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Messaging_Messages] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MetaData]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MetaData](
	[MetaDataID] [int] IDENTITY(1,1) NOT NULL,
	[MetaDataName] [nvarchar](100) NOT NULL,
	[MetaDataDescription] [nvarchar](2500) NULL,
 CONSTRAINT [PK_MetaData] PRIMARY KEY CLUSTERED 
(
	[MetaDataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Mobile_PreviewProfiles]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Mobile_PreviewProfiles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PortalId] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Width] [int] NOT NULL,
	[Height] [int] NOT NULL,
	[UserAgent] [nvarchar](260) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[CreatedByUserID] [int] NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
	[LastModifiedByUserID] [int] NOT NULL,
	[LastModifiedOnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Mobile_PreviewProfiles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Mobile_RedirectionRules]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Mobile_RedirectionRules](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RedirectionId] [int] NOT NULL,
	[Capability] [nvarchar](50) NOT NULL,
	[Expression] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Mobile_RedirectionRules] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Mobile_Redirections]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Mobile_Redirections](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PortalId] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Type] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[SourceTabId] [int] NOT NULL,
	[IncludeChildTabs] [bit] NOT NULL,
	[TargetType] [int] NOT NULL,
	[TargetValue] [nvarchar](260) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[CreatedByUserID] [int] NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
	[LastModifiedByUserID] [int] NOT NULL,
	[LastModifiedOnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Mobile_Redirections] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ModuleControls]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModuleControls](
	[ModuleControlID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleDefID] [int] NULL,
	[ControlKey] [nvarchar](50) NULL,
	[ControlTitle] [nvarchar](50) NULL,
	[ControlSrc] [nvarchar](256) NULL,
	[IconFile] [nvarchar](100) NULL,
	[ControlType] [int] NOT NULL,
	[ViewOrder] [int] NULL,
	[HelpUrl] [nvarchar](200) NULL,
	[SupportsPartialRendering] [bit] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[SupportsPopUps] [bit] NOT NULL,
 CONSTRAINT [PK_ModuleControls] PRIMARY KEY CLUSTERED 
(
	[ModuleControlID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_ModuleControls] UNIQUE NONCLUSTERED 
(
	[ModuleDefID] ASC,
	[ControlKey] ASC,
	[ControlSrc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ModuleDefinitions]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModuleDefinitions](
	[ModuleDefID] [int] IDENTITY(1,1) NOT NULL,
	[FriendlyName] [nvarchar](128) NOT NULL,
	[DesktopModuleID] [int] NOT NULL,
	[DefaultCacheTime] [int] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[DefinitionName] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ModuleDefinitions] PRIMARY KEY CLUSTERED 
(
	[ModuleDefID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ModulePermission]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModulePermission](
	[ModulePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
	[AllowAccess] [bit] NOT NULL,
	[RoleID] [int] NULL,
	[UserID] [int] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[PortalID] [int] NOT NULL,
 CONSTRAINT [PK_ModulePermission] PRIMARY KEY CLUSTERED 
(
	[ModulePermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Modules]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Modules](
	[ModuleID] [int] IDENTITY(0,1) NOT NULL,
	[ModuleDefID] [int] NOT NULL,
	[AllTabs] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InheritViewPermissions] [bit] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[PortalID] [int] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[LastContentModifiedOnDate] [datetime] NULL,
	[ContentItemID] [int] NULL,
	[IsShareable] [bit] NOT NULL,
	[IsShareableViewOnly] [bit] NOT NULL,
 CONSTRAINT [PK_Modules] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ModuleSettings]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModuleSettings](
	[ModuleID] [int] NOT NULL,
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](max) NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_ModuleSettings] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC,
	[SettingName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PackageDependencies]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackageDependencies](
	[PackageDependencyID] [int] IDENTITY(1,1) NOT NULL,
	[PackageID] [int] NOT NULL,
	[PackageName] [nvarchar](128) NOT NULL,
	[Version] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PackageDependencies] PRIMARY KEY CLUSTERED 
(
	[PackageDependencyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Packages]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Packages](
	[PackageID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[Name] [nvarchar](128) NOT NULL,
	[FriendlyName] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](2000) NULL,
	[PackageType] [nvarchar](100) NOT NULL,
	[Version] [nvarchar](50) NOT NULL,
	[License] [ntext] NULL,
	[Manifest] [ntext] NULL,
	[Owner] [nvarchar](100) NULL,
	[Organization] [nvarchar](100) NULL,
	[Url] [nvarchar](250) NULL,
	[Email] [nvarchar](100) NULL,
	[ReleaseNotes] [ntext] NULL,
	[IsSystemPackage] [bit] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[FolderName] [nvarchar](128) NULL,
	[IconFile] [nvarchar](100) NULL,
 CONSTRAINT [PK_Packages] PRIMARY KEY CLUSTERED 
(
	[PackageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PackageTypes]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackageTypes](
	[PackageType] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[SecurityAccessLevel] [int] NOT NULL,
	[EditorControlSrc] [nvarchar](250) NULL,
	[SupportsSideBySideInstallation] [bit] NOT NULL,
 CONSTRAINT [PK_PackageTypes_1] PRIMARY KEY CLUSTERED 
(
	[PackageType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PasswordHistory]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PasswordHistory](
	[PasswordHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_PasswordHistory] PRIMARY KEY CLUSTERED 
(
	[PasswordHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Permission]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Permission](
	[PermissionID] [int] IDENTITY(1,1) NOT NULL,
	[PermissionCode] [varchar](50) NOT NULL,
	[ModuleDefID] [int] NOT NULL,
	[PermissionKey] [varchar](50) NOT NULL,
	[PermissionName] [varchar](50) NOT NULL,
	[ViewOrder] [int] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_Permission] PRIMARY KEY CLUSTERED 
(
	[PermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Permission] UNIQUE NONCLUSTERED 
(
	[PermissionCode] ASC,
	[ModuleDefID] ASC,
	[PermissionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PortalAlias]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalAlias](
	[PortalAliasID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[HTTPAlias] [nvarchar](200) NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[BrowserType] [nvarchar](10) NULL,
	[Skin] [nvarchar](100) NULL,
	[CultureCode] [nvarchar](10) NULL,
	[IsPrimary] [bit] NOT NULL,
 CONSTRAINT [PK_PortalAlias] PRIMARY KEY CLUSTERED 
(
	[PortalAliasID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_PortalAlias] UNIQUE NONCLUSTERED 
(
	[HTTPAlias] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PortalDesktopModules]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalDesktopModules](
	[PortalDesktopModuleID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[DesktopModuleID] [int] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_PortalDesktopModules] PRIMARY KEY CLUSTERED 
(
	[PortalDesktopModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_PortalDesktopModules] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[DesktopModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PortalGroups]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalGroups](
	[PortalGroupID] [int] IDENTITY(1,1) NOT NULL,
	[MasterPortalID] [int] NULL,
	[PortalGroupName] [nvarchar](100) NULL,
	[PortalGroupDescription] [nvarchar](2000) NULL,
	[AuthenticationDomain] [nvarchar](200) NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_PortalGroup] PRIMARY KEY CLUSTERED 
(
	[PortalGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PortalLanguages]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalLanguages](
	[PortalLanguageID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[LanguageID] [int] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[IsPublished] [bit] NOT NULL,
 CONSTRAINT [PK_PortalLanguages] PRIMARY KEY CLUSTERED 
(
	[PortalLanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PortalLocalization]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalLocalization](
	[PortalID] [int] NOT NULL,
	[CultureCode] [nvarchar](10) NOT NULL,
	[PortalName] [nvarchar](128) NOT NULL,
	[LogoFile] [nvarchar](50) NULL,
	[FooterText] [nvarchar](100) NULL,
	[Description] [nvarchar](500) NULL,
	[KeyWords] [nvarchar](500) NULL,
	[BackgroundFile] [nvarchar](50) NULL,
	[HomeTabId] [int] NULL,
	[LoginTabId] [int] NULL,
	[UserTabId] [int] NULL,
	[AdminTabId] [int] NULL,
	[SplashTabId] [int] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[RegisterTabId] [int] NULL,
	[SearchTabId] [int] NULL,
	[Custom404TabId] [int] NULL,
	[Custom500TabId] [int] NULL,
 CONSTRAINT [PK_PortalLocalization] PRIMARY KEY CLUSTERED 
(
	[PortalID] ASC,
	[CultureCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Portals]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Portals](
	[PortalID] [int] IDENTITY(0,1) NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[UserRegistration] [int] NOT NULL,
	[BannerAdvertising] [int] NOT NULL,
	[AdministratorId] [int] NULL,
	[Currency] [char](3) NULL,
	[HostFee] [money] NOT NULL,
	[HostSpace] [int] NOT NULL,
	[AdministratorRoleId] [int] NULL,
	[RegisteredRoleId] [int] NULL,
	[GUID] [uniqueidentifier] NOT NULL,
	[PaymentProcessor] [nvarchar](50) NULL,
	[ProcessorUserId] [nvarchar](50) NULL,
	[ProcessorPassword] [nvarchar](50) NULL,
	[SiteLogHistory] [int] NULL,
	[DefaultLanguage] [nvarchar](10) NOT NULL,
	[TimezoneOffset] [int] NOT NULL,
	[HomeDirectory] [varchar](100) NOT NULL,
	[PageQuota] [int] NOT NULL,
	[UserQuota] [int] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[PortalGroupID] [int] NULL,
 CONSTRAINT [PK_Portals] PRIMARY KEY CLUSTERED 
(
	[PortalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PortalSettings]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalSettings](
	[PortalSettingID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](2000) NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[CultureCode] [nvarchar](10) NULL,
 CONSTRAINT [PK_PortalSettings] PRIMARY KEY NONCLUSTERED 
(
	[PortalSettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Profile]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Profile](
	[ProfileId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[PortalId] [int] NOT NULL,
	[ProfileData] [ntext] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Profile] PRIMARY KEY CLUSTERED 
(
	[ProfileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProfilePropertyDefinition]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProfilePropertyDefinition](
	[PropertyDefinitionID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[ModuleDefID] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[DataType] [int] NOT NULL,
	[DefaultValue] [ntext] NULL,
	[PropertyCategory] [nvarchar](50) NOT NULL,
	[PropertyName] [nvarchar](50) NOT NULL,
	[Length] [int] NOT NULL,
	[Required] [bit] NOT NULL,
	[ValidationExpression] [nvarchar](2000) NULL,
	[ViewOrder] [int] NOT NULL,
	[Visible] [bit] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[DefaultVisibility] [int] NULL,
	[ReadOnly] [bit] NOT NULL,
 CONSTRAINT [PK_ProfilePropertyDefinition] PRIMARY KEY CLUSTERED 
(
	[PropertyDefinitionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Relationships]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Relationships](
	[RelationshipID] [int] IDENTITY(1,1) NOT NULL,
	[RelationshipTypeID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[PortalID] [int] NULL,
	[UserID] [int] NULL,
	[DefaultResponse] [int] NOT NULL,
	[CreatedByUserID] [int] NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
	[LastModifiedByUserID] [int] NOT NULL,
	[LastModifiedOnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Relationships] PRIMARY KEY CLUSTERED 
(
	[RelationshipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RelationshipTypes]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RelationshipTypes](
	[RelationshipTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Direction] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[CreatedByUserID] [int] NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
	[LastModifiedByUserID] [int] NOT NULL,
	[LastModifiedOnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RelationshipTypes] PRIMARY KEY CLUSTERED 
(
	[RelationshipTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RoleGroups]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleGroups](
	[RoleGroupID] [int] IDENTITY(0,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[RoleGroupName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_RoleGroups] PRIMARY KEY CLUSTERED 
(
	[RoleGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_RoleGroupName] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[RoleGroupName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Roles]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Roles](
	[RoleID] [int] IDENTITY(0,1) NOT NULL,
	[PortalID] [int] NULL,
	[RoleName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[ServiceFee] [money] NULL,
	[BillingFrequency] [char](1) NULL,
	[TrialPeriod] [int] NULL,
	[TrialFrequency] [char](1) NULL,
	[BillingPeriod] [int] NULL,
	[TrialFee] [money] NULL,
	[IsPublic] [bit] NOT NULL,
	[AutoAssignment] [bit] NOT NULL,
	[RoleGroupID] [int] NULL,
	[RSVPCode] [nvarchar](50) NULL,
	[IconFile] [nvarchar](100) NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[Status] [int] NOT NULL,
	[SecurityMode] [int] NOT NULL,
	[IsSystemRole] [bit] NOT NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_RoleName] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[RoleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RoleSettings]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleSettings](
	[RoleSettingID] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [int] NOT NULL,
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](2000) NOT NULL,
	[CreatedByUserID] [int] NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
	[LastModifiedByUserID] [int] NOT NULL,
	[LastModifiedOnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RoleSettings] PRIMARY KEY CLUSTERED 
(
	[RoleSettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Schedule]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Schedule](
	[ScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[TypeFullName] [varchar](200) NOT NULL,
	[TimeLapse] [int] NOT NULL,
	[TimeLapseMeasurement] [varchar](2) NOT NULL,
	[RetryTimeLapse] [int] NOT NULL,
	[RetryTimeLapseMeasurement] [varchar](2) NOT NULL,
	[RetainHistoryNum] [int] NOT NULL,
	[AttachToEvent] [varchar](50) NOT NULL,
	[CatchUpEnabled] [bit] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[ObjectDependencies] [varchar](300) NOT NULL,
	[Servers] [nvarchar](2000) NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[FriendlyName] [nvarchar](200) NULL,
	[ScheduleStartDate] [datetime] NULL,
 CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ScheduleHistory]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduleHistory](
	[ScheduleHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleID] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[Succeeded] [bit] NULL,
	[LogNotes] [ntext] NULL,
	[NextStart] [datetime] NULL,
	[Server] [nvarchar](150) NULL,
 CONSTRAINT [PK_ScheduleHistory] PRIMARY KEY CLUSTERED 
(
	[ScheduleHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ScheduleItemSettings]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduleItemSettings](
	[ScheduleID] [int] NOT NULL,
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ScheduleItemSettings] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC,
	[SettingName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SearchCommonWords]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SearchCommonWords](
	[CommonWordID] [int] IDENTITY(1,1) NOT NULL,
	[CommonWord] [nvarchar](255) NOT NULL,
	[Locale] [nvarchar](10) NULL,
 CONSTRAINT [PK_SearchCommonWords] PRIMARY KEY CLUSTERED 
(
	[CommonWordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SearchDeletedItems]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SearchDeletedItems](
	[SearchDeletedItemsID] [int] IDENTITY(1,1) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[Document] [nvarchar](max) NULL,
 CONSTRAINT [PK_SearchDeletedItems] PRIMARY KEY CLUSTERED 
(
	[SearchDeletedItemsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SearchIndexer]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SearchIndexer](
	[SearchIndexerID] [int] IDENTITY(1,1) NOT NULL,
	[SearchIndexerAssemblyQualifiedName] [char](200) NOT NULL,
 CONSTRAINT [PK_SearchIndexer] PRIMARY KEY CLUSTERED 
(
	[SearchIndexerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SearchStopWords]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SearchStopWords](
	[StopWordsID] [int] IDENTITY(1,1) NOT NULL,
	[StopWords] [nvarchar](max) NOT NULL,
	[CreatedByUserID] [int] NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
	[LastModifiedByUserID] [int] NOT NULL,
	[LastModifiedOnDate] [datetime] NOT NULL,
	[PortalID] [int] NOT NULL,
	[CultureCode] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_SearchStopWords] PRIMARY KEY CLUSTERED 
(
	[StopWordsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SearchTypes]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SearchTypes](
	[SearchTypeId] [int] IDENTITY(1,1) NOT NULL,
	[SearchTypeName] [nvarchar](100) NOT NULL,
	[SearchResultClass] [nvarchar](256) NOT NULL,
	[IsPrivate] [bit] NULL,
 CONSTRAINT [PK_SearchTypes] PRIMARY KEY CLUSTERED 
(
	[SearchTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SiteLog]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SiteLog](
	[SiteLogId] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [smalldatetime] NOT NULL,
	[PortalId] [int] NOT NULL,
	[UserId] [int] NULL,
	[Referrer] [nvarchar](255) NULL,
	[Url] [nvarchar](255) NULL,
	[UserAgent] [nvarchar](255) NULL,
	[UserHostAddress] [nvarchar](255) NULL,
	[UserHostName] [nvarchar](255) NULL,
	[TabId] [int] NULL,
	[AffiliateId] [int] NULL,
 CONSTRAINT [PK_SiteLog] PRIMARY KEY CLUSTERED 
(
	[SiteLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SkinControls]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SkinControls](
	[SkinControlID] [int] IDENTITY(1,1) NOT NULL,
	[PackageID] [int] NOT NULL,
	[ControlKey] [nvarchar](50) NULL,
	[ControlSrc] [nvarchar](256) NULL,
	[IconFile] [nvarchar](100) NULL,
	[HelpUrl] [nvarchar](200) NULL,
	[SupportsPartialRendering] [bit] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_SkinControls] PRIMARY KEY CLUSTERED 
(
	[SkinControlID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SkinPackages]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SkinPackages](
	[SkinPackageID] [int] IDENTITY(1,1) NOT NULL,
	[PackageID] [int] NOT NULL,
	[PortalID] [int] NULL,
	[SkinName] [nvarchar](50) NOT NULL,
	[SkinType] [nvarchar](20) NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_SkinPackages] PRIMARY KEY CLUSTERED 
(
	[SkinPackageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Skins]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Skins](
	[SkinID] [int] IDENTITY(1,1) NOT NULL,
	[SkinPackageID] [int] NOT NULL,
	[SkinSrc] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_Skins] PRIMARY KEY CLUSTERED 
(
	[SkinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SMS_CATEGORIES]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_CATEGORIES](
	[category_id] [int] IDENTITY(200,1) NOT NULL,
	[category_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SMS_CATEGORIES] PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_INVENTORY_NOTIFICATION]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMS_INVENTORY_NOTIFICATION](
	[notification_id] [int] IDENTITY(700,1) NOT NULL,
	[warehouse_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[category_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[supplier_id] [int] NOT NULL,
 CONSTRAINT [PK_SMS_INVENTORY_NOTIFICATION] PRIMARY KEY CLUSTERED 
(
	[notification_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SMS_ITEMS_BARCODE_DATA]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_ITEMS_BARCODE_DATA](
	[item_id] [int] NOT NULL,
	[barcode_data] [varchar](14) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_PRODUCT_TRANSACTION]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMS_PRODUCT_TRANSACTION](
	[transaction_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[unit_price] [decimal](19, 2) NOT NULL,
	[quantity] [int] NOT NULL,
	[sub_total] [decimal](19, 2) NOT NULL,
 CONSTRAINT [PK_SMS_PRODUCT_TRANSACTION] PRIMARY KEY CLUSTERED 
(
	[transaction_id] ASC,
	[item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SMS_PRODUCTS]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_PRODUCTS](
	[product_id] [int] IDENTITY(100,1) NOT NULL,
	[product_name] [varchar](50) NOT NULL,
	[category_id] [int] NOT NULL,
	[product_thumbnail] [varchar](max) NOT NULL,
	[supplier_id] [int] NOT NULL,
	[barcode] [varchar](max) NOT NULL,
	[barcode_data] [varchar](14) NOT NULL,
 CONSTRAINT [PK_SMS_PRODUCTS] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_REGISTERED_BOXES]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_REGISTERED_BOXES](
	[reg_id] [int] IDENTITY(600,1) NOT NULL,
	[reg_code] [nvarchar](8) NOT NULL,
	[reg_product_name] [varchar](50) NOT NULL,
	[reg_category] [varchar](50) NOT NULL,
	[items_per_box] [int] NOT NULL,
	[dor] [varchar](12) NOT NULL,
	[tor] [varchar](12) NOT NULL,
	[warehouse_id] [int] NOT NULL,
 CONSTRAINT [PK_SMS_REGISTERED_BOXES] PRIMARY KEY CLUSTERED 
(
	[reg_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_REGISTERED_ITEMS]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_REGISTERED_ITEMS](
	[item_id] [int] IDENTITY(500,1) NOT NULL,
	[reg_code] [nvarchar](8) NOT NULL,
	[item_name] [varchar](50) NOT NULL,
	[item_price] [decimal](19, 2) NOT NULL,
 CONSTRAINT [PK_SMS_REGISTERED_ITEMS] PRIMARY KEY CLUSTERED 
(
	[item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_RESTOCKED_PRODUCTS]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_RESTOCKED_PRODUCTS](
	[restock_id] [int] IDENTITY(800,1) NOT NULL,
	[product_id] [int] NOT NULL,
	[restock_quantity] [int] NOT NULL,
	[dor] [varchar](12) NOT NULL,
	[tor] [varchar](12) NOT NULL,
	[warehouse_id] [int] NOT NULL,
 CONSTRAINT [PK_SMS_RESTOCKED_PRODUCTS] PRIMARY KEY CLUSTERED 
(
	[restock_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_RETURNED_ITEMS]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_RETURNED_ITEMS](
	[item_id] [int] NOT NULL,
	[barcode_data] [varchar](14) NOT NULL,
	[date_returned] [varchar](12) NOT NULL,
	[time_returned] [varchar](12) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[warehouse_id] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_SALES_BOXES]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_SALES_BOXES](
	[reg_code] [nvarchar](8) NOT NULL,
	[reg_product_name] [varchar](50) NOT NULL,
	[reg_category] [varchar](50) NOT NULL,
	[items_per_box] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_STAFF]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_STAFF](
	[staff_id] [varchar](8) NOT NULL,
	[first_name] [varchar](50) NOT NULL,
	[middle_name] [varchar](50) NOT NULL,
	[last_name] [varchar](50) NOT NULL,
	[dob] [date] NOT NULL,
	[home_address] [varchar](60) NOT NULL,
	[telephone_number] [varchar](40) NOT NULL,
	[email] [varchar](80) NOT NULL,
	[department_id] [int] NOT NULL,
	[role] [varchar](30) NOT NULL,
	[username] [varchar](7) NOT NULL,
	[password] [varchar](50) NOT NULL,
	[warehouse_id] [int] NOT NULL,
 CONSTRAINT [PK_SMS_STAFF] PRIMARY KEY CLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_SUPPLIED_PRODUCTS]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_SUPPLIED_PRODUCTS](
	[product_id] [int] NOT NULL,
	[supplier_id] [int] NOT NULL,
	[warehouse_id] [int] NOT NULL,
	[dos] [varchar](12) NOT NULL,
	[tod] [varchar](12) NOT NULL,
	[quantity_supplied] [int] NOT NULL,
	[box_price] [decimal](19, 2) NOT NULL,
	[unit_price] [decimal](19, 2) NULL,
	[item_per_box] [int] NULL,
 CONSTRAINT [PK_SMS_SUPPLIERS_PRODUCTS] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC,
	[supplier_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_SUPPLIER_PRODUCTS]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_SUPPLIER_PRODUCTS](
	[supplier_id] [int] NOT NULL,
	[sp_id] [int] IDENTITY(700,1) NOT NULL,
	[s_product_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SMS_SUPPLIER_PRODUCTS] PRIMARY KEY CLUSTERED 
(
	[supplier_id] ASC,
	[sp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_SUPPLIERS]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_SUPPLIERS](
	[supplier_id] [int] IDENTITY(300,1) NOT NULL,
	[supplier_name] [varchar](50) NOT NULL,
	[supplier_email] [varchar](80) NOT NULL,
	[supplier_phonenumber] [varchar](20) NOT NULL,
	[address] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SMS_SUPPLIERS] PRIMARY KEY CLUSTERED 
(
	[supplier_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_TRANSACTION]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_TRANSACTION](
	[transaction_id] [int] IDENTITY(1000,1) NOT NULL,
	[transaction_date] [varchar](12) NOT NULL,
	[transaction_time] [varchar](12) NOT NULL,
	[staff_username] [varchar](7) NOT NULL,
	[warehouse_id] [int] NOT NULL,
 CONSTRAINT [PK_SMS_TRANSACTION] PRIMARY KEY CLUSTERED 
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_TRANSACTION_BARCODE_DATA]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_TRANSACTION_BARCODE_DATA](
	[transaction_id] [int] NOT NULL,
	[barcode_data] [varchar](14) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_WAREHOUSE]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMS_WAREHOUSE](
	[warehouse_id] [int] IDENTITY(400,1) NOT NULL,
	[warehouse_location] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SMS_WAREHOUSE] PRIMARY KEY CLUSTERED 
(
	[warehouse_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SMS_WAREHOUSE_PRODUCTS]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMS_WAREHOUSE_PRODUCTS](
	[product_id] [int] NOT NULL,
	[warehouse_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[notified] [int] NOT NULL,
 CONSTRAINT [PK_SMS_WAREHOUSE_PRODUCTS] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC,
	[warehouse_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SQLQueries]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLQueries](
	[QueryId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Query] [nvarchar](max) NOT NULL,
	[ConnectionStringName] [nvarchar](50) NOT NULL,
	[CreatedByUserId] [int] NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
	[LastModifiedByUserId] [int] NOT NULL,
	[LastModifiedOnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SavedQueries] PRIMARY KEY CLUSTERED 
(
	[QueryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SynonymsGroups]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SynonymsGroups](
	[SynonymsGroupID] [int] IDENTITY(1,1) NOT NULL,
	[SynonymsTags] [nvarchar](max) NOT NULL,
	[PortalID] [int] NOT NULL,
	[CultureCode] [nvarchar](50) NOT NULL,
	[CreatedByUserID] [int] NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
	[LastModifiedByUserID] [int] NOT NULL,
	[LastModifiedOnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SynonymsGroups] PRIMARY KEY CLUSTERED 
(
	[SynonymsGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SystemMessages]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemMessages](
	[MessageID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[MessageName] [nvarchar](50) NOT NULL,
	[MessageValue] [ntext] NOT NULL,
 CONSTRAINT [PK_SystemMessages] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_SystemMessages] UNIQUE NONCLUSTERED 
(
	[MessageName] ASC,
	[PortalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TabAliasSkins]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabAliasSkins](
	[TabAliasSkinId] [int] IDENTITY(1,1) NOT NULL,
	[TabId] [int] NOT NULL,
	[PortalAliasId] [int] NOT NULL,
	[SkinSrc] [nvarchar](200) NOT NULL,
	[CreatedByUserId] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserId] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_TabAliasSkin] PRIMARY KEY CLUSTERED 
(
	[TabAliasSkinId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TabModules]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TabModules](
	[TabModuleID] [int] IDENTITY(1,1) NOT NULL,
	[TabID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[PaneName] [nvarchar](50) NOT NULL,
	[ModuleOrder] [int] NOT NULL,
	[CacheTime] [int] NOT NULL,
	[Alignment] [nvarchar](10) NULL,
	[Color] [nvarchar](20) NULL,
	[Border] [nvarchar](1) NULL,
	[IconFile] [nvarchar](100) NULL,
	[Visibility] [int] NOT NULL,
	[ContainerSrc] [nvarchar](200) NULL,
	[DisplayTitle] [bit] NOT NULL,
	[DisplayPrint] [bit] NOT NULL,
	[DisplaySyndicate] [bit] NOT NULL,
	[IsWebSlice] [bit] NOT NULL,
	[WebSliceTitle] [nvarchar](256) NULL,
	[WebSliceExpiryDate] [datetime] NULL,
	[WebSliceTTL] [int] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[CacheMethod] [varchar](50) NULL,
	[ModuleTitle] [nvarchar](256) NULL,
	[Header] [nvarchar](max) NULL,
	[Footer] [nvarchar](max) NULL,
	[CultureCode] [nvarchar](10) NULL,
	[UniqueId] [uniqueidentifier] NOT NULL,
	[VersionGuid] [uniqueidentifier] NOT NULL,
	[DefaultLanguageGuid] [uniqueidentifier] NULL,
	[LocalizedVersionGuid] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_TabModules] PRIMARY KEY CLUSTERED 
(
	[TabModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_TabModules_UniqueId] UNIQUE NONCLUSTERED 
(
	[UniqueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TabModuleSettings]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabModuleSettings](
	[TabModuleID] [int] NOT NULL,
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](max) NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_TabModuleSettings] PRIMARY KEY CLUSTERED 
(
	[TabModuleID] ASC,
	[SettingName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TabPermission]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabPermission](
	[TabPermissionID] [int] IDENTITY(1,1) NOT NULL,
	[TabID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
	[AllowAccess] [bit] NOT NULL,
	[RoleID] [int] NULL,
	[UserID] [int] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_TabPermission] PRIMARY KEY CLUSTERED 
(
	[TabPermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tabs]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tabs](
	[TabID] [int] IDENTITY(0,1) NOT NULL,
	[TabOrder] [int] NOT NULL,
	[PortalID] [int] NULL,
	[TabName] [nvarchar](200) NOT NULL,
	[IsVisible] [bit] NOT NULL,
	[ParentId] [int] NULL,
	[IconFile] [nvarchar](100) NULL,
	[DisableLink] [bit] NOT NULL,
	[Title] [nvarchar](200) NULL,
	[Description] [nvarchar](500) NULL,
	[KeyWords] [nvarchar](500) NULL,
	[IsDeleted] [bit] NOT NULL,
	[Url] [nvarchar](255) NULL,
	[SkinSrc] [nvarchar](200) NULL,
	[ContainerSrc] [nvarchar](200) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[RefreshInterval] [int] NULL,
	[PageHeadText] [nvarchar](max) NULL,
	[IsSecure] [bit] NOT NULL,
	[PermanentRedirect] [bit] NOT NULL,
	[SiteMapPriority] [float] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[IconFileLarge] [nvarchar](100) NULL,
	[CultureCode] [nvarchar](10) NULL,
	[ContentItemID] [int] NULL,
	[UniqueId] [uniqueidentifier] NOT NULL,
	[VersionGuid] [uniqueidentifier] NOT NULL,
	[DefaultLanguageGuid] [uniqueidentifier] NULL,
	[LocalizedVersionGuid] [uniqueidentifier] NOT NULL,
	[Level] [int] NOT NULL,
	[TabPath] [nvarchar](255) NOT NULL,
	[HasBeenPublished] [bit] NOT NULL,
	[IsSystem] [bit] NOT NULL,
 CONSTRAINT [PK_Tabs] PRIMARY KEY CLUSTERED 
(
	[TabID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Tabs_UniqueId] UNIQUE NONCLUSTERED 
(
	[UniqueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TabSettings]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabSettings](
	[TabID] [int] NOT NULL,
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](2000) NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_TabSettings] PRIMARY KEY NONCLUSTERED 
(
	[TabID] ASC,
	[SettingName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TabUrls]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabUrls](
	[TabId] [int] NOT NULL,
	[SeqNum] [int] NOT NULL,
	[Url] [nvarchar](200) NOT NULL,
	[QueryString] [nvarchar](200) NULL,
	[HttpStatus] [nvarchar](50) NOT NULL,
	[CultureCode] [nvarchar](50) NULL,
	[IsSystem] [bit] NOT NULL,
	[PortalAliasId] [int] NULL,
	[PortalAliasUsage] [int] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_TabRedirect] PRIMARY KEY CLUSTERED 
(
	[TabId] ASC,
	[SeqNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TabVersionDetails]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabVersionDetails](
	[TabVersionDetailId] [int] IDENTITY(1,1) NOT NULL,
	[TabVersionId] [int] NOT NULL,
	[ModuleId] [int] NOT NULL,
	[ModuleVersion] [int] NOT NULL,
	[PaneName] [nvarchar](50) NOT NULL,
	[ModuleOrder] [int] NOT NULL,
	[Action] [int] NOT NULL,
	[CreatedByUserID] [int] NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
	[LastModifiedByUserID] [int] NOT NULL,
	[LastModifiedOnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TabVersionDetails] PRIMARY KEY CLUSTERED 
(
	[TabVersionDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_TabVersionDetails_Unique(TabVersionId_ModuleId)] UNIQUE NONCLUSTERED 
(
	[TabVersionId] ASC,
	[ModuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TabVersions]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabVersions](
	[TabVersionId] [int] IDENTITY(1,1) NOT NULL,
	[TabId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[TimeStamp] [datetime] NOT NULL,
	[IsPublished] [bit] NOT NULL,
	[CreatedByUserID] [int] NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
	[LastModifiedByUserID] [int] NOT NULL,
	[LastModifiedOnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TabVersions] PRIMARY KEY CLUSTERED 
(
	[TabVersionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_TabVersions] UNIQUE NONCLUSTERED 
(
	[TabId] ASC,
	[Version] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Taxonomy_ScopeTypes]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Taxonomy_ScopeTypes](
	[ScopeTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ScopeType] [nvarchar](250) NULL,
 CONSTRAINT [PK_ScopeTypes] PRIMARY KEY CLUSTERED 
(
	[ScopeTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Taxonomy_Terms]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Taxonomy_Terms](
	[TermID] [int] IDENTITY(1,1) NOT NULL,
	[VocabularyID] [int] NOT NULL,
	[ParentTermID] [int] NULL,
	[Name] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](2500) NULL,
	[Weight] [int] NOT NULL,
	[TermLeft] [int] NOT NULL,
	[TermRight] [int] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_Taxonomy_Terms] PRIMARY KEY CLUSTERED 
(
	[TermID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Taxonomy_Vocabularies]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Taxonomy_Vocabularies](
	[VocabularyID] [int] IDENTITY(1,1) NOT NULL,
	[VocabularyTypeID] [int] NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](2500) NULL,
	[Weight] [int] NOT NULL,
	[ScopeID] [int] NULL,
	[ScopeTypeID] [int] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[IsSystem] [bit] NOT NULL,
 CONSTRAINT [PK_Taxonomy_Vocabulary] PRIMARY KEY CLUSTERED 
(
	[VocabularyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Taxonomy_VocabularyTypes]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Taxonomy_VocabularyTypes](
	[VocabularyTypeID] [int] IDENTITY(1,1) NOT NULL,
	[VocabularyType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Taxonomy_VocabularyType] PRIMARY KEY CLUSTERED 
(
	[VocabularyTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UrlLog]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UrlLog](
	[UrlLogID] [int] IDENTITY(1,1) NOT NULL,
	[UrlTrackingID] [int] NOT NULL,
	[ClickDate] [datetime] NOT NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_UrlLog] PRIMARY KEY CLUSTERED 
(
	[UrlLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Urls]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Urls](
	[UrlID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[Url] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Urls] PRIMARY KEY CLUSTERED 
(
	[UrlID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Urls] UNIQUE NONCLUSTERED 
(
	[Url] ASC,
	[PortalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UrlTracking]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UrlTracking](
	[UrlTrackingID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[Url] [nvarchar](255) NOT NULL,
	[UrlType] [char](1) NOT NULL,
	[Clicks] [int] NOT NULL,
	[LastClick] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LogActivity] [bit] NOT NULL,
	[TrackClicks] [bit] NOT NULL,
	[ModuleId] [int] NULL,
	[NewWindow] [bit] NOT NULL,
 CONSTRAINT [PK_UrlTracking] PRIMARY KEY CLUSTERED 
(
	[UrlTrackingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_UrlTracking] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[Url] ASC,
	[ModuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserAuthentication]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAuthentication](
	[UserAuthenticationID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[AuthenticationType] [nvarchar](100) NOT NULL,
	[AuthenticationToken] [nvarchar](1000) NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
 CONSTRAINT [PK_UserAuthentication] PRIMARY KEY CLUSTERED 
(
	[UserAuthenticationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserPortals]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPortals](
	[UserId] [int] NOT NULL,
	[PortalId] [int] NOT NULL,
	[UserPortalId] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Authorised] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[RefreshRoles] [bit] NOT NULL,
	[VanityUrl] [nvarchar](100) NULL,
 CONSTRAINT [PK_UserPortals] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[PortalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserProfile]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserProfile](
	[ProfileID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[PropertyDefinitionID] [int] NOT NULL,
	[PropertyValue] [nvarchar](3750) NULL,
	[PropertyText] [nvarchar](max) NULL,
	[Visibility] [int] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[ExtendedVisibility] [varchar](400) NULL,
 CONSTRAINT [PK_UserProfile] PRIMARY KEY CLUSTERED 
(
	[ProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserRelationshipPreferences]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRelationshipPreferences](
	[PreferenceID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[RelationshipID] [int] NOT NULL,
	[DefaultResponse] [int] NOT NULL,
	[CreatedByUserID] [int] NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
	[LastModifiedByUserID] [int] NOT NULL,
	[LastModifiedOnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_UserRelationshipPreferences] PRIMARY KEY CLUSTERED 
(
	[PreferenceID] ASC,
	[RelationshipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserRelationships]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRelationships](
	[UserRelationshipID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[RelatedUserID] [int] NOT NULL,
	[RelationshipID] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[CreatedByUserID] [int] NOT NULL,
	[CreatedOnDate] [datetime] NOT NULL,
	[LastModifiedByUserID] [int] NOT NULL,
	[LastModifiedOnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_UserRelationships] PRIMARY KEY CLUSTERED 
(
	[UserRelationshipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserRoles]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoles](
	[UserRoleID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[IsTrialUsed] [bit] NULL,
	[EffectiveDate] [datetime] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[Status] [int] NOT NULL,
	[IsOwner] [bit] NOT NULL,
 CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED 
(
	[UserRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](100) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[IsSuperUser] [bit] NOT NULL,
	[AffiliateId] [int] NULL,
	[Email] [nvarchar](256) NULL,
	[DisplayName] [nvarchar](128) NOT NULL,
	[UpdatePassword] [bit] NOT NULL,
	[LastIPAddress] [nvarchar](50) NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedByUserID] [int] NULL,
	[LastModifiedOnDate] [datetime] NULL,
	[PasswordResetToken] [uniqueidentifier] NULL,
	[PasswordResetExpiration] [datetime] NULL,
	[LowerEmail]  AS (lower([Email])) PERSISTED,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Users] UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UsersOnline]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersOnline](
	[UserID] [int] NOT NULL,
	[PortalID] [int] NOT NULL,
	[TabID] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[LastActiveDate] [datetime] NOT NULL,
 CONSTRAINT [PK_UsersOnline] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[PortalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[VendorClassification]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendorClassification](
	[VendorClassificationId] [int] IDENTITY(1,1) NOT NULL,
	[VendorId] [int] NOT NULL,
	[ClassificationId] [int] NOT NULL,
 CONSTRAINT [PK_VendorClassification] PRIMARY KEY CLUSTERED 
(
	[VendorClassificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_VendorClassification] UNIQUE NONCLUSTERED 
(
	[VendorId] ASC,
	[ClassificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Vendors]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Vendors](
	[VendorId] [int] IDENTITY(1,1) NOT NULL,
	[VendorName] [nvarchar](50) NOT NULL,
	[Street] [nvarchar](50) NULL,
	[City] [nvarchar](50) NULL,
	[Region] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](50) NULL,
	[Telephone] [nvarchar](50) NULL,
	[PortalId] [int] NULL,
	[Fax] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[Website] [nvarchar](100) NULL,
	[ClickThroughs] [int] NOT NULL,
	[Views] [int] NOT NULL,
	[CreatedByUser] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[LogoFile] [nvarchar](100) NULL,
	[KeyWords] [ntext] NULL,
	[Unit] [nvarchar](50) NULL,
	[Authorized] [bit] NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Cell] [varchar](50) NULL,
 CONSTRAINT [PK_Vendor] PRIMARY KEY CLUSTERED 
(
	[VendorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Vendors] UNIQUE NONCLUSTERED 
(
	[PortalId] ASC,
	[VendorName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Version]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Version](
	[VersionId] [int] IDENTITY(1,1) NOT NULL,
	[Major] [int] NOT NULL,
	[Minor] [int] NOT NULL,
	[Build] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Version] PRIMARY KEY CLUSTERED 
(
	[VersionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Version] UNIQUE NONCLUSTERED 
(
	[Major] ASC,
	[Minor] ASC,
	[Build] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WebServers]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebServers](
	[ServerID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastActivityDate] [datetime] NOT NULL,
	[URL] [nvarchar](255) NULL,
	[IISAppName] [nvarchar](200) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[ServerGroup] [nvarchar](200) NULL,
	[UniqueId] [nvarchar](200) NULL,
	[PingFailureCount] [int] NOT NULL,
 CONSTRAINT [PK_WebServers] PRIMARY KEY CLUSTERED 
(
	[ServerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Workflow]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Workflow](
	[WorkflowID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[WorkflowName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](2000) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Workflow] PRIMARY KEY CLUSTERED 
(
	[WorkflowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowStates]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowStates](
	[StateID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowID] [int] NOT NULL,
	[StateName] [nvarchar](50) NOT NULL,
	[Order] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Notify] [bit] NOT NULL,
 CONSTRAINT [PK_WorkflowStates] PRIMARY KEY CLUSTERED 
(
	[StateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[vw_Portals]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Portals]
AS
    SELECT
        P.PortalID,
        P.PortalGroupID,
        PL.PortalName,
        dbo.FilePath(PL.LogoFile) AS LogoFile,
        PL.FooterText,
        P.ExpiryDate,
        P.UserRegistration,
        P.BannerAdvertising,
        P.AdministratorId,
        P.Currency,
        P.HostFee,
        P.HostSpace,
        P.PageQuota,
        P.UserQuota,
        P.AdministratorRoleId,
        P.RegisteredRoleId,
        PL.Description,
        PL.KeyWords,
        dbo.FilePath(PL.BackgroundFile) AS BackgroundFile,
        P.GUID,
        P.PaymentProcessor,
        P.ProcessorUserId,
        P.ProcessorPassword,
        P.SiteLogHistory,
        U.Email,
        P.DefaultLanguage,
        P.TimezoneOffset,
        PL.AdminTabId,
        P.HomeDirectory,
        PL.SplashTabId,
        PL.HomeTabId,
        PL.LoginTabId,
        PL.RegisterTabId,
        PL.UserTabId,
        PL.SearchTabId,
        PL.Custom404TabId,
        PL.Custom500TabId,
        dbo.SuperUserTabID() AS SuperTabId,
        P.CreatedByUserID,
        P.CreatedOnDate,
        P.LastModifiedByUserID,
        P.LastModifiedOnDate,
        PL.CultureCode
    FROM       dbo.Portals            AS P
    INNER JOIN dbo.PortalLocalization AS PL ON P.PortalID = PL.PortalID
    LEFT  JOIN dbo.Users              AS U  ON P.AdministratorId = U.UserID
GO
/****** Object:  View [dbo].[vw_PortalsDefaultLanguage]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_PortalsDefaultLanguage]
AS
    SELECT * FROM dbo.[vw_Portals] WHERE CultureCode = DefaultLanguage
GO
/****** Object:  View [dbo].[vw_Files]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Files]
AS
	SELECT	fi.FileId, 
			fi.PortalId, 
			fi.FileName, 
			fi.Extension, 
			fi.Size, 
			fi.Width, 
			fi.Height, 
			fi.ContentType, 
			fi.FolderID, 
			fi.[Content], 
			fi.CreatedByUserID, 
			fi.CreatedOnDate, 
			fi.LastModifiedByUserID, 
			fi.LastModifiedOnDate, 
			fi.UniqueId, 
			fi.VersionGuid, 
			fi.SHA1Hash, 
			fi.LastModificationTime, 
			fi.Title, 
			fi.StartDate, 
			fi.EnablePublishPeriod, 
			fi.EndDate, 
			fi.ContentItemID, 
			fi.PublishedVersion, 
			fo.FolderPath AS Folder,
			fo.IsCached,
			fo.FolderMappingID,
			fo.StorageLocation
	FROM         dbo.[Files] AS fi 
	INNER JOIN dbo.[Folders] AS fo 
		ON fi.FolderID = fo.FolderID
GO
/****** Object:  View [dbo].[vw_PublishedFiles]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_PublishedFiles]
AS
	SELECT     
	   fi.[FileId]
      ,fi.[PortalId]
      ,fi.[FileName]
      ,fi.[Extension]
      ,fi.[Size]
      ,fi.[Width]
      ,fi.[Height]
      ,fi.[ContentType]
      ,fi.[FolderID]
      ,fi.[Content]
      ,fi.[CreatedByUserID]
      ,fi.[CreatedOnDate]
      ,fi.[LastModifiedByUserID]
      ,fi.[LastModifiedOnDate]
      ,fi.[UniqueId]
      ,fi.[VersionGuid]
      ,fi.[SHA1Hash]
      ,fi.[LastModificationTime]
      ,fi.[Title]
      ,fi.[StartDate]
      ,fi.[EnablePublishPeriod]
      ,fi.[EndDate]
      ,fi.[ContentItemID]
      ,fi.[PublishedVersion]
	  ,fi.[Folder]
	  ,fi.[IsCached]
	  ,fi.[StorageLocation]
	  ,fi.[FolderMappingID]
	FROM       dbo.[vw_Files] fi
	  WHERE [EnablePublishPeriod] = 0 
		 OR ([StartDate] <= GETDATE()
			AND ([EndDate] IS NULL OR GETDATE() <= [EndDate]))
GO
/****** Object:  View [dbo].[vw_Profile]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Profile]
AS
	SELECT     
		UP.UserID, 
		PD.PortalID, 
		PD.PropertyName, 
		CASE WHEN PropertyText IS NULL THEN PropertyValue ELSE PropertyText END AS PropertyValue, 
		UP.Visibility,
		UP.ExtendedVisibility,
		UP.LastUpdatedDate,
		PD.PropertyDefinitionID
	FROM dbo.[UserProfile] AS UP 
		INNER JOIN dbo.[ProfilePropertyDefinition] AS PD ON PD.PropertyDefinitionID = UP.PropertyDefinitionID
GO
/****** Object:  UserDefinedFunction [dbo].[GetUsersByPropertyName]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetUsersByPropertyName]
(
	@PropertyName nvarchar(100),
	@PropertyValue nvarchar(max),
	@PortalID int
)
RETURNS TABLE
AS
	RETURN
		SELECT *
			FROM dbo.[vw_Profile]
			WHERE PropertyName = @PropertyName 
				AND PropertyValue LIKE @PropertyValue
				AND PortalID = @PortalID
GO
/****** Object:  View [dbo].[vw_aspnet_Applications]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  CREATE VIEW [dbo].[vw_aspnet_Applications]
  AS SELECT [ApplicationName], [LoweredApplicationName], [ApplicationId], [Description]
  FROM [dbo].[aspnet_Applications]
  
GO
/****** Object:  View [dbo].[vw_aspnet_MembershipUsers]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  CREATE VIEW [dbo].[vw_aspnet_MembershipUsers]
  AS SELECT members.[UserId],
            members.[PasswordFormat],
            members.[MobilePIN],
            members.[Email],
            members.[LoweredEmail],
            members.[PasswordQuestion],
            members.[PasswordAnswer],
            members.[IsApproved],
            members.[IsLockedOut],
            members.[CreateDate],
            members.[LastLoginDate],
            members.[LastPasswordChangedDate],
            members.[LastLockoutDate],
            members.[FailedPasswordAttemptCount],
            members.[FailedPasswordAttemptWindowStart],
            members.[FailedPasswordAnswerAttemptCount],
            members.[FailedPasswordAnswerAttemptWindowStart],
            members.[Comment],
            users.[ApplicationId],
            users.[UserName],
            users.[MobileAlias],
            users.[IsAnonymous],
            users.[LastActivityDate]
  FROM [dbo].[aspnet_Membership] members INNER JOIN [dbo].[aspnet_Users] users
      ON members.[UserId] = users.[UserId]
  
GO
/****** Object:  View [dbo].[vw_aspnet_Users]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  CREATE VIEW [dbo].[vw_aspnet_Users]
  AS SELECT [ApplicationId], [UserId], [UserName], [LoweredUserName], [MobileAlias], [IsAnonymous], [LastActivityDate]
  FROM [dbo].[aspnet_Users]
  
GO
/****** Object:  View [dbo].[vw_ContentWorkflowStatePermissions]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ContentWorkflowStatePermissions]
AS
    SELECT     
	    WSP.WorkflowStatePermissionID, 
	    WSP.StateID, 
	    P.PermissionID, 
	    WSP.RoleID,
	    CASE WSP.RoleID
		    when -1 then 'All Users'
		    when -2 then 'Superuser'
		    when -3 then 'Unauthenticated Users'
		    else 	R.RoleName
	    END AS 'RoleName',
	    WSP.AllowAccess, 
	    WSP.UserID,
	    U.Username,
	    U.DisplayName, 
	    P.PermissionCode, 
	    P.ModuleDefID, 
	    P.PermissionKey, 
	    P.PermissionName, 
        WSP.CreatedByUserID, 
        WSP.CreatedOnDate, 
        WSP.LastModifiedByUserID, 
        WSP.LastModifiedOnDate    
    FROM dbo.ContentWorkflowStatePermission AS WSP 
	    LEFT OUTER JOIN dbo.Permission AS P ON WSP.PermissionID = P.PermissionID 
	    LEFT OUTER JOIN dbo.Roles AS R ON WSP.RoleID = R.RoleID
	    LEFT OUTER JOIN dbo.Users AS U ON WSP.UserID = U.UserID
GO
/****** Object:  View [dbo].[vw_ContentWorkflowUsage]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ContentWorkflowUsage]
AS
    SELECT ci.Content as 'ContentName', ct.ContentType, ws.WorkflowID 
	FROM dbo.[ContentItems] ci
		INNER JOIN dbo.[ContentTypes] ct
			ON ci.ContentTypeID = ct.ContentTypeID
		INNER JOIN dbo.[ContentWorkflowStates] ws 
			ON ci.StateID = ws.StateID
	WHERE ct.ContentType != 'Tab' -- Tabs will be managed specifically
		AND ct.ContentType != 'File' -- Exclude Files
	UNION ALL
	SELECT t.TabPath, ct.ContentType, ws.WorkflowID 
	FROM dbo.[ContentItems] ci
		INNER JOIN dbo.[ContentTypes] ct
			ON ci.ContentTypeID = ct.ContentTypeID
		INNER JOIN dbo.[Tabs] t
			ON ci.TabID = t.TabID
		INNER JOIN dbo.[ContentWorkflowStates] ws 
			ON ci.StateID = ws.StateID
	WHERE ct.ContentType = 'Tab'
		AND LOWER(t.TabPath) not like '//admin/%'
		AND LOWER(t.TabPath) != '//admin'
		AND t.IsSystem = 0
		AND LOWER(t.TabPath) not like '//host/%'
		AND LOWER(t.TabPath) != '//host'
		AND ci.StateID IS NOT NULL
	UNION ALL
	SELECT t.TabPath, ct.ContentType, 
		(SELECT CAST(ps.SettingValue AS INT) value 
			FROM dbo.[PortalSettings] ps
			WHERE ps.SettingName = 'DefaultTabWorkflowKey' 
			AND ps.PortalID = t.PortalID) as WorkflowID 
	FROM dbo.[ContentItems] ci
		INNER JOIN dbo.[ContentTypes] ct
			ON ci.ContentTypeID = ct.ContentTypeID
		INNER JOIN dbo.[Tabs] t
			ON ci.TabID = t.TabID
	WHERE ct.ContentType = 'Tab'
		AND LOWER(t.TabPath) NOT LIKE '//admin/%'
		AND LOWER(t.TabPath) != '//admin'
		AND t.IsSystem = 0
		AND LOWER(t.TabPath) NOT LIKE '//host/%'
		AND LOWER(t.TabPath) != '//host'
		AND ci.StateID IS NULL
	UNION ALL
	SELECT '/' + f.FolderPath, 'Folder', f.WorkflowID 
	FROM dbo.[Folders] f
	WHERE f.WorkflowID IS NOT NULL
	UNION ALL
	SELECT '/' + f.FolderPath, 'Folder', 
		(SELECT wf.WorkflowID 
			FROM dbo.[ContentWorkflows] wf
			WHERE wf.WorkflowKey = 'DirectPublish' 
			AND wf.PortalID = f.PortalID) AS WorkflowID 
	FROM dbo.[Folders] f
	WHERE f.WorkflowID IS NULL
GO
/****** Object:  View [dbo].[vw_CoreMessaging_Messages]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_CoreMessaging_Messages]
AS
	SELECT
		M.MessageID, 
		M.PortalID, 
		M.NotificationTypeID, 
		M.[To], 
		M.[From],
		M.Subject,
		M.Body,
		M.ConversationID, 
		M.ReplyAllAllowed, 
		M.SenderUserID,
		M.ExpirationDate, 
        M.Context, 
		M.IncludeDismissAction,
		M.CreatedByUserID, 
		M.CreatedOnDate, 
		M.LastModifiedByUserID, 
		M.LastModifiedOnDate, 
		MR.RecipientID,
		MR.UserID, 
        MR.[Read], 
		MR.Archived, 
		MR.EmailSent, 
		MR.EmailSentDate, 
		MR.EmailSchedulerInstance
	FROM       dbo.[CoreMessaging_MessageRecipients] MR
	INNER JOIN dbo.[CoreMessaging_Messages]          M ON mr.MessageID = m.MessageID
GO
/****** Object:  View [dbo].[vw_DesktopModulePermissions]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- use new FK
CREATE VIEW [dbo].[vw_DesktopModulePermissions]
AS
SELECT  PP.DesktopModulePermissionID,
        PP.PortalDesktopModuleID,
        P.PermissionID,
        PP.RoleID,
        R.RoleName,
        PP.AllowAccess,
        PP.UserID,
        U.Username,
        U.DisplayName,
        P.PermissionCode,
        P.ModuleDefID,
        P.PermissionKey,
        P.PermissionName,
        PP.CreatedByUserID,
        PP.CreatedOnDate,
        PP.LastModifiedByUserID,
        PP.LastModifiedOnDate
FROM        dbo.[DesktopModulePermission] AS PP
 INNER JOIN dbo.[Permission]              AS P  ON PP.PermissionID = P.PermissionID
 LEFT  JOIN dbo.[Roles]                   AS R  ON PP.RoleID = R.RoleID
 LEFT  JOIN dbo.[Users]                   AS U  ON PP.UserID = U.UserID
GO
/****** Object:  View [dbo].[vw_DesktopModules]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_DesktopModules]
AS
	SELECT
		DM.DesktopModuleID,
		DM.FriendlyName,
		DM.Description,
		DM.Version,
		DM.IsPremium,
		DM.IsAdmin,
		DM.BusinessControllerClass,
		DM.FolderName,
		DM.ModuleName,
		DM.SupportedFeatures,
		DM.CompatibleVersions,
		DM.Dependencies,
		DM.Permissions,
		DM.PackageID,
		DM.CreatedByUserID,
		DM.CreatedOnDate,
		DM.LastModifiedByUserID,
		DM.LastModifiedOnDate,
		CI.ContentItemID,
		CI.[Content],
		CI.ContentTypeID,
		CI.TabID,
		CI.ModuleID,
		CI.ContentKey,
		CI.Indexed,
		CI.StateID,
		DM.Shareable
	FROM dbo.[DesktopModules] AS DM
		LEFT OUTER JOIN dbo.[ContentItems] AS CI ON DM.ContentItemId = CI.ContentItemID
GO
/****** Object:  View [dbo].[vw_EventLog]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_EventLog]
AS
SELECT
 el.*,
 ee.AssemblyVersion,
 ee.PortalId,
 ee.UserId,
 ee.TabId,
 ee.RawUrl,
 ee.Referrer,
 ee.UserAgent,
 e.Message,
 e.StackTrace,
 e.InnerMessage,
 e.InnerStackTrace,
 e.Source
FROM dbo.EventLog el
 LEFT JOIN dbo.ExceptionEvents ee ON el.LogEventID = ee.LogEventID
 LEFT JOIN dbo.Exceptions e ON el.ExceptionHash = e.ExceptionHash
GO
/****** Object:  View [dbo].[vw_ExtensionUrlProviders]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ExtensionUrlProviders]
AS
	SELECT     
		P.ExtensionUrlProviderID, 
		PC.PortalID, 
		P.ProviderName, 
		P.IsActive, 
		P.RewriteAllUrls, 
		P.RedirectAllUrls, 
		P.ReplaceAllUrls, 
		P.DesktopModuleId
	FROM    dbo.ExtensionUrlProviderConfiguration PC
		RIGHT OUTER JOIN dbo.ExtensionUrlProviders P ON PC.ExtensionUrlProviderID = P.ExtensionUrlProviderID
GO
/****** Object:  View [dbo].[vw_FolderPermissions]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- use new FK
CREATE VIEW [dbo].[vw_FolderPermissions]
AS
SELECT  FP.FolderPermissionID,
        F.FolderID,
        F.FolderPath,
        F.PortalID,
        P.PermissionID,
        FP.RoleID,
        R.RoleName,
        FP.AllowAccess,
        FP.UserID,
        U.Username,
        U.DisplayName,
        P.PermissionCode,
        P.ModuleDefID,
        P.PermissionKey,
        P.PermissionName,
        FP.CreatedByUserID,
        FP.CreatedOnDate,
        FP.LastModifiedByUserID,
        FP.LastModifiedOnDate
FROM         dbo.[FolderPermission] AS FP
 INNER JOIN  dbo.[Folders]          AS F ON FP.FolderID     = F.FolderID
 INNER JOIN  dbo.[Permission]       AS P ON FP.PermissionID = P.PermissionID
 LEFT  JOIN  dbo.[Roles]            AS R ON FP.RoleID       = R.RoleID
 LEFT  JOIN  dbo.[Users]            AS U ON FP.UserID       = U.UserID
GO
/****** Object:  View [dbo].[vw_Lists]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- optimized
CREATE VIEW [dbo].[vw_Lists]
AS
	SELECT  L.EntryID, 
		L.ListName, 
		L.[Value], 
		L.Text, 
		L.[Level], 
		L.SortOrder, 
		L.DefinitionID, 
		L.ParentID, 
		L.Description, 
		L.PortalID, 
		L.SystemList, 
		dbo.[GetListParentKey](L.ParentID, L.ListName, N'ParentKey',  0) AS ParentKey, 
		dbo.[GetListParentKey](L.ParentID, L.ListName, N'Parent',     0) AS Parent, 
		dbo.[GetListParentKey](L.ParentID, L.ListName, N'ParentList', 0) AS ParentList,
		S.MaxSortOrder,
		S.EntryCount,
		CASE WHEN EXISTS (SELECT 1 FROM dbo.[Lists] WHERE (ParentID = L.EntryID)) THEN 1 ELSE 0 END AS HasChildren, 
		L.CreatedByUserID, 
		L.CreatedOnDate, 
		L.LastModifiedByUserID, 
		L.LastModifiedOnDate
	FROM dbo.[Lists] AS L
	LEFT JOIN (SELECT ListName, ParentID, Max(SortOrder) AS MaxSortOrder, Count(1) AS EntryCount 
			   FROM dbo.[Lists] GROUP BY ListName, ParentID) S 		ON L.ParentID = S.ParentId AND L.ListName = S.ListName
GO
/****** Object:  View [dbo].[vw_MessagesForDispatch]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_MessagesForDispatch]
AS
	SELECT CMR.RecipientID
	,CMR.MessageID
	,CMR.UserID
	,CMR.[Read]
	,CMR.Archived
	,CMR.EmailSent
	,CMR.EmailSentDate
	,CMR.EmailSchedulerInstance
	,CMR.CreatedByUserID
	,CMR.CreatedOnDate
	,CMR.LastModifiedByUserID
	,CMR.LastModifiedOnDate
	,CMR.SendToast
	,CM.NotificationTypeID	
    ,CASE 
		WHEN CM.NotificationTypeID IS NULL		
		THEN				
			ISNULL ((SELECT UP.[MessagesEmailFrequency] AS Expr1
					FROM          dbo.CoreMessaging_UserPreferences UP
					WHERE      (UP.UserId = CMR.UserID) AND (UP.PortalId = CM.PortalID)), 0)
		ELSE			
			ISNULL ((SELECT UP.[NotificationsEmailFrequency] AS Expr1
					FROM          dbo.CoreMessaging_UserPreferences UP
					WHERE      (UP.UserId = CMR.UserID) AND (UP.PortalId = CM.PortalID)), 2)
	END EmailFrequency
FROM dbo.CoreMessaging_MessageRecipients AS CMR 
	INNER JOIN
    dbo.CoreMessaging_Messages AS CM 
		ON CMR.MessageID = CM.MessageID
GO
/****** Object:  View [dbo].[vw_ModulePermissions]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- use new FK
CREATE VIEW [dbo].[vw_ModulePermissions]
AS
SELECT  MP.ModulePermissionID,
        MP.ModuleID,
        MP.PortalID,
        P.PermissionID,
        MP.RoleID,
        R.RoleName,
        MP.AllowAccess,
        MP.UserID,
        U.Username,
        U.DisplayName,
        P.PermissionCode,
        P.ModuleDefID,
        P.PermissionKey,
        P.PermissionName,
        MP.CreatedByUserID,
        MP.CreatedOnDate,
        MP.LastModifiedByUserID,
        MP.LastModifiedOnDate
FROM        dbo.[ModulePermission] AS MP
 INNER JOIN dbo.[Permission]       AS P  ON MP.PermissionID = P.PermissionID
 LEFT  JOIN dbo.[Roles]            AS R  ON MP.RoleID       = R.RoleID
 LEFT  JOIN dbo.[Users]            AS U  ON MP.UserID       = U.UserID
GO
/****** Object:  View [dbo].[vw_Modules]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- updated view to use new function
CREATE VIEW [dbo].[vw_Modules]
AS
    SELECT
        M.PortalID AS [OwnerPortalID],
        T.PortalID,
        TM.TabID,
        TM.TabModuleID,
        M.ModuleID,
        M.ModuleDefID,
        TM.ModuleOrder,
        TM.PaneName,
        TM.ModuleTitle,
        TM.CacheTime,
        TM.CacheMethod,
        TM.Alignment,
        TM.Color,
        TM.Border,
        dbo.FilePath(TM.IconFile) AS IconFile,
        M.AllTabs,
        TM.Visibility,
        TM.IsDeleted,
        TM.Header,
        TM.Footer,
        M.StartDate,
        M.EndDate,
        TM.ContainerSrc,
        TM.DisplayTitle,
        TM.DisplayPrint,
        TM.DisplaySyndicate,
        TM.IsWebSlice,
        TM.WebSliceTitle,
        TM.WebSliceExpiryDate,
        TM.WebSliceTTL,
        M.InheritViewPermissions,
        M.IsShareable,
        M.IsShareableViewOnly,
        MD.DesktopModuleID,
        MD.DefaultCacheTime,
        MC.ModuleControlID,
        DM.BusinessControllerClass,
        DM.IsAdmin,
        DM.SupportedFeatures,
        CI.ContentItemID,
        CI.Content,
        CI.ContentTypeID,
        CI.ContentKey,
        CI.Indexed,
        CI.StateID,
        M.CreatedByUserID,
        M.CreatedOnDate,
        M.LastModifiedByUserID,
        M.LastModifiedOnDate,
        M.LastContentModifiedOnDate,
        TM.UniqueId,
        TM.VersionGuid,
        TM.DefaultLanguageGuid,
        TM.LocalizedVersionGuid,
        TM.CultureCode
    FROM        dbo.ModuleDefinitions AS MD
     INNER JOIN dbo.Modules           AS M  ON MD.ModuleDefID = M.ModuleDefID
     INNER JOIN dbo.ModuleControls    AS MC ON MD.ModuleDefID = MC.ModuleDefID
     INNER JOIN dbo.DesktopModules    AS DM ON MD.DesktopModuleID = DM.DesktopModuleID
     LEFT  JOIN dbo.ContentItems      AS CI ON M.ContentItemID = CI.ContentItemID
     LEFT  JOIN dbo.TabModules        AS TM ON M.ModuleID = TM.ModuleID
     LEFT  JOIN dbo.Tabs              AS T  ON TM.TabID = T.TabID
    WHERE (MC.ControlKey IS NULL)
GO
/****** Object:  View [dbo].[vw_TabModules]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_TabModules]
AS
    SELECT
        M.PortalID AS [OwnerPortalID],
        T.PortalID,
        TM.TabID,
        TM.TabModuleID,
        M.ModuleID,
        M.ModuleDefID,
        TM.ModuleOrder,
        TM.PaneName,
        TM.ModuleTitle,
        TM.CacheTime,
        TM.CacheMethod,
        TM.Alignment,
        TM.Color,
        TM.Border,
        dbo.FilePath(TM.IconFile) AS IconFile,
        M.AllTabs,
        TM.Visibility,
        TM.IsDeleted,
        TM.Header,
        TM.Footer,
        M.StartDate,
        M.EndDate,
        TM.ContainerSrc,
        TM.DisplayTitle,
        TM.DisplayPrint,
        TM.DisplaySyndicate,
        TM.IsWebSlice,
        TM.WebSliceTitle,
        TM.WebSliceExpiryDate,
        TM.WebSliceTTL,
        M.InheritViewPermissions,
        M.IsShareable,
        M.IsShareableViewOnly,
        MD.DesktopModuleID,
        MD.DefaultCacheTime,
        MC.ModuleControlID,
        DM.BusinessControllerClass,
        DM.IsAdmin,
        DM.SupportedFeatures,
        CI.ContentItemID,
        CI.Content,
        CI.ContentTypeID,
        CI.ContentKey,
        CI.Indexed,
        CI.StateID,
        TM.CreatedByUserID,
        TM.CreatedOnDate,
        TM.LastModifiedByUserID,
        TM.LastModifiedOnDate,
        M.LastContentModifiedOnDate,
        TM.UniqueId,
        TM.VersionGuid,
        TM.DefaultLanguageGuid,
        TM.LocalizedVersionGuid,
        TM.CultureCode
    FROM dbo.ModuleDefinitions     AS MD
     INNER JOIN dbo.Modules        AS M  ON MD.ModuleDefID = M.ModuleDefID
     INNER JOIN dbo.ModuleControls AS MC ON MD.ModuleDefID = MC.ModuleDefID
     INNER JOIN dbo.DesktopModules AS DM ON MD.DesktopModuleID = DM.DesktopModuleID
     LEFT  JOIN dbo.ContentItems   AS CI ON M.ContentItemID = CI.ContentItemID
     LEFT  JOIN dbo.TabModules     AS TM ON M.ModuleID = TM.ModuleID
     LEFT  JOIN dbo.Tabs           AS T  ON TM.TabID = T.TabID
    WHERE (MC.ControlKey IS NULL)
GO
/****** Object:  View [dbo].[vw_TabPermissions]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- use new FK
CREATE VIEW [dbo].[vw_TabPermissions]
AS
SELECT  TP.TabPermissionID,
        T.TabID,
        T.PortalId,
        P.PermissionID,
        TP.RoleID,
        R.RoleName,
        TP.AllowAccess,
        TP.UserID,
        U.Username,
        U.DisplayName,
        P.PermissionCode,
        P.ModuleDefID,
        P.PermissionKey,
        P.PermissionName,
        TP.CreatedByUserID,
        TP.CreatedOnDate,
        TP.LastModifiedByUserID,
        TP.LastModifiedOnDate
FROM        dbo.[TabPermission]    AS TP
 INNER JOIN dbo.[Tabs]             AS T  ON TP.TabId        = T.TabId
 INNER JOIN dbo.[Permission]       AS P  ON TP.PermissionID = P.PermissionID
 LEFT  JOIN dbo.[Roles]            AS R  ON TP.RoleID       = R.RoleID
 LEFT  JOIN dbo.[Users]            AS U  ON TP.UserID       = U.UserID
GO
/****** Object:  View [dbo].[vw_Tabs]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- updated view to use new function
-- note comment regarding signature modification
CREATE VIEW [dbo].[vw_Tabs]
AS
    SELECT
        T.TabID,
        T.TabOrder,
        T.PortalID,
        T.TabName,
        T.ParentId,
        T.[Level],
        T.TabPath,
        T.UniqueId,
        T.VersionGuid,
        T.DefaultLanguageGuid,
        T.LocalizedVersionGuid,
        T.IsVisible,
		T.HasBeenPublished,
        dbo.FilePath(T.IconFile)      AS IconFile,
        dbo.FilePath(T.IconFileLarge) AS IconFileLarge,
        T.DisableLink,
        T.Title,
        T.Description,
        T.KeyWords,
        T.IsDeleted,
        T.SkinSrc,
        T.ContainerSrc,
        T.StartDate,
        T.EndDate,
        T.Url,
        CASE WHEN dbo.HasChildTab(T.TabID) = 1 THEN 'true' ELSE 'false' END AS HasChildren,
        T.RefreshInterval,
        T.PageHeadText,
        T.IsSecure,
        T.PermanentRedirect,
        T.SiteMapPriority,
        CI.ContentItemID,
        CI.[Content],
        CI.ContentTypeID,
        CI.ModuleID,
        CI.ContentKey,
        CI.Indexed,
        CI.StateID,
        T.CultureCode,
        T.CreatedByUserID,
        T.CreatedOnDate,
        T.LastModifiedByUserID,
        T.LastModifiedOnDate,
		T.IsSystem
    FROM       dbo.Tabs         AS T
    LEFT  JOIN dbo.ContentItems AS CI ON T.ContentItemID = CI.ContentItemID
GO
/****** Object:  View [dbo].[vw_UserRoles]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_UserRoles]
AS
	SELECT     
		UR.UserRoleID, 
		R.RoleID, 
		U.UserID, 
		R.PortalID, 
		R.RoleName, 
		U.Username, 
		R.Description, 
		U.DisplayName, 
		U.Email,
		UR.Status, 
		UR.IsOwner,
		R.SecurityMode,
		R.ServiceFee, 
		R.BillingFrequency, 
		R.TrialPeriod, 
        R.TrialFrequency, 
		R.BillingPeriod, 
		R.TrialFee, 
		R.IsPublic, 
		R.AutoAssignment, 
		R.RoleGroupID, 
		R.RSVPCode, 
		R.IconFile, 
		UR.EffectiveDate, 
		UR.ExpiryDate, 
        UR.IsTrialUsed, 
		UR.CreatedByUserID, 
		UR.CreatedOnDate, 
		UR.LastModifiedByUserID, 
		UR.LastModifiedOnDate 
	FROM dbo.UserRoles AS UR 
		INNER JOIN dbo.Users AS U ON UR.UserID = U.UserID 
		INNER JOIN dbo.Roles AS R ON UR.RoleID = R.RoleID
	WHERE R.Status = 1
GO
/****** Object:  View [dbo].[vw_Users]    Script Date: 31/03/2016 05:32:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Users]
AS
	SELECT  U.UserId,
        UP.PortalId,
        U.Username,
        U.FirstName,
        U.LastName,
        U.DisplayName,
        U.IsSuperUser,
        U.Email,
        UP.VanityUrl,
        U.AffiliateId,
        IsNull(UP.IsDeleted, U.IsDeleted) AS IsDeleted,
        UP.RefreshRoles,
        U.LastIPAddress,
        U.UpdatePassword,
        U.PasswordResetToken,
        U.PasswordResetExpiration,
        UP.Authorised,
        U.CreatedByUserId,
        U.CreatedOnDate,
        U.LastModifiedByUserId,
        U.LastModifiedOnDate
	FROM       dbo.[Users]       AS U
		LEFT JOIN dbo.[UserPortals] AS UP 
			ON CASE WHEN U.IsSuperuser = 1 THEN 0 ELSE U.UserId END = UP.UserId
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [aspnet_Applications_Index]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE CLUSTERED INDEX [aspnet_Applications_Index] ON [dbo].[aspnet_Applications]
(
	[LoweredApplicationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [aspnet_Membership_index]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE CLUSTERED INDEX [aspnet_Membership_index] ON [dbo].[aspnet_Membership]
(
	[ApplicationId] ASC,
	[LoweredEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [aspnet_Users_Index]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE CLUSTERED INDEX [aspnet_Users_Index] ON [dbo].[aspnet_Users]
(
	[ApplicationId] ASC,
	[LoweredUserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_PortalSettings]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE CLUSTERED INDEX [IX_PortalSettings] ON [dbo].[PortalSettings]
(
	[PortalID] ASC,
	[CultureCode] ASC,
	[SettingName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_TabSettings_TabID_SettingName]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE CLUSTERED INDEX [IX_TabSettings_TabID_SettingName] ON [dbo].[TabSettings]
(
	[TabID] ASC,
	[SettingName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [aspnet_Users_Index2]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [aspnet_Users_Index2] ON [dbo].[aspnet_Users]
(
	[ApplicationId] ASC,
	[LastActivityDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Banners]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Banners] ON [dbo].[Banners]
(
	[BannerTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Banners_1]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Banners_1] ON [dbo].[Banners]
(
	[VendorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Classification]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Classification] ON [dbo].[Classification]
(
	[ParentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ContentItems_TabID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_ContentItems_TabID] ON [dbo].[ContentItems]
(
	[TabID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ContentItems_Tags]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ContentItems_Tags] ON [dbo].[ContentItems_Tags]
(
	[ContentItemID] ASC,
	[TermID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ContentItems_Tags_TermID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_ContentItems_Tags_TermID] ON [dbo].[ContentItems_Tags]
(
	[TermID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ContentTypes_ContentType]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ContentTypes_ContentType] ON [dbo].[ContentTypes]
(
	[ContentType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [ContentTypeId_ActionType]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [ContentTypeId_ActionType] ON [dbo].[ContentWorkflowActions]
(
	[ContentTypeId] ASC,
	[ActionType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CoreMessaging_MessageAttachments_MessageID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_CoreMessaging_MessageAttachments_MessageID] ON [dbo].[CoreMessaging_MessageAttachments]
(
	[MessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CoreMessaging_MessageRecipients_UserID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_CoreMessaging_MessageRecipients_UserID] ON [dbo].[CoreMessaging_MessageRecipients]
(
	[UserID] ASC,
	[Read] DESC,
	[Archived] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CoreMessaging_Messages_SenderUserID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_CoreMessaging_Messages_SenderUserID] ON [dbo].[CoreMessaging_Messages]
(
	[SenderUserID] ASC,
	[CreatedOnDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CoreMessaging_NotificationTypeActions]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_CoreMessaging_NotificationTypeActions] ON [dbo].[CoreMessaging_NotificationTypeActions]
(
	[NotificationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_CoreMessaging_NotificationTypes]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_CoreMessaging_NotificationTypes] ON [dbo].[CoreMessaging_NotificationTypes]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DesktopModulePermission_DesktopModules]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_DesktopModulePermission_DesktopModules] ON [dbo].[DesktopModulePermission]
(
	[PortalDesktopModuleID] ASC,
	[PermissionID] ASC,
	[RoleID] ASC,
	[UserID] ASC
)
INCLUDE ( 	[AllowAccess]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DesktopModulePermission_Roles]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_DesktopModulePermission_Roles] ON [dbo].[DesktopModulePermission]
(
	[RoleID] ASC,
	[PortalDesktopModuleID] ASC,
	[PermissionID] ASC
)
INCLUDE ( 	[AllowAccess]) 
WHERE ([RoleID] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DesktopModulePermission_Users]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_DesktopModulePermission_Users] ON [dbo].[DesktopModulePermission]
(
	[UserID] ASC,
	[PortalDesktopModuleID] ASC,
	[PermissionID] ASC
)
INCLUDE ( 	[AllowAccess]) 
WHERE ([UserID] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_DesktopModules_FriendlyName]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_DesktopModules_FriendlyName] ON [dbo].[DesktopModules]
(
	[FriendlyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventLog_LogConfigID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventLog_LogConfigID] ON [dbo].[EventLog]
(
	[LogConfigID] ASC,
	[LogNotificationPending] ASC,
	[LogCreateDate] ASC
)
INCLUDE ( 	[LogEventID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventLog_LogCreateDate]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventLog_LogCreateDate] ON [dbo].[EventLog]
(
	[LogCreateDate] ASC
)
INCLUDE ( 	[LogConfigID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_EventLog_LogGUID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventLog_LogGUID] ON [dbo].[EventLog]
(
	[LogGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_EventLog_LogType]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventLog_LogType] ON [dbo].[EventLog]
(
	[LogTypeKey] ASC,
	[LogPortalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_LogTypeKey_LogTypePortalID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_LogTypeKey_LogTypePortalID] ON [dbo].[EventLogConfig]
(
	[LogTypeKey] ASC,
	[LogTypePortalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Files_ContentID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Files_ContentID] ON [dbo].[Files]
(
	[ContentItemID] ASC
)
INCLUDE ( 	[FileId],
	[FolderID],
	[FileName],
	[PublishedVersion]) 
WHERE ([ContentItemId] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Files_FileID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Files_FileID] ON [dbo].[Files]
(
	[FileId] ASC
)
INCLUDE ( 	[PortalId],
	[FolderID],
	[FileName],
	[PublishedVersion]) 
WHERE ([ContentItemId] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Files_PortalID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Files_PortalID] ON [dbo].[Files]
(
	[PortalId] ASC,
	[FolderID] ASC,
	[FileName] ASC
)
INCLUDE ( 	[FileId],
	[PublishedVersion]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FolderPermission_Folders]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_FolderPermission_Folders] ON [dbo].[FolderPermission]
(
	[FolderID] ASC,
	[PermissionID] ASC,
	[RoleID] ASC,
	[UserID] ASC
)
INCLUDE ( 	[AllowAccess]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FolderPermission_Modules]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_FolderPermission_Modules] ON [dbo].[FolderPermission]
(
	[FolderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FolderPermission_Permission]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_FolderPermission_Permission] ON [dbo].[FolderPermission]
(
	[PermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FolderPermission_Roles]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_FolderPermission_Roles] ON [dbo].[FolderPermission]
(
	[RoleID] ASC,
	[FolderID] ASC,
	[PermissionID] ASC
)
INCLUDE ( 	[AllowAccess]) 
WHERE ([RoleID] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FolderPermission_Users]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_FolderPermission_Users] ON [dbo].[FolderPermission]
(
	[UserID] ASC,
	[FolderID] ASC,
	[PermissionID] ASC
)
INCLUDE ( 	[AllowAccess]) 
WHERE ([UserID] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Folders_FolderID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Folders_FolderID] ON [dbo].[Folders]
(
	[FolderID] ASC
)
INCLUDE ( 	[PortalID],
	[FolderPath],
	[StorageLocation],
	[IsCached],
	[FolderMappingID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Folders_ParentID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Folders_ParentID] ON [dbo].[Folders]
(
	[PortalID] ASC,
	[ParentID] ASC,
	[FolderPath] ASC
)
INCLUDE ( 	[FolderID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_HtmlText_ModuleID_Version]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_HtmlText_ModuleID_Version] ON [dbo].[HtmlText]
(
	[ModuleID] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_HtmlTextLog_ItemID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_HtmlTextLog_ItemID] ON [dbo].[HtmlTextLog]
(
	[ItemID] ASC
)
INCLUDE ( 	[HtmlTextLogID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Journal_ContentItemId]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Journal_ContentItemId] ON [dbo].[Journal]
(
	[ContentItemId] ASC
)
INCLUDE ( 	[GroupId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LanguagePacks]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_LanguagePacks] ON [dbo].[LanguagePacks]
(
	[LanguageID] ASC,
	[PackageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Languages]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Languages] ON [dbo].[Languages]
(
	[CultureCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Lists_ListName_ParentID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Lists_ListName_ParentID] ON [dbo].[Lists]
(
	[ListName] ASC,
	[ParentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Lists_ParentID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Lists_ParentID] ON [dbo].[Lists]
(
	[ParentID] ASC,
	[ListName] ASC,
	[Value] ASC
)
INCLUDE ( 	[SortOrder],
	[DefinitionID],
	[Text]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Lists_SortOrder]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Lists_SortOrder] ON [dbo].[Lists]
(
	[PortalID] ASC,
	[ParentID] ASC,
	[ListName] ASC,
	[SortOrder] ASC
)
INCLUDE ( 	[DefinitionID],
	[Value],
	[Text]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Messaging_Messages_EmailSent_EmailSchedulerInstance_Status]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Messaging_Messages_EmailSent_EmailSchedulerInstance_Status] ON [dbo].[Messaging_Messages]
(
	[EmailSent] ASC,
	[EmailSchedulerInstance] ASC,
	[Status] ASC,
	[Date] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Messaging_Messages_FromUserID_Status]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Messaging_Messages_FromUserID_Status] ON [dbo].[Messaging_Messages]
(
	[FromUserID] ASC,
	[Status] ASC,
	[Date] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Messaging_Messages_ToUserID_Status_SkipPortal]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Messaging_Messages_ToUserID_Status_SkipPortal] ON [dbo].[Messaging_Messages]
(
	[ToUserID] ASC,
	[Status] ASC,
	[SkipPortal] ASC,
	[Date] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MetaData_MetaDataName]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MetaData_MetaDataName] ON [dbo].[MetaData]
(
	[MetaDataName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Mobile_PreviewProfiles_SortOrder]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Mobile_PreviewProfiles_SortOrder] ON [dbo].[Mobile_PreviewProfiles]
(
	[SortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Mobile_Redirections_SortOrder]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Mobile_Redirections_SortOrder] ON [dbo].[Mobile_Redirections]
(
	[SortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ModuleControls_ControlKey_ViewOrder]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_ModuleControls_ControlKey_ViewOrder] ON [dbo].[ModuleControls]
(
	[ControlKey] ASC,
	[ViewOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ModuleDefinitions]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ModuleDefinitions] ON [dbo].[ModuleDefinitions]
(
	[DefinitionName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ModuleDefinitions_1]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_ModuleDefinitions_1] ON [dbo].[ModuleDefinitions]
(
	[DesktopModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ModulePermission_Modules]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ModulePermission_Modules] ON [dbo].[ModulePermission]
(
	[ModuleID] ASC,
	[PermissionID] ASC,
	[RoleID] ASC,
	[UserID] ASC
)
INCLUDE ( 	[AllowAccess]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ModulePermission_Permission]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_ModulePermission_Permission] ON [dbo].[ModulePermission]
(
	[PermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ModulePermission_Roles]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ModulePermission_Roles] ON [dbo].[ModulePermission]
(
	[RoleID] ASC,
	[ModuleID] ASC,
	[PermissionID] ASC
)
INCLUDE ( 	[AllowAccess]) 
WHERE ([RoleID] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ModulePermission_Users]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ModulePermission_Users] ON [dbo].[ModulePermission]
(
	[UserID] ASC,
	[ModuleID] ASC,
	[PermissionID] ASC
)
INCLUDE ( 	[AllowAccess]) 
WHERE ([UserID] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Modules_ModuleDefId]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Modules_ModuleDefId] ON [dbo].[Modules]
(
	[ModuleDefID] ASC
)
INCLUDE ( 	[ModuleID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Modules_PortalId]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Modules_PortalId] ON [dbo].[Modules]
(
	[PortalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Packages]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Packages] ON [dbo].[Packages]
(
	[Owner] ASC,
	[Name] ASC,
	[PackageType] ASC,
	[PortalID] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PortalLanguages]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_PortalLanguages] ON [dbo].[PortalLanguages]
(
	[PortalID] ASC,
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Portals_AdministratorId]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Portals_AdministratorId] ON [dbo].[Portals]
(
	[AdministratorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Portals_DefaultLanguage]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Portals_DefaultLanguage] ON [dbo].[Portals]
(
	[DefaultLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Profile]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Profile] ON [dbo].[Profile]
(
	[UserId] ASC,
	[PortalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ProfilePropertyDefinition]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProfilePropertyDefinition] ON [dbo].[ProfilePropertyDefinition]
(
	[PortalID] ASC,
	[ModuleDefID] ASC,
	[PropertyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ProfilePropertyDefinition_PropertyName]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProfilePropertyDefinition_PropertyName] ON [dbo].[ProfilePropertyDefinition]
(
	[PropertyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Relationships_UserID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Relationships_UserID] ON [dbo].[Relationships]
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Roles]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Roles] ON [dbo].[Roles]
(
	[BillingFrequency] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Roles_RoleGroup]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Roles_RoleGroup] ON [dbo].[Roles]
(
	[RoleGroupID] ASC,
	[RoleName] ASC
)
INCLUDE ( 	[RoleID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Roles_RoleName]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Roles_RoleName] ON [dbo].[Roles]
(
	[PortalID] ASC,
	[RoleName] ASC
)
INCLUDE ( 	[RoleID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScheduleHistory_NextStart]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_ScheduleHistory_NextStart] ON [dbo].[ScheduleHistory]
(
	[ScheduleID] ASC,
	[NextStart] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScheduleHistory_StartDate]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_ScheduleHistory_StartDate] ON [dbo].[ScheduleHistory]
(
	[ScheduleID] ASC,
	[StartDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SearchDeletedItems_DateCreated]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_SearchDeletedItems_DateCreated] ON [dbo].[SearchDeletedItems]
(
	[DateCreated] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SiteLog]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_SiteLog] ON [dbo].[SiteLog]
(
	[PortalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_TabModules_ModuleID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_TabModules_ModuleID] ON [dbo].[TabModules]
(
	[ModuleID] ASC,
	[TabID] ASC
)
INCLUDE ( 	[IsDeleted],
	[CultureCode],
	[ModuleTitle]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_TabModules_ModuleOrder]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_TabModules_ModuleOrder] ON [dbo].[TabModules]
(
	[TabID] ASC,
	[PaneName] ASC,
	[ModuleOrder] ASC
)
INCLUDE ( 	[TabModuleID],
	[ModuleID],
	[CacheTime],
	[Alignment],
	[Color],
	[Border],
	[IconFile],
	[Visibility],
	[ContainerSrc],
	[DisplayTitle],
	[DisplayPrint],
	[DisplaySyndicate],
	[IsWebSlice],
	[WebSliceTitle],
	[WebSliceExpiryDate],
	[WebSliceTTL],
	[CreatedByUserID],
	[CreatedOnDate],
	[LastModifiedByUserID],
	[LastModifiedOnDate],
	[IsDeleted],
	[CacheMethod],
	[ModuleTitle],
	[Header],
	[Footer],
	[CultureCode],
	[UniqueId],
	[VersionGuid],
	[DefaultLanguageGuid],
	[LocalizedVersionGuid]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_TabModules_TabID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_TabModules_TabID] ON [dbo].[TabModules]
(
	[TabID] ASC,
	[ModuleID] ASC
)
INCLUDE ( 	[IsDeleted],
	[CultureCode],
	[ModuleTitle]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TabPermission_Permission]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_TabPermission_Permission] ON [dbo].[TabPermission]
(
	[PermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TabPermission_Roles]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_TabPermission_Roles] ON [dbo].[TabPermission]
(
	[RoleID] ASC,
	[TabID] ASC,
	[PermissionID] ASC
)
INCLUDE ( 	[AllowAccess]) 
WHERE ([RoleID] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TabPermission_Tabs]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_TabPermission_Tabs] ON [dbo].[TabPermission]
(
	[TabID] ASC,
	[PermissionID] ASC,
	[RoleID] ASC,
	[UserID] ASC
)
INCLUDE ( 	[AllowAccess]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TabPermission_Users]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_TabPermission_Users] ON [dbo].[TabPermission]
(
	[UserID] ASC,
	[TabID] ASC,
	[PermissionID] ASC
)
INCLUDE ( 	[AllowAccess]) 
WHERE ([UserID] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Tabs_ContentID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Tabs_ContentID] ON [dbo].[Tabs]
(
	[ContentItemID] ASC
)
INCLUDE ( 	[TabID],
	[TabName],
	[Title],
	[IsVisible],
	[IsDeleted],
	[UniqueId],
	[CultureCode]) 
WHERE ([ContentItemId] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Tabs_ParentId_IsDeleted]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Tabs_ParentId_IsDeleted] ON [dbo].[Tabs]
(
	[ParentId] ASC,
	[IsDeleted] ASC
)
INCLUDE ( 	[CreatedOnDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Tabs_PortalLevelParentOrder]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Tabs_PortalLevelParentOrder] ON [dbo].[Tabs]
(
	[PortalID] ASC,
	[Level] ASC,
	[ParentId] ASC,
	[TabOrder] ASC,
	[IsDeleted] ASC
)
INCLUDE ( 	[TabID],
	[TabName],
	[IsVisible],
	[IconFile],
	[DisableLink],
	[Title],
	[Description],
	[KeyWords],
	[Url],
	[SkinSrc],
	[ContainerSrc],
	[StartDate],
	[EndDate],
	[RefreshInterval],
	[PageHeadText],
	[IsSecure],
	[PermanentRedirect],
	[SiteMapPriority],
	[CreatedByUserID],
	[CreatedOnDate],
	[LastModifiedByUserID],
	[LastModifiedOnDate],
	[IconFileLarge],
	[CultureCode],
	[ContentItemID],
	[UniqueId],
	[VersionGuid],
	[DefaultLanguageGuid],
	[LocalizedVersionGuid],
	[TabPath]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TabVersionDetails_TabVersionId]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_TabVersionDetails_TabVersionId] ON [dbo].[TabVersionDetails]
(
	[TabVersionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TabVersions_TabId]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_TabVersions_TabId] ON [dbo].[TabVersions]
(
	[TabId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UrlTracking_ModuleId]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_UrlTracking_ModuleId] ON [dbo].[UrlTracking]
(
	[ModuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UrlTracking_Url_ModuleId]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_UrlTracking_Url_ModuleId] ON [dbo].[UrlTracking]
(
	[Url] ASC,
	[ModuleId] ASC
)
INCLUDE ( 	[TrackClicks],
	[NewWindow]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserAuthentication]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserAuthentication] ON [dbo].[UserAuthentication]
(
	[UserID] ASC,
	[AuthenticationType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserPortals]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserPortals] ON [dbo].[UserPortals]
(
	[PortalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserPortals_PortalId_IsDeleted]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserPortals_PortalId_IsDeleted] ON [dbo].[UserPortals]
(
	[PortalId] ASC,
	[IsDeleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserPortals_VanityUrl]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserPortals_VanityUrl] ON [dbo].[UserPortals]
(
	[VanityUrl] ASC
)
INCLUDE ( 	[UserId],
	[PortalId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserProfile]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserProfile] ON [dbo].[UserProfile]
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserProfile_LastUpdatedDate]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserProfile_LastUpdatedDate] ON [dbo].[UserProfile]
(
	[LastUpdatedDate] DESC
)
INCLUDE ( 	[UserID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserProfile_PropertyDefinitionID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserProfile_PropertyDefinitionID] ON [dbo].[UserProfile]
(
	[PropertyDefinitionID] ASC
)
INCLUDE ( 	[ProfileID],
	[UserID],
	[PropertyValue]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserProfile_UserID_PropertyDefinitionID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserProfile_UserID_PropertyDefinitionID] ON [dbo].[UserProfile]
(
	[UserID] ASC,
	[PropertyDefinitionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserProfile_Visibility]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserProfile_Visibility] ON [dbo].[UserProfile]
(
	[UserID] ASC,
	[ProfileID] ASC
)
INCLUDE ( 	[PropertyDefinitionID],
	[PropertyValue],
	[PropertyText],
	[Visibility],
	[LastUpdatedDate],
	[ExtendedVisibility]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserRelationships_RelatedUserID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserRelationships_RelatedUserID] ON [dbo].[UserRelationships]
(
	[RelatedUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserRelationships_UserID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserRelationships_UserID] ON [dbo].[UserRelationships]
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserRelationships_UserID_RelatedUserID_RelationshipID]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserRelationships_UserID_RelatedUserID_RelationshipID] ON [dbo].[UserRelationships]
(
	[UserID] ASC,
	[RelatedUserID] ASC,
	[RelationshipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserRoles_RoleUser]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserRoles_RoleUser] ON [dbo].[UserRoles]
(
	[RoleID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserRoles_UserRole]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserRoles_UserRole] ON [dbo].[UserRoles]
(
	[UserID] ASC,
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Users_Email]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Users_Email] ON [dbo].[Users]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Users_IsDeleted_DisplayName]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Users_IsDeleted_DisplayName] ON [dbo].[Users]
(
	[IsDeleted] ASC,
	[DisplayName] ASC
)
INCLUDE ( 	[UserID],
	[IsSuperUser],
	[Email]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Users_LastModifiedOnDate]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Users_LastModifiedOnDate] ON [dbo].[Users]
(
	[LastModifiedOnDate] DESC
)
INCLUDE ( 	[UserID],
	[IsSuperUser]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Users_LowerEmail]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_Users_LowerEmail] ON [dbo].[Users]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_VendorClassification_1]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_VendorClassification_1] ON [dbo].[VendorClassification]
(
	[ClassificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_WebServers_ServerName]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_WebServers_ServerName] ON [dbo].[WebServers]
(
	[ServerName] ASC,
	[IISAppName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Workflow]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Workflow] ON [dbo].[Workflow]
(
	[PortalID] ASC,
	[WorkflowName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_WorkflowStates]    Script Date: 31/03/2016 05:32:45 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_WorkflowStates] ON [dbo].[WorkflowStates]
(
	[WorkflowID] ASC,
	[StateName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AnonymousUsers] ADD  CONSTRAINT [DF_AnonymousUsers_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[AnonymousUsers] ADD  CONSTRAINT [DF_AnonymousUsers_LastActiveDate]  DEFAULT (getdate()) FOR [LastActiveDate]
GO
ALTER TABLE [dbo].[aspnet_Applications] ADD  DEFAULT (newid()) FOR [ApplicationId]
GO
ALTER TABLE [dbo].[aspnet_Membership] ADD  DEFAULT ((0)) FOR [PasswordFormat]
GO
ALTER TABLE [dbo].[aspnet_Users] ADD  DEFAULT (newid()) FOR [UserId]
GO
ALTER TABLE [dbo].[aspnet_Users] ADD  DEFAULT (NULL) FOR [MobileAlias]
GO
ALTER TABLE [dbo].[aspnet_Users] ADD  DEFAULT ((0)) FOR [IsAnonymous]
GO
ALTER TABLE [dbo].[Authentication] ADD  CONSTRAINT [DF__Authe__Packa__43F60EC8]  DEFAULT ((-1)) FOR [PackageID]
GO
ALTER TABLE [dbo].[Authentication] ADD  CONSTRAINT [DF_Authentication_IsEnabled]  DEFAULT ((0)) FOR [IsEnabled]
GO
ALTER TABLE [dbo].[Banners] ADD  CONSTRAINT [DF_Banners_Views]  DEFAULT ((0)) FOR [Views]
GO
ALTER TABLE [dbo].[Banners] ADD  CONSTRAINT [DF_Banners_ClickThroughs]  DEFAULT ((0)) FOR [ClickThroughs]
GO
ALTER TABLE [dbo].[Banners] ADD  CONSTRAINT [DF_Banners_Criteria]  DEFAULT ((1)) FOR [Criteria]
GO
ALTER TABLE [dbo].[Banners] ADD  CONSTRAINT [DF_Banners_Width]  DEFAULT ((0)) FOR [Width]
GO
ALTER TABLE [dbo].[Banners] ADD  CONSTRAINT [DF_Banners_Height]  DEFAULT ((0)) FOR [Height]
GO
ALTER TABLE [dbo].[ContentItems] ADD  CONSTRAINT [DF_ContentItems_Indexed]  DEFAULT ((0)) FOR [Indexed]
GO
ALTER TABLE [dbo].[ContentWorkflowLogs] ADD  DEFAULT ((-1)) FOR [Type]
GO
ALTER TABLE [dbo].[ContentWorkflows] ADD  CONSTRAINT [DF_ContentWorkflows_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[ContentWorkflows] ADD  CONSTRAINT [DF_ContentWorkflows_StartAfterCreating]  DEFAULT ((1)) FOR [StartAfterCreating]
GO
ALTER TABLE [dbo].[ContentWorkflows] ADD  CONSTRAINT [DF_ContentWorkflows_StartAfterEditing]  DEFAULT ((1)) FOR [StartAfterEditing]
GO
ALTER TABLE [dbo].[ContentWorkflows] ADD  CONSTRAINT [DF_ContentWorkflows_DispositionEnabled]  DEFAULT ((0)) FOR [DispositionEnabled]
GO
ALTER TABLE [dbo].[ContentWorkflows] ADD  DEFAULT ((0)) FOR [IsSystem]
GO
ALTER TABLE [dbo].[ContentWorkflows] ADD  DEFAULT (N'') FOR [WorkflowKey]
GO
ALTER TABLE [dbo].[ContentWorkflowStates] ADD  CONSTRAINT [DF_ContentWorkflowStates_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ContentWorkflowStates] ADD  CONSTRAINT [DF_ContentWorkflowStates_SendEmail]  DEFAULT ((0)) FOR [SendEmail]
GO
ALTER TABLE [dbo].[ContentWorkflowStates] ADD  CONSTRAINT [DF_ContentWorkflowStates_SendMessage]  DEFAULT ((0)) FOR [SendMessage]
GO
ALTER TABLE [dbo].[ContentWorkflowStates] ADD  CONSTRAINT [DF_ContentWorkflowStates_IsDisposalState]  DEFAULT ((0)) FOR [IsDisposalState]
GO
ALTER TABLE [dbo].[ContentWorkflowStates] ADD  CONSTRAINT [DF_ContentWorkflowStates_OnCompleteMessageSubject]  DEFAULT (N'') FOR [OnCompleteMessageSubject]
GO
ALTER TABLE [dbo].[ContentWorkflowStates] ADD  CONSTRAINT [DF_ContentWorkflowStates_OnCompleteMessageBody]  DEFAULT (N'') FOR [OnCompleteMessageBody]
GO
ALTER TABLE [dbo].[ContentWorkflowStates] ADD  CONSTRAINT [DF_ContentWorkflowStates_OnDiscardMessageSubject]  DEFAULT (N'') FOR [OnDiscardMessageSubject]
GO
ALTER TABLE [dbo].[ContentWorkflowStates] ADD  CONSTRAINT [DF_ContentWorkflowStates_OnDiscardMessageBody]  DEFAULT (N'') FOR [OnDiscardMessageBody]
GO
ALTER TABLE [dbo].[ContentWorkflowStates] ADD  DEFAULT ((0)) FOR [IsSystem]
GO
ALTER TABLE [dbo].[ContentWorkflowStates] ADD  DEFAULT ((1)) FOR [SendNotification]
GO
ALTER TABLE [dbo].[ContentWorkflowStates] ADD  DEFAULT ((1)) FOR [SendNotificationToAdministrators]
GO
ALTER TABLE [dbo].[CoreMessaging_MessageRecipients] ADD  CONSTRAINT [DF__CoreMe__Read__3AC1AA49]  DEFAULT ((0)) FOR [Read]
GO
ALTER TABLE [dbo].[CoreMessaging_MessageRecipients] ADD  CONSTRAINT [DF__CoreM__Archi__3BB5CE82]  DEFAULT ((0)) FOR [Archived]
GO
ALTER TABLE [dbo].[CoreMessaging_MessageRecipients] ADD  CONSTRAINT [DF__CoreM__Email__3CA9F2BB]  DEFAULT ((0)) FOR [EmailSent]
GO
ALTER TABLE [dbo].[CoreMessaging_MessageRecipients] ADD  DEFAULT ((0)) FOR [SendToast]
GO
ALTER TABLE [dbo].[CoreMessaging_NotificationTypes] ADD  DEFAULT ((0)) FOR [IsTask]
GO
ALTER TABLE [dbo].[Dashboard_Controls] ADD  CONSTRAINT [DF_Dashboard_Controls_ViewOrder]  DEFAULT ((0)) FOR [ViewOrder]
GO
ALTER TABLE [dbo].[Dashboard_Controls] ADD  CONSTRAINT [DF_Dashboard_Controls_PackageID]  DEFAULT ((-1)) FOR [PackageID]
GO
ALTER TABLE [dbo].[DesktopModules] ADD  CONSTRAINT [DF_DesktopModules_SupportedFeatures]  DEFAULT ((0)) FOR [SupportedFeatures]
GO
ALTER TABLE [dbo].[DesktopModules] ADD  CONSTRAINT [DF_DesktopModules_PackageID]  DEFAULT ((-1)) FOR [PackageID]
GO
ALTER TABLE [dbo].[DesktopModules] ADD  CONSTRAINT [DF_DesktopModules_ContentItemId]  DEFAULT ((-1)) FOR [ContentItemId]
GO
ALTER TABLE [dbo].[DesktopModules] ADD  CONSTRAINT [DF_DesktopModules_Shareable]  DEFAULT ((0)) FOR [Shareable]
GO
ALTER TABLE [dbo].[EventQueue] ADD  CONSTRAINT [DF_EventQueue_IsComplete]  DEFAULT ((0)) FOR [IsComplete]
GO
ALTER TABLE [dbo].[Files] ADD  CONSTRAINT [DF_Files_UniqueId]  DEFAULT (newid()) FOR [UniqueId]
GO
ALTER TABLE [dbo].[Files] ADD  CONSTRAINT [DF_Files_VersionGuid]  DEFAULT (newid()) FOR [VersionGuid]
GO
ALTER TABLE [dbo].[Files] ADD  CONSTRAINT [DF__Files__LastM__629A9179]  DEFAULT (getdate()) FOR [LastModificationTime]
GO
ALTER TABLE [dbo].[Files] ADD  DEFAULT (getdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[Files] ADD  DEFAULT ((0)) FOR [EnablePublishPeriod]
GO
ALTER TABLE [dbo].[Files] ADD  DEFAULT ((1)) FOR [PublishedVersion]
GO
ALTER TABLE [dbo].[Folders] ADD  CONSTRAINT [DF_Folders_StorageLocation]  DEFAULT ((0)) FOR [StorageLocation]
GO
ALTER TABLE [dbo].[Folders] ADD  CONSTRAINT [DF_Folders_IsProtected]  DEFAULT ((0)) FOR [IsProtected]
GO
ALTER TABLE [dbo].[Folders] ADD  CONSTRAINT [DF_Folders_IsCached]  DEFAULT ((0)) FOR [IsCached]
GO
ALTER TABLE [dbo].[Folders] ADD  CONSTRAINT [DF_Folders_UniqueId]  DEFAULT (newid()) FOR [UniqueId]
GO
ALTER TABLE [dbo].[Folders] ADD  CONSTRAINT [DF_Folders_VersionGuid]  DEFAULT (newid()) FOR [VersionGuid]
GO
ALTER TABLE [dbo].[Folders] ADD  DEFAULT ((0)) FOR [IsVersioned]
GO
ALTER TABLE [dbo].[HostSettings] ADD  CONSTRAINT [DF_HostSettings_Secure]  DEFAULT ((0)) FOR [SettingIsSecure]
GO
ALTER TABLE [dbo].[Journal] ADD  CONSTRAINT [DF_Journal_ProfileId]  DEFAULT ((-1)) FOR [ProfileId]
GO
ALTER TABLE [dbo].[Journal] ADD  CONSTRAINT [DF_Journal_GroupId]  DEFAULT ((-1)) FOR [GroupId]
GO
ALTER TABLE [dbo].[Journal] ADD  CONSTRAINT [DF_Journal_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Journal] ADD  CONSTRAINT [DF_Journal_CommentsDisabled]  DEFAULT ((0)) FOR [CommentsDisabled]
GO
ALTER TABLE [dbo].[Journal] ADD  CONSTRAINT [DF_Journal_CommentsHidden]  DEFAULT ((0)) FOR [CommentsHidden]
GO
ALTER TABLE [dbo].[Journal_Types] ADD  CONSTRAINT [DF_JournalTypes_PortalId]  DEFAULT ((-1)) FOR [PortalId]
GO
ALTER TABLE [dbo].[Journal_Types] ADD  CONSTRAINT [DF_JournalTypes_IsEnabled]  DEFAULT ((1)) FOR [IsEnabled]
GO
ALTER TABLE [dbo].[Journal_Types] ADD  CONSTRAINT [DF_JournalTypes_AppliesToProfile]  DEFAULT ((1)) FOR [AppliesToProfile]
GO
ALTER TABLE [dbo].[Journal_Types] ADD  CONSTRAINT [DF_JournalTypes_AppliesToGroup]  DEFAULT ((1)) FOR [AppliesToGroup]
GO
ALTER TABLE [dbo].[Journal_Types] ADD  CONSTRAINT [DF_JournalTypes_AppliesToStream]  DEFAULT ((1)) FOR [AppliesToStream]
GO
ALTER TABLE [dbo].[Journal_Types] ADD  CONSTRAINT [DF_JournalTypes_SupportsNotify]  DEFAULT ((0)) FOR [SupportsNotify]
GO
ALTER TABLE [dbo].[Journal_Types] ADD  CONSTRAINT [DF_Journal_Types_EnableComments]  DEFAULT ((1)) FOR [EnableComments]
GO
ALTER TABLE [dbo].[Lists] ADD  CONSTRAINT [DF_Lists_ParentID]  DEFAULT ((0)) FOR [ParentID]
GO
ALTER TABLE [dbo].[Lists] ADD  CONSTRAINT [DF_Lists_Level]  DEFAULT ((0)) FOR [Level]
GO
ALTER TABLE [dbo].[Lists] ADD  CONSTRAINT [DF_Lists_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[Lists] ADD  CONSTRAINT [DF_Lists_DefinitionID]  DEFAULT ((0)) FOR [DefinitionID]
GO
ALTER TABLE [dbo].[Lists] ADD  CONSTRAINT [DF_Lists_PortalID]  DEFAULT ((-1)) FOR [PortalID]
GO
ALTER TABLE [dbo].[Lists] ADD  CONSTRAINT [DF_Lists_SystemList]  DEFAULT ((0)) FOR [SystemList]
GO
ALTER TABLE [dbo].[Mobile_PreviewProfiles] ADD  CONSTRAINT [DF_Mobile_PreviewProfiles_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[Mobile_PreviewProfiles] ADD  CONSTRAINT [DF_Mobile_PreviewProfiles_CreatedOnDate]  DEFAULT (getdate()) FOR [CreatedOnDate]
GO
ALTER TABLE [dbo].[Mobile_PreviewProfiles] ADD  CONSTRAINT [DF_Mobile_PreviewProfiles_LastModifiedOnDate]  DEFAULT (getdate()) FOR [LastModifiedOnDate]
GO
ALTER TABLE [dbo].[Mobile_Redirections] ADD  CONSTRAINT [DF_Mobile_Redirections_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[Mobile_Redirections] ADD  CONSTRAINT [DF_Mobile_Redirections_CreatedOnDate]  DEFAULT (getdate()) FOR [CreatedOnDate]
GO
ALTER TABLE [dbo].[Mobile_Redirections] ADD  CONSTRAINT [DF_Mobile_Redirections_LastModifiedOnDate]  DEFAULT (getdate()) FOR [LastModifiedOnDate]
GO
ALTER TABLE [dbo].[ModuleControls] ADD  CONSTRAINT [DF_ModuleControls_SupportsPartialRendering]  DEFAULT ((0)) FOR [SupportsPartialRendering]
GO
ALTER TABLE [dbo].[ModuleControls] ADD  CONSTRAINT [DF_ModuleControls_SupportsPopUps]  DEFAULT ((0)) FOR [SupportsPopUps]
GO
ALTER TABLE [dbo].[ModuleDefinitions] ADD  CONSTRAINT [DF_ModuleDefinitions_DefaultCacheTime]  DEFAULT ((0)) FOR [DefaultCacheTime]
GO
ALTER TABLE [dbo].[Modules] ADD  CONSTRAINT [DF_Modules_AllTabs]  DEFAULT ((0)) FOR [AllTabs]
GO
ALTER TABLE [dbo].[Modules] ADD  CONSTRAINT [DF_Modules_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Modules] ADD  CONSTRAINT [DF_Modules_CreatedOnDate]  DEFAULT (getdate()) FOR [CreatedOnDate]
GO
ALTER TABLE [dbo].[Modules] ADD  CONSTRAINT [DF_Modules_LastModifiedOnDate]  DEFAULT (getdate()) FOR [LastModifiedOnDate]
GO
ALTER TABLE [dbo].[Modules] ADD  CONSTRAINT [DF_Modules_IsShareable]  DEFAULT ((1)) FOR [IsShareable]
GO
ALTER TABLE [dbo].[Modules] ADD  CONSTRAINT [DF_Modules_IsShareableViewOnly]  DEFAULT ((1)) FOR [IsShareableViewOnly]
GO
ALTER TABLE [dbo].[Packages] ADD  CONSTRAINT [DF_Packages_IsSystemPackage]  DEFAULT ((0)) FOR [IsSystemPackage]
GO
ALTER TABLE [dbo].[PackageTypes] ADD  DEFAULT ((0)) FOR [SupportsSideBySideInstallation]
GO
ALTER TABLE [dbo].[Permission] ADD  CONSTRAINT [DF_Permission_ViewOrder]  DEFAULT ((9999)) FOR [ViewOrder]
GO
ALTER TABLE [dbo].[PortalAlias] ADD  CONSTRAINT [DF_PortalAlias_IsPrimary]  DEFAULT ((0)) FOR [IsPrimary]
GO
ALTER TABLE [dbo].[PortalLanguages] ADD  CONSTRAINT [DF_PortalLanguages_IsPublished]  DEFAULT ((0)) FOR [IsPublished]
GO
ALTER TABLE [dbo].[Portals] ADD  CONSTRAINT [DF_Portals_UserRegistration]  DEFAULT ((0)) FOR [UserRegistration]
GO
ALTER TABLE [dbo].[Portals] ADD  CONSTRAINT [DF_Portals_BannerAdvertising]  DEFAULT ((0)) FOR [BannerAdvertising]
GO
ALTER TABLE [dbo].[Portals] ADD  CONSTRAINT [DF_Portals_HostFee]  DEFAULT ((0)) FOR [HostFee]
GO
ALTER TABLE [dbo].[Portals] ADD  CONSTRAINT [DF_Portals_HostSpace]  DEFAULT ((0)) FOR [HostSpace]
GO
ALTER TABLE [dbo].[Portals] ADD  CONSTRAINT [DF_Portals_GUID]  DEFAULT (newid()) FOR [GUID]
GO
ALTER TABLE [dbo].[Portals] ADD  CONSTRAINT [DF_Portals_DefaultLanguage]  DEFAULT ('en-US') FOR [DefaultLanguage]
GO
ALTER TABLE [dbo].[Portals] ADD  CONSTRAINT [DF_Portals_TimezoneOffset]  DEFAULT ((-8)) FOR [TimezoneOffset]
GO
ALTER TABLE [dbo].[Portals] ADD  CONSTRAINT [DF_Portals_HomeDirectory]  DEFAULT ('') FOR [HomeDirectory]
GO
ALTER TABLE [dbo].[Portals] ADD  CONSTRAINT [DF_Portals_PageQuota]  DEFAULT ((0)) FOR [PageQuota]
GO
ALTER TABLE [dbo].[Portals] ADD  CONSTRAINT [DF_Portals_UserQuota]  DEFAULT ((0)) FOR [UserQuota]
GO
ALTER TABLE [dbo].[ProfilePropertyDefinition] ADD  CONSTRAINT [DF_ProfilePropertyDefinition_Length]  DEFAULT ((0)) FOR [Length]
GO
ALTER TABLE [dbo].[ProfilePropertyDefinition] ADD  CONSTRAINT [DF_ProfilePropertyDefinition_ReadOnly]  DEFAULT ((0)) FOR [ReadOnly]
GO
ALTER TABLE [dbo].[Relationships] ADD  CONSTRAINT [DF_Relationships_CreatedOnDate]  DEFAULT (getdate()) FOR [CreatedOnDate]
GO
ALTER TABLE [dbo].[Relationships] ADD  CONSTRAINT [DF_Relationships_LastModifiedOnDate]  DEFAULT (getdate()) FOR [LastModifiedOnDate]
GO
ALTER TABLE [dbo].[RelationshipTypes] ADD  CONSTRAINT [DF_RelationshipTypes_CreatedOnDate]  DEFAULT (getdate()) FOR [CreatedOnDate]
GO
ALTER TABLE [dbo].[RelationshipTypes] ADD  CONSTRAINT [DF_RelationshipTypes_LastModifiedOnDate]  DEFAULT (getdate()) FOR [LastModifiedOnDate]
GO
ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Roles_ServiceFee]  DEFAULT ((0)) FOR [ServiceFee]
GO
ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Roles_IsPublic]  DEFAULT ((0)) FOR [IsPublic]
GO
ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Roles_AutoAssignment]  DEFAULT ((0)) FOR [AutoAssignment]
GO
ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Roles_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Roles_SecurityMode]  DEFAULT ((0)) FOR [SecurityMode]
GO
ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Roles_IsSystemRole]  DEFAULT ((0)) FOR [IsSystemRole]
GO
ALTER TABLE [dbo].[RoleSettings] ADD  CONSTRAINT [DF_RoleSettings_CreatedOnDate]  DEFAULT (getdate()) FOR [CreatedOnDate]
GO
ALTER TABLE [dbo].[RoleSettings] ADD  CONSTRAINT [DF_RoleSettings_LastModifiedOnDate]  DEFAULT (getdate()) FOR [LastModifiedOnDate]
GO
ALTER TABLE [dbo].[SearchDeletedItems] ADD  DEFAULT (getutcdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[SearchTypes] ADD  CONSTRAINT [DF_SearchTypes_IsPrivate]  DEFAULT ((0)) FOR [IsPrivate]
GO
ALTER TABLE [dbo].[SkinControls] ADD  CONSTRAINT [DF_SkinControls_PackageID]  DEFAULT ((-1)) FOR [PackageID]
GO
ALTER TABLE [dbo].[SkinControls] ADD  CONSTRAINT [DF_SkinControls_SupportsPartialRendering]  DEFAULT ((0)) FOR [SupportsPartialRendering]
GO
ALTER TABLE [dbo].[TabModules] ADD  CONSTRAINT [DF_TabModules_DisplayTitle]  DEFAULT ((1)) FOR [DisplayTitle]
GO
ALTER TABLE [dbo].[TabModules] ADD  CONSTRAINT [DF_TabModules_DisplayPrint]  DEFAULT ((1)) FOR [DisplayPrint]
GO
ALTER TABLE [dbo].[TabModules] ADD  CONSTRAINT [DF_TabModules_DisplaySyndicate]  DEFAULT ((1)) FOR [DisplaySyndicate]
GO
ALTER TABLE [dbo].[TabModules] ADD  CONSTRAINT [DF_abModules_IsWebSlice]  DEFAULT ((0)) FOR [IsWebSlice]
GO
ALTER TABLE [dbo].[TabModules] ADD  CONSTRAINT [DF_TabModules_CreatedOnDate]  DEFAULT (getdate()) FOR [CreatedOnDate]
GO
ALTER TABLE [dbo].[TabModules] ADD  CONSTRAINT [DF_TabModules_LastModifiedOnDate]  DEFAULT (getdate()) FOR [LastModifiedOnDate]
GO
ALTER TABLE [dbo].[TabModules] ADD  CONSTRAINT [DF_TabModules_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[TabModules] ADD  CONSTRAINT [DF_TabModules_Guid]  DEFAULT (newid()) FOR [UniqueId]
GO
ALTER TABLE [dbo].[TabModules] ADD  CONSTRAINT [DF_TabModules_VersionGuid]  DEFAULT (newid()) FOR [VersionGuid]
GO
ALTER TABLE [dbo].[TabModules] ADD  CONSTRAINT [DF_TabModules_LocalizedVersionGuid]  DEFAULT (newid()) FOR [LocalizedVersionGuid]
GO
ALTER TABLE [dbo].[Tabs] ADD  CONSTRAINT [DF_Tabs_TabOrder]  DEFAULT ((0)) FOR [TabOrder]
GO
ALTER TABLE [dbo].[Tabs] ADD  CONSTRAINT [DF_Tabs_IsVisible]  DEFAULT ((1)) FOR [IsVisible]
GO
ALTER TABLE [dbo].[Tabs] ADD  CONSTRAINT [DF_Tabs_DisableLink]  DEFAULT ((0)) FOR [DisableLink]
GO
ALTER TABLE [dbo].[Tabs] ADD  CONSTRAINT [DF_Tabs_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Tabs] ADD  CONSTRAINT [DF_Tabs_IsSecure]  DEFAULT ((0)) FOR [IsSecure]
GO
ALTER TABLE [dbo].[Tabs] ADD  CONSTRAINT [DF_Tabs_PermanentRedirect]  DEFAULT ((0)) FOR [PermanentRedirect]
GO
ALTER TABLE [dbo].[Tabs] ADD  CONSTRAINT [DF_Tabs_SiteMapPriority]  DEFAULT ((0.5)) FOR [SiteMapPriority]
GO
ALTER TABLE [dbo].[Tabs] ADD  CONSTRAINT [DF_Tabs_Guid]  DEFAULT (newid()) FOR [UniqueId]
GO
ALTER TABLE [dbo].[Tabs] ADD  CONSTRAINT [DF_Tabs_VersionGuid]  DEFAULT (newid()) FOR [VersionGuid]
GO
ALTER TABLE [dbo].[Tabs] ADD  CONSTRAINT [DF_Tabs_LocalizedVersionGuid]  DEFAULT (newid()) FOR [LocalizedVersionGuid]
GO
ALTER TABLE [dbo].[Tabs] ADD  CONSTRAINT [DF__Tabs__Level__526429B0]  DEFAULT ((0)) FOR [Level]
GO
ALTER TABLE [dbo].[Tabs] ADD  CONSTRAINT [DF__Tabs__TabPat__53584DE9]  DEFAULT ('') FOR [TabPath]
GO
ALTER TABLE [dbo].[Tabs] ADD  CONSTRAINT [DF_Tabs_HasBeenPublished]  DEFAULT ((0)) FOR [HasBeenPublished]
GO
ALTER TABLE [dbo].[Tabs] ADD  DEFAULT ((0)) FOR [IsSystem]
GO
ALTER TABLE [dbo].[TabUrls] ADD  CONSTRAINT [DF_TabUrls_IsSystem]  DEFAULT ((0)) FOR [IsSystem]
GO
ALTER TABLE [dbo].[Taxonomy_Terms] ADD  CONSTRAINT [DF_Taxonomy_Terms_Weight]  DEFAULT ((0)) FOR [Weight]
GO
ALTER TABLE [dbo].[Taxonomy_Terms] ADD  CONSTRAINT [DF_Taxonomy_Terms_TermLeft]  DEFAULT ((0)) FOR [TermLeft]
GO
ALTER TABLE [dbo].[Taxonomy_Terms] ADD  CONSTRAINT [DF_Taxonomy_Terms_TermRight]  DEFAULT ((0)) FOR [TermRight]
GO
ALTER TABLE [dbo].[Taxonomy_Vocabularies] ADD  CONSTRAINT [DF_Taxonomy_Vocabularies_Weight]  DEFAULT ((0)) FOR [Weight]
GO
ALTER TABLE [dbo].[Taxonomy_Vocabularies] ADD  CONSTRAINT [DF_Taxonomy_Vocabularies_IsSystem]  DEFAULT ((0)) FOR [IsSystem]
GO
ALTER TABLE [dbo].[UrlTracking] ADD  CONSTRAINT [DF_UrlTracking_TrackClicks]  DEFAULT ((1)) FOR [TrackClicks]
GO
ALTER TABLE [dbo].[UrlTracking] ADD  CONSTRAINT [DF_UrlTracking_NewWindow]  DEFAULT ((0)) FOR [NewWindow]
GO
ALTER TABLE [dbo].[UserPortals] ADD  CONSTRAINT [DF_UserPortals_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[UserPortals] ADD  CONSTRAINT [DF_UserPortals_Authorised]  DEFAULT ((1)) FOR [Authorised]
GO
ALTER TABLE [dbo].[UserPortals] ADD  CONSTRAINT [DF_UserPortals_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[UserPortals] ADD  CONSTRAINT [DF_UserPortals_RefreshRoles]  DEFAULT ((0)) FOR [RefreshRoles]
GO
ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF__UserP__Visib__1352D76D]  DEFAULT ((0)) FOR [Visibility]
GO
ALTER TABLE [dbo].[UserRelationshipPreferences] ADD  CONSTRAINT [DF_UserRelationshipPreferences_CreatedOnDate]  DEFAULT (getdate()) FOR [CreatedOnDate]
GO
ALTER TABLE [dbo].[UserRelationshipPreferences] ADD  CONSTRAINT [DF_UserRelationshipPreferences_LastModifiedOnDate]  DEFAULT (getdate()) FOR [LastModifiedOnDate]
GO
ALTER TABLE [dbo].[UserRelationships] ADD  CONSTRAINT [DF_UserRelationships_CreatedOnDate]  DEFAULT (getdate()) FOR [CreatedOnDate]
GO
ALTER TABLE [dbo].[UserRelationships] ADD  CONSTRAINT [DF_UserRelationships_LastModifiedOnDate]  DEFAULT (getdate()) FOR [LastModifiedOnDate]
GO
ALTER TABLE [dbo].[UserRoles] ADD  CONSTRAINT [DF_UserRoles_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[UserRoles] ADD  CONSTRAINT [DF_UserRoles_IsOwner]  DEFAULT ((0)) FOR [IsOwner]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsSuperUser]  DEFAULT ((0)) FOR [IsSuperUser]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_DisplayName]  DEFAULT ('') FOR [DisplayName]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_UpdatePassword]  DEFAULT ((0)) FOR [UpdatePassword]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[UsersOnline] ADD  CONSTRAINT [DF__Users__Creat__3BFFE745]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[UsersOnline] ADD  CONSTRAINT [DF__Users__LastA__3CF40B7E]  DEFAULT (getdate()) FOR [LastActiveDate]
GO
ALTER TABLE [dbo].[Vendors] ADD  CONSTRAINT [DF_Vendors_ClickThroughs]  DEFAULT ((0)) FOR [ClickThroughs]
GO
ALTER TABLE [dbo].[Vendors] ADD  CONSTRAINT [DF_Vendors_Views]  DEFAULT ((0)) FOR [Views]
GO
ALTER TABLE [dbo].[Vendors] ADD  CONSTRAINT [DF_Vendors_Authorized]  DEFAULT ((1)) FOR [Authorized]
GO
ALTER TABLE [dbo].[WebServers] ADD  CONSTRAINT [DF_WebServers_IISAppName]  DEFAULT ('') FOR [IISAppName]
GO
ALTER TABLE [dbo].[WebServers] ADD  CONSTRAINT [DF_WebServers_Enabled]  DEFAULT ((1)) FOR [Enabled]
GO
ALTER TABLE [dbo].[WebServers] ADD  DEFAULT ((0)) FOR [PingFailureCount]
GO
ALTER TABLE [dbo].[Affiliates]  WITH CHECK ADD  CONSTRAINT [FK_Affiliates_Vendors] FOREIGN KEY([VendorId])
REFERENCES [dbo].[Vendors] ([VendorId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Affiliates] CHECK CONSTRAINT [FK_Affiliates_Vendors]
GO
ALTER TABLE [dbo].[AnonymousUsers]  WITH CHECK ADD  CONSTRAINT [FK_AnonymousUsers_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AnonymousUsers] CHECK CONSTRAINT [FK_AnonymousUsers_Portals]
GO
ALTER TABLE [dbo].[aspnet_Membership]  WITH CHECK ADD FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[aspnet_Membership]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[aspnet_Users] ([UserId])
GO
ALTER TABLE [dbo].[aspnet_Users]  WITH CHECK ADD FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[Assemblies]  WITH CHECK ADD  CONSTRAINT [FK_PackageAssemblies_PackageAssemblies] FOREIGN KEY([PackageID])
REFERENCES [dbo].[Packages] ([PackageID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Assemblies] CHECK CONSTRAINT [FK_PackageAssemblies_PackageAssemblies]
GO
ALTER TABLE [dbo].[Authentication]  WITH NOCHECK ADD  CONSTRAINT [FK_Authentication_Packages] FOREIGN KEY([PackageID])
REFERENCES [dbo].[Packages] ([PackageID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Authentication] CHECK CONSTRAINT [FK_Authentication_Packages]
GO
ALTER TABLE [dbo].[Banners]  WITH CHECK ADD  CONSTRAINT [FK_Banner_Vendor] FOREIGN KEY([VendorId])
REFERENCES [dbo].[Vendors] ([VendorId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Banners] CHECK CONSTRAINT [FK_Banner_Vendor]
GO
ALTER TABLE [dbo].[Classification]  WITH CHECK ADD  CONSTRAINT [FK_Classification_Classification] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Classification] ([ClassificationId])
GO
ALTER TABLE [dbo].[Classification] CHECK CONSTRAINT [FK_Classification_Classification]
GO
ALTER TABLE [dbo].[ContentItems]  WITH CHECK ADD  CONSTRAINT [FK_ContentItems_ContentTypes] FOREIGN KEY([ContentTypeID])
REFERENCES [dbo].[ContentTypes] ([ContentTypeID])
GO
ALTER TABLE [dbo].[ContentItems] CHECK CONSTRAINT [FK_ContentItems_ContentTypes]
GO
ALTER TABLE [dbo].[ContentItems]  WITH CHECK ADD  CONSTRAINT [FK_ContentItems_ContentWorkflowStates] FOREIGN KEY([StateID])
REFERENCES [dbo].[ContentWorkflowStates] ([StateID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[ContentItems] CHECK CONSTRAINT [FK_ContentItems_ContentWorkflowStates]
GO
ALTER TABLE [dbo].[ContentItems_MetaData]  WITH NOCHECK ADD  CONSTRAINT [FK_ContentItems_MetaData_ContentItems] FOREIGN KEY([ContentItemID])
REFERENCES [dbo].[ContentItems] ([ContentItemID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ContentItems_MetaData] CHECK CONSTRAINT [FK_ContentItems_MetaData_ContentItems]
GO
ALTER TABLE [dbo].[ContentItems_MetaData]  WITH NOCHECK ADD  CONSTRAINT [FK_ContentItems_MetaDataMetaData] FOREIGN KEY([MetaDataID])
REFERENCES [dbo].[MetaData] ([MetaDataID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ContentItems_MetaData] CHECK CONSTRAINT [FK_ContentItems_MetaDataMetaData]
GO
ALTER TABLE [dbo].[ContentItems_Tags]  WITH CHECK ADD  CONSTRAINT [FK_ContentItems_Tags_ContentItems] FOREIGN KEY([ContentItemID])
REFERENCES [dbo].[ContentItems] ([ContentItemID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ContentItems_Tags] CHECK CONSTRAINT [FK_ContentItems_Tags_ContentItems]
GO
ALTER TABLE [dbo].[ContentItems_Tags]  WITH CHECK ADD  CONSTRAINT [FK_ContentItems_Tags_Taxonomy_Terms] FOREIGN KEY([TermID])
REFERENCES [dbo].[Taxonomy_Terms] ([TermID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ContentItems_Tags] CHECK CONSTRAINT [FK_ContentItems_Tags_Taxonomy_Terms]
GO
ALTER TABLE [dbo].[ContentWorkflowActions]  WITH CHECK ADD  CONSTRAINT [FK_ContentWorkflowActions_ContentTypes] FOREIGN KEY([ContentTypeId])
REFERENCES [dbo].[ContentTypes] ([ContentTypeID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ContentWorkflowActions] CHECK CONSTRAINT [FK_ContentWorkflowActions_ContentTypes]
GO
ALTER TABLE [dbo].[ContentWorkflowLogs]  WITH CHECK ADD  CONSTRAINT [FK_ContentWorkflowLogs_ContentItems] FOREIGN KEY([ContentItemID])
REFERENCES [dbo].[ContentItems] ([ContentItemID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ContentWorkflowLogs] CHECK CONSTRAINT [FK_ContentWorkflowLogs_ContentItems]
GO
ALTER TABLE [dbo].[ContentWorkflowLogs]  WITH CHECK ADD  CONSTRAINT [FK_ContentWorkflowLogs_ContentWorkflows] FOREIGN KEY([WorkflowID])
REFERENCES [dbo].[ContentWorkflows] ([WorkflowID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ContentWorkflowLogs] CHECK CONSTRAINT [FK_ContentWorkflowLogs_ContentWorkflows]
GO
ALTER TABLE [dbo].[ContentWorkflowSources]  WITH CHECK ADD  CONSTRAINT [FK_ContentWorkflowSources_ContentWorkflows] FOREIGN KEY([WorkflowID])
REFERENCES [dbo].[ContentWorkflows] ([WorkflowID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ContentWorkflowSources] CHECK CONSTRAINT [FK_ContentWorkflowSources_ContentWorkflows]
GO
ALTER TABLE [dbo].[ContentWorkflowStatePermission]  WITH CHECK ADD  CONSTRAINT [FK_ContentWorkflowStatePermission_ContentWorkflowStates] FOREIGN KEY([StateID])
REFERENCES [dbo].[ContentWorkflowStates] ([StateID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ContentWorkflowStatePermission] CHECK CONSTRAINT [FK_ContentWorkflowStatePermission_ContentWorkflowStates]
GO
ALTER TABLE [dbo].[ContentWorkflowStatePermission]  WITH CHECK ADD  CONSTRAINT [FK_ContentWorkflowStatePermission_Permission] FOREIGN KEY([PermissionID])
REFERENCES [dbo].[Permission] ([PermissionID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ContentWorkflowStatePermission] CHECK CONSTRAINT [FK_ContentWorkflowStatePermission_Permission]
GO
ALTER TABLE [dbo].[ContentWorkflowStatePermission]  WITH CHECK ADD  CONSTRAINT [FK_ContentWorkflowStatePermission_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ContentWorkflowStatePermission] CHECK CONSTRAINT [FK_ContentWorkflowStatePermission_Users]
GO
ALTER TABLE [dbo].[ContentWorkflowStates]  WITH CHECK ADD  CONSTRAINT [FK_ContentWorkflowStates_ContentWorkflows] FOREIGN KEY([WorkflowID])
REFERENCES [dbo].[ContentWorkflows] ([WorkflowID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ContentWorkflowStates] CHECK CONSTRAINT [FK_ContentWorkflowStates_ContentWorkflows]
GO
ALTER TABLE [dbo].[CoreMessaging_MessageAttachments]  WITH CHECK ADD  CONSTRAINT [FK_CoreMessaging_MessageAttachments_CoreMessaging_Messages] FOREIGN KEY([MessageID])
REFERENCES [dbo].[CoreMessaging_Messages] ([MessageID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CoreMessaging_MessageAttachments] CHECK CONSTRAINT [FK_CoreMessaging_MessageAttachments_CoreMessaging_Messages]
GO
ALTER TABLE [dbo].[CoreMessaging_MessageRecipients]  WITH CHECK ADD  CONSTRAINT [FK_CoreMessaging_MessageRecipients_CoreMessaging_Messages] FOREIGN KEY([MessageID])
REFERENCES [dbo].[CoreMessaging_Messages] ([MessageID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CoreMessaging_MessageRecipients] CHECK CONSTRAINT [FK_CoreMessaging_MessageRecipients_CoreMessaging_Messages]
GO
ALTER TABLE [dbo].[CoreMessaging_Messages]  WITH NOCHECK ADD  CONSTRAINT [FK_CoreMessaging_Messages_CoreMessaging_NotificationTypes] FOREIGN KEY([NotificationTypeID])
REFERENCES [dbo].[CoreMessaging_NotificationTypes] ([NotificationTypeID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CoreMessaging_Messages] CHECK CONSTRAINT [FK_CoreMessaging_Messages_CoreMessaging_NotificationTypes]
GO
ALTER TABLE [dbo].[CoreMessaging_NotificationTypeActions]  WITH CHECK ADD  CONSTRAINT [FK_CoreMessaging_NotificationTypeActions_CoreMessaging_NotificationTypes] FOREIGN KEY([NotificationTypeID])
REFERENCES [dbo].[CoreMessaging_NotificationTypes] ([NotificationTypeID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CoreMessaging_NotificationTypeActions] CHECK CONSTRAINT [FK_CoreMessaging_NotificationTypeActions_CoreMessaging_NotificationTypes]
GO
ALTER TABLE [dbo].[CoreMessaging_NotificationTypes]  WITH CHECK ADD  CONSTRAINT [FK_CoreMessaging_NotificationTypes_DesktopModules] FOREIGN KEY([DesktopModuleID])
REFERENCES [dbo].[DesktopModules] ([DesktopModuleID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CoreMessaging_NotificationTypes] CHECK CONSTRAINT [FK_CoreMessaging_NotificationTypes_DesktopModules]
GO
ALTER TABLE [dbo].[CoreMessaging_Subscriptions]  WITH CHECK ADD  CONSTRAINT [FK_CoreMessaging_Subscriptions_Modules] FOREIGN KEY([ModuleId])
REFERENCES [dbo].[Modules] ([ModuleID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CoreMessaging_Subscriptions] CHECK CONSTRAINT [FK_CoreMessaging_Subscriptions_Modules]
GO
ALTER TABLE [dbo].[CoreMessaging_Subscriptions]  WITH CHECK ADD  CONSTRAINT [FK_CoreMessaging_Subscriptions_Portals] FOREIGN KEY([PortalId])
REFERENCES [dbo].[Portals] ([PortalID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CoreMessaging_Subscriptions] CHECK CONSTRAINT [FK_CoreMessaging_Subscriptions_Portals]
GO
ALTER TABLE [dbo].[CoreMessaging_Subscriptions]  WITH CHECK ADD  CONSTRAINT [FK_CoreMessaging_Subscriptions_Subscriptions_Type] FOREIGN KEY([SubscriptionTypeId])
REFERENCES [dbo].[CoreMessaging_SubscriptionTypes] ([SubscriptionTypeId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CoreMessaging_Subscriptions] CHECK CONSTRAINT [FK_CoreMessaging_Subscriptions_Subscriptions_Type]
GO
ALTER TABLE [dbo].[CoreMessaging_Subscriptions]  WITH CHECK ADD  CONSTRAINT [FK_CoreMessaging_Subscriptions_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CoreMessaging_Subscriptions] CHECK CONSTRAINT [FK_CoreMessaging_Subscriptions_Users]
GO
ALTER TABLE [dbo].[Dashboard_Controls]  WITH NOCHECK ADD  CONSTRAINT [FK_Dashboard_Controls_Packages] FOREIGN KEY([PackageID])
REFERENCES [dbo].[Packages] ([PackageID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Dashboard_Controls] CHECK CONSTRAINT [FK_Dashboard_Controls_Packages]
GO
ALTER TABLE [dbo].[DesktopModulePermission]  WITH NOCHECK ADD  CONSTRAINT [FK_DesktopModulePermission_Permission] FOREIGN KEY([PermissionID])
REFERENCES [dbo].[Permission] ([PermissionID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DesktopModulePermission] CHECK CONSTRAINT [FK_DesktopModulePermission_Permission]
GO
ALTER TABLE [dbo].[DesktopModulePermission]  WITH CHECK ADD  CONSTRAINT [FK_DesktopModulePermission_PortalDesktopModules] FOREIGN KEY([PortalDesktopModuleID])
REFERENCES [dbo].[PortalDesktopModules] ([PortalDesktopModuleID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DesktopModulePermission] CHECK CONSTRAINT [FK_DesktopModulePermission_PortalDesktopModules]
GO
ALTER TABLE [dbo].[DesktopModulePermission]  WITH CHECK ADD  CONSTRAINT [FK_DesktopModulePermission_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([RoleID])
GO
ALTER TABLE [dbo].[DesktopModulePermission] CHECK CONSTRAINT [FK_DesktopModulePermission_Roles]
GO
ALTER TABLE [dbo].[DesktopModulePermission]  WITH CHECK ADD  CONSTRAINT [FK_DesktopModulePermission_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DesktopModulePermission] CHECK CONSTRAINT [FK_DesktopModulePermission_Users]
GO
ALTER TABLE [dbo].[DesktopModules]  WITH NOCHECK ADD  CONSTRAINT [FK_DesktopModules_Packages] FOREIGN KEY([PackageID])
REFERENCES [dbo].[Packages] ([PackageID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DesktopModules] CHECK CONSTRAINT [FK_DesktopModules_Packages]
GO
ALTER TABLE [dbo].[EventLog]  WITH NOCHECK ADD  CONSTRAINT [FK_EventLog_EventLogConfig] FOREIGN KEY([LogConfigID])
REFERENCES [dbo].[EventLogConfig] ([ID])
GO
ALTER TABLE [dbo].[EventLog] CHECK CONSTRAINT [FK_EventLog_EventLogConfig]
GO
ALTER TABLE [dbo].[EventLog]  WITH NOCHECK ADD  CONSTRAINT [FK_EventLog_EventLogTypes] FOREIGN KEY([LogTypeKey])
REFERENCES [dbo].[EventLogTypes] ([LogTypeKey])
GO
ALTER TABLE [dbo].[EventLog] CHECK CONSTRAINT [FK_EventLog_EventLogTypes]
GO
ALTER TABLE [dbo].[EventLogConfig]  WITH NOCHECK ADD  CONSTRAINT [FK_EventLogConfig_EventLogTypes] FOREIGN KEY([LogTypeKey])
REFERENCES [dbo].[EventLogTypes] ([LogTypeKey])
GO
ALTER TABLE [dbo].[EventLogConfig] CHECK CONSTRAINT [FK_EventLogConfig_EventLogTypes]
GO
ALTER TABLE [dbo].[ExceptionEvents]  WITH CHECK ADD  CONSTRAINT [FK_ExceptionEvents_LogEventId] FOREIGN KEY([LogEventID])
REFERENCES [dbo].[EventLog] ([LogEventID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ExceptionEvents] CHECK CONSTRAINT [FK_ExceptionEvents_LogEventId]
GO
ALTER TABLE [dbo].[Files]  WITH CHECK ADD  CONSTRAINT [FK_Files_ContentItems] FOREIGN KEY([ContentItemID])
REFERENCES [dbo].[ContentItems] ([ContentItemID])
GO
ALTER TABLE [dbo].[Files] CHECK CONSTRAINT [FK_Files_ContentItems]
GO
ALTER TABLE [dbo].[Files]  WITH CHECK ADD  CONSTRAINT [FK_Files_Folders] FOREIGN KEY([FolderID])
REFERENCES [dbo].[Folders] ([FolderID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Files] CHECK CONSTRAINT [FK_Files_Folders]
GO
ALTER TABLE [dbo].[Files]  WITH CHECK ADD  CONSTRAINT [FK_Files_Portals] FOREIGN KEY([PortalId])
REFERENCES [dbo].[Portals] ([PortalID])
GO
ALTER TABLE [dbo].[Files] CHECK CONSTRAINT [FK_Files_Portals]
GO
ALTER TABLE [dbo].[FileVersions]  WITH CHECK ADD  CONSTRAINT [FK_FileVersions_Files] FOREIGN KEY([FileId])
REFERENCES [dbo].[Files] ([FileId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FileVersions] CHECK CONSTRAINT [FK_FileVersions_Files]
GO
ALTER TABLE [dbo].[FolderMappings]  WITH CHECK ADD  CONSTRAINT [FK_FolderMappings_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FolderMappings] CHECK CONSTRAINT [FK_FolderMappings_Portals]
GO
ALTER TABLE [dbo].[FolderMappingsSettings]  WITH NOCHECK ADD  CONSTRAINT [FK_FolderMappingsSettings_FolderMappings] FOREIGN KEY([FolderMappingID])
REFERENCES [dbo].[FolderMappings] ([FolderMappingID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FolderMappingsSettings] CHECK CONSTRAINT [FK_FolderMappingsSettings_FolderMappings]
GO
ALTER TABLE [dbo].[FolderPermission]  WITH CHECK ADD  CONSTRAINT [FK_FolderPermission_Folders] FOREIGN KEY([FolderID])
REFERENCES [dbo].[Folders] ([FolderID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FolderPermission] CHECK CONSTRAINT [FK_FolderPermission_Folders]
GO
ALTER TABLE [dbo].[FolderPermission]  WITH NOCHECK ADD  CONSTRAINT [FK_FolderPermission_Permission] FOREIGN KEY([PermissionID])
REFERENCES [dbo].[Permission] ([PermissionID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FolderPermission] CHECK CONSTRAINT [FK_FolderPermission_Permission]
GO
ALTER TABLE [dbo].[FolderPermission]  WITH CHECK ADD  CONSTRAINT [FK_FolderPermission_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([RoleID])
GO
ALTER TABLE [dbo].[FolderPermission] CHECK CONSTRAINT [FK_FolderPermission_Roles]
GO
ALTER TABLE [dbo].[FolderPermission]  WITH CHECK ADD  CONSTRAINT [FK_FolderPermission_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FolderPermission] CHECK CONSTRAINT [FK_FolderPermission_Users]
GO
ALTER TABLE [dbo].[Folders]  WITH CHECK ADD  CONSTRAINT [FK_Folders_ContentWorkflows] FOREIGN KEY([WorkflowID])
REFERENCES [dbo].[ContentWorkflows] ([WorkflowID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Folders] CHECK CONSTRAINT [FK_Folders_ContentWorkflows]
GO
ALTER TABLE [dbo].[Folders]  WITH CHECK ADD  CONSTRAINT [FK_Folders_FolderMappings] FOREIGN KEY([FolderMappingID])
REFERENCES [dbo].[FolderMappings] ([FolderMappingID])
GO
ALTER TABLE [dbo].[Folders] CHECK CONSTRAINT [FK_Folders_FolderMappings]
GO
ALTER TABLE [dbo].[Folders]  WITH CHECK ADD  CONSTRAINT [FK_Folders_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Folders] CHECK CONSTRAINT [FK_Folders_Portals]
GO
ALTER TABLE [dbo].[HtmlText]  WITH NOCHECK ADD  CONSTRAINT [FK_HtmlText_Modules] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[Modules] ([ModuleID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HtmlText] CHECK CONSTRAINT [FK_HtmlText_Modules]
GO
ALTER TABLE [dbo].[HtmlText]  WITH NOCHECK ADD  CONSTRAINT [FK_HtmlText_WorkflowStates] FOREIGN KEY([StateID])
REFERENCES [dbo].[WorkflowStates] ([StateID])
GO
ALTER TABLE [dbo].[HtmlText] CHECK CONSTRAINT [FK_HtmlText_WorkflowStates]
GO
ALTER TABLE [dbo].[HtmlTextLog]  WITH NOCHECK ADD  CONSTRAINT [FK_HtmlTextLog_HtmlText] FOREIGN KEY([ItemID])
REFERENCES [dbo].[HtmlText] ([ItemID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HtmlTextLog] CHECK CONSTRAINT [FK_HtmlTextLog_HtmlText]
GO
ALTER TABLE [dbo].[HtmlTextLog]  WITH NOCHECK ADD  CONSTRAINT [FK_HtmlTextLog_WorkflowStates] FOREIGN KEY([StateID])
REFERENCES [dbo].[WorkflowStates] ([StateID])
GO
ALTER TABLE [dbo].[HtmlTextLog] CHECK CONSTRAINT [FK_HtmlTextLog_WorkflowStates]
GO
ALTER TABLE [dbo].[HtmlTextUsers]  WITH NOCHECK ADD  CONSTRAINT [FK_HtmlTextUsers_HtmlText] FOREIGN KEY([ItemID])
REFERENCES [dbo].[HtmlText] ([ItemID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HtmlTextUsers] CHECK CONSTRAINT [FK_HtmlTextUsers_HtmlText]
GO
ALTER TABLE [dbo].[JavaScriptLibraries]  WITH CHECK ADD  CONSTRAINT [FK_JavaScriptLibrariesPackages] FOREIGN KEY([PackageID])
REFERENCES [dbo].[Packages] ([PackageID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[JavaScriptLibraries] CHECK CONSTRAINT [FK_JavaScriptLibrariesPackages]
GO
ALTER TABLE [dbo].[Journal]  WITH NOCHECK ADD  CONSTRAINT [FK_Journal_JournalTypes] FOREIGN KEY([JournalTypeId])
REFERENCES [dbo].[Journal_Types] ([JournalTypeId])
GO
ALTER TABLE [dbo].[Journal] NOCHECK CONSTRAINT [FK_Journal_JournalTypes]
GO
ALTER TABLE [dbo].[Journal_Comments]  WITH NOCHECK ADD  CONSTRAINT [FK_JournalComments_Journal] FOREIGN KEY([JournalId])
REFERENCES [dbo].[Journal] ([JournalId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Journal_Comments] NOCHECK CONSTRAINT [FK_JournalComments_Journal]
GO
ALTER TABLE [dbo].[Journal_Data]  WITH NOCHECK ADD  CONSTRAINT [FK_Journal_Data_Journal] FOREIGN KEY([JournalId])
REFERENCES [dbo].[Journal] ([JournalId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Journal_Data] NOCHECK CONSTRAINT [FK_Journal_Data_Journal]
GO
ALTER TABLE [dbo].[LanguagePacks]  WITH NOCHECK ADD  CONSTRAINT [FK_LanguagePacks_Packages] FOREIGN KEY([PackageID])
REFERENCES [dbo].[Packages] ([PackageID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LanguagePacks] CHECK CONSTRAINT [FK_LanguagePacks_Packages]
GO
ALTER TABLE [dbo].[Mobile_PreviewProfiles]  WITH CHECK ADD  CONSTRAINT [FK_Mobile_PreviewProfiles_Portals] FOREIGN KEY([PortalId])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Mobile_PreviewProfiles] CHECK CONSTRAINT [FK_Mobile_PreviewProfiles_Portals]
GO
ALTER TABLE [dbo].[Mobile_RedirectionRules]  WITH CHECK ADD  CONSTRAINT [FK_Mobile_RedirectionRules_Mobile_Redirections] FOREIGN KEY([RedirectionId])
REFERENCES [dbo].[Mobile_Redirections] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Mobile_RedirectionRules] CHECK CONSTRAINT [FK_Mobile_RedirectionRules_Mobile_Redirections]
GO
ALTER TABLE [dbo].[Mobile_Redirections]  WITH CHECK ADD  CONSTRAINT [FK_Mobile_Redirections_Portals] FOREIGN KEY([PortalId])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Mobile_Redirections] CHECK CONSTRAINT [FK_Mobile_Redirections_Portals]
GO
ALTER TABLE [dbo].[ModuleControls]  WITH CHECK ADD  CONSTRAINT [FK_ModuleControls_ModuleDefinitions] FOREIGN KEY([ModuleDefID])
REFERENCES [dbo].[ModuleDefinitions] ([ModuleDefID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ModuleControls] CHECK CONSTRAINT [FK_ModuleControls_ModuleDefinitions]
GO
ALTER TABLE [dbo].[ModuleDefinitions]  WITH NOCHECK ADD  CONSTRAINT [FK_ModuleDefinitions_DesktopModules] FOREIGN KEY([DesktopModuleID])
REFERENCES [dbo].[DesktopModules] ([DesktopModuleID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ModuleDefinitions] CHECK CONSTRAINT [FK_ModuleDefinitions_DesktopModules]
GO
ALTER TABLE [dbo].[ModulePermission]  WITH NOCHECK ADD  CONSTRAINT [FK_ModulePermission_Modules] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[Modules] ([ModuleID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ModulePermission] CHECK CONSTRAINT [FK_ModulePermission_Modules]
GO
ALTER TABLE [dbo].[ModulePermission]  WITH NOCHECK ADD  CONSTRAINT [FK_ModulePermission_Permission] FOREIGN KEY([PermissionID])
REFERENCES [dbo].[Permission] ([PermissionID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ModulePermission] CHECK CONSTRAINT [FK_ModulePermission_Permission]
GO
ALTER TABLE [dbo].[ModulePermission]  WITH CHECK ADD  CONSTRAINT [FK_ModulePermission_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([RoleID])
GO
ALTER TABLE [dbo].[ModulePermission] CHECK CONSTRAINT [FK_ModulePermission_Roles]
GO
ALTER TABLE [dbo].[ModulePermission]  WITH CHECK ADD  CONSTRAINT [FK_ModulePermission_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ModulePermission] CHECK CONSTRAINT [FK_ModulePermission_Users]
GO
ALTER TABLE [dbo].[Modules]  WITH CHECK ADD  CONSTRAINT [FK_Modules_ContentItems] FOREIGN KEY([ContentItemID])
REFERENCES [dbo].[ContentItems] ([ContentItemID])
GO
ALTER TABLE [dbo].[Modules] CHECK CONSTRAINT [FK_Modules_ContentItems]
GO
ALTER TABLE [dbo].[Modules]  WITH CHECK ADD  CONSTRAINT [FK_Modules_ModuleDefinitions] FOREIGN KEY([ModuleDefID])
REFERENCES [dbo].[ModuleDefinitions] ([ModuleDefID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Modules] CHECK CONSTRAINT [FK_Modules_ModuleDefinitions]
GO
ALTER TABLE [dbo].[ModuleSettings]  WITH CHECK ADD  CONSTRAINT [FK_ModuleSettings_Modules] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[Modules] ([ModuleID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ModuleSettings] CHECK CONSTRAINT [FK_ModuleSettings_Modules]
GO
ALTER TABLE [dbo].[PackageDependencies]  WITH CHECK ADD  CONSTRAINT [FK_PackageDependencies_Packages] FOREIGN KEY([PackageID])
REFERENCES [dbo].[Packages] ([PackageID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PackageDependencies] CHECK CONSTRAINT [FK_PackageDependencies_Packages]
GO
ALTER TABLE [dbo].[Packages]  WITH NOCHECK ADD  CONSTRAINT [FK_Packages_PackageTypes] FOREIGN KEY([PackageType])
REFERENCES [dbo].[PackageTypes] ([PackageType])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Packages] CHECK CONSTRAINT [FK_Packages_PackageTypes]
GO
ALTER TABLE [dbo].[PasswordHistory]  WITH CHECK ADD  CONSTRAINT [FK_PasswordHistory_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PasswordHistory] CHECK CONSTRAINT [FK_PasswordHistory_Users]
GO
ALTER TABLE [dbo].[PortalAlias]  WITH CHECK ADD  CONSTRAINT [FK_PortalAlias_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PortalAlias] CHECK CONSTRAINT [FK_PortalAlias_Portals]
GO
ALTER TABLE [dbo].[PortalDesktopModules]  WITH NOCHECK ADD  CONSTRAINT [FK_PortalDesktopModules_DesktopModules] FOREIGN KEY([DesktopModuleID])
REFERENCES [dbo].[DesktopModules] ([DesktopModuleID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PortalDesktopModules] CHECK CONSTRAINT [FK_PortalDesktopModules_DesktopModules]
GO
ALTER TABLE [dbo].[PortalDesktopModules]  WITH CHECK ADD  CONSTRAINT [FK_PortalDesktopModules_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PortalDesktopModules] CHECK CONSTRAINT [FK_PortalDesktopModules_Portals]
GO
ALTER TABLE [dbo].[PortalLanguages]  WITH NOCHECK ADD  CONSTRAINT [FK_PortalLanguages_PortalLanguages] FOREIGN KEY([LanguageID])
REFERENCES [dbo].[Languages] ([LanguageID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PortalLanguages] CHECK CONSTRAINT [FK_PortalLanguages_PortalLanguages]
GO
ALTER TABLE [dbo].[PortalLanguages]  WITH CHECK ADD  CONSTRAINT [FK_PortalLanguages_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PortalLanguages] CHECK CONSTRAINT [FK_PortalLanguages_Portals]
GO
ALTER TABLE [dbo].[PortalLocalization]  WITH CHECK ADD  CONSTRAINT [FK_PortalLocalization_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PortalLocalization] CHECK CONSTRAINT [FK_PortalLocalization_Portals]
GO
ALTER TABLE [dbo].[PortalSettings]  WITH CHECK ADD  CONSTRAINT [FK_PortalSettings_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PortalSettings] CHECK CONSTRAINT [FK_PortalSettings_Portals]
GO
ALTER TABLE [dbo].[Profile]  WITH CHECK ADD  CONSTRAINT [FK_Profile_Portals] FOREIGN KEY([PortalId])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Profile] CHECK CONSTRAINT [FK_Profile_Portals]
GO
ALTER TABLE [dbo].[Profile]  WITH CHECK ADD  CONSTRAINT [FK_Profile_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Profile] CHECK CONSTRAINT [FK_Profile_Users]
GO
ALTER TABLE [dbo].[ProfilePropertyDefinition]  WITH NOCHECK ADD  CONSTRAINT [FK_ProfilePropertyDefinition_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProfilePropertyDefinition] CHECK CONSTRAINT [FK_ProfilePropertyDefinition_Portals]
GO
ALTER TABLE [dbo].[Relationships]  WITH CHECK ADD  CONSTRAINT [FK_Relationships_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Relationships] CHECK CONSTRAINT [FK_Relationships_Portals]
GO
ALTER TABLE [dbo].[Relationships]  WITH NOCHECK ADD  CONSTRAINT [FK_Relationships_RelationshipTypes] FOREIGN KEY([RelationshipTypeID])
REFERENCES [dbo].[RelationshipTypes] ([RelationshipTypeID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Relationships] CHECK CONSTRAINT [FK_Relationships_RelationshipTypes]
GO
ALTER TABLE [dbo].[Relationships]  WITH CHECK ADD  CONSTRAINT [FK_Relationships_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Relationships] CHECK CONSTRAINT [FK_Relationships_Users]
GO
ALTER TABLE [dbo].[RoleGroups]  WITH CHECK ADD  CONSTRAINT [FK_RoleGroups_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RoleGroups] CHECK CONSTRAINT [FK_RoleGroups_Portals]
GO
ALTER TABLE [dbo].[Roles]  WITH CHECK ADD  CONSTRAINT [FK_Roles_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Roles] CHECK CONSTRAINT [FK_Roles_Portals]
GO
ALTER TABLE [dbo].[Roles]  WITH CHECK ADD  CONSTRAINT [FK_Roles_RoleGroups] FOREIGN KEY([RoleGroupID])
REFERENCES [dbo].[RoleGroups] ([RoleGroupID])
GO
ALTER TABLE [dbo].[Roles] CHECK CONSTRAINT [FK_Roles_RoleGroups]
GO
ALTER TABLE [dbo].[ScheduleHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_ScheduleHistory_Schedule] FOREIGN KEY([ScheduleID])
REFERENCES [dbo].[Schedule] ([ScheduleID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ScheduleHistory] CHECK CONSTRAINT [FK_ScheduleHistory_Schedule]
GO
ALTER TABLE [dbo].[ScheduleItemSettings]  WITH NOCHECK ADD  CONSTRAINT [FK_ScheduleItemSettings_Schedule] FOREIGN KEY([ScheduleID])
REFERENCES [dbo].[Schedule] ([ScheduleID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ScheduleItemSettings] CHECK CONSTRAINT [FK_ScheduleItemSettings_Schedule]
GO
ALTER TABLE [dbo].[SiteLog]  WITH CHECK ADD  CONSTRAINT [FK_SiteLog_Portals] FOREIGN KEY([PortalId])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SiteLog] CHECK CONSTRAINT [FK_SiteLog_Portals]
GO
ALTER TABLE [dbo].[SkinControls]  WITH NOCHECK ADD  CONSTRAINT [FK_SkinControls_Packages] FOREIGN KEY([PackageID])
REFERENCES [dbo].[Packages] ([PackageID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SkinControls] CHECK CONSTRAINT [FK_SkinControls_Packages]
GO
ALTER TABLE [dbo].[SkinPackages]  WITH NOCHECK ADD  CONSTRAINT [FK_SkinPackages_Packages] FOREIGN KEY([PackageID])
REFERENCES [dbo].[Packages] ([PackageID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SkinPackages] CHECK CONSTRAINT [FK_SkinPackages_Packages]
GO
ALTER TABLE [dbo].[Skins]  WITH NOCHECK ADD  CONSTRAINT [FK_Skins_SkinPackages] FOREIGN KEY([SkinPackageID])
REFERENCES [dbo].[SkinPackages] ([SkinPackageID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Skins] CHECK CONSTRAINT [FK_Skins_SkinPackages]
GO
ALTER TABLE [dbo].[SMS_ITEMS_BARCODE_DATA]  WITH CHECK ADD  CONSTRAINT [FK_SMS_ITEMS_BARCODE_DATA_SMS_REGISTERED_ITEMS] FOREIGN KEY([item_id])
REFERENCES [dbo].[SMS_REGISTERED_ITEMS] ([item_id])
GO
ALTER TABLE [dbo].[SMS_ITEMS_BARCODE_DATA] CHECK CONSTRAINT [FK_SMS_ITEMS_BARCODE_DATA_SMS_REGISTERED_ITEMS]
GO
ALTER TABLE [dbo].[SMS_PRODUCT_TRANSACTION]  WITH CHECK ADD  CONSTRAINT [FK_SMS_PRODUCT_TRANSACTION_SMS_REGISTERED_ITEMS] FOREIGN KEY([item_id])
REFERENCES [dbo].[SMS_REGISTERED_ITEMS] ([item_id])
GO
ALTER TABLE [dbo].[SMS_PRODUCT_TRANSACTION] CHECK CONSTRAINT [FK_SMS_PRODUCT_TRANSACTION_SMS_REGISTERED_ITEMS]
GO
ALTER TABLE [dbo].[SMS_PRODUCT_TRANSACTION]  WITH CHECK ADD  CONSTRAINT [FK_SMS_PRODUCT_TRANSACTION_SMS_TRANSACTION] FOREIGN KEY([transaction_id])
REFERENCES [dbo].[SMS_TRANSACTION] ([transaction_id])
GO
ALTER TABLE [dbo].[SMS_PRODUCT_TRANSACTION] CHECK CONSTRAINT [FK_SMS_PRODUCT_TRANSACTION_SMS_TRANSACTION]
GO
ALTER TABLE [dbo].[SMS_PRODUCTS]  WITH CHECK ADD  CONSTRAINT [FK_SMS_PRODUCTS_SMS_CATEGORIES] FOREIGN KEY([category_id])
REFERENCES [dbo].[SMS_CATEGORIES] ([category_id])
GO
ALTER TABLE [dbo].[SMS_PRODUCTS] CHECK CONSTRAINT [FK_SMS_PRODUCTS_SMS_CATEGORIES]
GO
ALTER TABLE [dbo].[SMS_RESTOCKED_PRODUCTS]  WITH CHECK ADD  CONSTRAINT [FK_SMS_RESTOCKED_PRODUCTS_SMS_PRODUCTS] FOREIGN KEY([product_id])
REFERENCES [dbo].[SMS_PRODUCTS] ([product_id])
GO
ALTER TABLE [dbo].[SMS_RESTOCKED_PRODUCTS] CHECK CONSTRAINT [FK_SMS_RESTOCKED_PRODUCTS_SMS_PRODUCTS]
GO
ALTER TABLE [dbo].[SMS_RETURNED_ITEMS]  WITH CHECK ADD  CONSTRAINT [FK_SMS_RETURNED_ITEMS_SMS_REGISTERED_ITEMS] FOREIGN KEY([item_id])
REFERENCES [dbo].[SMS_REGISTERED_ITEMS] ([item_id])
GO
ALTER TABLE [dbo].[SMS_RETURNED_ITEMS] CHECK CONSTRAINT [FK_SMS_RETURNED_ITEMS_SMS_REGISTERED_ITEMS]
GO
ALTER TABLE [dbo].[SMS_SUPPLIED_PRODUCTS]  WITH CHECK ADD  CONSTRAINT [FK_SMS_SUPPLIED_PRODUCTS_SMS_PRODUCTS] FOREIGN KEY([product_id])
REFERENCES [dbo].[SMS_PRODUCTS] ([product_id])
GO
ALTER TABLE [dbo].[SMS_SUPPLIED_PRODUCTS] CHECK CONSTRAINT [FK_SMS_SUPPLIED_PRODUCTS_SMS_PRODUCTS]
GO
ALTER TABLE [dbo].[SMS_SUPPLIED_PRODUCTS]  WITH CHECK ADD  CONSTRAINT [FK_SMS_SUPPLIED_PRODUCTS_SMS_SUPPLIERS] FOREIGN KEY([supplier_id])
REFERENCES [dbo].[SMS_SUPPLIERS] ([supplier_id])
GO
ALTER TABLE [dbo].[SMS_SUPPLIED_PRODUCTS] CHECK CONSTRAINT [FK_SMS_SUPPLIED_PRODUCTS_SMS_SUPPLIERS]
GO
ALTER TABLE [dbo].[SMS_SUPPLIER_PRODUCTS]  WITH CHECK ADD  CONSTRAINT [FK_SMS_SUPPLIER_PRODUCTS_SMS_SUPPLIERS] FOREIGN KEY([supplier_id])
REFERENCES [dbo].[SMS_SUPPLIERS] ([supplier_id])
GO
ALTER TABLE [dbo].[SMS_SUPPLIER_PRODUCTS] CHECK CONSTRAINT [FK_SMS_SUPPLIER_PRODUCTS_SMS_SUPPLIERS]
GO
ALTER TABLE [dbo].[SMS_TRANSACTION_BARCODE_DATA]  WITH CHECK ADD  CONSTRAINT [FK_SMS_TRANSACTION_BARCODE_DATA_SMS_TRANSACTION] FOREIGN KEY([transaction_id])
REFERENCES [dbo].[SMS_TRANSACTION] ([transaction_id])
GO
ALTER TABLE [dbo].[SMS_TRANSACTION_BARCODE_DATA] CHECK CONSTRAINT [FK_SMS_TRANSACTION_BARCODE_DATA_SMS_TRANSACTION]
GO
ALTER TABLE [dbo].[SMS_WAREHOUSE_PRODUCTS]  WITH CHECK ADD  CONSTRAINT [FK_SMS_WAREHOUSE_PRODUCTS_SMS_PRODUCTS] FOREIGN KEY([product_id])
REFERENCES [dbo].[SMS_PRODUCTS] ([product_id])
GO
ALTER TABLE [dbo].[SMS_WAREHOUSE_PRODUCTS] CHECK CONSTRAINT [FK_SMS_WAREHOUSE_PRODUCTS_SMS_PRODUCTS]
GO
ALTER TABLE [dbo].[SMS_WAREHOUSE_PRODUCTS]  WITH CHECK ADD  CONSTRAINT [FK_SMS_WAREHOUSE_PRODUCTS_SMS_WAREHOUSE] FOREIGN KEY([warehouse_id])
REFERENCES [dbo].[SMS_WAREHOUSE] ([warehouse_id])
GO
ALTER TABLE [dbo].[SMS_WAREHOUSE_PRODUCTS] CHECK CONSTRAINT [FK_SMS_WAREHOUSE_PRODUCTS_SMS_WAREHOUSE]
GO
ALTER TABLE [dbo].[SystemMessages]  WITH CHECK ADD  CONSTRAINT [FK_SystemMessages_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SystemMessages] CHECK CONSTRAINT [FK_SystemMessages_Portals]
GO
ALTER TABLE [dbo].[TabModules]  WITH NOCHECK ADD  CONSTRAINT [FK_TabModules_Modules] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[Modules] ([ModuleID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TabModules] CHECK CONSTRAINT [FK_TabModules_Modules]
GO
ALTER TABLE [dbo].[TabModules]  WITH NOCHECK ADD  CONSTRAINT [FK_TabModules_Tabs] FOREIGN KEY([TabID])
REFERENCES [dbo].[Tabs] ([TabID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TabModules] CHECK CONSTRAINT [FK_TabModules_Tabs]
GO
ALTER TABLE [dbo].[TabModuleSettings]  WITH CHECK ADD  CONSTRAINT [FK_TabModuleSettings_TabModules] FOREIGN KEY([TabModuleID])
REFERENCES [dbo].[TabModules] ([TabModuleID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TabModuleSettings] CHECK CONSTRAINT [FK_TabModuleSettings_TabModules]
GO
ALTER TABLE [dbo].[TabPermission]  WITH NOCHECK ADD  CONSTRAINT [FK_TabPermission_Permission] FOREIGN KEY([PermissionID])
REFERENCES [dbo].[Permission] ([PermissionID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TabPermission] CHECK CONSTRAINT [FK_TabPermission_Permission]
GO
ALTER TABLE [dbo].[TabPermission]  WITH CHECK ADD  CONSTRAINT [FK_TabPermission_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([RoleID])
GO
ALTER TABLE [dbo].[TabPermission] CHECK CONSTRAINT [FK_TabPermission_Roles]
GO
ALTER TABLE [dbo].[TabPermission]  WITH NOCHECK ADD  CONSTRAINT [FK_TabPermission_Tabs] FOREIGN KEY([TabID])
REFERENCES [dbo].[Tabs] ([TabID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TabPermission] CHECK CONSTRAINT [FK_TabPermission_Tabs]
GO
ALTER TABLE [dbo].[TabPermission]  WITH CHECK ADD  CONSTRAINT [FK_TabPermission_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TabPermission] CHECK CONSTRAINT [FK_TabPermission_Users]
GO
ALTER TABLE [dbo].[Tabs]  WITH CHECK ADD  CONSTRAINT [FK_Tabs_ContentItems] FOREIGN KEY([ContentItemID])
REFERENCES [dbo].[ContentItems] ([ContentItemID])
GO
ALTER TABLE [dbo].[Tabs] CHECK CONSTRAINT [FK_Tabs_ContentItems]
GO
ALTER TABLE [dbo].[Tabs]  WITH NOCHECK ADD  CONSTRAINT [FK_Tabs_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Tabs] CHECK CONSTRAINT [FK_Tabs_Portals]
GO
ALTER TABLE [dbo].[Tabs]  WITH NOCHECK ADD  CONSTRAINT [FK_Tabs_Tabs] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Tabs] ([TabID])
GO
ALTER TABLE [dbo].[Tabs] CHECK CONSTRAINT [FK_Tabs_Tabs]
GO
ALTER TABLE [dbo].[TabSettings]  WITH NOCHECK ADD  CONSTRAINT [FK_TabSettings_Tabs] FOREIGN KEY([TabID])
REFERENCES [dbo].[Tabs] ([TabID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TabSettings] CHECK CONSTRAINT [FK_TabSettings_Tabs]
GO
ALTER TABLE [dbo].[TabUrls]  WITH CHECK ADD  CONSTRAINT [FK_TabUrls_Tabs] FOREIGN KEY([TabId])
REFERENCES [dbo].[Tabs] ([TabID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TabUrls] CHECK CONSTRAINT [FK_TabUrls_Tabs]
GO
ALTER TABLE [dbo].[TabVersionDetails]  WITH CHECK ADD  CONSTRAINT [FK_TabVersionDetails_TabVersionId] FOREIGN KEY([TabVersionId])
REFERENCES [dbo].[TabVersions] ([TabVersionId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TabVersionDetails] CHECK CONSTRAINT [FK_TabVersionDetails_TabVersionId]
GO
ALTER TABLE [dbo].[TabVersions]  WITH CHECK ADD  CONSTRAINT [FK_TabVersions_TabId] FOREIGN KEY([TabId])
REFERENCES [dbo].[Tabs] ([TabID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TabVersions] CHECK CONSTRAINT [FK_TabVersions_TabId]
GO
ALTER TABLE [dbo].[Taxonomy_Terms]  WITH CHECK ADD  CONSTRAINT [FK_Taxonomy_Terms_Taxonomy_Terms] FOREIGN KEY([ParentTermID])
REFERENCES [dbo].[Taxonomy_Terms] ([TermID])
GO
ALTER TABLE [dbo].[Taxonomy_Terms] CHECK CONSTRAINT [FK_Taxonomy_Terms_Taxonomy_Terms]
GO
ALTER TABLE [dbo].[Taxonomy_Terms]  WITH CHECK ADD  CONSTRAINT [FK_Taxonomy_Terms_Taxonomy_Vocabularies] FOREIGN KEY([VocabularyID])
REFERENCES [dbo].[Taxonomy_Vocabularies] ([VocabularyID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Taxonomy_Terms] CHECK CONSTRAINT [FK_Taxonomy_Terms_Taxonomy_Vocabularies]
GO
ALTER TABLE [dbo].[Taxonomy_Vocabularies]  WITH CHECK ADD  CONSTRAINT [FK_Taxonomy_Vocabularies_Taxonomy_ScopeTypes] FOREIGN KEY([ScopeTypeID])
REFERENCES [dbo].[Taxonomy_ScopeTypes] ([ScopeTypeID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Taxonomy_Vocabularies] CHECK CONSTRAINT [FK_Taxonomy_Vocabularies_Taxonomy_ScopeTypes]
GO
ALTER TABLE [dbo].[Taxonomy_Vocabularies]  WITH CHECK ADD  CONSTRAINT [FK_Taxonomy_Vocabularies_Taxonomy_VocabularyTypes] FOREIGN KEY([VocabularyTypeID])
REFERENCES [dbo].[Taxonomy_VocabularyTypes] ([VocabularyTypeID])
GO
ALTER TABLE [dbo].[Taxonomy_Vocabularies] CHECK CONSTRAINT [FK_Taxonomy_Vocabularies_Taxonomy_VocabularyTypes]
GO
ALTER TABLE [dbo].[UrlLog]  WITH CHECK ADD  CONSTRAINT [FK_UrlLog_UrlTracking] FOREIGN KEY([UrlTrackingID])
REFERENCES [dbo].[UrlTracking] ([UrlTrackingID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UrlLog] CHECK CONSTRAINT [FK_UrlLog_UrlTracking]
GO
ALTER TABLE [dbo].[Urls]  WITH CHECK ADD  CONSTRAINT [FK_Urls_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Urls] CHECK CONSTRAINT [FK_Urls_Portals]
GO
ALTER TABLE [dbo].[UrlTracking]  WITH CHECK ADD  CONSTRAINT [FK_UrlTracking_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UrlTracking] CHECK CONSTRAINT [FK_UrlTracking_Portals]
GO
ALTER TABLE [dbo].[UserAuthentication]  WITH CHECK ADD  CONSTRAINT [FK_UserAuthentication_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserAuthentication] CHECK CONSTRAINT [FK_UserAuthentication_Users]
GO
ALTER TABLE [dbo].[UserPortals]  WITH CHECK ADD  CONSTRAINT [FK_UserPortals_Portals] FOREIGN KEY([PortalId])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserPortals] CHECK CONSTRAINT [FK_UserPortals_Portals]
GO
ALTER TABLE [dbo].[UserPortals]  WITH CHECK ADD  CONSTRAINT [FK_UserPortals_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserPortals] CHECK CONSTRAINT [FK_UserPortals_Users]
GO
ALTER TABLE [dbo].[UserProfile]  WITH NOCHECK ADD  CONSTRAINT [FK_UserProfile_ProfilePropertyDefinition] FOREIGN KEY([PropertyDefinitionID])
REFERENCES [dbo].[ProfilePropertyDefinition] ([PropertyDefinitionID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserProfile] CHECK CONSTRAINT [FK_UserProfile_ProfilePropertyDefinition]
GO
ALTER TABLE [dbo].[UserProfile]  WITH CHECK ADD  CONSTRAINT [FK_UserProfile_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserProfile] CHECK CONSTRAINT [FK_UserProfile_Users]
GO
ALTER TABLE [dbo].[UserRelationshipPreferences]  WITH CHECK ADD  CONSTRAINT [FK_UserRelationshipPreferences_Relationships] FOREIGN KEY([RelationshipID])
REFERENCES [dbo].[Relationships] ([RelationshipID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserRelationshipPreferences] CHECK CONSTRAINT [FK_UserRelationshipPreferences_Relationships]
GO
ALTER TABLE [dbo].[UserRelationshipPreferences]  WITH CHECK ADD  CONSTRAINT [FK_UserRelationshipPreferences_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[UserRelationshipPreferences] CHECK CONSTRAINT [FK_UserRelationshipPreferences_Users]
GO
ALTER TABLE [dbo].[UserRelationships]  WITH CHECK ADD  CONSTRAINT [FK_UserRelationships_Relationships] FOREIGN KEY([RelationshipID])
REFERENCES [dbo].[Relationships] ([RelationshipID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserRelationships] CHECK CONSTRAINT [FK_UserRelationships_Relationships]
GO
ALTER TABLE [dbo].[UserRelationships]  WITH CHECK ADD  CONSTRAINT [FK_UserRelationships_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[UserRelationships] CHECK CONSTRAINT [FK_UserRelationships_Users]
GO
ALTER TABLE [dbo].[UserRelationships]  WITH CHECK ADD  CONSTRAINT [FK_UserRelationships_Users_OnRelatedUser] FOREIGN KEY([RelatedUserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[UserRelationships] CHECK CONSTRAINT [FK_UserRelationships_Users_OnRelatedUser]
GO
ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([RoleID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_Roles]
GO
ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_Users]
GO
ALTER TABLE [dbo].[UsersOnline]  WITH CHECK ADD  CONSTRAINT [FK_UsersOnline_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UsersOnline] CHECK CONSTRAINT [FK_UsersOnline_Portals]
GO
ALTER TABLE [dbo].[UsersOnline]  WITH CHECK ADD  CONSTRAINT [FK_UsersOnline_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UsersOnline] CHECK CONSTRAINT [FK_UsersOnline_Users]
GO
ALTER TABLE [dbo].[VendorClassification]  WITH CHECK ADD  CONSTRAINT [FK_VendorClassification_Classification] FOREIGN KEY([ClassificationId])
REFERENCES [dbo].[Classification] ([ClassificationId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VendorClassification] CHECK CONSTRAINT [FK_VendorClassification_Classification]
GO
ALTER TABLE [dbo].[VendorClassification]  WITH CHECK ADD  CONSTRAINT [FK_VendorClassification_Vendors] FOREIGN KEY([VendorId])
REFERENCES [dbo].[Vendors] ([VendorId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VendorClassification] CHECK CONSTRAINT [FK_VendorClassification_Vendors]
GO
ALTER TABLE [dbo].[Vendors]  WITH CHECK ADD  CONSTRAINT [FK_Vendor_Portals] FOREIGN KEY([PortalId])
REFERENCES [dbo].[Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Vendors] CHECK CONSTRAINT [FK_Vendor_Portals]
GO
ALTER TABLE [dbo].[WorkflowStates]  WITH NOCHECK ADD  CONSTRAINT [FK_WorkflowStates_Workflow] FOREIGN KEY([WorkflowID])
REFERENCES [dbo].[Workflow] ([WorkflowID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WorkflowStates] CHECK CONSTRAINT [FK_WorkflowStates_Workflow]
GO
ALTER TABLE [dbo].[UserRoles]  WITH NOCHECK ADD  CONSTRAINT [CK_UserRoles_RoleId] CHECK  (([RoleId]>=(0)))
GO
ALTER TABLE [dbo].[UserRoles] CHECK CONSTRAINT [CK_UserRoles_RoleId]
GO
USE [master]
GO
ALTER DATABASE [SIMS] SET  READ_WRITE 
GO
