/*
RM 88415 � Vitor Torres Dantas
RM 88430 � Matheus de Oliveira
*/
SET SERVEROUTPUT ON;

-- Cria��o da fun��o para validar CNPJ
CREATE OR REPLACE FUNCTION validar_cnpj(p_cnpj VARCHAR2) RETURN VARCHAR2 IS
    v_cnpj VARCHAR2(14) := TRIM(REGEXP_REPLACE(p_cnpj, '[^0-9]', ''));
    v_digito_verificador CHAR(1);
    v_soma NUMBER := 0;
    v_mult NUMBER := 2;
BEGIN
    -- Verifica se o CNPJ tem 14 d�gitos
    IF LENGTH(v_cnpj) <> 14 THEN
        RETURN 'Inv�lido';
    END IF;

    -- Verifica se todos os d�gitos s�o iguais (condi��o inv�lida)
    IF REGEXP_LIKE(v_cnpj, '^(\d)\1{13}$') THEN
        RETURN 'Inv�lido';
    END IF;

    -- Calcula o primeiro d�gito verificador
    FOR i IN REVERSE 1..12 LOOP
        v_soma := v_soma + TO_NUMBER(SUBSTR(v_cnpj, i, 1)) * v_mult;
        v_mult := v_mult + 1;
        IF v_mult > 9 THEN
            v_mult := 2;
        END IF;
    END LOOP;
    v_digito_verificador := CASE MOD(11 - MOD(v_soma, 11), 10)
                             WHEN 10 THEN '0'
                             ELSE TO_CHAR(MOD(11 - MOD(v_soma, 11), 10))
                             END;

    -- Verifica se o primeiro d�gito verificador � igual ao pen�ltimo caractere do CNPJ
    IF v_digito_verificador = SUBSTR(v_cnpj, 13, 1) THEN
        -- Calcula o segundo d�gito verificador
        v_soma := 0;
        v_mult := 2;
        FOR i IN REVERSE 1..13 LOOP
            v_soma := v_soma + TO_NUMBER(SUBSTR(v_cnpj, i, 1)) * v_mult;
            v_mult := v_mult + 1;
            IF v_mult > 9 THEN
                v_mult := 2;
            END IF;
        END LOOP;
        v_digito_verificador := CASE MOD(11 - MOD(v_soma, 11), 10)
                                 WHEN 10 THEN '0'
                                 ELSE TO_CHAR(MOD(11 - MOD(v_soma, 11), 10))
                                 END;

        -- Verifica se o segundo d�gito verificador � igual ao �ltimo caractere do CNPJ
        IF v_digito_verificador = SUBSTR(v_cnpj, 14, 1) THEN
            RETURN 'V�lido';
        END IF;
    END IF;

    RETURN 'Inv�lido';
END validar_cnpj;
/

-- Programa principal
DECLARE
    v_cnpj_input VARCHAR2(14);
    v_validacao VARCHAR2(10);
BEGIN
    -- Solicita um CNPJ como entrada
    v_cnpj_input := '&cnpj_input'; -- O usu�rio ser� solicitado a inserir o CNPJ

    -- Chama a fun��o para validar o CNPJ
    v_validacao := validar_cnpj(v_cnpj_input);

    -- Exibe o resultado
    DBMS_OUTPUT.PUT_LINE('O CNPJ inserido � ' || v_validacao);
END;
/

GRANT EXECUTE ON validar_cnpj TO PF0645;


