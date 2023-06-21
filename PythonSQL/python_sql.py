#Biblioteca
import pyodbc

#Dados da conexao
dados_conexao = (
    "Driver={ODBC Driver 17 for SQL Server};"
    "Server=mint;"
    "Database=PythonSQL;"
    "UID=sa;"
    "PWD=Kiara05#"
)

#Realizando conexao
conexao = pyodbc.connect(dados_conexao)

print("Conectado")

#Criando cursor
cursor = conexao.cursor()

#SQL
comando = """ 
CREATE TABLE bronze_netflix(
   	show_id      VARCHAR(5) NOT NULL PRIMARY KEY,
	type         VARCHAR(7) NOT NULL,
  	title        VARCHAR(104) NOT NULL,
  	director     VARCHAR(208),
  	desc_cast    VARCHAR(771),
  	country      VARCHAR(123),
	date_added   VARCHAR(19),
  	release_year VARCHAR(6) NOT NULL,
 	rating       VARCHAR(8),
  	duration     VARCHAR(10),
  	listed_in    VARCHAR(79) NOT NULL,
  	description  VARCHAR(248) NOT NULL
);
"""

cursor.execute(comando)
cursor.commit()

