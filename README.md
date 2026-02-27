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
