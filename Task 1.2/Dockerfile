FROM debian
LABEL org.opencontainers.image.authors="konstantin@atomauto.ru"
RUN apt update && apt -y full-upgrade && apt install -y gawk
ADD /awkserver /awkserver
CMD cd awkserver && gawk -f samples/numbers/numbers.awk