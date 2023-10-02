SET SERVEROUTPUT ON;

/*
RM 88415 � Vitor Torres Dantas
RM 88430 � Matheus de Oliveira
RM 89134 - Leandro Teruya
*/
-- Cria��o da fun��o para validar CPF
CREATE OR REPLACE FUNCTION validar_cpf(p_cpf VARCHAR2) RETURN VARCHAR2 IS
    v_cpf VARCHAR2(11) := TRIM(p_cpf);
    v_soma1 NUMBER := 0;
    v_soma2 NUMBER := 0;
    v_digito1 NUMBER;
    v_digito2 NUMBER;
BEGIN
    -- Verifica se o CPF tem 11 d�gitos
    IF LENGTH(v_cpf) <> 11 THEN
        RETURN 'Inv�lido';
    END IF;

    -- Verifica se todos os d�gitos s�o iguais (situa��o inv�lida)
    IF v_cpf = RPAD(SUBSTR(v_cpf,1,1),11,SUBSTR(v_cpf,1,1)) THEN
        RETURN 'Inv�lido';
    END IF;

    -- C�lculo do primeiro d�gito verificador
    FOR i IN 1..9 LOOP
        v_soma1 := v_soma1 + TO_NUMBER(SUBSTR(v_cpf,i,1)) * (11 - i);
    END LOOP;
    v_digito1 := MOD(11 - MOD(v_soma1, 11), 10);

    -- C�lculo do segundo d�gito verificador
    FOR i IN 1..9 LOOP
        v_soma2 := v_soma2 + TO_NUMBER(SUBSTR(v_cpf,i,1)) * (12 - i);
    END LOOP;
    v_soma2 := v_soma2 + v_digito1 * 2;
    v_digito2 := MOD(11 - MOD(v_soma2, 11), 10);

    -- Verifica se os d�gitos calculados batem com os d�gitos originais
    IF v_digito1 = TO_NUMBER(SUBSTR(v_cpf,10,1)) AND v_digito2 = TO_NUMBER(SUBSTR(v_cpf,11,1)) THEN
        RETURN 'V�lido';
    ELSE
        RETURN 'Inv�lido';
    END IF;
END validar_cpf;
/

-- Programa principal
DECLARE
    v_cpf_input VARCHAR2(11);
    v_validacao VARCHAR2(10);
BEGIN
    -- Solicita um CPF como entrada
    v_cpf_input := &cpf_input; -- O usu�rio ser� solicitado a inserir o CPF

    -- Chama a fun��o para validar o CPF
    v_validacao := validar_cpf(v_cpf_input);

    -- Exibe o resultado
    DBMS_OUTPUT.PUT_LINE('O CPF inserido � ' || v_validacao);
END;
/


GRANT EXECUTE ON validar_cpf TO PF0645;