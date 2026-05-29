let express=require('express');
let mongoose=require('mongoose');
let cors = require('cors');
const router = require('./App/routes/common_routes');
require('dotenv').config();
let app = express();
app.use(express.json());
app.use(cors());

//Routes
app.use('/api', router);


//Connect to MongoDB
mongoose.connect(process.env.DBURL).then(() => {
    console.log('Connected to MongoDB');
    app.listen(process.env.PORT || 3000, () => {
        console.log('Server is running');
    })
}).catch((err) => {
    console.log("MongoDB Connection failed");
    console.log(err);
    process.exit(1);
})