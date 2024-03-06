use uma;

-- Q3. When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
-- Q4. When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

SELECT distinct(rewardsReceiptStatus) , count(*) 
from receipts
group by rewardsReceiptStatus;
-- we do not have 'accepted' as a rewardsReceiptStatus but we will consider the 'finished' cases as 'accepted ones' 
-- this could be a wrong assumption because finished could actually means the receipts that have been fully processed the 
-- outcome of which can be REJECTED or SUCCESSFUL - this ambiguity is a data quality issue
-- We are taking 'sum' of purchasedItemCount to get a total of number of items purchased 

SELECT rewardsReceiptStatus, round(avg(totalSpent),2) as averageTotalSpent, sum(purchasedItemCount) as totalItemsPurchased
FROM uma.receipts 
WHERE rewardsReceiptStatus IN ('FINISHED', 'REJECTED') 
GROUP BY rewardsReceiptStatus;
-- The total spent and total items purchased for 'finished'/ 'accepted' is more - this could be because of an uneven 
-- distribution between both classes, more analysis and information is required for a definite conclusion


-- Q5. Which brand has the most spend among users who were created within the past 6 months?

-- Logic: Get max(createDate) and retrive user.id made 6 months from that date, match the user.id with receipts.userIds
-- and get hold of receipts.id and then ultimately reach rewardItems.finalPrice and rewardItems.quantityPurchased to 
-- calculate the total spent

select brands.name, sum(rewards.finalPrice * rewards.quantityPurchased) as total_spend
from rewardItems as rewards 
    LEFT JOIN Brands ON rewardItems.brandCode = brands.brandCode
    WHERE rewardItems.brandCode IS NOT NULL AND brands.brandCode IS NOT NULL and
	rewards.id in ( select r.id from receipts r
        where r.userId in ( select u.id
                from users as u,
                    (select MAX(createdDate) as lastDate from users ) as ld where DATEDIFF(ld.lastDate, u.createdDate) <= 180
            ) )
    and brands.name IS NOT NULL
GROUP BY brands.name
order by total_spend desc 
limit 1;

-- Ans: The brand is Cracker Barrel Cheese with a total spend of 4080$.

-- Q6. Which brand has the most transactions among users who were created within the past 6 months?

-- to get the brand with most number of transactions, we have to count the number of times that brand is mentioned
select brands.name, count(*) as number_of_transactions
from receipt_reward_items as rewards 
    LEFT JOIN Brands ON rewardItems.brandCode = brands.brandCode 
WHERE rewardItems.brandCode IS NOT NULL AND brands.brandCode IS NOT NULL
and rewards.id in ( select r.id from receipts r
        where r.userId in ( select u.id
                from users as u,
                    (select MAX(createdDate) as lastDate from users ) as ld where DATEDIFF(ld.lastDate, u.createdDate) <= 180
            ) )
    and brands.name IS NOT NULL
GROUP BY brands.name
order by number_of_transactions desc 
limit 1;

-- Ans. Pepsi, with a count of 74, had the most transactions among users who were created within the past 6 months  
    
    
    
    


