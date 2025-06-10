4 scenarios are demonstated:

Dirty read
Non-repeatable read
Repeatable read
Deadlock

Each scenario contains a setup, session1 and session2 script
SLEEP incorporated to simulate continuity

Dirty read is pretty self-explanatory, both sessions run in READ UNCOMMITTED mode,
which does not isolate transactions, thus allowing second session to read uncommitted
table value from the first transaction. 

Non-repeatable read is produced in READ COMMITTED mode: the first session reads,
waits 10 seconds and reads once again. The second session should be run in between reads,
changing the result of the second read, thus making it non-repeatable. The READ COMMITTED isolation
level does ensure all changes must be committed first to be applied to the table, but does not
ensure data integrity inside sessions.

In the repeatable read scenario, the only change from the last one will be isolation level.
It is set to be REPEATABLE READ, as the name implies, each session has a snapshot of database,
when started, ensuring proper repeatability and consistency.

Lastly, the deadlock scenario is presented the isolation level is not mentioned directly, but
REPEATABLE READ is used by default. Thus each session locks its row with an X lock, and 
then tries to access another row, currently locked, leading to a deadlock, where each session 
awaits one another. MySql will resolve the error on its own, giving a warning message and
terminating the latest out of two sessions.

