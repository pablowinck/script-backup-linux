################################
# SCRIPT BACKUP SERVIDOR DADOS #
################################
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

DATA=$(date +%d-%m-%Y-%H.%M)

#! PARTIÇÃO ONDE O HD EXTERNO É MONTADO
PARTICAO=/dev/sda3
###* sempre que trocar a porta USB, o caminho será o diferente

function realizarBackup {
    #* COMPACTA TODO O CONTEÚDO DAS PASTAS DENTRO DE /BACKUP INDIVIDUALMENTE.
    tar -zcvf /backup/backup-"$DATA".tar.gz /home/Grupo/

    #* DESMONTA O PONTO DE MONTAGEM /BACKUP
    umount /backup
    #umount /dev/sda3

    printf "${GREEN}Backup realizado com sucesso${NC}\n"

    exit 1
}

#* MONTA O PONTO DE MONTAGEM /BACKUP
mount $PARTICAO /backup
montado=$(mount | grep /backup)

if [ -e /backup/backup-"$DATA".tar.gz ]; then
    t=1
    while [ $t == 1 ]; do
        printf "Esse backup já existe, deseja sobrescreve-lo? [ s / n ]  "
        read sim_nao
        case $sim_nao in
        s) realizarBackup ;;
        n)
            echo "Script Finalizado"
            t=$(($t + 1))
            ;;
        *) printf "${RED}Opção inválida${NC} \n" ;;
        esac
    done

else

    #! SE A MONTAGEM NÃO ESTIVER UP ENTÃO FECHA, CASO CONTRÁRIO REALIZA O BACKUP
    if [ -z "$montado" ]; then
        exit 1
    else

        realizarBackup

    fi
fi