Онлайн сауда платформасы (E-commerce) деректер қоры
1-қадам: PostgreSQL орнатуЕң алдымен компьютеріңізде PostgreSQL ДҚБЖ орнатылған болуы тиіс. Егер жоқ болса, ресми сайттан жүктеп алыңыз.
2-қадам: Деректер қорын құруPostgreSQL терминалын немесе pgAdmin құралын ашып, жаңа деректер қорын құрыңыз:
SQLCREATE DATABASE ecommerce_db;
3-қадам: Рөлдер мен пайдаланушыларды баптауДҚ-ны қауіпсіз басқару үшін арнайы рөлдер мен пайдаланушылар құрылды:
admin_role: Барлық құқықтарға ие әкімші рөлі.customer_role: 
Тек деректерді көруге рұқсаты бар тұтынушы рөлі.
Пайдаланушылар: shop_admin және shop_user аккаунттары құрылып, тиісті рөлдер бекітілді .
4-қадам: Схеманы құруSRS.sql файлын орындау арқылы базаның концептуалды, логикалық және физикалық модельдері іске асады . 
Бұл кезеңде:Кестелер құрылып (Users, Categories, Products, Orders, Order_Items), олардың арасындағы 1:M және M:N қатынастары орнатылады .
Негізгі (PK) және сыртқы кілттер (FK) анықталады.Деректердің тұтастығы үшін шектеулер (NOT NULL, UNIQUE, CHECK) қойылады .
5-қадам: Өнімділікті оңтайландыруФизикалық модельді тиімді ету үшін жиі ізделетін бағандарға (category_id және user_id) индекстер қосылды . 
Бұл сұраныстардың жылдам орындалуын қамтамасыз етеді.
Тестілік сұраныстар (Testing Queries)Жүйенің дұрыс жұмыс істейтінін тексеру үшін келесі күрделі SQL сұраныстары орындалды :
JOIN сұранысы: Клиенттердің сатып алу тарихын көру үшін бірнеше кестелерді біріктіру .
Агрегаттық функциялар: Тапсырыс санын (COUNT) және жалпы шығынды (SUM) есептеу .
Фильтрация: Күрделі WHERE шарттары арқылы деректерді іріктеу .
Индекстерді тексеру: EXPLAIN ANALYZE пәрмені арқылы өнімділікті талдау .

```mermaid

erDiagram
    Users {
        int user_id PK
        varchar name
        varchar email
        varchar password_hash
        date registration_date
    }

    Categories {
        int category_id PK
        varchar category_name
    }

    Products {
        int product_id PK
        varchar name
        numeric price
        int stock_quantity
        int category_id FK
    }

    Orders {
        int order_id PK
        int user_id FK
        timestamp order_date
        numeric total_amount
        varchar status
    }

    Order_Items {
        int order_item_id PK
        int order_id FK
        int product_id FK
        int quantity
        numeric price
    }

    %% Байланыстар (Relations)
    Categories ||--o{ Products : "қамтиды (has)"
    Users ||--o{ Orders : "жасайды (makes)"
    Orders ||--o{ Order_Items : "құралады (consists of)"
    Products ||--o{ Order_Items : "кіреді (included in)"

 ```
