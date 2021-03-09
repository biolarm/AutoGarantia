/*Inserindo dados nas tabelas*/

insert into Marca
values('Chevrolet'),('Volkswagen'),('Fiat'),('Renault'),('Ford'),('Toyota'),('Hyundai'),('Jeep')

declare 
	@id_marca_random	int,
	@auto				varchar(100) = 'Automóvel',
	@count				int = 1 

while (@count <= 10000)
begin
	
	--gravando uma marca aleatoria
	select @id_marca_random  = ceiling(rand() * 8)

	--gravando nome do autmovel
	select @auto = @auto+' - '+convert(varchar(100),@count)

	--inserindo na tabela 
	insert into Automovel
	values(@auto, @id_marca_random)

	select @count = @count+1
	select @auto = 'Automóvel'

end 



