# sonar-sql-demo

Primer statičke analize T-SQL skripti pomoću SonarCloud-a (SonarQube Cloud).

- `sql/schema.sql` – tabele
- `sql/procedures.sql` – procedure sa namernim greškama (SQL injection, `SELECT *`, `NOLOCK`, `DELETE` bez `WHERE`, `= NULL`, kursor, prazan `CATCH`, hardkodovana lozinka, `GOTO`) i jedna ispravna verzija za poređenje
- `sonar-project.properties` – podešavanje analize (`.sql` → T-SQL)
- `.github/workflows/sonarcloud.yml` – analiza na svaki push / PR
