--Checking data quality for crm_cust_info

			-- Checking for Null or Duplicates in Primary Key
			-- Expectation: No Result
			SELECT 
				cst_id,
				COUNT(*)
			FROM bronze.crm_cust_info
			GROUP BY cst_id
			HAVING COUNT(*) > 1 OR cst_id IS NULL;

	-- Testing again for silver.crm_cust_info
	SELECT 
		cst_id,
		COUNT(*)
	FROM silver.crm_cust_info
	GROUP BY cst_id
	HAVING COUNT(*) > 1 OR cst_id IS NULL;


			-- Checking for unwanted Spaces
			-- Expectation: No Result
			SELECT 
				cst_marital_status
			FROM bronze.crm_cust_info
			WHERE cst_marital_status != trim(cst_marital_status);

	-- Testing again for silver.crm_cust_info
	SELECT 
		cst_marital_status
	FROM silver.crm_cust_info
	WHERE cst_marital_status != trim(cst_marital_status);


			--Data Standardization & Consistency
			SELECT DISTINCT cst_gndr
			FROM bronze.crm_cust_info;

			SELECT DISTINCT cst_marital_status
			FROM bronze.crm_cust_info;

	-- Testing again for silver.crm_cust_info
	SELECT DISTINCT cst_gndr
	FROM silver.crm_cust_info;

	SELECT DISTINCT cst_marital_status
	FROM silver.crm_cust_info;


--**********--
SELECT * 
FROM bronze.crm_cust_info;

SELECT * 
FROM silver.crm_cust_info;
--**********--



--Checking data quality for crm_prd_info

			-- Checking for Null or Duplicates in Primary Key
			-- Expectation: No Result
			SELECT 
				prd_id,
				COUNT(*)
			FROM bronze.crm_prd_info
			GROUP BY prd_id
			HAVING COUNT(*) > 1 OR prd_id IS NULL;

	-- Testing again for silver.crm_prd_info
	SELECT 
		prd_id,
		COUNT(*)
	FROM silver.crm_prd_info
	GROUP BY prd_id
	HAVING COUNT(*) > 1 OR prd_id IS NULL;


			-- Checking for unwanted Spaces
			-- Expectation: No Result
			SELECT 
				prd_nm
			FROM bronze.crm_prd_info
			WHERE prd_nm != trim(prd_nm);

	-- Testing again for silver.crm_prd_info
	SELECT 
		prd_nm
	FROM silver.crm_prd_info
	WHERE prd_nm != trim(prd_nm);


			--Checking for Nulls or Negative number
			-- Expectation: No Result
			SELECT 
				prd_cost
			FROM bronze.crm_prd_info
			WHERE prd_cost < 0 OR prd_cost IS NULL;

	-- Testing again for silver.crm_prd_info
	SELECT 
		prd_cost
	FROM silver.crm_prd_info
	WHERE prd_cost < 0 OR prd_cost IS NULL;


			--Data Standardization & Consistency
			SELECT DISTINCT prd_line
			FROM bronze.crm_prd_info;

	-- Testing again for silver.crm_prd_info
	SELECT DISTINCT prd_line
	FROM silver.crm_prd_info;


			--Checking data quality in datetime
			SELECT *
			FROM bronze.crm_prd_info
			WHERE prd_end_dt < prd_start_dt;

	-- Testing again for silver.crm_prd_info	
	SELECT *
	FROM silver.crm_prd_info
	WHERE prd_end_dt < prd_start_dt;


--**********--
SELECT *
FROM bronze.crm_prd_info;

SELECT *
FROM silver.crm_prd_info;
--**********--



