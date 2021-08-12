################################
# SCRIPT BACKUP SERVIDOR DADOS #
################################

function realizarBackup {
    # COMPACTA TODO O CONTEÚDO DAS PASTAS DENTRO DE /BACKUP INDIVIDUALMENTE.
    tar -zcvf /backup/backup-"$DATA".tar.gz /home/Grupo/

    # DESMONTA O PONTO DE MONTAGEM /BACKUP
    umount /backup
    #umount /dev/sda3

    echo "Backup realizado com sucesso"

    exit 1
}

DATA=$(date +%d-%m-%Y-%H.%M)

# MONTA O PONTO DE MONTAGEM /BACKUP
mount /dev/sda3 /backup
montado=$(mount | grep /backup)

if [ -e /backup/backup-"$DATA".tar.gz ]; then
    t=1
    while [ $t == 1 ]; do
        echo "Esse backup já existe, deseja sobrescreve-lo? [ s / n ]"
        read sim_nao
        case $sim_nao in
        s) realizarBackup ;;
        n)
            echo "Script Finalizado"
            t=$(($t + 1))
            ;;
        *) echo "Opção inválida" ;;
        esac
    done

else

    # SE A MONTAGEM NÃO ESTIVER UP ENTÃO FECHA, CASO CONTRÁRIO REALIZA O BACKUP
    if [ -z "$montado" ]; then
        exit 1
    else

        realizarBackup

    fi
fi
