DB_NAME=uma
#  mongosh="/mnt/c/Program\ Files/MongoDB//mnt/c/Program\ Files/MongoDB/mongosh-2.1.5-win32-x64/bin/mongosh.exe-2.1.5-win32-x64/bin/"
#  mongoexport="/mnt/c/Program\ Files/MongoDB/Tools/100/bin/mongoexport.exe"
#  mongoimport="/mnt/c/Program\ Files/MongoDB/Tools/100/bin/mongoimport.exe"

/mnt/c/Program\ Files/MongoDB/mongosh-2.1.5-win32-x64/bin/mongosh.exe --eval 'db.dropDatabase()' $DB_NAME


#Since the original json files have nested arrays which can be extracted as tables, we can use MongoDB to import the json files and then export them as CSV files to be used in Python and MySQL


# Import Data to MongoDB
/mnt/c/Program\ Files/MongoDB/Tools/100/bin/mongoimport.exe --db $DB_NAME --collection users --type json --file users.json
#I am creating a new column 'id' by converting all '_id'fields to string to avoid any issues with the data  and '_view_for_export' views to be used for exporting data to cvs

/mnt/c/Program\ Files/MongoDB/mongosh-2.1.5-win32-x64/bin/mongosh.exe --eval 'db.createView("users_view_for_export", "users", [ { $addFields: { id: { "$toString": "$_id" } } } ])' $DB_NAME
/mnt/c/Program\ Files/MongoDB/Tools/100/bin/mongoimport.exe --db $DB_NAME --collection receipts --type json --file receipts.json
/mnt/c/Program\ Files/MongoDB/mongosh-2.1.5-win32-x64/bin/mongosh.exe --eval 'db.createView("receipts_view_for_export", "receipts", [ { $addFields: { id: { "$toString": "$_id" } } } ])' $DB_NAME
# By using unwind and project, I am able to extract the nested array 'rewardsReceiptItemList' and insert it into a new collection 'receiptRewardItems'
/mnt/c/Program\ Files/MongoDB/mongosh-2.1.5-win32-x64/bin/mongosh.exe --eval 'db.receipts_view_for_export.aggregate([ { $unwind: "$rewardsReceiptItemList" }, {$project: {_id: 0, id: 1, 'rewardsReceiptItemList': 1}} ]).toArray().forEach(d => db.receiptRewardItems.insertOne({id: d.id, ...(d.rewardsReceiptItemList),}))' $DB_NAME
/mnt/c/Program\ Files/MongoDB/Tools/100/bin/mongoimport.exe --db $DB_NAME --collection brands --type json --file brands.json
/mnt/c/Program\ Files/MongoDB/mongosh-2.1.5-win32-x64/bin/mongosh.exe --eval 'db.createView("brands_view_for_export", "brands", [ { $addFields: { id: { "$toString": "$_id" } } } ])' $DB_NAME

#Export Data from MongoDB in CSV format
/mnt/c/Program\ Files/MongoDB/Tools/100/bin/mongoexport.exe --host localhost --db $DB_NAME --collection users_view_for_export --type=csv --out users.csv --fields=id,active,createdDate,lastLogin,role,signUpSource,state
/mnt/c/Program\ Files/MongoDB/Tools/100/bin/mongoexport.exe --host localhost --db $DB_NAME --collection receipts_view_for_export --type=csv --out receipts.csv --fields=id,userId,bonusPointsEarned,bonusPointsEarnedReason,createDate,dateScanned,modifyDate,pointsEarned,purchaseDate,purchasedItemCount,rewardsReceiptStatus,totalSpent
# Initially, I manually specified column names based on an analysis of the JSON file. However, I discovered irregularities such as missing columns. To address this, I wrote a script called 'doc_keys.js' to extract and list all the keys present in the JSON file. This helped me identify and include all possible columns in my analysis. The output of script showed there are total 35 columns in 'rewardReceiptItems'
/mnt/c/Program\ Files/MongoDB/Tools/100/bin/mongoexport.exe --host localhost --db $DB_NAME --collection receiptRewardItems --type=csv --out rewardReceiptItems.csv --fields='id,barcode,brandCode,description,finalPrice,itemPrice,needsFetchReview,partnerItemId,preventTargetGapPoints,quantityPurchased,userFlaggedBarcode,userFlaggedNewItem,userFlaggedPrice,userFlaggedQuantity,competitorRewardsGroup,discountedItemPrice,originalReceiptItemText,itemNumber,needsFetchReviewReason,originalMetaBriteQuantityPurchased,pointsNotAwardedReason,pointsPayerId,rewardsGroup,rewardsProductPartnerId,userFlaggedDescription,targetPrice,pointsEarned,competitiveProduct,originalFinalPrice,originalMetaBriteBarcode,originalMetaBriteItemPrice,originalMetaBriteDescription,deleted,priceAfterCoupon,metabriteCampaignId'
/mnt/c/Program\ Files/MongoDB/Tools/100/bin/mongoexport.exe --host localhost --db $DB_NAME --collection brands_view_for_export --type=csv --out brands.csv --fields=id,name,category,categoryCode,barcode,brandCode,topBrand
/mnt/c/Program\ Files/MongoDB/mongosh-2.1.5-win32-x64/bin/mongosh.exe --eval 'db.cpg.insert(db.brands_view_for_export.find({}, {cpg: 1, id: 1}).map(d => JSON.parse(JSON.stringify(d))).map(d => ({id: d.id, cpgRef: d.cpg["$ref"], cpgId: d.cpg["$id"]})).toArray())' $DB_NAME
/mnt/c/Program\ Files/MongoDB/Tools/100/bin/mongoexport.exe --host localhost --db uma --collection cpg --type=csv --out cpg.csv --fields=id,cpgRef,cpgId

 