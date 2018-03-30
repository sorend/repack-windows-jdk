
Repack Windows JDK
====

Repackages an Ora- Windows JDK/JRE .exe as a portable .zip file, ready to unzip and run.

Has been tested with various version of JDK 7, JDK 8 and JDK 9.

Usage:
----

Give the script the jdk's .exe to repack as argument:

```bash
./repack-windows-jdk.sh jdk-7u80-windows-x86.exe
```

Produces jdk-7u80-windows-x86.zip in the same folder.

Usage with docker:
----

If you don't want to install the environment required but have Docker in hand, you can use the
docker-.sh commands to run the script through a docker environment with tools in handy.

```bash
# build docker image
./docker-build.sh

# same as the example above
./docker-run.sh jdk-7u80-windows-x86.exe
```


License
----

Public domain
