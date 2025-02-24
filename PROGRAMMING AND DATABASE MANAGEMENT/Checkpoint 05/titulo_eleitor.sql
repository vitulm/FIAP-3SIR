/*
RM 88415 � Vitor Torres Dantas
RM 88430 � Matheus de Oliveira
RM 89134 - Leandro Teruya
*/

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION valida_titulo_eleitoral (p_titulo_eleitoral VARCHAR2) RETURN VARCHAR2 IS
    v_seq NUMBER;
    v_uf NUMBER;
    v_dv_1 NUMBER;
    v_dv_2 NUMBER;
    v_calc_dv_1 NUMBER;
    v_calc_dv_2 NUMBER;
    v_resto_1 NUMBER;
    v_resto_2 NUMBER;
BEGIN
    -- Extra��o dos componentes do t�tulo
    v_seq := TO_NUMBER(SUBSTR(p_titulo_eleitoral, 1, 6));
    v_uf := TO_NUMBER(SUBSTR(p_titulo_eleitoral, 7, 2));
    v_dv_1 := TO_NUMBER(SUBSTR(p_titulo_eleitoral, 9, 1));
    v_dv_2 := TO_NUMBER(SUBSTR(p_titulo_eleitoral, 10, 1));

    -- C�lculo do DV-1
    v_calc_dv_1 := 0;
    FOR i IN 1..LENGTH(v_seq) LOOP
        v_calc_dv_1 := v_calc_dv_1 + TO_NUMBER(SUBSTR(v_seq, i, 1)) * (8 - i);
    END LOOP;
    v_resto_1 := MOD(v_calc_dv_1, 11);
    IF v_resto_1 = 10 THEN
        v_resto_1 := 0;
    END IF;

    -- C�lculo do DV-2
    v_calc_dv_2 := MOD((v_uf * 100 + v_dv_1) * 10 + v_dv_2, 11);
    IF v_calc_dv_2 = 10 THEN
        v_calc_dv_2 := 1;
    END IF;

    -- Verifica��o dos d�gitos verificadores
    IF (v_resto_1 = v_dv_1) AND (v_calc_dv_2 = v_dv_2) THEN
        RETURN 'O t�tulo de eleitor � v�lido.';
    ELSE
        RETURN 'O t�tulo de eleitor � inv�lido.';
    END IF;
END;
/

-- Ativar a sa�da no console
DBMS_OUTPUT.ENABLE;

-- Programa principal
DECLARE
    v_titulo_input VARCHAR2(12);
    v_validacao VARCHAR2(100);
BEGIN
    -- Solicita um t�tulo eleitoral como entrada
    v_titulo_input := '&titulo_input'; -- O usu�rio ser� solicitado a inserir o t�tulo eleitoral

    -- Chama a fun��o para validar o t�tulo eleitoral
    v_validacao := valida_titulo_eleitoral(v_titulo_input);

    -- Exibe o resultado
    DBMS_OUTPUT.PUT_LINE('O t�tulo inserido � ' || v_validacao);
END;
/


GRANT EXECUTE ON valida_titulo_eleitoral TO PF0645;

