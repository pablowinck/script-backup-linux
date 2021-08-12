# Script de Backup para Linux

### O que o script faz, passo a passo

- Monta a partição
- Realiza o backup, comprimindo os arquivos
- Desmonta a partição </br></br>

### Variáveis

1. **PARTICAO** é onde deve ser alterado. Onde seu HD externo é conectado. </br>
   _Para saber o que colocar, use o comando **df** para identificar seu hd externo._ </br>
1. **PASTA** é onde está salvo os arquivos que você quer fazer o backup </br>
1. **DATA** se refere a data atual, a qual fica no nome do arquivo salvo no hd externo </br></br>

### Caminho no HD externo

No seu hd externo, o backup ficará com o seguinte nome: _backup-12-08-2021-15.08_ </br>
Sempre será alterado para data/hora atual.

</br></br>_obs: para ler melhor o script, use a extensão Better Comments no VSCODE_</br>

_obs2: você precisa dar sudo su, antes de executar o script_
