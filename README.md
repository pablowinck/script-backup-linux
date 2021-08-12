# Script de Backup para Linux
### O que o script faz, passo a passo
* Monta a partição
* Realiza o backup, comprimindo os arquivos
* Desmonta a partição </br></br>

### Variáveis
1. **PARTICAO** é onde deve ser alterado. Onde seu HD externo é conectado. </br>
*Para saber o que colocar, use o comando **df** para identificar seu hd externo.* </br>
2. **DATA** se refere a data atual, a qual fica no nome do arquivo salvo no hd externo </br></br>

### Caminho no HD externo
No seu hd externo, o backup ficará com o seguinte nome: *backup-12-08-2021-15.08* </br>
Sempre será alterado para data/hora atual.

</br></br>*obs: para ler melhor o script, use a extensão Better Comments no VSCODE*

