USE [master]
GO
/****** Object:  Database [AutoGarantia]    Script Date: 09/03/2021 10:45:00 ******/
CREATE DATABASE [AutoGarantia]
  
GO
ALTER DATABASE [AutoGarantia] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AutoGarantia].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AutoGarantia] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AutoGarantia] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AutoGarantia] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AutoGarantia] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AutoGarantia] SET ARITHABORT OFF 
GO
ALTER DATABASE [AutoGarantia] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [AutoGarantia] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AutoGarantia] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AutoGarantia] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AutoGarantia] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AutoGarantia] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AutoGarantia] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AutoGarantia] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AutoGarantia] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AutoGarantia] SET  ENABLE_BROKER 
GO
ALTER DATABASE [AutoGarantia] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AutoGarantia] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AutoGarantia] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AutoGarantia] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AutoGarantia] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AutoGarantia] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AutoGarantia] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AutoGarantia] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [AutoGarantia] SET  MULTI_USER 
GO
ALTER DATABASE [AutoGarantia] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AutoGarantia] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AutoGarantia] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AutoGarantia] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AutoGarantia] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [AutoGarantia] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [AutoGarantia] SET QUERY_STORE = OFF
GO
USE [AutoGarantia]
GO
/****** Object:  Table [dbo].[Automovel]    Script Date: 09/03/2021 10:45:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Automovel](
	[id_auto] [int] IDENTITY(1,1) NOT NULL,
	[nm_auto] [varchar](100) NULL,
	[id_marca] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_auto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fc_maiuscula]    Script Date: 09/03/2021 10:45:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [dbo].[fc_maiuscula]
(
	@id_auto int
)

returns table

-- select * from fc_maiuscula(null)

as
return
(
	select 
		nm_auto = upper(nm_auto)
	from Automovel
)
	
GO
/****** Object:  Table [dbo].[Log_Automovel]    Script Date: 09/03/2021 10:45:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log_Automovel](
	[id_log] [int] IDENTITY(1,1) NOT NULL,
	[nm_auto] [varchar](100) NULL,
	[dt_registro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_log] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Marca]    Script Date: 09/03/2021 10:45:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Marca](
	[id_marca] [int] IDENTITY(1,1) NOT NULL,
	[nm_marca] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_marca] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Automovel]  WITH CHECK ADD FOREIGN KEY([id_marca])
REFERENCES [dbo].[Marca] ([id_marca])
GO
/****** Object:  StoredProcedure [dbo].[p_alterar_veiculo]    Script Date: 09/03/2021 10:45:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[p_alterar_veiculo]
(
	@id_auto	int,
	@nm_auto	varchar(100),
	@id_marca	int,

	@cd_retorno	int	output, 
	@nm_retorno varchar(300) output
)

/*----------------------------------------------------------------------------------------------------------------------
Procedure:p_alterar_veiculo
Autor: Fabiola Rodrigues 
Objetivo: Aletrar registro na tabela Automovel

Exec: 

declare @cd_retorno int, @nm_retorno varchar(300), @id_veiculo int
exec	p_alterar_veiculo 
			@nm_auto	='Uno usado',
			@id_marca	= 4,
			@id_auto	= 10002,
			@cd_retorno	= @cd_retorno,
			@nm_retorno	= @nm_retorno

--------------------------------------------------------------------------------------------------------------------------*/
as
begin
	begin transaction

	begin try

		if exists(select top 1 1 from Automovel where id_auto = @id_auto)
		begin

			update a 
			set
				nm_auto		= @nm_auto, 
				id_marca	= @id_marca
			from Automovel a
			where id_auto = @id_auto

			select 
				@cd_retorno = 0,
				@nm_retorno	= 'Autmovel alterado com sucesso!'
		end
		else
		begin
			select 
				@cd_retorno = 1,
				@nm_retorno	= 'Automóvel não encontrado!' 
		end
	IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION
			return 

	end try
	begin catch

		select 
			error_procedure() AS ErrorProcedure ,
			error_line() AS ErrorLine ,
			error_message() AS ErrorMessage; 

		IF @@TRANCOUNT > 0  
			ROLLBACK TRANSACTION; 	
	end catch
end
	
