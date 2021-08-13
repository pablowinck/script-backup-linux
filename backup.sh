################################
# SCRIPT BACKUP SERVIDOR DADOS #
################################

####### CORES ########
RED='\033[0;31m'   ###
GREEN='\033[0;32m' ###
NC='\033[0m'       ### Sem cor
######################

printf "[ ${GREEN}✔${NC} ] Iniciando script...\n"

DATA=$(date +%d-%m-%Y-%H.%M)

PARTICAO=/dev/sdb3

PASTA=/home/Grupo/

DIAS=5

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

export BackupException=100
export DeleteException=101
export UmontException=102
export MontException=103

try
(
    mount $PARTICAO /backup || throw $MontException
    montado=$(mount | grep /backup)
    throwErrors

    printf "[ ${GREEN}✔${NC} ] Unidade montada com sucesso\n"
)
catch || {
    case $ex_code in
    $MontException)
        printf "[ ${RED}X${NC} ] Erro ao montar unidade, verifique a pasta destino\n"
        exit 0
        ;;
    esac
}

function realizarBackup {
    try
    (
        printf "\nComeçando o backup...\n"
        tar -zcvf /backup/backup-"$DATA".tar.gz $PASTA || throw $BackupException

        throwErrors
        # printf "\nExcluíndo arquivos antigos...\n"
        # find /backup -name *.tar.gz -mtime $DIAS -exec rm -f {} \; && throw $DeleteException

        # throwErrors

        umount /backup || throw $UmontException
        #umount /dev/sda3
        throwErrors
        printf "\n\n[ ${GREEN}✔${NC} ] Unidade desmontada com sucesso\n"

        printf "[ ${GREEN}✔${NC} ] Backup realizado com sucesso\n"

        exit 1
    )
    catch || {
        case $ex_code in
        $BackupException)
            printf "[ ${RED}X${NC} ] Erro ao realizar o backup, verifique a pasta destino\n"
            umount /backup
            ;;
        $DeleteException)
            printf "[ ${RED}X${NC} ] Erro ao excluir arquivos antigos\n"
            umount /backup
            ;;
        $UmontException)
            printf "[ ${RED}X${NC} ] Erro ao desmontar unidade, verifique a pasta destino\n"
            umount /backup
            ;;
        esac
    }
}

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
            t=$(($t + 1))
            ;;
        *) printf "[ ${RED}X${NC} ] Opção inválida \n" ;;
        esac
    done

else

    realizarBackup

fi
