DROP DATABASE uma;
CREATE DATABASE IF NOT EXISTS uma;
use uma;
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(255) NOT NULL,
    active BOOLEAN NULL,
    createdDate DATETIME NULL,
    lastLogin DATETIME NULL,
    role VARCHAR(255) NULL,
    signUpSource VARCHAR(255) NULL,
    state VARCHAR(255) NULL,
    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS brands (
	id VARCHAR(255) NOT NULL,
	name VARCHAR(255) NULL,
	barcode VARCHAR(255) NULL,
	brandCode VARCHAR(255) NULL,
	category VARCHAR(255) NULL,
	categoryCode VARCHAR(255) NULL,
	topBrand BOOLEAN NULL,
    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS cpg (
  id VARCHAR(255) NOT NULL,
  cpgRef VARCHAR(255) NULL,
  cpgId VARCHAR(255) NULL,
  FOREIGN KEY(id) references brands(id)
);

CREATE TABLE IF NOT EXISTS receipts (
id VARCHAR(255) NOT NULL,
userId VARCHAR(255) NULL,
bonusPointsEarned INTEGER NULL,
bonusPointsEarnedReason VARCHAR(255) NULL,
createDate DATETIME NULL,
dateScanned DATETIME NULL,
modifyDate DATETIME NULL,
pointsEarned INTEGER NULL,
purchaseDate DATETIME NULL,
purchasedItemCount INTEGER NULL,
rewardsReceiptStatus VARCHAR(255) NULL,
totalSpent FLOAT(10, 2) NULL,
finishedDate DATETIME NULL,
pointsAwardedDate DATETIME NULL,
PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS rewardItems (
id VARCHAR(255),
barcode VARCHAR(255) NULL,
description VARCHAR(255) NULL,
finalPrice FLOAT(10, 2) NULL,
itemPrice FLOAT(10, 2) NULL,
needsFetchReview BOOLEAN NULL,
partnerItemId VARCHAR(255) NULL,
preventTargetGapPoints BOOLEAN NULL,
quantityPurchased INTEGER NULL,
userFlaggedBarcode VARCHAR(255) NULL,
userFlaggedNewItem BOOLEAN NULL,
userFlaggedPrice FLOAT(10, 2) NULL,
userFlaggedQuantity INTEGER NULL,
brandCode VARCHAR(255) NULL,
competitorRewardsGroup VARCHAR(255) NULL,
discountedItemPrice FLOAT(10, 2) NULL,
originalReceiptItemText VARCHAR(255) NULL,
itemNumber VARCHAR(255) NULL,
needsFetchReviewReason VARCHAR(255) NULL,
originalMetaBriteQuantityPurchased INTEGER NULL,
pointsNotAwardedReason VARCHAR(255) NULL,
pointsPayerId VARCHAR(255) NULL,
rewardsGroup VARCHAR(255) NULL,
rewardsProductPartnerId VARCHAR(255) NULL,
userFlaggedDescription VARCHAR(255) NULL,
targetPrice VARCHAR(255) NULL,
pointsEarned FLOAT(10, 2) NULL,
competitiveProduct BOOLEAN NULL,
originalFinalPrice FLOAT(10, 2) NULL,
originalMetaBriteBarcode VARCHAR(255) NULL,
originalMetaBriteItemPrice FLOAT(10, 2) NULL,
originalMetaBriteDescription VARCHAR(255) NULL,
deleted BOOLEAN NULL,
priceAfterCoupon FLOAT(10, 2) NULL,
metabriteCampaignId VARCHAR(255) NULL,
FOREIGN KEY(id) REFERENCES receipts(id)
);


LOAD DATA LOCAL INFILE '/Users/tirth/Desktop/uma/users.csv'
INTO TABLE uma.users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, @active, @createdDate, @lastLogin, role, signUpSource, state)
SET active = CASE WHEN @active = 'true' THEN 1 ELSE 0 END,
	  createdDate = CASE WHEN @createdDate = '' OR @createdDate = Null THEN Null Else STR_TO_DATE(@createdDate, '%Y-%m-%dT%H:%i:%s.%fZ') END,
    lastLogin = CASE WHEN @lastLogin = '' or @lastLogin = Null THEN Null Else STR_TO_DATE(@lastLogin, '%Y-%m-%dT%H:%i:%s.%fZ') END
;


LOAD DATA LOCAL INFILE '/Users/tirth/Desktop/uma/brands.csv'
INTO TABLE uma.brands
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, barcode, brandCode, category, categoryCode, @topBrand)
SET topBrand = CASE WHEN @topBrand = 'true' THEN 1 ELSE 0 END
;

LOAD DATA LOCAL INFILE '/Users/tirth/Desktop/uma/cpg.csv'
INTO TABLE uma.cpg
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
;

