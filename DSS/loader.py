#!/usr/bin/env python
# coding: utf-8

# In[4]:


import pandas as pd
import hashlib
from datetime import datetime

def generate_hash_key(business_key):
    """Генерация хэш-ключа на основе БК"""
    return hashlib.sha256(str(business_key).encode('utf-8')).hexdigest()

def prepare_data_vault_keys(input_file, output_file):
    df = pd.read_csv(input_file)
    result_df = df.copy()
    
    # 1. HUB_CUSTOMER (Segment + City + State + Postal Code)
    result_df['Customer_BK'] = (
        result_df['Segment'] + '|' + 
        result_df['City'] + '|' + 
        result_df['State'] + '|' + 
        result_df['Postal Code'].astype(str)
    )
    result_df['Customer_HK'] = result_df['Customer_BK'].apply(generate_hash_key)
    
    # 2. HUB_PRODUCT (Category + Sub-Category)
    result_df['Product_BK'] = (
        result_df['Category'] + '|' + 
        result_df['Sub-Category']
    )
    result_df['Product_HK'] = result_df['Product_BK'].apply(generate_hash_key)
    
    # 3. HUB_ORDER
    result_df['Order_BK'] = 'ORDER_' + result_df.index.astype(str)
    result_df['Order_HK'] = result_df['Order_BK'].apply(generate_hash_key)
    
    # 4. HUB_LOCATION (Postal Code + City + State)
    result_df['Location_BK'] = (
        result_df['Postal Code'].astype(str) + '|' + 
        result_df['City'] + '|' + 
        result_df['State']
    )
    result_df['Location_HK'] = result_df['Location_BK'].apply(generate_hash_key)
    
    # 5. HUB_SHIP_MODE
    result_df['ShipMode_BK'] = result_df['Ship Mode']
    result_df['ShipMode_HK'] = result_df['ShipMode_BK'].apply(generate_hash_key)
    
    # 6. HUB_SEGMENT
    result_df['Segment_BK'] = result_df['Segment']
    result_df['Segment_HK'] = result_df['Segment_BK'].apply(generate_hash_key)
    
    # 7. HUB_REGION
    result_df['Region_BK'] = result_df['Region']
    result_df['Region_HK'] = result_df['Region_BK'].apply(generate_hash_key)
    
    # Добавляем служебные поля для Data Vault
    current_timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    result_df['LoadDate'] = current_timestamp
    result_df['RecordSource'] = input_file
    
    # DataFrame
    final_columns = [
        'Ship Mode', 'Segment', 'Country', 'City', 'State', 'Postal Code', 
        'Region', 'Category', 'Sub-Category', 'Sales', 'Quantity', 'Discount', 'Profit',
        # БК
        'Customer_BK', 'Customer_HK',
        'Product_BK', 'Product_HK', 
        'Order_BK', 'Order_HK',
        'Location_BK', 'Location_HK',
        'ShipMode_BK', 'ShipMode_HK',
        'Segment_BK', 'Segment_HK',
        'Region_BK', 'Region_HK',
        # Доп поля
        'LoadDate', 'RecordSource'
    ]
    
    final_df = result_df[final_columns]
    final_df.to_csv(output_file, index=False)
    
if __name__ == "__main__":
    input_filename = "SampleSuperstore.csv"
    output_filename = "prepared_data.csv"
    prepare_data_vault_keys(input_filename, output_filename)

