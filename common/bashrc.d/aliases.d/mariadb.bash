# MariaDB
alias mysql='mariadb'
dbsizes() {
    mariadb -N -e "SELECT table_schema AS db, ROUND(SUM(data_length+index_length)/1024/1024,1) AS mb
                 FROM information_schema.tables
                 GROUP BY table_schema ORDER BY mb DESC;"
}
