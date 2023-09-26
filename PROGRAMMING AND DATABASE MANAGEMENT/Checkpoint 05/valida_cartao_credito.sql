SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION valida_cartao_credito (p_numero_cartao VARCHAR2) 
RETURN BOOLEAN
IS
    v_soma NUMBER := 0;
    v_numero_digitos NUMBER := LENGTH(p_numero_cartao);
    v_digito NUMBER := 0;
BEGIN
    FOR i IN REVERSE 1..v_numero_digitos LOOP
        -- Pega o d�gito atual
        v_digito := TO_NUMBER(SUBSTR(p_numero_cartao, i, 1));
        
        -- Aplica a multiplica��o alternada
        IF MOD(i, 2) = MOD(v_numero_digitos, 2) THEN
            v_digito := v_digito * 2;
            IF v_digito > 9 THEN
                v_digito := v_digito - 9;
            END IF;
        END IF;
        
        -- Soma os d�gitos
        v_soma := v_soma + v_digito;
    END LOOP;
    
    -- Verifica se o resultado � m�ltiplo de 10
    IF MOD(v_soma, 10) = 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
/

-- Seu c�digo da fun��o valida_cartao_credito

-- Ativar a sa�da no console
DBMS_OUTPUT.ENABLE;

-- Programa principal
DECLARE
    v_numero_cartao_input VARCHAR2(19);
    v_validacao VARCHAR2(10);
BEGIN
    -- Solicita um n�mero de cart�o como entrada
    v_numero_cartao_input := '&numero_cartao_input'; -- O usu�rio ser� solicitado a inserir o n�mero do cart�o

    -- Chama a fun��o para validar o n�mero do cart�o
    v_validacao := CASE 
                     WHEN valida_cartao_credito(v_numero_cartao_input) THEN 'v�lido'
                     ELSE 'inv�lido'
                   END;

    -- Exibe o resultado
    DBMS_OUTPUT.PUT_LINE('O n�mero do cart�o inserido � ' || v_validacao);
END;
/



