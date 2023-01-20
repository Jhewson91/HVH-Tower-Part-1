-- Check that Building_Profile data set has been imported correctly.
SELECT *
FROM PortfolioProjectHCMCProfiles..['Profiles']

-- Tableau 1
-- Look at Buildings that are located in CBD
SELECT *
FROM PortfolioProjectHCMCProfiles..['Profiles']
WHERE building_location like '%Prime_CBD%'

-- Tableau 2
-- Look at Buildings Specications
SELECT building_name, building_location, building_class, typical_floorplate_sqm, floor_to_ceiling_height, floor_efficiency_percentage, led_lighting, cabling_rating, handover_condition 
FROM PortfolioProjectHCMCProfiles..['Profiles']
WHERE building_location like '%CBD%'
AND typical_floorplate_sqm >= 1000
AND floor_efficiency_percentage >= 80
AND led_lighting = 'Yes'

-- Tableau 3
-- Look at Building amenities 
SELECT building_name, building_location, building_class, fitness_area_rating, café_resturant_amenties_rating, outdoor_roof_terrace_sqm
FROM PortfolioProjectHCMCProfiles..['Profiles']
WHERE fitness_area_rating like '%Good%' 
AND café_resturant_amenties_rating like '%Good%' 
AND outdoor_roof_terrace_sqm > 200


-- Tableau 4
-- Look at Building facilities  
SELECT building_name, building_location, building_class, destination_control_lifts, sqm_per_lift, sqm_per_secure_parking, communal_showers
FROM PortfolioProjectHCMCProfiles..['Profiles']
WHERE destination_control_lifts = 'Yes'
AND sqm_per_lift < 8000
AND sqm_per_secure_parking < 2500
AND communal_showers > 5


-- Tableau 5
-- Look at Building Sustainibility / Green Efficiency 
SELECT building_name, building_location, building_class, building_energy_rating, leed_rating, breeam_rating, nzeb_compliance
FROM PortfolioProjectHCMCProfiles..['Profiles']
WHERE building_energy_rating like '%A%'
AND leed_rating like '%Platinum%' or leed_rating like '%Gold%'
AND breeam_rating like '%Excellent%' or leed_rating like '%Outstanding%'
AND nzeb_compliance = 'Yes'

-- Tableau 6
-- All of the above
SELECT building_name, building_class
FROM PortfolioProjectHCMCProfiles..['Profiles']
WHERE building_location like '%CBD%'
AND typical_floorplate_sqm >= 1000
AND floor_efficiency_percentage >= 80
AND led_lighting = 'Yes'
AND fitness_area_rating like '%Good%' 
AND café_resturant_amenties_rating like '%Good%' 
AND outdoor_roof_terrace_sqm > 200
AND destination_control_lifts = 'Yes'
AND sqm_per_lift < 8000
AND sqm_per_secure_parking < 2500
AND communal_showers > 5
AND building_energy_rating like '%A%'
AND leed_rating like '%Platinum%' or leed_rating like '%Gold%'
AND breeam_rating like '%Excellent%' or leed_rating like '%Outstanding%'
AND nzeb_compliance = 'Yes'

-- Next import market data and merge them, to see the transactions and rental rates, provide the client with general range. 
-- then look into the net absorption (create this) to see a timeline of filling the building. just add a column of "time taken to exceed 80% occupancy"

SELECT *
FROM PortfolioProjectHCMCProfiles..['Office Transactions']

-- Find average rental rate and marketing period from direct comparables
SELECT AVG (convert(bigint, trans.net_effective_rr_sqm)) as 'average_transacting_rental_rate', AVG(convert(bigint, trans.time_to_full_occupancy_months)) as 'average_marketing_period'
FROM PortfolioProjectHCMCProfiles..['Office Transactions'] trans
WHERE transaction_building  in ('Bitexco Financial Tower', 'Saigon Centre 1', 'mPlaza', 'Sun Wah Tower', 'Times Square')

--Drop irrelevant data
DELETE FROM PortfolioProjectHCMCProfiles..['Profiles']
WHERE building_name not in ('Bitexco Financial Tower', 'Saigon Centre 1', 'mPlaza', 'Sun Wah Tower', 'Times Square')

-- Tableau 8
--join two tables on building_name
Select pro.building_name, pro.building_class, trans.transaction_date, trans.net_effective_rr_sqm, trans.time_to_full_occupancy_months
From PortfolioProjectHCMCProfiles..['Profiles'] pro
Join PortfolioProjectHCMCProfiles..['Office Transactions'] trans
on pro.building_name = trans.transaction_building
ORDER BY pro.building_name
