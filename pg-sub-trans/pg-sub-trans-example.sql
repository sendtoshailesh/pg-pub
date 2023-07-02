-- Create a function that uses subtransactions
CREATE OR REPLACE FUNCTION perform_subtransactions()
RETURNS VOID AS $$
DECLARE
    outer_transaction_id INTEGER;
BEGIN
    -- Start the outer transaction
    BEGIN
        -- Perform operations within the outer transaction
        INSERT INTO table_name (column1, column2) VALUES ('value1', 'value2');

        -- Start the subtransaction
        SAVEPOINT subtransaction;

        BEGIN
            -- Perform operations within the subtransaction
            UPDATE table_name SET column1 = 'new_value' WHERE condition;

            -- Commit the subtransaction
            RELEASE SAVEPOINT subtransaction;
        EXCEPTION
            -- Rollback the subtransaction on error
            WHEN OTHERS THEN
                ROLLBACK TO SAVEPOINT subtransaction;
                RAISE; -- Propagate the exception
        END;
        
        -- Perform more operations within the outer transaction
        DELETE FROM table_name WHERE condition;

        -- Commit the outer transaction
        COMMIT;
    EXCEPTION
        -- Rollback the outer transaction on error
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE; -- Propagate the exception
END;
$$ LANGUAGE plpgsql;
