Certainly! Here's a sample code snippet demonstrating the usage of subtransactions in PostgreSQL using PL/pgSQL:

```sql
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
```

In the above code, a function named `perform_subtransactions` is created using PL/pgSQL. Within this function, an outer transaction is started using `BEGIN`, and various operations are performed within it. A subtransaction is initiated using `SAVEPOINT` and nested within the outer transaction. Operations specific to the subtransaction are executed within the nested `BEGIN...END` block. If any error occurs, the subtransaction is rolled back to the savepoint using `ROLLBACK TO SAVEPOINT`, and the exception is propagated. The subtransaction is committed by releasing the savepoint using `RELEASE SAVEPOINT`. Further operations can be performed within the outer transaction, and finally, the outer transaction is committed using `COMMIT`. Any error occurring at the outer level also triggers a rollback.

You can invoke the function `perform_subtransactions` to execute the code and observe the behavior of subtransactions within the PostgreSQL environment. Remember to replace `table_name`, `column1`, `column2`, and `condition` with your actual table and column names, as well as the appropriate conditions for your use case.

Please note that this is a simplified example to illustrate the concept of subtransactions. You may need to adapt and modify the code to suit your specific requirements and transactional logic.
