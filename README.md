This project analyzes the trends in shopping habits of a large customer base in a cosmopoliton region using the datasets of scanned receipts from the customers. The project aims to demonstrate the process of reviewing unstructured data (JSON data), designing a structured relational data model, generating queries to answer business questions, identifying data quality issues, and communicating the findings to stakeholders.

#  Datasets description
There are three datasets in this project. Each contains details about the purchases made by the customers based on the receipts scanned. The brief description of the datasets are as follows: 

## Receipts Data Schema

• _id: uuid for this receipt \
•  bonusPointsEarned: Number of bonus points that were awarded upon receipt completion \
•  bonusPointsEarnedReason: event that triggered bonus points \
•  createDate: The date that the event was created\
•  dateScanned: Date that the user scanned their receipt\
•  finishedDate: Date that the receipt finished processing\
•  modifyDate: The date the event was modified\
•  pointsAwardedDate: The date we awarded points for the transaction\
•  pointsEarned: The number of points earned for the receipt\
•  purchaseDate: the date of the purchase\
•  purchasedItemCount: Count of number of items on the receipt\
•  rewardsReceiptItemList: The items that were purchased on the receipt\
•  rewardsReceiptStatus: status of the receipt through receipt validation and processing\
•  totalSpent: The total amount on the receipt\
•  userId: string id back to the User collection for the user who scanned the receipt
## Users Data Schema

• _id: user Id\
•  state: state abbreviation\
•  createdDate: when the user created their account\
•  lastLogin: last time the user was recorded logging in to the app\
•  role: constant value set to 'CONSUMER'\
•  active: indicates if the user is active; only Fetch will de-activate an account with this flag

##  Brand Data Scheme
  
•  _id: brand uuid\
•  barcode: the barcode on the item\
•  brandCode: String that corresponds with the brand column in a partner product file\
•  category: The category name for which the brand sells products in\
•  categoryCode: The category code that references a BrandCategory\
•  cpg: reference to CPG collection\
•  topBrand: Boolean indicator for whether the brand should be featured as a 'top brand'\
•  name: Brand name

# Repository Description
Files 0.1 and 0.1 contain the scripts for table creation from raw json files. File 1 includes a relational diagram illustrating how i would model the data in a data warehouse. Files 2.1 and 2.2 contain the SQL scripts for table creation and the queries used to answer the listed questions. File 3.1 is the Jupyter notebook I used to analyze data quality issues, and file 4 contains a sam[ple Slack message that can be sent to stakeholders to enquire about the data quality issues.
