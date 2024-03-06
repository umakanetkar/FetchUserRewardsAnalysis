const { MongoClient } = require("mongodb");

// Replace the uri string with your connection string.
const uri = "mongodb://127.0.0.1:27017/uma?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.1.5";
const client = new MongoClient(uri);

async function get(database, collectionName) {
  const collection = database.collection(collectionName);
  
  const cursor = await collection.find();

  // Print a message if no documents were found
  const s = new Set();
  for await (const doc of cursor) {
    Object.keys(doc).forEach((key) => s.add(key));
  }
  s.delete("_id");
  console.log(collectionName, await collection.countDocuments(), "====>", s);
}

async function run() {
  try {
    const database = client.db("uma");
    const collections = [
      "users_view_for_export",
      "brands_view_for_export",
      "receipts_view_for_export",
      "receiptRewardItems",
       "cpg",
    ];
    
    for (let i = 0; i < collections.length; i++) {
      await get(database, collections[i]);
    }
  } finally {
    // Ensures that the client will close when you finish/error
    await client.close();
  }
}
run().catch(console.dir);