GO
/****** Object:  StoredProcedure [dbo].[p_consulta_veiculo]    Script Date: 09/03/2021 10:45:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[p_consulta_veiculo]
(
	@nm_auto	varchar(100),
	@id_marca	int
)

/*----------------------------------------------------------------------------------------------------------------------
Procedure:p_incluir_veiculo
Autor: Fabiola Rodrigues 
Objetivo: Inserir registro na tabela Automovel

Exec: 

exec	p_consulta_veiculo 
			@nm_auto	= 'Uno usado',
			@id_marca	= 4

--------------------------------------------------------------------------------------------------------------------------*/
as

begin
	
	declare @sql nvarchar(max)

	set @sql = '
				select 
					*
				from Automovel a
				where 1=1 
				'
	if @id_marca is not null
	begin
		set @sql = @sql + ' and a.id_marca = @id_marca'
	end

	if @nm_auto is not null
	begin
		set @sql = @sql + ' and a.nm_auto = @nm_auto'
	end

	print @sql

	exec sp_executesql @sql, N'@id_marca int, @nm_auto varchar(100)', @id_marca = @id_marca, @nm_auto = @nm_auto
end
GO
/****** Object:  StoredProcedure [dbo].[p_deletar_veiculo]    Script Date: 09/03/2021 10:45:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[p_deletar_veiculo]
(
	@id_auto	int,

	@cd_retorno	int	output, 
	@nm_retorno varchar(300) output
)

/*----------------------------------------------------------------------------------------------------------------------
Procedure:p_alterar_veiculo
Autor: Fabiola Rodrigues 
Objetivo: Deletar registro na tabela Automovel

Exec: 

declare @cd_retorno int, @nm_retorno varchar(300)
exec	p_deletar_veiculo 
			@id_auto	= 10002,
			@cd_retorno	= @cd_retorno,
			@nm_retorno	= @nm_retorno

--------------------------------------------------------------------------------------------------------------------------*/
as
begin
	begin transaction

	begin try

		if exists(select top 1 1 from Automovel where id_auto = @id_auto)
		begin

			delete from Automovel 
			where id_auto = @id_auto

			select 
				@cd_retorno = 0,
				@nm_retorno	= 'Autmovel deletado com sucesso!' 
		end
		else
		begin
			select 
				@cd_retorno = 1,
				@nm_retorno	= 'Automóvel não existe' 
		end
	IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION; 	
	return
	end try
	begin catch

		select 
			error_procedure() AS ErrorProcedure ,
			error_line() AS ErrorLine ,
			error_message() AS ErrorMessage; 

		IF @@TRANCOUNT > 0  
			ROLLBACK TRANSACTION; 	
	end catch
end
	
GO
/****** Object:  StoredProcedure [dbo].[p_incluir_veiculo]    Script Date: 09/03/2021 10:45:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[p_incluir_veiculo]
(
	@nm_auto	varchar(100),
	@id_marca	int,

	@id_auto int output,
	@cd_retorno	int	output, 
	@nm_retorno varchar(300) output
)

/*----------------------------------------------------------------------------------------------------------------------
Procedure:p_incluir_veiculo
Autor: Fabiola Rodrigues 
Objetivo: Inserir registro na tabela Automovel

Exec: 

declare @cd_retorno int, @nm_retorno varchar(300), @id_auto int
exec	p_incluir_veiculo 
			@nm_auto	='Uno',
			@id_marca	= 4,
			@id_auto	= @id_auto,
			@cd_retorno	= @cd_retorno,
			@nm_retorno	= @nm_retorno

--------------------------------------------------------------------------------------------------------------------------*/
as

begin

	if not exists(select top 1 1 from Automovel where nm_auto = @nm_auto and id_marca = @id_marca)
	begin

		insert into Automovel 
		values(@nm_auto, @id_marca)

		select 
			@cd_retorno = 0,
			@nm_retorno	= 'Autmovel inserido com sucesso!'

		select @id_auto = max(id_auto) from Automovel 

		return 
	end
	else
	begin
		select 
			@cd_retorno = 1,
			@nm_retorno	= 'Automóvel já registrado!'
		return 
	end
end
GO
 
Create Trigger t_log_automovel
on Automovel
for delete
as
declare
	@nm_auto varchar(100)

	select @nm_auto = nm_auto from deleted

	insert into Log_Automovel
	values(@nm_auto, getdate())
 

GO
USE [master]
GO
ALTER DATABASE [AutoGarantia] SET  READ_WRITE 
GO

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
USE [master]
GO
ALTER DATABASE [AutoGarantia] SET  READ_WRITE 
GO