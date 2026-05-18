--Checking the data in customer table
		
		-- Checking the duplicate after joining
				SELECT 
					cst_id,
					count(*)
				FROM (
					SELECT
						ci.cst_id,
						ci.cst_key,
						ci.cst_firstname,
						ci.cst_lastname,
						ci.cst_marital_status,
						ci.cst_gndr,
						ci.cst_create_date,
						ca.bdate,
						ca.gen,
						la.cntry
					FROM silver.crm_cust_info ci
					LEFT JOIN silver.erp_cust_az12 ca 
					ON			ci.cst_key =	ca.cid
					LEFT JOIN silver.erp_loc_a101 la
					ON			ci.cst_key = la.cid
				) t 
				GROUP BY cst_id
				HAVING count(*) > 1; -- Checking the duplicate after joining


		--Checking the gender information (two sources)
				SELECT DISTINCT
					ci.cst_gndr,
					ca.gen,
					CASE 
						WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr --CRM is the MASTER
						ELSE coalesce(ca.gen, 'n/a')
					END AS new_gen
				FROM silver.crm_cust_info ci
				LEFT JOIN silver.erp_cust_az12 ca 
				ON			ci.cst_key =	ca.cid
				LEFT JOIN silver.erp_loc_a101 la
				ON			ci.cst_key = la.cid
				ORDER BY 1, 2;
				
		-- Tesing 
		SELECT 
			*
		FROM gold.dim_customers;

		SELECT DISTINCT
			gender
		FROM gold.dim_customers;


--Checking the data quality in product table
		--Checking duplicate after joining
				SELECT
					prd_key,
					count(*)
				FROM (
					SELECT 
						pn.prd_id,
						pn.cat_id,
						pn.prd_key,
						pn.prd_cost,
						pn.prd_line,
						pn.prd_start_dt,
						pc.cat,
						pc.subcat,
						pc.maintenance
					FROM silver.crm_prd_info pn
					LEFT JOIN silver.erp_px_cat_g1v2 pc
					ON	      pn.cat_id =pc.id
					WHERE prd_end_dt IS NULL
				) t
				GROUP BY prd_key
				HAVING count(*) > 1; -- Checking the duplicate after joining

		-- Tesing 
		SELECT 
			*
		FROM gold.dim_products;


-- Checking data quality in sales table
		--Testing
		SELECT
			*
		FROM gold.fact_sales;

		--
		SELECT
			*
		FROM gold.fact_sales f
		LEFT JOIN gold.dim_customers c
		ON c.customer_key = f.customer_key
		WHERE c.customer_key IS NULL;

		--
		SELECT
			*
		FROM gold.fact_sales f
		LEFT JOIN gold.dim_products p
		ON p.product_key = f.product_key
		WHERE p.product_key IS NULL;

