FROM openjdk:8-jre-alpine
ADD repack-windows-jdk.sh /
RUN set -x && \
	apk add --no-cache bash p7zip
ENTRYPOINT ["/repack-windows-jdk.sh"]
