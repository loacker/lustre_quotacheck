Lustre group quota check
========================


Simple shell script to check the lustre group quota limits.
Send an email when the threshold is exceeded.

Usage:
------
    quotachek.sh <-t|--threshold> <-e|--email> <group>

Options:
--------
    -t|--threshold  Threshold to monitor (Percentage value e.g. 80%)
    -e|--email      Email address to notify 

Argument:
---------
    group           Group to check 

Test:
-----
    Specifing the type of test in the environment variable TEST.
    TEST can assume one values of soft, hard or veryhard.

DEBUG:
------
    Set the environment variable DEBUG with the value 1.

Examples:
---------
.. code:: bash
    $ quotacheck -t 80% -e hello@world.it mygroup
    $ TEST=soft quotacheck -t 30% -e hello@world.it mygroup
    $ DEBUG=1 quotacheck -t 50% -e hello@world.it mygroup

Crontab:
--------
    Following an example for run the script every 5 minutes.

.. code:: bash
    /5 * * * * quotacheck -t 75% -e hello@world.it mygroup

To modify the body of the email message edit the script changing the content
of the function `msg` between the `__EOF__`.

