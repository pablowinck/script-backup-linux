# Script de Backup para Linux

### O que o script faz, passo a passo

- Monta a partição
- Realiza o backup, comprimindo os arquivos
- Deleta backups antigos
- Desmonta a partição </br></br>

### Variáveis

1. **PARTICAO** é onde seu HD externo é conectado. </br>
   _Para saber o que colocar, use o comando **df** para identificar seu hd externo._ </br>
2. **PASTA** é onde está salvo os arquivos que você quer fazer o backup </br>
3. **DATA** se refere a data atual, a qual fica no nome do arquivo salvo no hd externo </br>
3. **DIAS** se refere aos arquivos que você quer manter no HD externo, ex: se por 5, o que estiver salvo 5 dias anteriores a rodar o script, e for de extensão .tar.gz, será apagado. </br></br>

### Caminho no HD externo

No seu hd externo, o backup ficará com o seguinte nome: _backup-12-08-2021-15.08.tar.gz_ </br>
Sempre será alterado para data/hora atual.

</br></br>_obs: para ler melhor o script, use a extensão Better Comments no VSCODE_</br>

_obs2: (UBUNTU) você precisa dar sudo su, antes de executar o script_
