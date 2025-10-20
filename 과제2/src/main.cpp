#include <iostream>
#include<iomanip> 
#include <string>
#include "mysql.h"

void query_function(const char* query, MYSQL* conn) {
    MYSQL_RES* res;
    MYSQL_ROW row;

    // 쿼리 실행
    if (mysql_query(conn, query)) {
        std::cerr << "SELECT failed. Error: " << mysql_error(conn) << "\n";
        mysql_close(conn);
    }

    // 결과 저장
    res = mysql_store_result(conn);
    if (res == nullptr) {
        std::cerr << "mysql_store_result() failed. Error: " << mysql_error(conn) << "\n";
        mysql_close(conn);
    }

    // 필드 개수 가져오기
    int num_fields = mysql_num_fields(res);
    MYSQL_FIELD* fields = mysql_fetch_fields(res);

    // 헤더 출력
    for (int i = 0; i < num_fields; i++) {
        std::cout << std::setw(15) << fields[i].name << "\t";
    }
    std::cout << "\n";

    // 행 출력
    while ((row = mysql_fetch_row(res))) {
        for (int i = 0; i < num_fields; i++) {
            std::cout << std::setw(15) << (row[i] ? row[i] : "NULL") << "\t";
        }
        std::cout << "\n";
    }

    // 리소스 해제
    mysql_free_result(res);
}

