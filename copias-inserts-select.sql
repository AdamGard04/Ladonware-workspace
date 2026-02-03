DECLARE
    -- ==========================================
    -- VARIABLE CONFIGURATION
    -- ==========================================
    v_old_report_code   VARCHAR2(100) := '5001410'; -- Source report
    v_new_report_code   VARCHAR2(100) := '5001505'; -- Destination report
    v_new_app_code      VARCHAR2(100) := 'BGM';     -- Application code
    v_label_title_code  VARCHAR2(100) := '2473';    -- New Label Title Code
    
    -- Variable to store the catalog row
    v_row_catalog       R0_CATALOG_REPORTS%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Starting report duplication from ' || v_old_report_code || ' to ' || v_new_report_code);

    -- 1. R0_CATALOG_REPORTS (Using SELECT INTO to ensure unique record)
    BEGIN
        SELECT * INTO v_row_catalog 
        FROM R0_CATALOG_REPORTS 
        WHERE REPORT_CODE = v_old_report_code;

        -- Modify the necessary values
        v_row_catalog.REPORT_CODE      := v_new_report_code;
        v_row_catalog.APPLICATION_CODE := v_new_app_code;
        v_row_catalog.LABEL_TITLE_CODE := v_label_title_code; -- Confirmed: Correctly assigned

        INSERT INTO R0_CATALOG_REPORTS VALUES v_row_catalog;
        DBMS_OUTPUT.PUT_LINE('-> Catalog: Successfully created with Label: ' || v_label_title_code);

    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: The source report ' || v_old_report_code || ' does not exist.');
            RETURN; -- Stops execution if there is nothing to copy
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20001, 'CRITICAL ERROR: More than one record found for code ' || v_old_report_code || ' in R0_CATALOG_REPORTS.');
        WHEN DUP_VAL_ON_INDEX THEN 
            DBMS_OUTPUT.PUT_LINE('-> Catalog: Code ' || v_new_report_code || ' already exists. Continuing with child tables...');
    END;

    -- 2. R0_REPORT_PARAMETERS
    FOR r IN (SELECT * FROM R0_REPORT_PARAMETERS WHERE REPORT_CODE = v_old_report_code) LOOP
        BEGIN
            r.REPORT_CODE := v_new_report_code;
            -- r.APPLICATION_CODE := v_new_app_code; -- Uncomment if applicable
            INSERT INTO R0_REPORT_PARAMETERS VALUES r;
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; -- If parameter already exists, ignore and continue
        END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-> Parameters: Processed.');

    -- 3. R0_QUERIES_BY_REPORT
    FOR r IN (SELECT * FROM R0_QUERIES_BY_REPORT WHERE REPORT_CODE = v_old_report_code) LOOP
        BEGIN
            r.REPORT_CODE := v_new_report_code;
            INSERT INTO R0_QUERIES_BY_REPORT VALUES r;
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
        END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-> Queries: Processed.');

    -- 4. R0_PLSQL_REPORT_X
    FOR r IN (SELECT * FROM R0_PLSQL_REPORT_X WHERE REPORT_CODE = v_old_report_code) LOOP
        BEGIN
            r.REPORT_CODE := v_new_report_code;
            INSERT INTO R0_PLSQL_REPORT_X VALUES r;
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
        END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-> PLSQL Report X: Processed.');

    -- 5. R0_REPORT_FORMATS
    FOR r IN (SELECT * FROM R0_REPORT_FORMATS WHERE REPORT_CODE = v_old_report_code) LOOP
        BEGIN
            r.REPORT_CODE := v_new_report_code;
            INSERT INTO R0_REPORT_FORMATS VALUES r;
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
        END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-> Formats: Processed.');

    -- 6. R0_PROPERTIES_LANGUAGE
    FOR r IN (SELECT * FROM R0_PROPERTIES_LANGUAGE WHERE REPORT_CODE = v_old_report_code) LOOP
        BEGIN
            r.REPORT_CODE      := v_new_report_code;
            r.APPLICATION_CODE := v_new_app_code; 
            r.KEY_CODE := REPLACE(r.KEY_CODE, v_old_report_code, v_new_report_code);
            -- Also replace the App Code in the Key if necessary
            r.KEY_CODE := REPLACE(r.KEY_CODE, 'BGM', v_new_app_code); 
            
            INSERT INTO R0_PROPERTIES_LANGUAGE VALUES r;
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
        END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-> Language Properties: Processed.');

    DBMS_OUTPUT.PUT_LINE('*** PROCESS COMPLETED WITHOUT CRITICAL ERRORS ***');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
        ROLLBACK;
END;

/