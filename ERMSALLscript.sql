/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2017 (14.0.1000)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/
USE [ERMS]
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 21-06-2021 13:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[CommentsId] [bigint] IDENTITY(1,1) NOT NULL,
	[EmpId] [bigint] NULL,
	[Author] [varchar](max) NULL,
	[Comments] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CommentsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 21-06-2021 13:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmpId] [bigint] IDENTITY(1,1) NOT NULL,
	[EmpName] [varchar](100) NULL,
	[DOJ] [datetime] NULL,
	[JobTitle] [varchar](max) NULL,
	[DepartMent] [varchar](max) NULL,
	[SalaryMonthly] [decimal](18, 2) NULL,
	[SalaryAnnually] [decimal](18, 2) NULL,
	[IsLineManager] [bit] NULL,
	[Address] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[Images] [nvarchar](max) NULL,
	[Location] [varchar](max) NULL,
	[Mobile] [varchar](25) NULL,
	[IsWFH] [bit] NULL,
	[Project] [nvarchar](max) NULL,
	[MstSkill_Id] [bigint] NULL,
	[SkillSets] [nvarchar](max) NULL,
	[InBench] [bit] NULL,
	[ReHired] [bit] NULL,
	[SkillSets2] [nvarchar](max) NULL,
	[HLMgr] [nvarchar](max) NULL,
	[Email] [nvarchar](25) NULL,
	[ExpDetail] [nvarchar](max) NULL,
	[EmpNo] [nvarchar](15) NULL,
	[PortalId] [nvarchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[EmpId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Mst_SKills]    Script Date: 21-06-2021 13:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Mst_SKills](
	[SkillsId] [bigint] IDENTITY(1,1) NOT NULL,
	[SkillName] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[SkillsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 21-06-2021 13:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](100) NULL,
	[Password] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[EmpName] [varchar](100) NULL,
	[Role] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Comments] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Employee] ADD  DEFAULT ((0)) FOR [IsLineManager]
