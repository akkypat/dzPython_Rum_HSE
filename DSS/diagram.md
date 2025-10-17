```mermaid
---
config:
  look: neo
  layout: dagre
---
erDiagram
	direction TB
	H_CUSTOMER {
        string H_Hash_Customer PK ""  
        string Customer_Id ""  
        string H_Load_Source ""  
        datetime H_Load_Date ""  
    }

    H_PRODUCT {
        string H_Hash_Product PK ""  
        string Product_Id ""  
        string H_Load_Source ""  
        datetime H_Load_Date ""  
    }

    H_ORDER {
        string H_Hash_Order PK ""  
        string Order_Id ""  
        string H_Load_Source ""  
        datetime H_Load_Date ""  
    }

    H_LOCATION {
        string H_Hash_Location PK ""  
        string Location_Id ""  
        string H_Load_Source ""  
        datetime H_Load_Date ""  
    }

    H_SHIP_MODE {
        string H_Hash_Ship_Mode PK ""  
        string Ship_Mode_Id ""  
        string H_Load_Source ""  
        datetime H_Load_Date ""  
    }

    H_SEGMENT {
        string H_Hash_Segment PK ""  
        string Segment_Id ""  
        string H_Load_Source ""  
        datetime H_Load_Date ""  
    }

    H_REGION {
        string H_Hash_Region PK ""  
        string Region_Id ""  
        string H_Load_Source ""  
        datetime H_Load_Date ""  
    }

    LINK_SALES_TRANSACTION {
        string L_Sales_Transaction_HK PK ""  
        string H_Order_HK FK ""  
        string H_Customer_HK FK ""  
        string H_Product_HK FK ""  
        string H_Ship_Mode_HK FK ""  
        string Load_Source ""  
        datetime Load_Date ""  
    }

    LINK_ORDER_LOCATION {
        string L_Order_Location_HK PK ""  
        string H_Order_HK FK ""  
        string H_Location_HK FK ""  
        string Load_Source ""  
        datetime Load_Date ""  
    }

    LINK_CUSTOMER_SEGMENT {
        string L_Customer_Segment_HK PK ""  
        string H_Customer_HK FK ""  
        string H_Segment_HK FK ""  
        string Load_Source ""  
        datetime Load_Date ""  
    }

    LINK_LOCATION_REGION {
        string L_Location_Region_HK PK ""  
        string H_Location_HK FK ""  
        string H_Region_HK FK ""  
        string Load_Source ""  
        datetime Load_Date ""  
    }

    S_CUSTOMER_DETAILS {
        string H_Customer_HK PK,FK ""  
        datetime Load_Date PK ""  
        string Segment ""  
        string City ""  
        string State ""  
        string Postal_Code ""  
        string Country ""  
        string Hash_Diff ""  
        string Load_Source ""  
    }

    S_PRODUCT_DETAILS {
        string H_Product_HK PK,FK ""  
        datetime Load_Date PK ""  
        string Category ""  
        string Sub_Category ""  
        string Hash_Diff ""  
        string Load_Source ""  
    }

    S_LOCATION_DETAILS {
        string H_Location_HK PK,FK ""  
        datetime Load_Date PK ""  
        string Postal_Code ""  
        string City ""  
        string State ""  
        string Country ""  
        string Hash_Diff ""  
        string Load_Source ""  
    }

    S_SALES_METRICS {
        string L_Sales_Transaction_HK PK,FK ""  
        datetime Load_Date PK ""  
        number Sales ""  
        number Quantity ""  
        number Discount ""  
        number Profit ""  
        string Hash_Diff ""  
        string Load_Source ""  
    }

    S_SHIP_MODE_DETAILS {
        string H_Ship_Mode_HK PK,FK ""  
        datetime Load_Date PK ""  
        string Ship_Mode_Name ""  
        string Hash_Diff ""  
        string Load_Source ""  
    }

    S_SEGMENT_DETAILS {
        string H_Segment_HK PK,FK ""  
        datetime Load_Date PK ""  
        string Segment_Name ""  
        string Hash_Diff ""  
        string Load_Source ""  
    }

    S_REGION_DETAILS {
        string H_Region_HK PK,FK ""  
        datetime Load_Date PK ""  
        string Region_Name ""  
        string Hash_Diff ""  
        string Load_Source ""  
    }

    H_CUSTOMER||--o{LINK_CUSTOMER_SEGMENT:""
    H_SEGMENT||--o{LINK_CUSTOMER_SEGMENT:""
    H_CUSTOMER||--o{LINK_SALES_TRANSACTION:""
    H_ORDER||--o{LINK_SALES_TRANSACTION:""
    H_PRODUCT||--o{LINK_SALES_TRANSACTION:""
    H_SHIP_MODE||--o{LINK_SALES_TRANSACTION:""
    H_ORDER||--o{LINK_ORDER_LOCATION:""
    H_LOCATION||--o{LINK_ORDER_LOCATION:""
    H_LOCATION||--o{LINK_LOCATION_REGION:""
    H_REGION||--o{LINK_LOCATION_REGION:""
    H_CUSTOMER||--o{S_CUSTOMER_DETAILS:""
    H_PRODUCT||--o{S_PRODUCT_DETAILS:""
    H_LOCATION||--o{S_LOCATION_DETAILS:""
    LINK_SALES_TRANSACTION||--o{S_SALES_METRICS:""
    H_SHIP_MODE||--o{S_SHIP_MODE_DETAILS:""
    H_SEGMENT||--o{S_SEGMENT_DETAILS:""
    H_REGION||--o{S_REGION_DETAILS:""

```
