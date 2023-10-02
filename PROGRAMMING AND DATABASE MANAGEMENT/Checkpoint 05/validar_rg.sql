/*
RM 88415 � Vitor Torres Dantas
RM 88430 � Matheus de Oliveira
RM 89134 - Leandro Teruya

*/

SET SERVEROUTPUT ON;

-- Cria��o da fun��o para validar RG
CREATE OR REPLACE FUNCTION validar_rg(p_rg VARCHAR2) RETURN VARCHAR2 IS
    v_rg VARCHAR2(20) := TRIM(p_rg);
    v_numeros VARCHAR2(8);
    v_digito_verificador CHAR(1);
    v_soma NUMBER := 0;
BEGIN
    -- Extrai os n�meros da base do RG
    v_numeros := SUBSTR(v_rg, 1, 8);

    -- Calcula o d�gito verificador
    FOR i IN 1..8 LOOP
        v_soma := v_soma + TO_NUMBER(SUBSTR(v_numeros, i, 1)) * (10 - i);
    END LOOP;
    
    v_digito_verificador := CASE MOD(v_soma, 11)
                             WHEN 10 THEN 'X'
                             ELSE TO_CHAR(MOD(v_soma, 11))
                             END;

    -- Verifica se o d�gito verificador � igual ao �ltimo caractere do RG
    IF v_digito_verificador = UPPER(SUBSTR(v_rg, 9, 1)) THEN
        RETURN 'V�lido';
    ELSE
        RETURN 'Inv�lido';
    END IF;
END validar_rg;
/


-- Programa principal
DECLARE
    v_rg_input VARCHAR2(20);
    v_validacao VARCHAR2(10);
BEGIN
    -- Solicita um RG como entrada
    v_rg_input := '&rg_input'; -- O usu�rio ser� solicitado a inserir o RG

    -- Chama a fun��o para validar o RG
    v_validacao := validar_rg(v_rg_input);

    -- Exibe o resultado
    DBMS_OUTPUT.PUT_LINE('O RG inserido � ' || v_validacao);
END;
/

GRANT EXECUTE ON validar_rg TO PF0645;