--Checking data quality for crm_prd_info
		--sls_ord_num
				--Checking unwanted spaces 
				--Expectation: No Results
				SELECT *
				FROM bronze.crm_sales_details
				WHERE sls_ord_num != trim(sls_ord_num);
				--Result: 0 sls_ord_num need to be trimmed
				
				--Testing Data:
				SELECT *
				FROM silver.crm_sales_details
				WHERE sls_ord_num != trim(sls_ord_num);

		--sls_prd_key
				--Checking unwanted spaces 
				--Expectation: No Results
				SELECT *
				FROM bronze.crm_sales_details
				WHERE sls_prd_key != trim(sls_prd_key);
				--Result: 0 sls_ord_num need to be trimmed

				--
				SELECT *
				FROM silver.crm_sales_details
				WHERE sls_prd_key != trim(sls_prd_key);

		--sls_prd_key
				--Checking whether any sls_prd_key dont exist in pro_info.prd_key
				--Expectation: No Results
				SELECT *
				FROM bronze.crm_sales_details
				WHERE sls_prd_key NOT IN (SELECT silver.crm_prd_info.prd_key from silver.crm_prd_info);
				--Result: no extra prd_key or mistake on prd_key detected

				--
				SELECT *
				FROM silver.crm_sales_details
				WHERE sls_prd_key NOT IN (SELECT silver.crm_prd_info.prd_key from silver.crm_prd_info);


		--sls_cust_id
				--Checking whether any sls_csut_id dont exist in cust_info.cst_id
				--Expectation: No Results
				SELECT *
				FROM bronze.crm_sales_details
				WHERE sls_cust_id NOT IN (SELECT silver.crm_cust_info.cst_id from silver.crm_cust_info);
				--Result: no extra sls_cust_id or mistake on sls_cust_id detected

			    --
				SELECT *
				FROM silver.crm_sales_details
				WHERE sls_cust_id NOT IN (SELECT silver.crm_cust_info.cst_id from silver.crm_cust_info);

		--sls_order_dt
				--Chceking the 0 and negative values in sls_order_dt (1)(2)
				SELECT
					sls_order_dt				
				FROM bronze.crm_sales_details
				WHERE sls_order_dt < 0;
				-- 0 negative 

				SELECT
					sls_order_dt				
				FROM bronze.crm_sales_details
				WHERE sls_order_dt <= 0;
				-- 17 0-values ==> need to be transfromed into NULL

				--Checking whether there are wrong format for sls_order_dt (3)
				SELECT
					sls_order_dt				
				FROM bronze.crm_sales_details
				WHERE len(sls_order_dt) != 8;
				--17 0-values and 2 not-date values

				--(1)(2)(3)==>
				SELECT
				NULLIF(sls_order_dt, 0) sls_order_dt
				FROM bronze.crm_sales_details
				WHERE sls_order_dt <= 0
				OR sls_order_dt < 0
				OR sls_order_dt > 20500101
				OR sls_order_dt < 19000101;


		--sls_ship_dt
				--Chceking the 0 and negative values in sls_ship_dt
				--Checking whether there are wrong format for sls_ship_dt
				SELECT
				NULLIF(sls_ship_dt, 0) sls_ship_dt
				FROM bronze.crm_sales_details
				WHERE sls_ship_dt <= 0
				OR sls_ship_dt < 0
				OR sls_ship_dt > 20500101
				OR sls_ship_dt < 19000101;
				-- no problems detected
				--*** to prevent problems in the future same transformation should be applied


		 --sls_due_dt
				--Chceking the 0 and negative values in sls_due_dt
				--Checking whether there are wrong format for sls_due_dt
				SELECT
				NULLIF(sls_due_dt, 0) sls_due_dt
				FROM bronze.crm_sales_details
				WHERE sls_due_dt <= 0
				OR sls_due_dt < 0
				OR sls_due_dt > 20500101
				OR sls_due_dt < 19000101;
				-- no problems detected
				--*** to prevent problems in the future same transformation should be applied

				--Checking invalid order date
				SELECT *
				FROM bronze.crm_sales_details
				WHERE sls_order_dt > sls_ship_dt
				OR sls_ship_dt > sls_due_dt;
				--no problems that the order date is later the ship date (ship and due too)

				--
				SELECT *
				FROM silver.crm_sales_details
				WHERE sls_order_dt > sls_ship_dt
				OR sls_ship_dt > sls_due_dt;

		--sls_sales, sls_quantity, and sls_price
				--
				SELECT DISTINCT
					sls_sales  AS old_sales,
					sls_quantity,
					sls_price AS old_price,
					CASE 
						WHEN sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price)
							THEN sls_quantity *abs(sls_price)
						ELSE sls_sales 
					END AS sls_sales,
					CASE 
						WHEN sls_price is null or sls_price <= 0
							THEN sls_sales / nullif(sls_quantity, 0)
						ELSE sls_price
					END AS sls_price
				FROM bronze.crm_sales_details
				WHERE sls_sales != sls_quantity * sls_price
				OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
				OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
				ORDER BY sls_sales, sls_quantity, sls_price;
				--7 NULL values 3 Negative values in sales
				-- no problem in quantity
				--7 NULL and 5 Negative values in price

				--
				SELECT DISTINCT
					sls_sales,
					sls_quantity,
					sls_price
				FROM silver.crm_sales_details
				WHERE sls_sales != sls_quantity * sls_price
				OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
				OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
				ORDER BY sls_sales, sls_quantity, sls_price;
--**********--
SELECT *
FROM bronze.crm_sales_details;

SELECT *
FROM silver.crm_sales_details;
--**********--


--Checking data quality for erp_cust_az12
		--cid
				SELECT
					CASE 
						WHEN cid LIKE 'NAS%' THEN substring(cid, 4, len(cid))
						ELSE cid
					END AS cid,
					bdate,
					gen
				FROM bronze.erp_cust_az12;

				-- 
				SELECT 
					cid				
				FROM silver.erp_cust_az12
				WHERE cid NOT LIKE 'A%';

				SELECT 
					cid				
				FROM silver.erp_cust_az12
				WHERE cid not in (SELECT cst_key FROM silver.crm_cust_info)


		--bdate
				SELECT
				bdate
				FROM bronze.erp_cust_az12
				WHERE bdate < '1924-01-01' OR bdate > GETdate();
				
				--testing
				SELECT
				bdate
				FROM silver.erp_cust_az12
				WHERE bdate > GETdate();

				--gen
				SELECT DISTINCT 
					gen
				FROM bronze.erp_cust_az12;

		--testing
				SELECT DISTINCT
					gen
				FROM silver.erp_cust_az12;