LOAD DATA LOCAL INFILE '/Users/tirth/Desktop/uma/receipts.csv'
INTO TABLE uma.receipts
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, userId, @bonusPointsEarned, bonusPointsEarnedReason, @createDate, @dateScanned, @modifyDate, @pointsEarned, @purchaseDate, @purchasedItemCount, rewardsReceiptStatus, @totalSpent, @finishedDate, @pointsAwardedDate)
SET createDate = CASE WHEN @createDate = '' OR @createDate = Null THEN Null Else STR_TO_DATE(@createDate, '%Y-%m-%dT%H:%i:%s.%fZ') END,
    dateScanned = CASE WHEN @dateScanned = '' OR @dateScanned = Null THEN Null Else STR_TO_DATE(@dateScanned, '%Y-%m-%dT%H:%i:%s.%fZ') END,
    modifyDate = CASE WHEN @modifyDate = '' OR @modifyDate = Null THEN Null Else STR_TO_DATE(@modifyDate, '%Y-%m-%dT%H:%i:%s.%fZ') END,
    purchaseDate = CASE WHEN @purchaseDate = '' OR @purchaseDate = Null THEN Null Else STR_TO_DATE(@purchaseDate, '%Y-%m-%dT%H:%i:%s.%fZ') END,
    finishedDate = CASE WHEN @finishedDate = '' OR @finishedDate = Null THEN Null Else STR_TO_DATE(@finishedDate, '%Y-%m-%dT%H:%i:%s.%fZ') END,
    pointsAwardedDate = CASE WHEN @pointsAwardedDate = '' OR @pointsAwardedDate = Null THEN Null Else STR_TO_DATE(@pointsAwardedDate, '%Y-%m-%dT%H:%i:%s.%fZ') END,
    bonusPointsEarned = CASE WHEN @bonusPointsEarned = '' OR @bonusPointsEarned = Null THEN Null ELSE @bonusPointsEarned END,
    pointsEarned = CASE WHEN @pointsEarned = '' OR @pointsEarned = Null THEN Null ELSE @pointsEarned END,
    totalSpent = CASE WHEN @totalSpent = '' OR @totalSpent = Null THEN Null ELSE @totalSpent END,
    purchasedItemCount = CASE WHEN @purchasedItemCount = '' OR @purchasedItemCount = Null THEN Null ELSE @purchasedItemCount END
;

LOAD DATA LOCAL INFILE '/Users/tirth/Desktop/uma/rewardReceiptItems.csv'
INTO TABLE uma.receiptItems
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, barcode, description, @finalPrice, @itemPrice, @needsFetchReview, partnerItemId, @preventTargetGapPoints, @quantityPurchased, userFlaggedBarcode, @userFlaggedNewItem, @userFlaggedPrice, @userFlaggedQuantity, brandCode, competitorRewardsGroup, @discountedItemPrice, originalReceiptItemText, itemNumber, needsFetchReviewReason, @originalMetaBriteQuantityPurchased, pointsNotAwardedReason, pointsPayerId, rewardsGroup, rewardsProductPartnerId, userFlaggedDescription, targetPrice, @pointsEarned, @competitiveProduct, @originalFinalPrice, originalMetaBriteBarcode, @originalMetaBriteItemPrice, originalMetaBriteDescription, @deleted, @priceAfterCoupon, metabriteCampaignId)
SET needsFetchReview = CASE WHEN @needsFetchReview = 'true' THEN 1 ELSE 0 END,
preventTargetGapPoints = CASE WHEN @preventTargetGapPoints = 'true' THEN 1 ELSE 0 END,
userFlaggedNewItem = CASE WHEN @userFlaggedNewItem = 'true' THEN 1 ELSE 0 END,
competitiveProduct = CASE WHEN @competitiveProduct = 'true' THEN 1 ELSE 0 END,
deleted = deleted = CASE WHEN @deleted = 'true' THEN 1 WHEN @deleted = 'false' THEN 0 ELSE NULL END,
finalPrice = CASE WHEN @finalPrice = '' or @finalPrice = Null THEN Null ELSE @finalPrice END,
itemPrice = CASE WHEN @itemPrice = '' or @itemPrice = Null THEN Null ELSE @itemPrice END,
quantityPurchased = CASE WHEN @quantityPurchased = '' or @quantityPurchased = Null THEN Null ELSE @quantityPurchased END,
userFlaggedPrice = CASE WHEN @userFlaggedPrice = '' or @userFlaggedPrice = Null THEN Null ELSE @userFlaggedPrice END,
userFlaggedQuantity = CASE WHEN @userFlaggedQuantity = '' or @userFlaggedQuantity = Null THEN Null ELSE @userFlaggedQuantity END,
discountedItemPrice = CASE WHEN @discountedItemPrice = '' or @discountedItemPrice = Null THEN Null ELSE @discountedItemPrice END,
originalMetaBriteQuantityPurchased = CASE WHEN @originalMetaBriteQuantityPurchased = '' or @originalMetaBriteQuantityPurchased = Null THEN Null ELSE @originalMetaBriteQuantityPurchased END,
pointsEarned = CASE WHEN @pointsEarned = '' or @pointsEarned = Null THEN Null ELSE @pointsEarned END,
originalFinalPrice = CASE WHEN @originalFinalPrice = '' or @originalFinalPrice = Null THEN Null ELSE @originalFinalPrice END,
originalMetaBriteItemPrice = CASE WHEN @originalMetaBriteItemPrice = '' or @originalMetaBriteItemPrice = Null THEN Null ELSE @originalMetaBriteItemPrice END,
deleted = CASE WHEN @deleted = '' or @deleted = Null THEN Null ELSE @deleted END,
priceAfterCoupon = CASE WHEN @priceAfterCoupon = '' or @priceAfterCoupon = Null THEN Null ELSE @priceAfterCoupon END
;