int main() {
    MYSQL* conn;
    const char* server = "localhost";
    const char* user = "root";
    const char* password = "1234"; // 여기에 비밀번호 입력
    const char* database = "store"; // 여기에 데이터베이스 이름 입력

    // MySQL 초기화
    conn = mysql_init(nullptr);
    if (conn == nullptr) {
        std::cerr << "mysql_init() failed\n";
        return 1;
    }

    mysql_ssl_mode sslmode = SSL_MODE_DISABLED;
    mysql_options(conn, MYSQL_OPT_SSL_MODE, &sslmode);

    // MySQL 서버 연결
    if (mysql_real_connect(conn, server, user, password, database, 0, nullptr, 0) == nullptr) {
        std::cerr << "mysql_real_connect() failed\n";
        mysql_close(conn);
        return 1;
    }
    while (1) {
        std::cout << '\n' << "---------- SELECT QUERY TYPES --------------" << '\n';
        std::cout << "          1. TYPE 1" << '\n';
        std::cout << "          2. TYPE 2" << '\n';
        std::cout << "          3. TYPE 3" << '\n';
        std::cout << "          4. TYPE 4" << '\n';
        std::cout << "          5. TYPE 5" << '\n';
        std::cout << "          6. TYPE 6" << '\n';
        std::cout << "          7. TYPE 7" << '\n';
        std::cout << "          0. QUIT" << '\n';

        std::cout << '\n' << "select type : ";
        int N; std::cin >> N;

        if (N == 1) {
            std::cout << "Which stores currently carry a certain product(by UPC, name, or brand),and how much inventory do they have ?" << '\n';
            std::cout << "Enter product indentifier (UPC, name, or brand): ";
            std::string str; std::cin >> str;
            std::string s;
            int cnt = 0;
            for (int i = 0; i < str.length(); i++) {
                if (isdigit(str[i])) cnt++;
            }
            if (cnt == str.length()) {
                s = "SELECT s.store_id,s.name,s.inventory_level,p.product_upc,p.name,p.brand"
                    " FROM products p JOIN (SELECT * FROM inventory NATURAL JOIN stores) s"
                    " ON p.product_upc=s.product_upc"
                    " WHERE"
                    " p.product_upc =" + str;
            }
            else {
                s = "SELECT s.store_id,s.name,s.inventory_level,p.product_upc,p.name,p.brand"
                    " FROM products p JOIN (SELECT * FROM inventory NATURAL JOIN stores) s"
                    " ON p.product_upc=s.product_upc"
                    " WHERE"
                    " p.name = \"" + str + "\""
                    " OR p.brand = \"" + str + "\"";
            }
            const char* query = s.c_str();
            query_function(query, conn);
        }
        else if (N == 2) {
            std::cout << "Which products have the highest sales volume in each store over the past month?" << '\n';
            std::string s = " SELECT store_id, p.name, sales FROM products p  NATURAL JOIN"
                " (SELECT store_id, product_upc, SUM(total_amount) as sales FROM sales_transactions"
                " WHERE buy_date LIKE \"2025-05%\""
                " group by store_id, product_upc"
                " HAVING(store_id, sum(total_amount)) IN"
                " (SELECT store_id, MAX(sales) as max_sales FROM("
                " SELECT store_id, product_upc, SUM(total_amount) as sales FROM sales_transactions"
                " WHERE buy_date LIKE \"2025-05%\""
                " group by store_id, product_upc) s group by store_id)) s";
            const char* query = s.c_str();
            query_function(query, conn);
        }
        else if (N == 3) {
            std::cout << "Which store has generated the highest overall revenue this quarter ?" << '\n';
            std::string s = "SELECT store_id, name,revenue FROM stores s NATURAL JOIN"
                " (SELECT store_id, SUM(total_amount * price) as revenue FROM"
                " (SELECT * FROM sales_transactions t NATURAL JOIN products p"
                " WHERE t.buy_date LIKE \"2025-04%\" OR t.buy_date LIKE \"2025-05%\" OR t.buy_date LIKE \"2025-06%\") sub"
                " GROUP BY store_id ORDER BY revenue DESC LIMIT 1) r";
            const char* query = s.c_str();
            query_function(query, conn);
        }
        else if (N == 4) {
            std::cout << "Which vendor supplies the most products across the chain, and how many total units have been sold ? " << '\n';
            std::string s = " SELECT vendor_id, name, supply, sales FROM vendors v NATURAL JOIN"
                " (SELECT vendor_id, sum(supply) as supply, sum(sales) as sales FROM"
                " (SELECT vendor_id, product_upc, SUM(product_num) AS supply FROM product_vendor"
                " GROUP BY vendor_id, product_upc) supply NATURAL JOIN"
                " (SELECT product_upc, SUM(total_amount) AS sales FROM sales_transactions"
                " GROUP BY product_upc) sale"
                " GROUP BY vendor_id"
                " ORDER BY supply DESC LIMIT 1) sub";
            const char* query = s.c_str();
            query_function(query, conn);
        }
        else if (N == 5) {
            std::cout << "Which products in each store are below the reorder threshold and need restocking ?" << '\n';
            std::string s = "SELECT  store_id,product_upc,inventory_level,reorder_thresholds"
                " FROM inventory WHERE inventory_level < reorder_thresholds";
            const char* query = s.c_str();
            query_function(query, conn);
        }
        else if (N == 6) {
            std::cout << "List the top 3 items that loyalty program customers typically purchase with coffee." << '\n';
            std::string s = " SELECT product_upc, name, sales FROM products p NATURAL JOIN"
                " (SELECT product_upc, SUM(total_amount) as sales FROM sales_transactions"
                " WHERE(store_id, payment_method, buy_date, customer_id) IN"
                " (SELECT vip.store_id, vip.payment_method, vip.buy_date, vip.customer_id FROM products p JOIN"
                " (SELECT * FROM sales_transactions NATURAL JOIN customers"
                " WHERE loyality = \"VIP\") vip ON p.product_upc = vip.product_upc"
                " WHERE p.name = \"coffee\")"
                " GROUP BY product_upc) sub"
                " HAVING name <> \"coffee\""
                " ORDER BY sales DESC LIMIT 3";
            const char* query = s.c_str();
            query_function(query, conn);
        }
        else if (N == 7) {
            std::cout << "Among franchise-owned stores, which one offers the widest variety of products, and how does that compare to corporate - owned stores ? " << '\n';
            std::string s = "SELECT ownership_type, ROUND(AVG(variety),2) AS variety"
                " FROM stores NATURAL JOIN"
                " (SELECT store_id, COUNT(*) AS variety FROM inventory GROUP BY store_id) v"
                " GROUP BY ownership_type"
                " ORDER BY variety DESC";
            const char* query = s.c_str();
            query_function(query, conn);
        }
        else if (N == 0) {
            break;
        }
        else {
            std::cout << "you should input 0~7" << '\n';
        }
    }
    mysql_close(conn);

    return 0;
}