FROM mysql:8.4
COPY ./conf/my.cnf /etc/mysql/conf.d/my.cnf
RUN chmod 0444 /etc/mysql/conf.d/my.cnf
CMD ["mysqld"]
EXPOSE 3306
