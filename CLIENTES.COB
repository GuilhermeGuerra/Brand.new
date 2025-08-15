       IDENTIFICATION              DIVISION.
       PROGRAM-ID. CLIENTES.
      * COMENTÁRIO: Este é um exemplo de programa COBOL.
       ENVIRONMENT             DIVISION.
       CONFIGURATION           SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       INPUT-OUTPUT            SECTION.
       FILE-CONTROL.
           SELECT EARQCLI ASSIGN TO ".\EARQCLI.TXT"
               FILE STATUS IS FS-EARQCLI.
           SELECT SARQCLI ASSIGN TO ".\SARQCLI.TXT"
               FILE STATUS IS FS-SARQCLI.
       DATA                    DIVISION.
       FILE                    SECTION.
      *-------------------- ARQUIVO DE ENTRADA 
       FD  EARQCLI
           RECORDING MODE IS F.
           COPY "BOOKCLI".

      *-------------------- ARQUIVO DE SAIDA 
      *    LAYOUT = 20 POSICOES(AGENCIA, CONTA, TIPO E SALDO)
       FD  SARQCLI
           RECORDING MODE IS F.
       01 REG-SARQCLI          PIC X(22).


       WORKING-STORAGE         SECTION.
      *----------------------- VARIAVEIS DE STATUS 
       01 FS-EARQCLI           PIC 9(02).
       01 FS-SARQCLI           PIC 9(02).

      *----------------------- VARIAVEIS ACUMUMLADORAS

       01  WRK-CONTADOR        PICTURE 9(03) USAGE COMP.
       01  WRK-VALIDOS         PICTURE 9(03) USAGE COMP.
       01  WRK-NVALIDOS        PICTURE 9(03) USAGE COMP.
 
       PROCEDURE               DIVISION.
      *-------------------- PRINCIPAL
       0100-PRINCIPAL              SECTION.
           PERFORM 0200-INICIAR.
           PERFORM 0300-PROCESSAR UNTIL FS-EARQCLI EQUAL 10.
           PERFORM 0400-FINALIZAR.
           STOP    RUN.
      *-------------------- INICIAR
       0200-INICIAR                SECTION.
           OPEN INPUT EARQCLI.
           OPEN OUTPUT SARQCLI.

           IF FS-EARQCLI NOT EQUAL 0 OR FS-SARQCLI NOT EQUAL 0
               DISPLAY "ARQUIVO(S) NAO ABERTO(S)"
               GOBACK
           END-IF.

           PERFORM 0210-LEITURA.

       EXIT.

       0210-LEITURA               SECTION.
            READ EARQCLI.
       EXIT.

      *-------------------- PROCESSAR
       0300-PROCESSAR              SECTION.
           
           ADD 1 TO WRK-CONTADOR.

           IF REG-SALDO GREATER THAN OR EQUAL 5000 
           AND
           (REG-TIPO-CONTA EQUAL 1 OR REG-TIPO-CONTA EQUAL 2)

           STRING  REG-AGENCIA     DELIMITED BY SIZE
                   REG-CONTA       DELIMITED BY SIZE
                   REG-TIPO-CONTA  DELIMITED BY SIZE
                   REG-SALDO       DELIMITED BY SIZE
           INTO    REG-SARQCLI

           WRITE   REG-SARQCLI
               IF FS-SARQCLI NOT EQUAL ZEROS
                   DISPLAY "ERRO AO GRAVAR" REG-AGENCIA REG-CONTA
               END-IF
           
               ADD 1 TO WRK-VALIDOS 

           ELSE

           
      *         EVALUATE TRUE
      *             WHEN REG-SALDO LESS THAN 5000
      *                 DISPLAY "SALDO NAO COMPATIVEL"
      *             WHEN REG-TIPO-CONTA NOT EQUAL 1
      *             OR REG-TIPO-CONTA NOT EQUAL 2
      *             DISPLAY "TIPO DE CONTA INVALIDA"
      *         END-EVALUATE

               ADD 1 TO WRK-NVALIDOS 

           END-IF.
       EXIT.

           PERFORM 0210-LEITURA.

      *-------------------- FINALIZAR
       0400-FINALIZAR              SECTION.
           CLOSE   EARQCLI
                   SARQCLI.

           DISPLAY "-------------------"
           DISPLAY "--- ESTATISTICA ---"
           DISPLAY "CLIENTES LIDOS: " WRK-CONTADOR.
           DISPLAY "VALIDOS.......: " WRK-VALIDOS.
           DISPLAY "NAO VALIDOS...: " WRK-NVALIDOS.
           DISPLAY "-------------------"
       EXIT.

    