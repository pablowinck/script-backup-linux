###################################
# SCRIPT BACKUP SERVIDOR DE DADOS #
###################################

#* As cores servem para modificar a cor printada no terminal

####### CORES ########
RED='\033[0;31m'   ###
GREEN='\033[0;32m' ###
NC='\033[0m'       ### Sem cor
######################

printf "[ ${GREEN}✔${NC} ] Iniciando script...\n"

#!# VARIÁVEIS #!#
#* Data que será exibida no nome do arquivo de backup
DATA=$(date +%d-%m-%Y-%H.%M)

#* Onde está seu hd externo
PARTICAO=/dev/sdb3

#* Pasta a ser salva
PASTA=/home/Grupo/

#* A partir de X dias atrás, será excluído
DIAS=5
#!#!#!#!#!#!#!#!#

#* Funções para facilitar o tratamento de erros *#
function try() {
    [[ $- = *e* ]]
    SAVED_OPT_E=$?
    set +e
}
function catch() {
    export ex_code=$?
    (($SAVED_OPT_E)) && set +e
    return $ex_code
}
function throw() {
    exit $1
}
function throwErrors() {
    set -e
}
#*##############################################*#

#* Variáveis correspondentes a cada tipo de erro...

export BackupException=100
export DeleteException=101
export UmontException=102
export MontException=103

#* Montando onde será salvo os arquivos...
try
(
    mount $PARTICAO /backup || throw $MontException
    montado=$(mount | grep /backup)

    throwErrors

    printf "[ ${GREEN}✔${NC} ] Unidade montada com sucesso\n"
)
catch || { #* Tratamento de erros...
    case $ex_code in
    $MontException)
        printf "[ ${RED}X${NC} ] Erro ao montar unidade, verifique a pasta destino\n"
        exit 0
        ;;
    esac
}

#* Função que realiza backup, exclusão de arquivos antigos, e desmonta partição
function realizarBackup {
    try
    (
        printf "\nComeçando o backup...\n"
        tar -zcvf /backup/backup-"$DATA".tar.gz $PASTA || throw $BackupException #* faz o backup

        throwErrors

        printf "\n\n[ ${GREEN}✔${NC} ] Backup realizado com sucesso\n"

        find /backup -name *.tar.gz -mtime $DIAS -exec rm -f {} \; || throw $DeleteException #* exclui os arquivos antigos

        throwErrors

        printf "[ ${GREEN}✔${NC} ] Arquivos de ${DIAS} dias atras, deletados com sucesso\n"

        umount /backup || throw $UmontException #* desmonta partição
        #umount /dev/sda3

        throwErrors

        printf "[ ${GREEN}✔${NC} ] Unidade desmontada com sucesso\n"

        exit 1
    ) #* Tratamento de erros...
    catch || {
        case $ex_code in
        $BackupException)
            printf "[ ${RED}X${NC} ] Erro ao realizar o backup, verifique a pasta destino\n"
            umount /backup
            ;;
        $DeleteException)
            printf "[ ${RED}X${NC} ] Erro ao deletar arquivos antigos\n"
            umount /backup
            ;;
        $UmontException)
            printf "[ ${RED}X${NC} ] Erro ao desmontar unidade, verifique a pasta destino\n"
            umount /backup
            ;;
        esac
    }
}

#* Verifica se existe backup, se sim, da a opção de sobrescrever,
#* caso não existir, realiza o backup normalmente.

if [ -e /backup/backup-"$DATA".tar.gz ]; then
    t=1
    while [ $t == 1 ]; do
        printf "Esse backup já existe, deseja sobrescreve-lo? [ s / n ]  "
        read sim_nao
        case $sim_nao in
        s)
            realizarBackup
            exit 0
            ;;
        n)
            echo "Script Finalizado"
            umount /backup
            t=$(($t + 1))
            ;;
        *) printf "[ ${RED}X${NC} ] Opção inválida \n" ;;
        esac
    done

else

    realizarBackup

fi