--**********--
SELECT *
FROM bronze.erp_cust_az12;

SELECT *
FROM silver.erp_cust_az12;
--**********--



--Checking data quality for erp_loc_a101
		
		--cid
				--Checking unwanted space
				SELECT
					cid
				FROM bronze.erp_loc_a101
				WHERE cid != trim(cid);

				--testing
				SELECT
					cid
				FROM silver.erp_loc_a101
				WHERE cid != trim(cid);

				--Checking unmachted cid with crm_cust_info.cst_key
				SELECT
				replace(cid, '-',  '') as cid
				FROM bronze.erp_loc_a101
				WHERE replace(cid, '-',  '') not in (SELECT cst_key FROM silver.crm_cust_info);
				
				--testing
				SELECT
					cid
				FROM silver.erp_loc_a101
				WHERE cid not in (SELECT cst_key FROM silver.crm_cust_info);

		--cntry
				
				SELECT DISTINCT
					cntry
				FROM bronze.erp_loc_a101;

				SELECT 
					CASE WHEN trim(cntry) = 'DE' THEN 'Germany'
						 WHEN trim(cntry) IN ('US', 'USA') THEN 'United States'
						 WHEN trim(cntry) = '' OR cntry IS NULL THEN 'n/a'
					ELSE trim(cntry)
				END as cntry
				FROM bronze.erp_loc_a101;

				SELECT DISTINCT
					cntry as old_cntry,
					CASE WHEN trim(cntry) = 'DE' THEN 'Germany'
						 WHEN trim(cntry) IN ('US', 'USA') THEN 'United States'
						 WHEN trim(cntry) = '' OR cntry IS NULL THEN 'n/a'
					ELSE trim(cntry)
					END as cntry
				FROM bronze.erp_loc_a101
				ORDER BY cntry;

				--Teting
				SELECT DISTINCT
					cntry
				FROM silver.erp_loc_a101;

		
--**********--
SELECT *
FROM bronze.erp_loc_a101;

SELECT *
FROM silver.erp_loc_a101;
--**********--


--Checking data quality for erp_loc_a101
		--id
				--Checking unwanted spaces
				SELECT 
					id				
				FROM bronze.erp_px_cat_g1v2
				WHERE id != trim(id);
				-- no result

				SELECT 
					id	
				FROM bronze.erp_px_cat_g1v2
				WHERE id not in (SELECT cat_id FROM silver.crm_prd_info);
				--no result

				--testing
				SELECT 
					id				
				FROM silver.erp_px_cat_g1v2
				WHERE id != trim(id);

				SELECT 
					id	
				FROM silver.erp_px_cat_g1v2
				WHERE id not in (SELECT cat_id FROM silver.crm_prd_info);
			

		--cat
				--Checking unwanted spaces
				SELECT 
					cat				
				FROM bronze.erp_px_cat_g1v2
				WHERE cat != trim(cat);
				-- no result

				SELECT DISTINCT 
					cat
				FROM bronze.erp_px_cat_g1v2;
				--no abr. or null values

				--testing
			    SELECT 
					cat				
				FROM silver.erp_px_cat_g1v2
				WHERE cat != trim(cat);

				SELECT DISTINCT 
					cat
				FROM silver.erp_px_cat_g1v2;


		 --subcat
				--Checking unwanted spaces
				SELECT 
					subcat				
				FROM bronze.erp_px_cat_g1v2
				WHERE subcat != trim(subcat);
				-- no result

				SELECT DISTINCT 
					subcat
				FROM bronze.erp_px_cat_g1v2;
				--no abr. or null values
		
				--testing
				SELECT 
					subcat				
				FROM silver.erp_px_cat_g1v2
				WHERE subcat != trim(subcat);

				SELECT DISTINCT 
					subcat
				FROM silver.erp_px_cat_g1v2;
		

		--maintenance
				SELECT 
					maintenance				
				FROM bronze.erp_px_cat_g1v2
				WHERE maintenance != trim(maintenance)
				-- no result

				SELECT DISTINCT 
					maintenance
				FROM bronze.erp_px_cat_g1v2;
				--no abr. or null values

				--testing
				SELECT 
					maintenance				
				FROM silver.erp_px_cat_g1v2
				WHERE maintenance != trim(maintenance);

				SELECT DISTINCT 
					maintenance
				FROM silver.erp_px_cat_g1v2;

--**********--
SELECT *
FROM bronze.erp_px_cat_g1v2;

SELECT *
FROM silver.erp_px_cat_g1v2;
--**********--
