database project 2 logical schema , physical schema , schema+sample_data.sql, main.cpp , README.md , project_report.pdf

실행 환경: windows 11, mingw configuration setup

c_cpp_properties.json의 includepath에 mysql.c 경로 추가

launch.json의 환경변수(envirment)에 mingw의 bin 과 mysql connector의 lib 추가

tasks.json의 args에 include,lib, -lmysql 부분 추가

실행방법

mysql Workbench를 이용하여 store 라는 schema를 만들고 비밀번호를 1234로 설정한다.

mysql Workbench에서 schema+sample_data.sql 를 실행하여 테이블을 만들고 데이터를 삽입한다.

main.cpp를 실행한다.

type 1 을 선택할 시 product_upc나 물건의 이름이나 브랜드를 한 번 더 입력하여야한다.

type 2-7을 선택할 시 원하는 값이 출력된다.

type 0 을 선택할 시 exit한다.

예외처리로 다른 숫자를 입력시 간단한 문구와 함께께 다시 반복문의 처음으로 돌아간다.