GO
ALTER TABLE [dbo].[Employee] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Employee] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Mst_SKills] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Mst_SKills] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD FOREIGN KEY([EmpId])
REFERENCES [dbo].[Employee] ([EmpId])
GO
/****** Object:  StoredProcedure [dbo].[AddComments]    Script Date: 21-06-2021 13:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[AddComments]
   @CommentsId bigint=0,
   @EmpId bigint,
   @Author varchar(max),
   @Comments nvarchar(max),
   @IsActive bit=1,
  @ErrorMessage varchar(200) out, 
  @Status varchar(10) out 
  as
  begin
  begin try
  begin transaction
       if(@CommentsId=0)
       begin
	     Insert into Comments(EmpId,Author,Comments)values(@EmpId,@Author,@Comments)
		 set @ErrorMessage='Comments Saved Successfully'
			 set @Status='1'  
	   end
	   else	    
		begin 
		  Update Comments set Comments=@Comments,Author=@Author,CreatedDate=GETDATE() where CommentsId=@CommentsId and EmpId=@EmpId
		  set @ErrorMessage='Comments Updated Successfully'
          set @Status='2'
		end 
		commit
 end try
 begin catch
     set @ErrorMessage=ERROR_MESSAGE() 
     set @Status='-1' 
     rollback
 end catch
  end
GO
/****** Object:  StoredProcedure [dbo].[AddEmployee_Details]    Script Date: 21-06-2021 13:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[AddEmployee_Details]
@EmpId bigint=0,
@EmpName varchar(max)='',
@DOJ Datetime=getdate,
@JobTitle varchar(max)='',
@Address nvarchar(max)='',
@DepartMent varchar(max)='',
@SalaryMonthly decimal(18,2)=0,
@SalaryAnnually decimal(18,2)=0,
@IsLineManager bit=0,
@IsActive bit=1,
@ErrorMessage varchar(200) out, 
@Status varchar(10) out 
as
begin
 begin try
  begin transaction
    if(@EmpId=0)
    begin
	     if((select count(*) from Employee where EmpId=@EmpId or UPPER(EmpName)=UPPER(@EmpName))=0)
		 begin
			 Insert into Employee(EmpName,DOJ,JobTitle,DepartMent,SalaryMonthly,SalaryAnnually,IsLineManager,Address)
			 values(@EmpName,@DOJ,@JobTitle,@DepartMent,@SalaryMonthly,@SalaryAnnually,@IsLineManager,@Address)
			 set @ErrorMessage='Employee Details Saved Successfully'
			 set @Status='1'  
	     end
		 else
		 begin
		    set @ErrorMessage='Employee Exists'
			 set @Status='-2'  
		 end
    end
   else
   begin
      Update Employee set EmpName=@EmpName,Address=@Address,DOJ=@DOJ,JobTitle=@JobTitle,
	  DepartMent=@DepartMent,SalaryMonthly=@SalaryMonthly,SalaryAnnually=@SalaryAnnually,
	  IsLineManager=@IsLineManager,IsActive=@IsActive
	  where EmpId=@EmpId
    set @ErrorMessage='Employee Details Updated Successfully'
    set @Status='2'
   end
  commit
 end try
 begin catch
     set @ErrorMessage=ERROR_MESSAGE() 
     set @Status='-1' 
     rollback
 end catch
end
GO
/****** Object:  StoredProcedure [dbo].[Authentication]    Script Date: 21-06-2021 13:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Authentication]
@UserName varchar(100)='',
@Password nvarchar(100)=''
as
begin
  select UserName,EmpName,Isnull(Role,'') as Role,Password from Users where Username=@UserName
end
GO
/****** Object:  StoredProcedure [dbo].[DeleteEmployee]    Script Date: 21-06-2021 13:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[DeleteEmployee]
@EmpId bigint=0,
@ErrorMessage varchar(200)='' out, 
@Status varchar(10)='' out 
as
begin
 begin try
  begin transaction
      Update Employee set IsActive=0 where EmpId=@EmpId
	  set @Status='1' 
  commit
 end try
 begin catch
     set @ErrorMessage=ERROR_MESSAGE() 
     set @Status='-1' 
     rollback
 end catch
end
GO
/****** Object:  StoredProcedure [dbo].[GetAllEmployees]    Script Date: 21-06-2021 13:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetAllEmployees]
@EmpId bigint=0
as
begin
if(@EmpId!=0 or @EmpId>0)
begin
SELECT  ROW_NUMBER() OVER (ORDER BY CreatedDate desc)  as Sno,[EmpId]
      ,[EmpName]
      ,[DOJ]
      ,[JobTitle]
      ,[DepartMent]
      ,[SalaryMonthly]
      ,[SalaryAnnually]
      ,[IsLineManager]
      ,[Address]
      ,[CreatedDate]
      ,[IsActive],isnull(Location,'')as Location,isNull(Images,'')as Images
	  ,isnull([Mobile],'')as Mobile
      ,isnull([IsWFH],0)as IsWFH,HLMgr,Email
      ,[Project]
      ,[MstSkill_Id]
      ,[SkillSets]
      ,[InBench]
      ,[ReHired]
      ,[SkillSets2],[EmpNo],[PortalId],[ExpDetail]
  FROM [ERMS].[dbo].[Employee] where EmpId=@EmpId;
  end
  else
  begin
   SELECT TOP (1000) 
       ROW_NUMBER() OVER (ORDER BY CreatedDate desc)  as Sno,
	   [EmpId]
      ,[EmpName]
      ,[DOJ]
      ,[JobTitle]
      ,[DepartMent]
      ,[SalaryMonthly]
      ,[SalaryAnnually]
      ,[IsLineManager]
      ,[Address]
      ,[CreatedDate]
      ,[IsActive],isnull(Location,'')as Location,isNull(Images,'')as Images
	   ,isnull([Mobile],'')as Mobile
      ,isnull([IsWFH],0)as IsWFH,HLMgr,Email,
      [Project]
      ,[MstSkill_Id]
      ,[SkillSets]
      ,[InBench]
      ,[ReHired]
      ,[SkillSets2],[EmpNo],[PortalId],[ExpDetail]
  FROM [ERMS].[dbo].[Employee] where IsActive=1 order by CreatedDate desc;
  end
end
GO
/****** Object:  StoredProcedure [dbo].[GetComments]    Script Date: 21-06-2021 13:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetComments]
  @CommentsId bigint=0,
  @MinPage bigint=1,
  @MaxPage bigint=10
  as
  begin
  if(@CommentsId=0)
  begin
	SELECT  SNo,CommentsId,EmpName,Author,Comments,CreatedDate,Counts
FROM(select ROW_NUMBER() OVER (ORDER BY c.CommentsId desc) AS SNo,CommentsId,
     EmpName,Author,Comments,c.CreatedDate,(select count(*) from Comments)as Counts   from Employee e
     inner join Comments c on e.EmpId=c.EmpId) AS RowConstrainedResult
WHERE   SNo >=@MinPage
    AND SNo <=@MaxPage
ORDER BY SNo
  end
  else
  begin
     select e.EmpId,CommentsId,EmpName,Author,Comments,c.CreatedDate,(select count(*) from Comments)as Counts from Employee e
    inner join Comments c on e.EmpId=c.EmpId where CommentsId=@CommentsId order by c.CreatedDate desc
  end
  end
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeeProfiles]    Script Date: 21-06-2021 13:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetEmployeeProfiles] ---1,'0',0,0,0
@EmpType bit=0,
@EmpLocation nvarchar(max)='0',
@SkillSetId bigint=0,
@InBench bit=0,
@IsRemoteWork bit=0,
@MinPage bigint=1,
@MaxPage bigint=10
as
begin
SELECT  *
into #temp from
    (select ROW_NUMBER() OVER (ORDER BY createdDate desc) AS SNo,
	   [EmpId]
      ,[EmpName]
      ,[DOJ]
      ,[JobTitle]
      ,[DepartMent]
      ,[SalaryMonthly]
      ,[SalaryAnnually]
      ,[IsLineManager]
      ,[Address]
      ,[CreatedDate]
      ,[IsActive],
	  isnull(Location,'')as Location,isNull(Images,'')as Images
	   ,isnull([Mobile],'')as Mobile
      ,isnull([IsWFH],0)as IsWFH,Email
	   ,HLMgr
      ,[Project]
      ,[MstSkill_Id]
      ,[SkillSets]
      ,[InBench]
      ,[ReHired]
      ,[SkillSets2],[EmpNo],[PortalId],[ExpDetail]
  FROM [ERMS].[dbo].[Employee] with(NoLock)
		 where IsActive=1 and
		 [IsLineManager]=@EmpType
	     and Location like case  when @EmpLocation='0'  then Location else  '%'+@EmpLocation+'%'  end
		 and MstSkill_Id=(case  when @SkillSetId=0  then MstSkill_Id else @SkillSetId end)
	     and InBench=@InBench
		 and IsWFH=@IsRemoteWork	 
		 ) AS ps        
		 select  SNo,
	   [EmpId]
      ,[EmpName]
      ,[DOJ]
      ,[JobTitle]
      ,[DepartMent]
      ,[SalaryMonthly]
      ,[SalaryAnnually]
      ,[IsLineManager]
      ,[Address]
      ,[CreatedDate]
      ,[IsActive],Images,Mobile,IsWFH,Email
	   ,HLMgr
      ,[Project]
      ,[MstSkill_Id]
      ,[SkillSets]
      ,[InBench]
      ,[ReHired]
      ,[SkillSets2],[EmpNo],[PortalId],[ExpDetail],(select count(*) from #temp) as counts from #temp where SNo >=@MinPage
    AND SNo <=@MaxPage
ORDER BY SNo
	   
end
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 21-06-2021 13:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetEmployees] 
@IsLineManager bit=1
as
begin
SELECT  ROW_NUMBER() OVER (ORDER BY CreatedDate desc)  as Sno,[EmpId]
      ,[EmpName]
      ,[DOJ]
      ,[JobTitle]
      ,[DepartMent]
      ,[SalaryMonthly]
      ,[SalaryAnnually]
      ,[IsLineManager]
      ,[Address]
      ,[CreatedDate]
      ,[IsActive],isNull([location],'')as Location,isNull(Images,'')as Images,
	  isnull(Location,'')as Location,isNull(Images,'')as Images
	   ,isnull([Mobile],'')as Mobile
      ,isnull([IsWFH],0)as IsWFH,Email
	   ,HLMgr
      ,[Project]
      ,[MstSkill_Id]
      ,[SkillSets]
      ,[InBench]
      ,[ReHired]
      ,[SkillSets2],[EmpNo],[PortalId],[ExpDetail]
  FROM [ERMS].[dbo].[Employee] ps  with(NOLOCK)
		   where IsLineManager=@IsLineManager and IsActive=1
end
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesFilter]    Script Date: 21-06-2021 13:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetEmployeesFilter] ---0,'','','1753/01/01','1753/01/01'
@EmpId bigint=0,
@JobTitle varchar(max)='',
@DepartMent nvarchar(max)='',
--@Location varchar(max)='',
@StartDate DateTime='1753/01/01',
@EndDate DateTime='1753/01/01'
as
begin
SELECT  ROW_NUMBER() OVER (ORDER BY CreatedDate desc)  as Sno,[EmpId]
      ,[EmpName]
      ,[DOJ]
      ,[JobTitle]
      ,[DepartMent]
      ,[SalaryMonthly]
      ,[SalaryAnnually]
      ,[IsLineManager]
      ,[Address]
      ,[CreatedDate]
      ,[IsActive]
  FROM [ERMS].[dbo].[Employee] ps  with(NOLOCK)
		 where ps.IsActive=1 
		 and ps.EmpId=case when @EmpId=0 then ps.EmpId else @EmpId end
		 and (ps.JobTitle like case  when @JobTitle=''  then ps.JobTitle else  '%'+@JobTitle+'%'  end
	     and (ps.DepartMent like case  when @DepartMent=''  then ps.DepartMent else  '%'+@DepartMent+'%'  end
		 and cast(ps.createddate as date)>= case when cast(@StartDate as date)='1753/01/01'  then cast(ps.createddate as date) else cast(@startdate as date) end
		 and cast(ps.createddate as date)<= case when cast(@EndDate as date)='1753/01/01' then cast(ps.createddate as date) else cast(@enddate as date) end)
	   )
end
GO
/****** Object:  StoredProcedure [dbo].[GetLocations]    Script Date: 21-06-2021 13:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetLocations]
as
begin
 select Location from Employee where Location is not null group by Location
end
GO
/****** Object:  StoredProcedure [dbo].[GetSkillSets]    Script Date: 21-06-2021 13:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GetSkillSets]
as
begin
SELECT TOP (1000) [SkillsId]
      ,[SkillName]
      ,[IsActive]
      ,[CreatedDate] 
  FROM [ERMS].[dbo].[Mst_SKills]  with(NoLock) 
end
GO
