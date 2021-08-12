ARQUIVO=backup.sh

TESTE= date -r deletar.sh +%s
DATA= date -r $ARQUIVO +%s

if [ $TESTE -qt $DATA ]; then
    echo 'Teste é maior que data'
else
    echo 'Data é maior que teste'
fi


echo stat(1)