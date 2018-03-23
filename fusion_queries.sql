--Start by understanding the schema
SHOW TABLES;

--Return all rows in  specific table, understand what's in there
--Replace _contact with any fused object type 
SELECT * FROM fused_contact;

--Understand what fields are available for quering in a certain table
--Again, replace table with any table, by default the fused_ tables contain the universal mappings whereas the raw tables contain all fields on the object in that system 
DESCRIBE fused_contact;


--base single object queries, swap out column names at will and mess around with grouping, I recommend metabse to visualze
--fused_contact, start with a simple grouping by a picklist 
--country, state, status, lead_score, lifecyclestage, hubspot_score
SELECT 
	lifecycle_stage,
	COUNT(lifecycle_stage)
FROM
	fused_contact
GROUP BY lifecycle_stage ASC;

--And you can make the output look nicer by defining clearer names to variables and ordering in a certain manner
SELECT 
	lifecycle_stage AS `LCS`,
	COUNT(lifecycle_stage) AS `Count LCS`
FROM
	fused_contact
GROUP BY lifecycle_stage
ORDER BY COUNT(lifecycle_stage) DESC;

--fused_opportunity
--is_won, is_closed, close_date, lead_source, amount, deal_stage
SELECT 
    deal_stage, close_date, amount, external_sales_person_id
FROM
    fused_opportunity
WHERE
    fiscal_quarter = '1'


--some basic building blocks
GROUP BY 
ORDER BY
COUNT()


--join syntax, this will return contacts tied to companies and both contact and company fields
SELECT 
    *
FROM
    fused_company
        JOIN
    fused_contact links_company_contact ON links_company_contact.contact_id;


--joining 2 tables and grouping results
SELECT 
	fused_contact.hubspot_score AS `Score`,
	fused_opportunity.deal_stage AS `Stage`,
	fused_opportunity.close_date AS `Date`
FROM
	fused_opportunity
		JOIN
	links_contact_opportunity ON fused_contact.contact_id = links_contact_opportunity.contact_id
WHERE
	fused_opportunity.amount >= '10000'
GROUP BY `Score`, `Stage`, `Date`;


--going further. joining 3 tables. opportunities created from paid search leads looking for product 'A'. NOTE: this assumes you have a product object and not just a product field on the opportunity
SELECT 
    fused_contact.created_at AS `Date`,
    fused_opportunity.stage AS `Stage`,
    fused_opportunity.amount AS `MRR`
FROM
    fused_opportunity
        JOIN
    links_contact_opportunity ON fused_contact.contact_id = links_contact_opportunity.contact_id
    links_contact_product ON fused_product.product_id = links_contact_product.product_id
WHERE
    fused_contact.leadsource = 'Paid Search'
        AND fused_contact.created_at BETWEEN '2017-01-01' AND '2017-03-31'
        AND fused_product.product = 'A'
GROUP BY `Date`, `Stage`, `MRR`;
